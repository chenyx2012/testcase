/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

#include "mqtt_impl.h"
#include <algorithm>
#include <cstddef>
#include <cstring>
#include <memory>
#include "mqtt_constant.h"
#include "event_list.h"
#include "mqtt_client.h"
#include "mqtt_log.h"
#include "mqtt_napi_utils.h"
#include "MQTTProperties.h"

namespace OHOS {
namespace PahoMqtt {

int MqttImpl::SslErrorCallback(const char *str, size_t len, void *u)
{
    LOGE("AsyncMqtt MqttSslErr: str: %{public}s, len: %{public}d, u: %{public}s", str, len, u);
    return 0;
}

void MqttImpl::MqttTraceCallback(enum MQTTASYNC_TRACE_LEVELS level, char *message)
{
    LOGD("AsyncMqtt MqttTrace: level: %{public}d, msg: %{public}s", level, message);
}

bool MqttImpl::Initialize(MqttClientOptions options)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (initialized_) {
        return true;
    }
    std::string clientId = options.GetClientId();
    std::string url = options.GetUrl();
    int persistenceType = options.GetPersistenceType();
    MQTTAsync_createOptions createOpts = MQTTAsync_createOptions_initializer;
    if (options.GetMqttVersion() == MQTTVERSION_5) {
        createOpts = MQTTAsync_createOptions_initializer5;
    } else {
        createOpts = MQTTAsync_createOptions_initializer;
    }
    int rc = MQTTAsync_createWithOptions(&mqttAsync_, url.c_str(), clientId.c_str(), persistenceType, NULL, &createOpts);
    LOGI("AsyncMqtt MQTTAsync_create url: %{public}s, MQTTVersion: %{public}d, struct_version: %{public}d, rc = %{public}d",
        url.c_str(), createOpts.MQTTVersion, createOpts.struct_version, rc);
    
    if (rc != MQTTASYNC_SUCCESS) {
        return false;
    }
    initialized_ = true;
    return initialized_;
}

void MqttImpl::OnConnectSuccess(void *context, MQTTAsync_successData *response)
{
    LOGI("AsyncMqtt Connect Success MQTTVersion: %{public}d, sessionPresent: %{public}d",
         response->alt.connect.MQTTVersion, response->alt.connect.sessionPresent);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetMessage("Connect Success");
    ImplCallBack(context, MQTT_CONNECT_EVENT, mqttResponse);
}

static void FillMqttResponseProperties(MqttResponse& mqttResponse, MQTTProperties& responseProperties)
{
    auto properties = std::make_shared<Properties>();
    for (int i = 0; i < responseProperties.count; i++) {
        MQTTProperty property = responseProperties.array[i];
        LOGD("AsyncMqtt Property %{public}d:\n", i + 1);
        LOGD("AsyncMqtt  Identifier: %{public}d\n", property.identifier);
        auto type = MQTTProperty_getType(property.identifier);
        LOGD("AsyncMqtt  Type: %{public}d\n", type);
        switch (type) {
            case MQTTPROPERTY_TYPE_BYTE:
                properties->integerProperties.emplace_back(property.value.byte);
                break;
            case MQTTPROPERTY_TYPE_TWO_BYTE_INTEGER:
                properties->integerProperties.emplace_back(property.value.integer2);
                break;
            case MQTTPROPERTY_TYPE_FOUR_BYTE_INTEGER:
            case MQTTPROPERTY_TYPE_VARIABLE_BYTE_INTEGER:
                properties->integerProperties.emplace_back(property.value.integer4);
                break;
            case MQTTPROPERTY_TYPE_BINARY_DATA:
            case MQTTPROPERTY_TYPE_UTF_8_ENCODED_STRING:
                properties->strProperties.emplace_back(std::string(property.value.data.data, property.value.data.len));
                break;
            case MQTTPROPERTY_TYPE_UTF_8_STRING_PAIR:
                properties->userProperties.push_back({.key = std::string(property.value.data.data, property.value.data.len),
                    .val = std::string(property.value.value.data, property.value.value.len)});
                break;
            default:
                LOGE("AsyncMqtt  Value: (unknown type)\n");
                break;
        }
    }
    mqttResponse.SetProperties(properties);
}

void MqttImpl::OnConnectSuccess5(void *context, MQTTAsync_successData5 *response)
{
    LOGI("AsyncMqtt Connect Success MQTTVersion: %{public}d, sessionPresent: %{public}d, reasonCode=%{public}d, properties.count = %{public}d",
         response->alt.connect.MQTTVersion, response->alt.connect.sessionPresent, response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage("Connect5 Success");
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_CONNECT_EVENT, mqttResponse);
}

void MqttImpl::OnConnectFail(void *context, MQTTAsync_failureData *response)
{
    LOGI("AsyncMqtt Connect Fail code: %{public}d, message: %{public}s", response->code, response->message);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    ImplCallBack(context, MQTT_CONNECT_EVENT, mqttResponse);
}

void MqttImpl::OnConnectFail5(void *context, MQTTAsync_failureData5 *response)
{
    LOGI("AsyncMqtt Connect Fail code: %{public}d, message: %{public}s, reasonCode: %{public}d, properties.count = %{public}d", response->code, response->message, response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_CONNECT_EVENT, mqttResponse);
}

int MqttImpl::MessageArrived(void *context, char *topicName, int topicLen, MQTTAsync_message *message)
{
    LOGI("AsyncMqtt MessageArrived topicName: %{public}s msgid: %{public}d", topicName, message->msgid);
    if (message == nullptr) {
        return 0;
    }

    if ((topicName == nullptr) || (strlen(topicName) == 0)) {
        return 0;
    }

    auto publishContext = reinterpret_cast<PublishContext *>(context);
    MqttMessage *mqttMessage = new MqttMessage();
    if (!mqttMessage) {
        return 0;
    }

    std::vector<uint8_t> vec;
    uint8_t *tmp = (uint8_t*) message->payload;
    for (int i = 0; i < message->payloadlen; i++) {
        vec.push_back(tmp[i]);
    }
    auto properties = std::make_shared<Properties>();
    if (message->payloadlen > 0) {
        properties->contentType = "application/json";
    }
    for (int i = 0; i < message->properties.count; i++) {
        const MQTTProperty* prop = &message->properties.array[i];
        std::string key;
        std::string val;
        switch (prop->identifier) {
            case MQTTPROPERTY_CODE_USER_PROPERTY:
                key = std::string(prop->value.data.data, prop->value.data.len);
                val = std::string(prop->value.value.data, prop->value.value.len);
                LOGD("AsyncMqtt User Property - Key: %{public}s, Value: %{public}s\n", key.c_str(), val.c_str());
                properties->userProperties.push_back({.key = std::move(key), .val = std::move(val)});
                break;
            default:
                LOGE("AsyncMqtt Unknown Property - Identifier: %d\n", prop->identifier);
                break;
        }
    }
    mqttMessage->SetTopic(std::string(topicName));
    mqttMessage->SetPayload(std::string((char *)message->payload, message->payloadlen));
    mqttMessage->SetPayloadBinary(vec);
    mqttMessage->SetQos(message->qos);
    mqttMessage->SetRetained(message->retained);
    mqttMessage->SetDup(message->dup);
    mqttMessage->SetMsgid(message->msgid);
    mqttMessage->SetProperties(properties);
    publishContext->CallTsFunction(MQTT_MESSAGE_ARRIVED_EVENT, mqttMessage);
    MQTTAsync_freeMessage(&message);
    MQTTAsync_free(topicName);
    return 1;
}

void MqttImpl::ConnectionLost(void *context, char *cause)
{
    LOGI("AsyncMqtt MqttImpl::connectionLost");
    auto baseContext = reinterpret_cast<BaseContext *>(context);
    MqttResponse *mqttResponse = new MqttResponse();
    mqttResponse->SetMessage(cause == nullptr ? "null" : cause);
    mqttResponse->SetCode(MQTTASYNC_SUCCESS);
    baseContext->CallTsFunction(MQTT_CONNECT_LOST_EVENT, mqttResponse);
}

void MqttImpl::OnSubscribeSuccess(void *context, MQTTAsync_successData *response)
{
    LOGI("AsyncMqtt OnSubscribe Success");
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetMessage("Subscribe Success");
    ImplCallBack(context, MQTT_SUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnSubscribeSuccess5(void *context, MQTTAsync_successData5 *response)
{
    LOGI("AsyncMqtt OnSubscribe5 Success, reasonCode=%{public}d, MQTTProperties count=%{public}d, properties.count = %{public}d", response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage("Subscribe5 Success");
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_SUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnSubscribeFail(void *context, MQTTAsync_failureData *response)
{
    LOGI("AsyncMqtt OnSubscribeFail code: %{public}d, message: %{public}s", response->code, response->message);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    ImplCallBack(context, MQTT_SUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnSubscribeFail5(void *context, MQTTAsync_failureData5 *response)
{
    LOGI("AsyncMqtt OnSubscribeFail5 code: %{public}d, message: %{public}s, reasonCode: %{public}d, properties.count = %{public}d", response->code, response->message, response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_SUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnUnSubscribe(void *context, MQTTAsync_successData *response)
{
    LOGI("AsyncMqtt OnUnSubscribe Success");
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetMessage("UnSubscribe Success");
    ImplCallBack(context, MQTT_UNSUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnUnSubscribe5(void *context, MQTTAsync_successData5 *response)
{
    LOGI("AsyncMqtt OnUnSubscribe5 Success.reasonCode: %{public}d, properties.count = %{public}d", response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage("UnSubscribe5 Success");
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_UNSUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnUnSubscribeFail(void *context, MQTTAsync_failureData *response)
{
    LOGI("AsyncMqtt OnUnSubscribeFail code: %{public}d, message: %{public}s", response->code, response->message);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    ImplCallBack(context, MQTT_UNSUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnUnSubscribeFail5(void *context, MQTTAsync_failureData5 *response)
{
    LOGI("AsyncMqtt OnUnSubscribeFail5 code: %{public}d, message: %{public}s, reasonCode: %{public}d, properties.count = %{public}d", response->code, response->message, response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_UNSUBSCRIBE_EVENT, mqttResponse);
}

void MqttImpl::OnDisconnect(void *context, MQTTAsync_successData *response)
{
    LOGI("AsyncMqtt OnDisconnect Success");
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetMessage("Disconnect Success");
    ImplCallBack(context, MQTT_DISCONNECT_EVENT, mqttResponse);
}

void MqttImpl::OnDisconnect5(void *context, MQTTAsync_successData5 *response)
{
    LOGI("AsyncMqtt OnDisconnect5 Success.reasonCode: %{public}d, properties.count = %{public}d", response->reasonCode,  response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage("Disconnect5 Success");
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_DISCONNECT_EVENT, mqttResponse);
}

void MqttImpl::ImplCallBack(void *context, const std::string &type, const MqttResponse& mqttResponse)
{
    std::lock_guard<std::mutex> lock(publishMutex);
    const size_t MAX_COUNT = 0xff;
    auto info = reinterpret_cast<AsyncCallbackInfo *>(context);
    if (info == nullptr || info->context == nullptr) {
        LOGE("AsyncMqtt ImplCallBack context is NULL");
        return;
    }
    info->work_finished = WORK_IS_FINISH;
    info->count--;
    auto baseContext = reinterpret_cast<BaseContext *>(info->context);
    int res = baseContext->GetIsComplete();
    if (!res) {
        LOGE("AsyncMqtt ImplCallBack REQUEST_NO_CALLBACK count: %{public}d", info->count);
        if (info->count <= 0) {
            info->count = MAX_COUNT;
            delete info->context;
            info->context = nullptr;
            delete info;
            info = nullptr;
        }
        return;
    }
    if (!baseContext->GetIsPromise()) {
        MqttResponse *mqttResponsePtr = new MqttResponse(mqttResponse);
        if (mqttResponsePtr == nullptr) {
            LOGE("AsyncMqtt ImplCallBack mqttResponsePtr is NULL");
            return;
        }
        baseContext->CallTsFunction(type, mqttResponsePtr);
        baseContext->ReleaseTsFunction();
    } else {
        baseContext->SetCode(mqttResponse.GetCode());
        baseContext->SetReasonCode(mqttResponse.GetReasonCode());
        baseContext->SetMessage(mqttResponse.GetMessage());
        baseContext->SetProperties(mqttResponse.GetProperties());
        baseContext->SetIsPromise(false);
    }
    baseContext->SetFinished(type, 1);
    if (info->count <= 0) {
        info->count = MAX_COUNT;
        delete info->context;
        info->context = nullptr;
        delete info;
        info = nullptr;
    }
}

void MqttImpl::OnPublishSuccess(void *context, MQTTAsync_successData *response)
{
    LOGI("AsyncMqtt OnPublish Success");
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetMessage("Publish Success");
    ImplCallBack(context, MQTT_PUBLISH_EVENT, mqttResponse);
}

void MqttImpl::OnPublishSuccess5(void *context, MQTTAsync_successData5 *response)
{
    LOGI("AsyncMqtt OnPublish5 Success, reasonCode=%{public}d, properties.count = %{public}d", response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(0);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage("Publish5 Success");
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_PUBLISH_EVENT, mqttResponse);
}

void MqttImpl::OnPublishFail(void *context, MQTTAsync_failureData *response)
{
    LOGI("AsyncMqtt OnPublishFail code: %{public}d, message: %{public}s", response->code, response->message);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    ImplCallBack(context, MQTT_PUBLISH_EVENT, mqttResponse);
}

void MqttImpl::OnPublishFail5(void *context, MQTTAsync_failureData5 *response)
{
    LOGI("AsyncMqtt OnPublishFail5 code: %{public}d, message: %{public}s, reasonCode: %{public}d, properties.count = %{public}d", response->code, response->message, response->reasonCode, response->properties.count);
    MqttResponse mqttResponse;
    mqttResponse.SetCode(response->code);
    mqttResponse.SetReasonCode(response->reasonCode);
    mqttResponse.SetMessage(response->message == nullptr ? "failed" : response->message);
    FillMqttResponseProperties(mqttResponse, response->properties);
    ImplCallBack(context, MQTT_PUBLISH_EVENT, mqttResponse);
}

bool MqttImpl::CheckCallBack(AsyncCallbackInfo *info)
{
    int flag = info->context->GetIsComplete();
    if (!flag) {
        LOGE("AsyncMqtt CheckCallBack REQUEST_NO_CALLBACK");
    }
    
    return flag;
}

bool MqttImpl::CheckConnecte()
{
    if (!initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        return false;
    }
    if (MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is connected");
        return false;
    }
    return true;
}

MQTTAsync_connectOptions MqttImpl::GetOptions(AsyncCallbackInfo *info, MQTTAsync_SSLOptions *sslOptions,
                                              MQTTAsync_willOptions *willOptions)
{
    LOGI("AsyncMqtt GetOptions start");
    ConnectContext *context = reinterpret_cast<ConnectContext *>(info->context);
    MQTTAsync_connectOptions opts = context->options.GetConnectOptions();
    info->count++;
    if (opts.MQTTVersion == MQTTVERSION_5) {
        opts.onSuccess5 = OnConnectSuccess5;
        opts.onFailure5 = OnConnectFail5;
    } else {
        opts.onSuccess = OnConnectSuccess;
        opts.onFailure = OnConnectFail;
    }
    opts.automaticReconnect = false;
    opts.context = info;
    if (context->options.GetHasSslOptions()) {
        *sslOptions = context->options.GetSslOptions();
        opts.ssl = sslOptions;
        opts.ssl->ssl_error_cb = SslErrorCallback;
    }
    if (context->options.GetHasWillOptions()) {
        *willOptions = context->options.GetWillOptions();
        opts.will = willOptions;
    }
	LOGI("AsyncMqtt GetOptions end.struct_version=%{public}d, MQTTVersion=%{public}d", opts.struct_version, opts.MQTTVersion);
    return opts;
}

bool MqttImpl::MqttConnect(AsyncCallbackInfo *info)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (info == nullptr || info->context == nullptr) {
        return false;
    }
    LOGI("AsyncMqtt MqttConnect start");
    int rc = MQTTASYNC_FAILURE;
    int count = 0;
    int timeoutCount = 0;
    MQTTAsync_connectOptions opts;
    MQTTAsync_SSLOptions sslOptions;
    MQTTAsync_willOptions willOptions;
    ConnectContext *context = reinterpret_cast<ConnectContext *>(info->context);
    if (!CheckConnecte()) {
        goto fail;
    }
    opts = MqttImpl::GetOptions(info, &sslOptions, &willOptions);
    timeoutCount = ((opts.connectTimeout + 5) * 1000LL * 1000LL) / MqttImpl::sleepTime_;
    rc = MQTTAsync_connect(mqttAsync_, &opts);
    FreeConnectcontext(context);
    LOGI("AsyncMqtt MQTTAsync_connect rc = %{public}d", rc);
    if (rc != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MQTTAsync_connect failed:");
        goto fail;
    }
    while (!context->GetFinished(MQTT_CONNECT_EVENT) && (++count < timeoutCount)) {
        usleep(MqttImpl::sleepTime_);
    }
    if (!context->GetFinished(MQTT_CONNECT_EVENT)) {
        LOGE("AsyncMqtt MQTTAsync_connect no response. connectTimeout : %{public}d", opts.connectTimeout);
        context->SetIsComplete(false);
        goto fail;
    }
    context->SetFinished(MQTT_CONNECT_EVENT, 0);
    return true;
    
fail:
    context->SetFinished(MQTT_CONNECT_EVENT, 0);
    return false;
}

bool MqttImpl::MqttDisconnect(AsyncCallbackInfo *info)
{
    if (info == nullptr || info->context == nullptr) {
        return false;
    }
    BaseContext *context = reinterpret_cast<BaseContext *>(info->context);
    int count = 0;
    MQTTAsync_disconnectOptions opts = MQTTAsync_disconnectOptions_initializer;
    info->count++;
    auto mqttVersion = info->client->manager->options.GetMqttVersion();
    if (mqttVersion == MQTTVERSION_5) {
        opts.onSuccess5 = OnDisconnect5;
    } else {
        opts.onSuccess = OnDisconnect;
    }
    opts.context = info;
    LOGD("AsyncMqtt MqttDisconnect");
    int rc = MQTTASYNC_FAILURE;
    if (!initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        goto fail;
    }
    if (!MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is not connected");
        goto fail;
    }
    rc = MQTTAsync_disconnect(mqttAsync_, &opts);
    if (rc != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MqttDisconnect res: %{public}d", rc);
        goto fail;
    }
    while (!context->GetFinished(MQTT_DISCONNECT_EVENT) && (++count < cyclesCount_)) {
        usleep(MqttImpl::sleepTime_);
    }
    if (!context->GetFinished(MQTT_DISCONNECT_EVENT)) {
        LOGE("AsyncMqtt MQTTAsync_disconnect no response");
        context->SetIsComplete(false);
        goto fail;
    }
    context->SetFinished(MQTT_DISCONNECT_EVENT, 0);
    return true;
    
fail:
    context->SetFinished(MQTT_DISCONNECT_EVENT, 0);
    return false;
}

bool MqttImpl::MqttReConnect()
{
    LOGD("AsyncMqtt MqttReConnect");
    if (!initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        return false;
    }
    int count = 0;
    if (MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is connected");
        return false;
    }
    int rc = MQTTAsync_reconnect(mqttAsync_);
    if (rc != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MqttReConnect res: %{public}d", rc);
        return false;
    }
    
    while (!MqttImpl::IsConnected() && (++count < cyclesCount_)) {
        usleep(MqttImpl::sleepTime_);
    }
    
    if (!MqttImpl::IsConnected()) {
        return false;
    }
    return true;
}

bool MqttImpl::IsConnected()
{
    if (!initialized_) {
        return false;
    }
    return MQTTAsync_isConnected(mqttAsync_);
}

bool MqttImpl::MqttSubscribe(AsyncCallbackInfo *info)
{
    if (info == nullptr || info->context == nullptr) {
        return false;
    }
    SubscribeContext *context = reinterpret_cast<SubscribeContext *>(info->context);
    auto mqttVersion = info->client->manager->options.GetMqttVersion();
    LOGD("AsyncMqtt Starting - MqttSubscribe.MQTTVersion=%{public}u", mqttVersion);
    int countTime = 0;
    MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
    if (mqttVersion == MQTTVERSION_5) {
        opts.onSuccess5 = OnSubscribeSuccess5;
        opts.onFailure5 = OnSubscribeFail5;
    } else {
        opts.onSuccess = OnSubscribeSuccess;
        opts.onFailure = OnSubscribeFail;
    }
    opts.context = info;
    info->count++;
    int count = context->options.GetTopics().size();
    char *const *topics = context->options.GetTopicList();
    const int *qos = context->options.GetQosList();
    int rc = MQTTASYNC_FAILURE;
    if (!initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        goto fail;
    }
    if (!MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is not connected");
        goto fail;
    }
    rc = MQTTAsync_subscribeMany(mqttAsync_, count, topics, qos, &opts);
    if (rc != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MqttSubscribe failed, rc=%{public}d:", rc);
        goto fail;
    }
    while (!context->GetFinished(MQTT_SUBSCRIBE_EVENT) && (++countTime < cyclesCount_)) {
        usleep(MqttImpl::sleepTime_);
    }
    
    if (!context->GetFinished(MQTT_SUBSCRIBE_EVENT)) {
        LOGE("AsyncMqtt MqttSubscribe no response");
        context->SetIsComplete(false);
        goto fail;
    }
    context->SetFinished(MQTT_SUBSCRIBE_EVENT, 0);
    return true;
    
fail:
    context->SetFinished(MQTT_SUBSCRIBE_EVENT, 0);
    if (topics != nullptr) {
        delete [] topics;
        topics = nullptr;
    }
    if (qos != nullptr) {
        delete [] qos;
        topics = nullptr;
    }
    return false;
}

bool MqttImpl::MqttUnsubscribe(AsyncCallbackInfo *info)
{
    if (info == nullptr || info->context == nullptr) {
        return false;
    }
    SubscribeContext *context = reinterpret_cast<SubscribeContext *>(info->context);
    LOGD("AsyncMqtt Starting MqttUnsubscribe");
    MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
    info->count++;
    auto mqttVersion = info->client->manager->options.GetMqttVersion();
    if (mqttVersion == MQTTVERSION_5) {
        opts.onSuccess5 = OnUnSubscribe5;
        opts.onFailure5 = OnUnSubscribeFail5;
    } else {
        opts.onSuccess = OnUnSubscribe;
        opts.onFailure = OnUnSubscribeFail;
    }
    opts.context = info;
    int count = context->options.GetTopics().size();
    char *const *topics = context->options.GetTopicList();
    int rc = MQTTASYNC_FAILURE;
    if (!initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        goto fail;
    }
    if (!MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is not connected");
        goto fail;
    }
    rc = MQTTAsync_unsubscribeMany(mqttAsync_, count, topics, &opts);
    if (rc != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MqttUnsubscribe failed: ");
        goto fail;
    }
    while (!context->GetFinished(MQTT_UNSUBSCRIBE_EVENT) && (++count < cyclesCount_)) {
        usleep(MqttImpl::sleepTime_);
    }
    
    if (!context->GetFinished(MQTT_UNSUBSCRIBE_EVENT)) {
        LOGE("AsyncMqtt MqttUnsubscribe no response");
        context->SetIsComplete(false);
        goto fail;
    }
    context->SetFinished(MQTT_UNSUBSCRIBE_EVENT, 0);
    return true;
    
fail:
    context->SetFinished(MQTT_UNSUBSCRIBE_EVENT, 0);
    if (topics != nullptr) {
        delete [] topics;
        topics = nullptr;
    }
    return false;
}

bool MqttImpl::MqttPublish(AsyncCallbackInfo *info)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (info == nullptr || info->context == nullptr) {
        return false;
    }
    PublishContext *context = reinterpret_cast<PublishContext *>(info->context);
    MQTTAsync_message pubmsg = MQTTAsync_message_initializer;
    MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
    MQTTProperties props = MQTTProperties_initializer;
    auto mqttVersion = info->client->manager->options.GetMqttVersion();
    LOGD("AsyncMqtt Starting - MqttPublish");
    int rc1 = MQTTASYNC_FAILURE;
    int rc2 = MQTTASYNC_FAILURE;
    int32_t responseCode = rc1;
    std::vector<uint8_t> payloadBinary = context->mqttMessage.GetPayloadBinary();
    std::string payload = context->mqttMessage.GetPayload();
    std::string topic = context->mqttMessage.GetTopic();
    if (!MqttImpl::IsConnected()) {
        LOGE("AsyncMqtt is not connected");
        goto fail;
    }
    if (payloadBinary.size() == 0) {
        pubmsg.payload = (char *)payload.c_str();
        pubmsg.payloadlen = context->mqttMessage.GetPayload().length();
    } else {
        pubmsg.payload = payloadBinary.data();
        pubmsg.payloadlen = payloadBinary.size();
    }
    pubmsg.qos = context->mqttMessage.GetQos();
    pubmsg.retained = context->mqttMessage.GetRetained();
    info->count++;
    if (mqttVersion == MQTTVERSION_5) {
        opts.onSuccess5 = OnPublishSuccess5;
        opts.onFailure5 = OnPublishFail5;
        auto propertPtr = context->mqttMessage.GetProperties();
        if (propertPtr != nullptr && !propertPtr->userProperties.empty()) {
            for (const auto& [key, value] : propertPtr->userProperties) {
                MQTTProperty property;
                property.identifier = MQTTPROPERTY_CODE_USER_PROPERTY;
                property.value.data.data = const_cast<char*>(key.c_str());
                property.value.data.len = key.size();
                property.value.value.data = const_cast<char*>(value.c_str());
                property.value.value.len = value.size();
                MQTTProperties_add(&props, &property);
            }
            pubmsg.properties = props;
        } else {
            LOGD("AsyncMqtt userProperties is empty!");
        }
    } else {
        opts.onSuccess = OnPublishSuccess;
        opts.onFailure = OnPublishFail;
    }
    opts.context = info;
    rc1 = MQTTAsync_sendMessage(mqttAsync_, topic.c_str(), &pubmsg, &opts);
    if (rc1 != MQTTASYNC_SUCCESS) {
        LOGE("AsyncMqtt MQTTAsync_sendMessage failed: rc = %{public}d", rc1);
        goto fail;
    }
    LOGI("AsyncMqtt publish opts.token = %{public}d", opts.token);
    rc2 = MQTTAsync_waitForCompletion(mqttAsync_, opts.token, waitCompletionTime_);
    if (rc2 != MQTTASYNC_SUCCESS || !context->GetFinished(MQTT_PUBLISH_EVENT)) {
        if(info->work_finished != WORK_IS_FINISH && rc2 == MQTTASYNC_FAILURE && MqttImpl::IsConnected()){
            info->context->SetErrorCode(MQTT_IS_BROKEN);
        }
        else {
            info->context->SetErrorCode(MQTT_PUBLISH_FAILED);
        }
        LOGE("AsyncMqtt MQTTAsync_waitForCompletion failed: rc = %{public}d errorcode = %{public}d", rc2, context->GetErrorCode());
        MqttImpl::IsComplete(context, opts.token);
        goto fail;
    }
    context->SetFinished(MQTT_PUBLISH_EVENT, 0);
    MQTTProperties_free(&props);
    return true;
fail:
    MQTTProperties_free(&props);
    context->SetFinished(MQTT_PUBLISH_EVENT, 0);
    return false;
}

void MqttImpl::SetMqttTrace(enum MQTTASYNC_TRACE_LEVELS level)
{
    MQTTAsync_setTraceCallback(MqttTraceCallback);
    MQTTAsync_setTraceLevel(level);
}

int MqttImpl::SetMessageArrivedCallback(PublishContext *context)
{
    if (context == nullptr || !initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        return MQTTASYNC_FAILURE;
    }
    return MQTTAsync_setMessageArrivedCallback(mqttAsync_, context, MqttImpl::MessageArrived);
}

int MqttImpl::SetConnectionLostCallback(BaseContext *context)
{
    if (context == nullptr || !initialized_) {
        LOGE("AsyncMqtt mqttAsync_ is null");
        return MQTTASYNC_FAILURE;
    }
    return MQTTAsync_setConnectionLostCallback(mqttAsync_, context, MqttImpl::ConnectionLost);
}

void MqttImpl::FreeConnectcontext(ConnectContext *context)
{
    if (context == nullptr) {
        return;
    }
    if (context->options.GetConnectOptions().username) {
        delete[] context->options.GetConnectOptions().username;
    }
    if (context->options.GetConnectOptions().password) {
        delete[] context->options.GetConnectOptions().password;
    }
    if (context->options.GetConnectOptions().serverURIs) {
        for (int i = 0; i < context->options.GetConnectOptions().serverURIcount; i++) {
            delete[] context->options.GetConnectOptions().serverURIs[i];
        }
        delete[] context->options.GetConnectOptions().serverURIs;
    }
    if (context->options.GetWillOptions().topicName) {
        delete[] context->options.GetWillOptions().topicName;
    }
    if (context->options.GetWillOptions().message) {
        delete[] context->options.GetWillOptions().message;
    }
}

bool MqttImpl::Destroy()
{
    std::lock_guard<std::mutex> lock(mutex_);
    LOGI("AsyncMqtt MQTTAsync_destroy");
    if (initialized_) {
        initialized_ = false;
        MQTTAsync_destroy(&mqttAsync_);
        if (mqttAsync_ == nullptr) {
            return true;
        }
    } else {
        LOGE("AsyncMqtt not initialized");
        return false;
    }
    return true;
}

void MqttImpl::IsComplete(PublishContext *context, MQTTAsync_token token)
{
    int rc = MQTTASYNC_FAILURE;
    rc = MQTTAsync_isComplete(mqttAsync_, token);
    if (rc != MQTTASYNC_TRUE) {
        LOGE("AsyncMqtt MQTTAsync_isComplete failed: rc = %{public}d", rc);
        context->SetIsComplete(false);
        return;
    }
    context->SetIsComplete(true);
}
} // namespace PahoMqtt
} // namespace OHOS
