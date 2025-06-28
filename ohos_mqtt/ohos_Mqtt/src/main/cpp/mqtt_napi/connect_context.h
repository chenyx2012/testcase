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

#ifndef PAHOMQTT_CONNECT_CONTEXT_H
#define PAHOMQTT_CONNECT_CONTEXT_H

#include "mqtt_connect_options.h"
#include "mqtt_constant.h"
#include "base_context.h"
#include "MQTTAsync.h"
#include <string>


namespace OHOS {
namespace PahoMqtt {
class ConnectContext final : public BaseContext {
public:

    ConnectContext() = delete;

    explicit ConnectContext(napi_env env, EventManager *manager);

    void ParseParams(napi_value *params, size_t paramsCount);

    MqttConnectOptions options;

private:
    bool CheckParamsType(napi_value *params, size_t paramsCount);
    
    bool ParseBuff(char *dest, size_t destMax, const char *src, size_t count);

    void ParseConnectOptions(napi_value optionsValue);

    void ParseSslOptions(napi_value optionsValue);

    void ParseWillOptions(napi_value optionsValue);
};
};
} // namespace OHOS::PahoMqtt

#endif /* PAHOMQTT_CONNECT_CONTEXT_H */
