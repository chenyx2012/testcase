/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the  Eclipse Public License -v 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.eclipse.org/legal/epl-2.0/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "mqtt_client.h"
#include "mqtt_log.h"
#include "mqtt_napi_utils.h"
#include "event_list.h"
#include "task_pool/task_pool.h"

namespace OHOS {
namespace PahoMqtt {

napi_value MqttAsyncClient::Construct(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Construct %{public}s", MQTTNAPI_VERSION_STRING);
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_value jsthis = nullptr;
    napi_get_cb_info(env, info, &paramsCount, params, &jsthis, nullptr);
    
    MqttAsyncClient *client = new MqttAsyncClient();
    
    client->mqttImpl = new MqttImpl();
    auto eventManager = new EventManager();
    client->manager = eventManager;
    ParseClientOptions(env, params[0], &(eventManager->options));
    
    if (!client->mqttImpl->Initialize(eventManager->options)) {
        LOGE("AsyncMqtt Initialize fail");
        return nullptr;
    }
    napi_status status = napi_wrap(env, jsthis, client,
                                   [](napi_env env, void* finalize_data, void* finalize_hint) {
                                       LOGD("AsyncMqtt finalize");
                                       if (!finalize_data)
                                           return;
                                       MqttAsyncClient *client = reinterpret_cast<MqttAsyncClient *>(finalize_data);
                                       if (client) {
                                           delete client->mqttImpl;
                                           client->mqttImpl = nullptr;
                                           delete client->manager;
                                           client->manager = nullptr;
                                           delete client;
                                           client = nullptr;
                                       }
                                   }, nullptr, nullptr);
    if (status != napi_ok) {
        LOGE("AsyncMqtt napi_wrap fail status = %{public}d", status);
    }
    return jsthis;
}

void MqttResponseComplete(napi_env env, napi_status nousb, void *data)
{
    std::lock_guard<std::mutex> lock(publishMutex);
    const size_t MAX_COUNT = 0xff;
    if (data == nullptr) {
        LOGE("AsyncMqtt MqttResponseComplete data is NULL");
        return;
    }
    auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
    if (asyncCallbackInfo->context == nullptr) {
        LOGE("AsyncMqtt MqttResponseComplete context is NULL");
        delete asyncCallbackInfo;
        return;
    }
    asyncCallbackInfo->count--;
    auto baseContext = reinterpret_cast<BaseContext *>(asyncCallbackInfo->context);
    napi_value code;
    napi_create_int32(env, baseContext->GetCode(), &code);
    napi_value errorCode;
    napi_create_int32(env, baseContext->GetErrorCode(), &errorCode);
    napi_value reasonCode;
    napi_create_int32(env, baseContext->GetReasonCode(), &reasonCode);
    napi_value message;
    napi_create_string_utf8(env, baseContext->GetMessage().c_str(),
        strlen(baseContext->GetMessage().c_str()), &message);
    napi_value response;
    napi_status status = napi_create_object(env, &response);
    napi_set_named_property(env, response, "code", code);
    napi_set_named_property(env, response, "errorCode", errorCode);
    napi_set_named_property(env, response, "reasonCode", reasonCode);
    napi_set_named_property(env, response, "message", message);
    NapiUtils::SetMqttProperties(env, response, "properties", baseContext->GetProperties());
    if (baseContext->GetCode() != 0) {
        napi_reject_deferred(env, asyncCallbackInfo->deferred, response);
    } else {
        napi_resolve_deferred(env, asyncCallbackInfo->deferred, response);
    }
    napi_delete_async_work(env, asyncCallbackInfo->async_work);
    if (baseContext->GetIsComplete()) {
        if (asyncCallbackInfo->count <= 0) {
            asyncCallbackInfo->count = MAX_COUNT;
            delete baseContext;
            asyncCallbackInfo->context = nullptr;
            delete asyncCallbackInfo;
            asyncCallbackInfo = nullptr;
        }
    }
}

napi_value MqttAsyncClient::Connect(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Connect Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new ConnectContext(env, eventManager);
    if (context == nullptr) {
        LOGE("AsyncMqtt Connect context is NULL");
        return NapiUtils::GetUndefined(env);
    }
    context->ParseParams(params, paramsCount);
    LOGI("AsyncMqtt Connect context code = %{public}d", context->GetCode());
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    asyncCallbackInfo->context = context;
    asyncCallbackInfo->count = 1;
    if (NapiUtils::GetValueType(env, context->GetCallback()) != napi_function && context->IsNeedPromise()) {
        LOGI("AsyncMqtt create promise");
        napi_value ret = NapiUtils::CreatePromise(env, &asyncCallbackInfo->deferred);
        context->SetIsPromise(true);
        CreateAsyncWork(env, "connect", [](napi_env env, void *data) {
                auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
                if (!asyncCallbackInfo && !asyncCallbackInfo->client) {
                    LOGI("AsyncMqtt asyncCallbackInfo is NULL");
                    return;
                }
                bool res = asyncCallbackInfo->client->mqttImpl->MqttConnect(asyncCallbackInfo);
                if (!res) {
                    asyncCallbackInfo->context->SetCode(-1);
                    asyncCallbackInfo->context->SetMessage("Connect fail");
                }
            },
            MqttResponseComplete, asyncCallbackInfo);
        return ret;
    }
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_CONNECT_EVENT, params[1], true, true);
        context->CreateTsFunction(MQTT_CONNECT_EVENT, context, NapiUtils::FinalizeCallBack,
                                  ResponseCallBack);
        auto func = [](struct AsyncCallbackInfo *data) {
            if (data == nullptr) {
                return;
            }
            if (data->context == nullptr || data->client == nullptr || data->client->mqttImpl == nullptr) {
                delete data;
                data = nullptr;
                return;
            }
            if (!data->client->mqttImpl->MqttConnect(data)) {
                LOGI("AsyncMqtt Connnct MQTT_CONNECT_EVENT failed");
            }
            delete data;
            data = nullptr;
        };
        TaskPool::GetInstance().PushTask(ffrt_queue_priority_high, func, asyncCallbackInfo);
    }
    return NapiUtils::GetUndefined(env);
}

napi_value MqttAsyncClient::Subscribe(napi_env env, napi_callback_info info)
{
    return SubscribeMany(env, info);
}

napi_value MqttAsyncClient::Unsubscribe(napi_env env, napi_callback_info info)
{
    return UnsubscribeMany(env, info);
}

napi_value MqttAsyncClient::SubscribeMany(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Subscribe Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new SubscribeContext(env, eventManager);
    context->ParseParams(params, paramsCount);
    LOGI("AsyncMqtt SubscribeMany context code = %{public}d", context->GetCode());
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    asyncCallbackInfo->context = context;
    asyncCallbackInfo->count = 1;
    if (NapiUtils::GetValueType(env, context->GetCallback()) != napi_function && context->IsNeedPromise()) {
        LOGI("AsyncMqtt create promise");
        napi_value ret = NapiUtils::CreatePromise(env, &asyncCallbackInfo->deferred);
        context->SetIsPromise(true);
        CreateAsyncWork(env, "connect", [](napi_env env, void *data) {
                auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
                if (!asyncCallbackInfo && !asyncCallbackInfo->client) {
                    LOGI("AsyncMqtt asyncCallbackInfo is NULL");
                    return;
                }
                bool res = asyncCallbackInfo->client->mqttImpl->MqttSubscribe(asyncCallbackInfo);
                if (!res) {
                    asyncCallbackInfo->context->SetCode(-1);
                    asyncCallbackInfo->context->SetMessage("Subscribe fail");
                }
            },
            MqttResponseComplete, asyncCallbackInfo);
        return ret;
    }

    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_SUBSCRIBE_EVENT, params[1], true, true);
        context->CreateTsFunction(MQTT_SUBSCRIBE_EVENT, context, NapiUtils::FinalizeCallBack,
                                  MqttAsyncClient::ResponseCallBack);
        auto func = [](struct AsyncCallbackInfo *data) {
            if (data == nullptr) {
                return;
            }
            if (data->context == nullptr || data->client == nullptr || data->client->mqttImpl == nullptr) {
                delete data;
                data = nullptr;
                return;
            }
            if (!data->client->mqttImpl->MqttSubscribe(data)) {
                LOGI("AsyncMqtt Unsubscribe MQTT_SUBSCRIBE_EVENT failed");
            }
            delete data;
            data = nullptr;
        };
        TaskPool::GetInstance().PushTask(ffrt_queue_priority_high, func, asyncCallbackInfo);
    }
    return NapiUtils::GetUndefined(env);
}

napi_value MqttAsyncClient::UnsubscribeMany(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Unsubscribe Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new SubscribeContext(env, eventManager);
    context->ParseParams(params, paramsCount);
    LOGI("AsyncMqtt UnsubscribeMany context code = %{public}d", context->GetCode());
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    asyncCallbackInfo->context = context;
    asyncCallbackInfo->count = 1;
    if (NapiUtils::GetValueType(env, context->GetCallback()) != napi_function && context->IsNeedPromise()) {
        LOGI("AsyncMqtt create promise");
        napi_value ret = NapiUtils::CreatePromise(env, &asyncCallbackInfo->deferred);
        context->SetIsPromise(true);
        CreateAsyncWork(env, "connect", [](napi_env env, void *data) {
                auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
                if (!asyncCallbackInfo && !asyncCallbackInfo->client) {
                        LOGI("AsyncMqtt asyncCallbackInfo is NULL");
                        return;
                }
                bool res = asyncCallbackInfo->client->mqttImpl->MqttUnsubscribe(asyncCallbackInfo);
                if (!res) {
                    asyncCallbackInfo->context->SetCode(-1);
                    asyncCallbackInfo->context->SetMessage("Unsubscribe fail");
                }
            },
            MqttResponseComplete, asyncCallbackInfo);
        return ret;
    }
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_UNSUBSCRIBE_EVENT, params[1], true, true);
        context->CreateTsFunction(MQTT_UNSUBSCRIBE_EVENT, context, NapiUtils::FinalizeCallBack,
                                  MqttAsyncClient::ResponseCallBack);
        if (!client->mqttImpl->MqttUnsubscribe(asyncCallbackInfo)) {
            MqttAsyncClient::RejectError(asyncCallbackInfo, MQTT_UNSUBSCRIBE_EVENT);
        }
    }
    return NapiUtils::GetUndefined(env);
}
napi_value MqttAsyncClient::MqttAsyncClient::Publish(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Publish Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new PublishContext(env, eventManager);
    context->ParseParams(params, paramsCount);
    LOGI("AsyncMqtt Publish context code = %{public}d", context->GetCode());
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    asyncCallbackInfo->context = context;
    asyncCallbackInfo->count = 1;
    if (NapiUtils::GetValueType(env, context->GetCallback()) != napi_function && context->IsNeedPromise()) {
        LOGI("AsyncMqtt create promise");
        napi_value ret = NapiUtils::CreatePromise(env, &asyncCallbackInfo->deferred);
        context->SetIsPromise(true);
        CreateAsyncWork(env, "connect", [](napi_env env, void *data) {
                auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
                if (!asyncCallbackInfo && !asyncCallbackInfo->client) {
                    LOGI("AsyncMqtt asyncCallbackInfo is NULL");
                    return;
                }
                bool res = asyncCallbackInfo->client->mqttImpl->MqttPublish(asyncCallbackInfo);
                if (!res) {
                    asyncCallbackInfo->context->SetCode(-1);
                    asyncCallbackInfo->context->SetMessage("Publish fail");
                }
            },
            MqttResponseComplete, asyncCallbackInfo);
        return ret;
    }
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_PUBLISH_EVENT, params[1], true, true);
        context->CreateTsFunction(MQTT_PUBLISH_EVENT, context, NapiUtils::FinalizeCallBack,
                                  MqttAsyncClient::ResponseCallBack);
        if (!client->mqttImpl->MqttPublish(asyncCallbackInfo)) {
            MqttAsyncClient::RejectError(asyncCallbackInfo, MQTT_PUBLISH_EVENT);
        }
    }
    return NapiUtils::GetUndefined(env);
}
napi_value MqttAsyncClient::MessageArrived(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt MessageArrived Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    if (paramsCount != paramCountOne || NapiUtils::GetValueType(env, params[0]) != napi_function) {
        LOGE("AsyncMqtt messagearrived interface param error");
        return NapiUtils::GetUndefined(env);
    }

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new PublishContext(env, eventManager); // 待释放
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_MESSAGE_ARRIVED_EVENT, params[0], false, true);
        context->CreateTsFunction(MQTT_MESSAGE_ARRIVED_EVENT, context, nullptr, MqttAsyncClient::MessageCallBack);
        if (client->mqttImpl->SetMessageArrivedCallback(context) != MQTTASYNC_SUCCESS) {
            eventManager->DeleteListener(MQTT_MESSAGE_ARRIVED_EVENT, params[0]);
            delete context;
        }
    }
    return NapiUtils::GetUndefined(env);
}
napi_value MqttAsyncClient::ConnectLost(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt ConnectLost Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    if (paramsCount != paramCountOne || NapiUtils::GetValueType(env, params[0]) != napi_function) {
        LOGE("AsyncMqtt connectlost interface param error");
        return NapiUtils::GetUndefined(env);
    }

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new BaseContext(env, eventManager); // 待释放
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_CONNECT_LOST_EVENT, params[0], false, true);
        context->CreateTsFunction(MQTT_CONNECT_LOST_EVENT, context, nullptr, MqttAsyncClient::ResponseCallBack);
        if (client->mqttImpl->SetConnectionLostCallback(context) != MQTTASYNC_SUCCESS) {
            eventManager->DeleteListener(MQTT_CONNECT_LOST_EVENT, params[0]);
            delete context;
        }
    }
    return NapiUtils::GetUndefined(env);
}
napi_value MqttAsyncClient::Disconnect(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt Disconnect Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    auto context = new BaseContext(env, eventManager);
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    asyncCallbackInfo->context = context;
    asyncCallbackInfo->count = 1;
    if (paramsCount != paramCountOne || NapiUtils::GetValueType(env, params[0]) != napi_function) {
        LOGI("AsyncMqtt create promise");
        napi_value ret = NapiUtils::CreatePromise(env, &asyncCallbackInfo->deferred);
        context->SetIsPromise(true);
        CreateAsyncWork(env, "Disconnect", [](napi_env env, void *data) {
                auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
                if (!asyncCallbackInfo && !asyncCallbackInfo->client) {
                    LOGI("AsyncMqtt asyncCallbackInfo is NULL");
                    return;
                }
                bool res = asyncCallbackInfo->client->mqttImpl->MqttDisconnect(asyncCallbackInfo);
                if (!res) {
                    asyncCallbackInfo->context->SetCode(-1);
                    asyncCallbackInfo->context->SetMessage("Disconnect fail");
                }
            },
            MqttResponseComplete, asyncCallbackInfo);
        return ret;
    }
    if (eventManager != nullptr) {
        eventManager->AddListener(env, MQTT_DISCONNECT_EVENT, params[0], true, true);
        context->CreateTsFunction(MQTT_DISCONNECT_EVENT, context, NapiUtils::FinalizeCallBack,
                                  MqttAsyncClient::ResponseCallBack);
        if (!client->mqttImpl->MqttDisconnect(asyncCallbackInfo)) {
            MqttAsyncClient::RejectError(asyncCallbackInfo, MQTT_DISCONNECT_EVENT);
        }
    }
    return NapiUtils::GetUndefined(env);
}

void IsConnectedExecute(napi_env env, void *data)
{
    auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
    if (!asyncCallbackInfo || !asyncCallbackInfo->client) {
        LOGE("AsyncMqtt IsConnectedExecute asyncCallbackInfo is NULL");
        asyncCallbackInfo->param = false;
        return;
    }
    asyncCallbackInfo->param = asyncCallbackInfo->client->mqttImpl->IsConnected();
}

void Complete(napi_env env, napi_status nousb, void *data)
{
    auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
    if (!asyncCallbackInfo || !asyncCallbackInfo->deferred || !asyncCallbackInfo->deferred ||
        !asyncCallbackInfo->async_work) {
        LOGE("AsyncMqtt Complete asyncCallbackInfo is NULL");
        return;
    }
    napi_value result;
    napi_status status = napi_get_boolean(env, asyncCallbackInfo->param, &result);
    if (status != napi_ok) {
        LOGE("AsyncMqtt Complete napi_create_int32 fail");
        return;
    }
    // Resolve or reject the promise associated with the deferred depending on
    // whether the asynchronous action succeeded.
    napi_resolve_deferred(env, asyncCallbackInfo->deferred, result);

    // At this point the deferred has been freed, so we should assign NULL to it.
    asyncCallbackInfo->deferred = nullptr;
    napi_delete_async_work(env, asyncCallbackInfo->async_work);

    delete asyncCallbackInfo;
}

napi_value MqttAsyncClient::IsConnected(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt IsConnected Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);
    struct AsyncCallbackInfo *asyncCallbackInfo = new AsyncCallbackInfo();
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    asyncCallbackInfo->client = client;
    napi_value promise;
    napi_status status = napi_create_promise(env, &asyncCallbackInfo->deferred, &promise);
    if (status != napi_ok) {
        return NULL;
    }
    napi_value resource = nullptr;
    status = napi_create_string_utf8(env, "IsConnected", NAPI_AUTO_LENGTH, &resource);
    if (status != napi_ok) {
        return nullptr;
    }
    // Create async work.
    status = napi_create_async_work(env, nullptr, resource, IsConnectedExecute, Complete,
        reinterpret_cast<void *>(asyncCallbackInfo), &asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        LOGE("AsyncMqtt IsConnected napi_create_async_work fail");
        return nullptr;
    }
    status = napi_queue_async_work(env, asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        LOGE("AsyncMqtt IsConnected napi_queue_async_work fail");
        return nullptr;
    }
    // Return the promise to JS
    return promise;
}


void ReconnectExecute(napi_env env, void *data)
{
    auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
    if (!asyncCallbackInfo || !asyncCallbackInfo->client) {
        LOGI("AsyncMqtt ReconnectExecute asyncCallbackInfo is NULL");
        asyncCallbackInfo->param = false;
        return;
    }
    asyncCallbackInfo->param = asyncCallbackInfo->client->mqttImpl->MqttReConnect();
}

napi_value MqttAsyncClient::Reconnect(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt Reconnect Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);
    auto asyncCallbackInfo = new AsyncCallbackInfo();
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    asyncCallbackInfo->client = client;
    napi_deferred deferred;
    napi_value promise;
    napi_status status = napi_create_promise(env, &asyncCallbackInfo->deferred, &promise);
    if (status != napi_ok) {
        return NULL;
    }
    napi_value resource = nullptr;
    status = napi_create_string_utf8(env, "Destroy", NAPI_AUTO_LENGTH, &resource);
    if (status != napi_ok) {
        return nullptr;
    }
    // Create async work.
    status = napi_create_async_work(env, nullptr, resource, ReconnectExecute, Complete,
        reinterpret_cast<void *>(asyncCallbackInfo), &asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        LOGE("AsyncMqtt Reconnect napi_create_async_work fail");
        return nullptr;
    }
    status = napi_queue_async_work(env, asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        LOGE("AsyncMqtt Reconnect napi_queue_async_work fail");
        return nullptr;
    }
    // Return the promise to JS
    return promise;
}
napi_value MqttAsyncClient::SetMqttTrace(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt SetMqttTrace");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    EventManager *eventManager = nullptr;
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    eventManager = client->manager;
    uint32_t level = NapiUtils::GetUint32FromValue(env, params[0]);
    if (level == 0) {
        level = MQTTASYNC_TRACE_MINIMUM;
    }
    client->mqttImpl->SetMqttTrace((enum MQTTASYNC_TRACE_LEVELS)level);
    return NapiUtils::GetUndefined(env);
}

void DestroyExecute(napi_env env, void *data)
{
    auto asyncCallbackInfo = reinterpret_cast<AsyncCallbackInfo *>(data);
    if (!asyncCallbackInfo || !asyncCallbackInfo->client) {
        LOGI("AsyncMqtt ReconnectExecute asyncCallbackInfo is NULL");
        asyncCallbackInfo->param = false;
        return;
    }
    asyncCallbackInfo->param = asyncCallbackInfo->client->mqttImpl->Destroy();
}

napi_value MqttAsyncClient::Destroy(napi_env env, napi_callback_info info)
{
    LOGD("AsyncMqtt Destroy Start");
    napi_value thisVal = nullptr;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);
    MqttAsyncClient *client = nullptr;
    napi_unwrap(env, thisVal, (void **)&client);
    auto asyncCallbackInfo = new AsyncCallbackInfo();
    asyncCallbackInfo->client = client;
    napi_deferred deferred;
    napi_value promise;
    napi_status status = napi_create_promise(env, &asyncCallbackInfo->deferred, &promise);
    if (status != napi_ok) {
        return NULL;
    }
    napi_value resource = nullptr;
    status = napi_create_string_utf8(env, "Destroy", NAPI_AUTO_LENGTH, &resource);
    if (status != napi_ok) {
        return nullptr;
    }
    // Create async work.
    status = napi_create_async_work(env, nullptr, resource, DestroyExecute, Complete,
        reinterpret_cast<void *>(asyncCallbackInfo), &asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        return nullptr;
    }
    status = napi_queue_async_work(env, asyncCallbackInfo->async_work);
    if (status != napi_ok) {
        LOGE("AsyncMqtt IsConnected napi_queue_async_work fail");
        return nullptr;
    }
    // Return the promise to JS
    return promise;
}

void MqttAsyncClient::CreateAsyncWork(napi_env env, const std::string &name, AsyncWorkExecutor executor,
                                      AsyncWorkCallback callback, AsyncCallbackInfo *asyncCallbackInfoOne)
{
    napi_status ret = napi_create_async_work(env, nullptr, NapiUtils::CreateStringUtf8(env, name), executor, callback,
            reinterpret_cast<void *>(asyncCallbackInfoOne), &asyncCallbackInfoOne->async_work);
    if (ret != napi_ok) {
        return;
    }
    (void)napi_queue_async_work(env, asyncCallbackInfoOne->async_work);
}

void MqttAsyncClient::ParseClientOptions(napi_env env, napi_value objValue, MqttClientOptions *options)
{
    LOGD("AsyncMqtt ParseClientOptions Start");
    if (NapiUtils::GetValueType(env, objValue) != napi_object) {
        LOGE("AsyncMqtt clientOptions error");
        return;
    }
    options->SetUrl(NapiUtils::GetStringPropertyUtf8(env, objValue, MqttConstant::PARAM_URL));
    options->SetClientId(NapiUtils::GetStringPropertyUtf8(env, objValue, MqttConstant::PARAM_CLIENT_ID));
    options->SetPersistenceType(NapiUtils::GetUint32Property(env, objValue, MqttConstant::PARAM_PERSISTENCE_TYPE));
    
    bool result = NapiUtils::HasNamedProperty(env, objValue, MqttConstant::PARAM_MQTTVERSION);
    if (result) {
        options->SetMqttVersion(NapiUtils::GetUint32Property(env, objValue, MqttConstant::PARAM_MQTTVERSION));
    }
    LOGD("AsyncMqtt ParseClientOptions End, MqttVersion = %{public}u", options->GetMqttVersion());
}

void MqttAsyncClient::ResponseCallBack(napi_env env, napi_value tsfn_cb, void *context, void *data)
{
    LOGD("AsyncMqtt ResponseCallBack1 context= %{public}x", context);
    auto baseContext = reinterpret_cast<BaseContext *>(context);
    auto mqttResponsePt = reinterpret_cast<MqttResponse *>(data);
    napi_value message = CreateMqttResponse(baseContext, mqttResponsePt);
    if (message == nullptr) {
        LOGE("AsyncMqtt ResponseCallBack1 message is NULL");
        return;
    }
    napi_value undefined = NapiUtils::GetUndefined(baseContext->GetEnv());
    baseContext->Emit(baseContext->EventType(), std::make_pair(undefined, message));
    delete mqttResponsePt;
}

napi_value MqttAsyncClient::CreateMqttResponse(BaseContext *context, MqttResponse *mqttResponse)
{
    napi_value object = NapiUtils::CreateObject(context->GetEnv());
    if (NapiUtils::GetValueType(context->GetEnv(), object) != napi_object) {
        return nullptr;
    }
    NapiUtils::SetStringPropertyUtf8(context->GetEnv(), object, MqttConstant::RESPONSE_KEY_MESSAGE,
                                     mqttResponse->GetMessage());
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::RESPONSE_KEY_CODE, mqttResponse->GetCode());
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::RESPONSE_KEY_REASON_CODE, mqttResponse->GetReasonCode());
    NapiUtils::SetMqttProperties(context->GetEnv(), object, MqttConstant::PARAM_PROPERTIES, mqttResponse->GetProperties());
    return object;
}

napi_value MqttAsyncClient::CreateMqttMessage(BaseContext *context, MqttMessage *mqttMessage)
{
    napi_value object = NapiUtils::CreateObject(context->GetEnv());
    if (NapiUtils::GetValueType(context->GetEnv(), object) != napi_object) {
        return nullptr;
    }
    NapiUtils::SetStringPropertyUtf8(context->GetEnv(), object, MqttConstant::PARAM_TOPIC, mqttMessage->GetTopic());
    NapiUtils::SetStringPropertyUtf8(context->GetEnv(), object, MqttConstant::PARAM_PAYLOAD, mqttMessage->GetPayload());
    NapiUtils::SetStringPropertyVector(context->GetEnv(),
                                       object,
                                       MqttConstant::PARAM_PAYLOAD_BINARY,
                                       mqttMessage->GetPayloadBinary());
    NapiUtils::SetUint32Property(context->GetEnv(), object, MqttConstant::PARAM_QOS, mqttMessage->GetQos());
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::PARAM_RETAINED, mqttMessage->GetRetained());
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::PARAM_DUP, mqttMessage->GetDup());
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::PARAM_MSGID, mqttMessage->GetMsgid());
    NapiUtils::SetMqttProperties(context->GetEnv(), object, MqttConstant::PARAM_PROPERTIES, mqttMessage->GetProperties());
    return object;
}

void MqttAsyncClient::RejectError(AsyncCallbackInfo *info, const std::string &type)
{
    auto context = reinterpret_cast<BaseContext *>(info->context);
    napi_value object = NapiUtils::CreateObject(context->GetEnv());
    if (NapiUtils::GetValueType(context->GetEnv(), object) != napi_object) {
        return;
    }
    NapiUtils::SetStringPropertyUtf8(context->GetEnv(), object, MqttConstant::RESPONSE_KEY_MESSAGE,
                                     MqttConstant::RESPONSE_ERROR_MSG);
    NapiUtils::SetInt32Property(context->GetEnv(), object, MqttConstant::RESPONSE_KEY_CODE,
                                MqttConstant::RESPONSE_ERROR_CODE);
    napi_value undefined = NapiUtils::GetUndefined(context->GetEnv());
    context->Emit(type, std::make_pair(undefined, object));
    if (context->GetIsComplete()) {
        delete info->context;
        info->context = nullptr;
        delete info;
        info = nullptr;
    }
}

void MqttAsyncClient::MessageCallBack(napi_env env, napi_value tsfn_cb, void *context, void *data)
{
    LOGD("AsyncMqtt MessageCallBack");
    auto publishContext = reinterpret_cast<PublishContext *>(context);
    auto mqttMessagePt = reinterpret_cast<MqttMessage *>(data);
    napi_value mqttMessage = CreateMqttMessage(publishContext, mqttMessagePt);
    if (mqttMessage == nullptr) {
        LOGE("AsyncMqtt MessageCallBack mqttMessage is NULL");
        return;
    }
    napi_value undefined = NapiUtils::GetUndefined(publishContext->GetEnv());
    publishContext->Emit(publishContext->EventType(), std::make_pair(undefined, mqttMessage));
    delete mqttMessagePt;
}
}
}