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

#ifndef PAHOMQTT_EXEC_H
#define PAHOMQTT_EXEC_H

#include <mutex>
#include <vector>

#include "napi/native_api.h"
#include <unistd.h>
#include "MQTTAsync.h"
#include "mqtt_client_options.h"
#include "connect_context.h"
#include "subscribe_context.h"
#include "publish_context.h"
#include "callback_info.h"

#define MQTT_PUBLISH_FAILED -1
#define MQTT_IS_BROKEN -2

namespace OHOS {
namespace PahoMqtt {
class MqttImpl final {
public:

    MqttImpl() = default;

    ~MqttImpl() = default;

    bool Initialize(MqttClientOptions options);

    bool MqttConnect(AsyncCallbackInfo *info);

    bool MqttSubscribe(AsyncCallbackInfo *info);

    bool MqttDisconnect(AsyncCallbackInfo *info);

    bool MqttPublish(AsyncCallbackInfo *info);

    bool MqttUnsubscribe(AsyncCallbackInfo *info);

    bool IsConnected();

    bool MqttReConnect();

    void SetMqttTrace(enum MQTTASYNC_TRACE_LEVELS level);

    int SetMessageArrivedCallback(PublishContext *context);

    int SetConnectionLostCallback(BaseContext *context);

    bool Destroy();

private:
    const uint32_t waitCompletionTime_ = 3000;

    MQTTAsync mqttAsync_;

    std::mutex mutex_;

    bool initialized_ = false;
    
    int sleepTime_ = 10000;
    
    int cyclesCount_ = 1000;

    bool IsSSLConnect(const std::string &url);

    static void MqttTraceCallback(enum MQTTASYNC_TRACE_LEVELS level, char *message);

    static int SslErrorCallback(const char *str, size_t len, void *u);

    static void OnConnectSuccess(void *context, MQTTAsync_successData *response);
    
    static void OnConnectSuccess5(void *context, MQTTAsync_successData5 *response);

    static void OnConnectFail(void *context, MQTTAsync_failureData *response);
    
    static void OnConnectFail5(void *context, MQTTAsync_failureData5 *response);

    static void OnSubscribeFail(void *context, MQTTAsync_failureData *response);
    
    static void OnSubscribeFail5(void *context, MQTTAsync_failureData5 *response);

    static void OnSubscribeSuccess(void *context, MQTTAsync_successData *response);
    
    static void OnSubscribeSuccess5(void *context, MQTTAsync_successData5 *response);

    static int MessageArrived(void *context, char *topicName, int topicLen, MQTTAsync_message *message);

    static void ConnectionLost(void *context, char *cause);

    static void OnUnSubscribe(void *context, MQTTAsync_successData *response);
    
    static void OnUnSubscribe5(void *context, MQTTAsync_successData5 *response);

    static void OnUnSubscribeFail(void *context, MQTTAsync_failureData *response);
    
    static void OnUnSubscribeFail5(void *context, MQTTAsync_failureData5 *response);

    static void OnDisconnect(void *context, MQTTAsync_successData *response);
    
    static void OnDisconnect5(void *context, MQTTAsync_successData5 *response);
    

    static void OnPublishSuccess(void *context, MQTTAsync_successData *response);
    
    static void OnPublishSuccess5(void *context, MQTTAsync_successData5 *response);

    static void OnPublishFail(void *context, MQTTAsync_failureData *response);

    static void OnPublishFail5(void *context, MQTTAsync_failureData5 *response);
    
    void FreeConnectcontext(ConnectContext *context);
    
    static void ImplCallBack(void *context, const std::string &type, const MqttResponse& mqttResponse);
    
    void IsComplete(PublishContext *context, MQTTAsync_token token);
    
    bool CheckConnecte();
    
    static bool CheckCallBack(AsyncCallbackInfo *info);
    
    MQTTAsync_connectOptions GetOptions(AsyncCallbackInfo *info, MQTTAsync_SSLOptions *ssl,
                                        MQTTAsync_willOptions *willOptions);
};
}
} // namespace OHOS::PahoMqtt

#endif /* PAHOMQTT_EXEC_H */
