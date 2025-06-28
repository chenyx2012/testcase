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

#ifndef PAHOMQTT_BASE_CONTEXT_H
#define PAHOMQTT_BASE_CONTEXT_H

#include <atomic>
#include "napi/native_api.h"
#include "event_manager.h"
#include "mqtt_message.h"

namespace OHOS {
namespace PahoMqtt {
typedef void (*AsyncWorkExecutor)(napi_env env, void *data);

typedef void (*AsyncWorkCallback)(napi_env env, napi_status status, void *data);

enum FinishedCallback {
    CONNECT = 1,
    SUBSCRIBE,
    PUBLISH,
    UNSUBSCRIBE,
    DISCONNECT
};

class BaseContext {
public:

    BaseContext() = delete;

    explicit BaseContext(napi_env env, EventManager *manager);

    virtual ~BaseContext();

    void SetParseOK(bool parseOK);

    void SetExecOK(bool requestOK);

    void SetErrorCode(int32_t errorCode);

    void SetCode(int32_t code);
    
    void SetReasonCode(int32_t code);

    void SetMessage(std::string message);

    napi_status SetCallback(napi_value callback);

    void DeleteCallback();

    void CreateAsyncWork(const std::string &name, AsyncWorkExecutor executor, AsyncWorkCallback callback);

    void DeleteAsyncWork();

    napi_value CreatePromise();

    [[nodiscard]] bool IsParseOK() const;

    [[nodiscard]] bool IsExecOK() const;

    [[nodiscard]] napi_env GetEnv() const;

    [[nodiscard]] int32_t GetErrorCode() const;
    
    [[nodiscard]] int32_t GetCode() const;
    
    [[nodiscard]] int32_t GetReasonCode() const;

    [[nodiscard]] std::string GetMessage() const;

    [[nodiscard]] napi_value GetCallback() const;

    [[nodiscard]] napi_deferred GetDeferred() const;

    [[nodiscard]] const std::string &GetAsyncWorkName() const;

    [[nodiscard]] const std::string &EventType() const;

    void Emit(const std::string &type, const std::pair<napi_value, napi_value> &argv);

    void SetNeedPromise(bool needPromise);

    [[nodiscard]] bool IsNeedPromise() const;

    [[nodiscard]] EventManager *GetManager() const;

    void ReleaseTsFunction();

    void CallTsFunction(const std::string &type, void *data);

    void CreateTsFunction(const std::string &resourceName, void *context, napi_finalize threadFinalizeCb,
                          napi_threadsafe_function_call_js callJsCallback);
    
    void SetTopic(const std::string &topic);

    [[nodiscard]] const std::string &GetTopic() const;

    void SetPayload(const std::string &payload);

    void SetPayloadBinary(const std::vector<uint8_t> &payload);

    [[nodiscard]] const std::string &GetPayload() const;

    [[nodiscard]] const std::vector<uint8_t> &GetPayloadBinary() const;

    void SetQos(uint32_t qos);

    [[nodiscard]] uint32_t GetQos() const;

    void SetRetained(int32_t retained);

    [[nodiscard]] int32_t GetRetained() const;

    void SetDup(int32_t dup);

    [[nodiscard]] int32_t GetDup() const;

    void SetMsgid(int32_t msgid);

    [[nodiscard]] int32_t GetMsgid() const;
    
    void SetProperties(const std::shared_ptr<Properties>& properties);

    [[nodiscard]] const std::shared_ptr<Properties>& GetProperties() const;
    
    napi_async_work GetAsyncWork() const;
    
    void SetIsPromise(bool isPromise);
    
    [[nodiscard]] bool GetIsPromise() const;
    
    void SetFinished(const std::string &type, int count);
    
    int GetFinished(const std::string &type);
    
    void SetIsComplete(bool isComplete);
    
    [[nodiscard]] bool GetIsComplete() const;
    
protected:
    EventManager *manager_;

private:
    napi_env env_;

    bool parseOK_;

    bool requestOK_;
    
    napi_ref ref_;

    int32_t errorCode_{0};

    napi_ref callback_;

    napi_async_work asyncWork_;

    napi_deferred deferred_;

    std::string asyncWorkName_;

    std::string eventType_;

    bool needPromise_;

    std::atomic<int32_t> code_ {-1};
    
    std::atomic<int32_t> reasonCode_ {0};

    std::string message_ = "";

    napi_threadsafe_function tsFunc_;
    
    std::string topic_ = "";

    std::string payload_ = "";
    
    std::vector<uint8_t> payloadBinary_;
    
    std::shared_ptr<Properties> properties_;

    uint32_t qos_ = 0;

    int32_t retained_ = 0;

    int32_t dup_ = 0;

    int32_t msgid_ = 0;

    std::atomic<bool> isPromise_ {false};

    std::atomic<int> connectFinished_ {0};
    
    std::atomic<int> subscribeFinished_ {0};
    
    std::atomic<int> publishFinished_ {0};
    
    std::atomic<int> unSubscribeFinished_ {0};
    
    std::atomic<int> disConnectFinished_ {0};
    
    std::mutex tsFuncMutex_;
    
    std::atomic<bool> isComplete_ {true};
};
};
} // namespace OHOS::PahoMqtt

#endif /* PAHOMQTT_BASE_CONTEXT_H */
