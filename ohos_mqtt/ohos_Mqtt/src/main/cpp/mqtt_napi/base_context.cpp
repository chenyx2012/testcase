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

#include "mqtt_response.h"
#include "event_list.h"
#include "base_context.h"
#include "napi/native_api.h"
#include "mqtt_napi_utils.h"
#include "mqtt_log.h"
#include <hilog/log.h>

namespace OHOS {
namespace PahoMqtt {
BaseContext::BaseContext(napi_env env, EventManager *manager)
    : manager_(manager),
    env_(env),
    parseOK_(false),
    requestOK_(false),
    errorCode_(0),
    callback_(nullptr),
    asyncWork_(nullptr),
    deferred_(nullptr),
    tsFunc_(nullptr),
    needPromise_(true)
    {}
    
BaseContext::~BaseContext()
{
    DeleteCallback();
}


void BaseContext::SetParseOK(bool parseOK)
{
    parseOK_ = parseOK;
}

void BaseContext::SetExecOK(bool requestOK)
{
    requestOK_ = requestOK;
}

void BaseContext::SetErrorCode(int32_t errorCode)
{
    errorCode_ = errorCode;
}

napi_status BaseContext::SetCallback(napi_value callback)
{
    if (callback_ != nullptr) {
        (void)napi_delete_reference(env_, callback_);
    }
    return napi_create_reference(env_, callback, 1, &callback_);
}

void BaseContext::DeleteCallback()
{
    if (callback_ == nullptr) {
        return;
    }
    (void)napi_delete_reference(env_, callback_);
    callback_ = nullptr;
}

void BaseContext::CreateAsyncWork(const std::string &name, AsyncWorkExecutor executor, AsyncWorkCallback callback)
{
    napi_status ret = napi_create_async_work(env_, nullptr, NapiUtils::CreateStringUtf8(env_, name), executor, callback,
            this, &asyncWork_);
    if (ret != napi_ok) {
        return;
    }
    asyncWorkName_ = name;
    (void)napi_queue_async_work(env_, asyncWork_);
}

void BaseContext::DeleteAsyncWork()
{
    if (asyncWork_ == nullptr) {
        return;
    }
    (void)napi_delete_async_work(env_, asyncWork_);
}

napi_value BaseContext::CreatePromise()
{
    napi_value result = nullptr;
    napi_create_promise(env_, &deferred_, &result);
    return result;
}

bool BaseContext::IsParseOK() const
{
    return parseOK_;
}

bool BaseContext::IsExecOK() const
{
    return requestOK_;
}

napi_env BaseContext::GetEnv() const
{
    return env_;
}

int32_t BaseContext::GetErrorCode() const
{
    return errorCode_;
}

napi_value BaseContext::GetCallback() const
{
    if (callback_ == nullptr) {
        return nullptr;
    }
    napi_value callback = nullptr;
    napi_get_reference_value(env_, callback_, &callback);
    return callback;
}

napi_deferred BaseContext::GetDeferred() const
{
    return deferred_;
}

const std::string &BaseContext::GetAsyncWorkName() const
{
    return asyncWorkName_;
}

void BaseContext::Emit(const std::string &type, const std::pair<napi_value, napi_value> &argv)
{
    if (manager_ != nullptr) {
        manager_->Emit(type, argv);
    }
}

void BaseContext::SetNeedPromise(bool needPromise)
{
    needPromise_ = needPromise;
}

bool BaseContext::IsNeedPromise() const
{
    return needPromise_;
}

EventManager *BaseContext::GetManager() const
{
    return manager_;
}

void BaseContext::CreateTsFunction(const std::string &resourceName, void *context, napi_finalize threadFinalizeCb,
                                   napi_threadsafe_function_call_js callJsCallback)
{
    std::lock_guard<std::mutex> lock(tsFuncMutex_);
    NapiUtils::CreateTsFunction(env_, GetCallback(), nullptr, resourceName,
                                0, 1, context, threadFinalizeCb, context,
                                callJsCallback, &tsFunc_);
}

void BaseContext::ReleaseTsFunction()
{
    std::lock_guard<std::mutex> lock(tsFuncMutex_);
    if (tsFunc_ == nullptr) {
        LOGE("AsyncMqtt napi_release_threadsafe_function fail");
        return;
    }
    LOGD("AsyncMqtt napi_release_threadsafe_function start");
    napi_status status = napi_release_threadsafe_function(tsFunc_, napi_tsfn_release);
    if (status != napi_ok) {
        LOGE("AsyncMqtt release ts func error");
    }
    tsFunc_ = nullptr;
}

const std::string &BaseContext::EventType() const
{
    return eventType_;
}

void BaseContext::CallTsFunction(const std::string &type, void *data)
{
    std::lock_guard<std::mutex> lock(tsFuncMutex_);
    if (tsFunc_ == nullptr || data == nullptr) {
        LOGE("AsyncMqtt napi_call_threadsafe_function fail");
        return;
    }
    eventType_ = type;
    LOGD("AsyncMqtt napi_call_threadsafe_function start");
    napi_status status = napi_call_threadsafe_function(tsFunc_, data, napi_tsfn_blocking);
    if (status != napi_ok) {
        LOGE("AsyncMqtt call ts func error");
    }
}

void BaseContext::SetCode(int32_t code)
{
    code_ = code;
}

int32_t BaseContext::GetCode() const
{
    return code_;
}

int32_t BaseContext::GetReasonCode() const
{
    return reasonCode_;
}

void BaseContext::SetReasonCode(int32_t code)
{
    reasonCode_ = code;
}

void BaseContext::SetMessage(std::string message)
{
    message_ = message;
}

std::string BaseContext::GetMessage() const
{
    return message_;
}

void BaseContext::SetTopic(const std::string &topic)
{
    topic_ = topic;
}

const std::string &BaseContext::GetTopic() const
{
    return topic_;
}

void BaseContext::SetPayload(const std::string &payload)
{
    payload_ = payload;
}

void BaseContext::SetPayloadBinary(const std::vector<uint8_t> &payload)
{
    payloadBinary_ = payload;
}

const std::string &BaseContext::GetPayload() const
{
    return payload_;
}

const std::vector<uint8_t> &BaseContext::GetPayloadBinary() const
{
    return payloadBinary_;
}

void BaseContext::SetQos(uint32_t qos)
{
    qos_ = qos;
}

uint32_t BaseContext::GetQos() const
{
    return qos_;
}

void BaseContext::SetRetained(int32_t retained)
{
    retained_ = retained;
}

int32_t BaseContext::GetRetained() const
{
    return retained_;
}

void BaseContext::SetDup(int32_t dup)
{
    dup_ = dup;
}

int32_t BaseContext::GetDup() const
{
    return dup_;
}

void BaseContext::SetMsgid(int32_t msgid)
{
    msgid_ = msgid;
}

int32_t BaseContext::GetMsgid() const
{
    return msgid_;
}

void BaseContext::SetProperties(const std::shared_ptr<Properties>& properties)
{
    properties_ = properties;
}

const std::shared_ptr<Properties>& BaseContext::GetProperties() const
{
    return properties_;
}

napi_async_work BaseContext::GetAsyncWork() const
{
    return asyncWork_;
}

void BaseContext::SetIsPromise(bool isPromise)
{
    isPromise_ = isPromise;
}

[[nodiscard]] bool BaseContext::GetIsPromise() const
{
    return isPromise_;
}

void BaseContext::SetFinished(const std::string &type, int count)
{
    if (type == MQTT_CONNECT_EVENT) {
        connectFinished_ = count;
    } else if (type == MQTT_SUBSCRIBE_EVENT) {
        subscribeFinished_ = count;
    } else if (type == MQTT_UNSUBSCRIBE_EVENT) {
        unSubscribeFinished_ = count;
    } else if (type == MQTT_DISCONNECT_EVENT) {
        disConnectFinished_ = count;
    } else if (type == MQTT_PUBLISH_EVENT) {
        publishFinished_ = count;
    }
}

int BaseContext::GetFinished(const std::string &type)
{
    int res = 0;
    if (type == MQTT_CONNECT_EVENT) {
        res = connectFinished_;
    } else if (type == MQTT_SUBSCRIBE_EVENT) {
        res = subscribeFinished_;
    } else if (type == MQTT_UNSUBSCRIBE_EVENT) {
        res = unSubscribeFinished_;
    } else if (type == MQTT_DISCONNECT_EVENT) {
        res = disConnectFinished_;
    } else if (type == MQTT_PUBLISH_EVENT) {
        res = publishFinished_;
    }
    return res;
}

void BaseContext::SetIsComplete(bool isComplete)
{
    isComplete_ = isComplete;
}

[[nodiscard]] bool BaseContext::GetIsComplete() const
{
    return isComplete_;
}

}
} // namespace OHOS::PahoMqtt