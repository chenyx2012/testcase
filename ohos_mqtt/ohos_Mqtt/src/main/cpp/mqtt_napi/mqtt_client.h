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
#ifndef MQTT_CLIENT_H
#define MQTT_CLIENT_H

#include "napi/native_api.h"
#include "mqtt_impl.h"
#include "event_manager.h"
#include "callback_info.h"

#define MAX_PARAM_NUM 64

namespace OHOS {
namespace PahoMqtt {
    class MqttAsyncClient {
    public:
        static constexpr const int paramCountOne = 1;

        MqttAsyncClient() = default;
        ~MqttAsyncClient() = default;
        static napi_value Connect(napi_env env, napi_callback_info info);
        static napi_value Destroy(napi_env env, napi_callback_info info);
        static napi_value On(napi_env env, napi_callback_info info);
        static napi_value Off(napi_env env, napi_callback_info info);
        static napi_value Subscribe(napi_env env, napi_callback_info info);
        static napi_value SubscribeMany(napi_env env, napi_callback_info info);
        static napi_value MessageArrived(napi_env env, napi_callback_info info);
        static napi_value Unsubscribe(napi_env env, napi_callback_info info);
        static napi_value UnsubscribeMany(napi_env env, napi_callback_info info);
        static napi_value Publish(napi_env env, napi_callback_info info);
        static napi_value Disconnect(napi_env env, napi_callback_info info);
        static napi_value IsConnected(napi_env env, napi_callback_info info);
        static napi_value Reconnect(napi_env env, napi_callback_info info);
        static napi_value ConnectLost(napi_env env, napi_callback_info info);
        static napi_value SetMqttTrace(napi_env env, napi_callback_info info);
        static napi_value Construct(napi_env env, napi_callback_info info);
    
        static void ParseClientOptions(napi_env env, napi_value objValue, MqttClientOptions *options);
        static void CreateAsyncWork(napi_env env, const std::string &name, AsyncWorkExecutor executor,
                                AsyncWorkCallback callback, AsyncCallbackInfo *asyncCallbackInfoOne);
        static void ResponseCallBack(napi_env env, napi_value tsfn_cb, void *context, void *data);
        static napi_value CreateMqttResponse(BaseContext *context, MqttResponse *asyncContext);
        static napi_value CreateMqttMessage(BaseContext *context, MqttMessage *mqttMessage);
        static void RejectError(AsyncCallbackInfo *info, const std::string &type);
        static void MessageCallBack(napi_env env, napi_value tsfn_cb, void *context, void *data);
        MqttImpl *mqttImpl;
        EventManager *manager;
    };
}
}
#endif