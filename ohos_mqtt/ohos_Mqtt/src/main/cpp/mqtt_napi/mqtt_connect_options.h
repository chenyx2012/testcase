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

#ifndef MQTT_CONNECT_OPTIONS_CONTEXT_H
#define MQTT_CONNECT_OPTIONS_CONTEXT_H

#include "MQTTAsync.h"

namespace OHOS {
namespace PahoMqtt {
class MqttConnectOptions final {
public:
    MqttConnectOptions();

    void SetHasWillOptions(bool hasWillOptions);

    void SetHasSslOptions(bool hasSslOptions);

    void SetConnectOptions(MQTTAsync_connectOptions options);

    void SetSslOptions(MQTTAsync_SSLOptions options);

    void SetWillOptions(MQTTAsync_willOptions options);

    [[nodiscard]] bool GetHasWillOptions() const;

    [[nodiscard]] bool GetHasSslOptions() const;

    MQTTAsync_connectOptions GetConnectOptions();

    MQTTAsync_SSLOptions GetSslOptions();

    MQTTAsync_willOptions GetWillOptions();

private:
    bool hasWillOptions_;

    bool hasSslOptions_;

    MQTTAsync_connectOptions connectOptions_;

    MQTTAsync_SSLOptions sslOptions_;

    MQTTAsync_willOptions willOptions_;
};
}
} // namespace OHOS::PahoMqtt
#endif // MQTT_CONNECT_OPTIONS_CONTEXT_H