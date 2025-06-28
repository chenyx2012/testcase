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

#ifndef MQTT_CLIENT_OPTIONS_CONTEXT_H
#define MQTT_CLIENT_OPTIONS_CONTEXT_H

#include <string>
#include <cstdint>

namespace OHOS {
namespace PahoMqtt {
class MqttClientOptions final {
public:
    MqttClientOptions();

    void SetUrl(const std::string &url);

    void SetClientId(const std::string &clientId);

    void SetPersistenceType(uint32_t persistenceType);
    
    void SetMqttVersion(uint32_t mqttVersion);

    [[nodiscard]] const std::string &GetUrl() const;

    [[nodiscard]] const std::string &GetClientId() const;

    [[nodiscard]] uint32_t GetPersistenceType() const;

    [[nodiscard]] uint32_t GetMqttVersion() const;
    
private:
    std::string url_;

    std::string clientId_;

    uint32_t persistenceType_;
    
    uint32_t mqttVersion_;
};
}
} // namespace OHOS::PahoMqtt
#endif // MQTT_CLIENT_OPTIONS_CONTEXT_H