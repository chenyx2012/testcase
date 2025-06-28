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

#include "mqtt_client_options.h"
#include "MQTTAsync.h"

namespace OHOS {
namespace PahoMqtt {
MqttClientOptions::MqttClientOptions() : url_(""), clientId_(""), persistenceType_(1), mqttVersion_(MQTTVERSION_DEFAULT) {}

void MqttClientOptions::SetUrl(const std::string &url)
{
    url_ = url;
}

const std::string &MqttClientOptions::GetUrl() const
{
    return url_;
}

void MqttClientOptions::SetClientId(const std::string &clientId)
{
    clientId_ = clientId;
}

const std::string &MqttClientOptions::GetClientId() const
{
    return clientId_;
}

void MqttClientOptions::SetPersistenceType(uint32_t persistenceType)
{
    persistenceType_ = persistenceType;
}

void MqttClientOptions::SetMqttVersion(uint32_t mqttVersion)
{
    mqttVersion_ = mqttVersion;
}

uint32_t MqttClientOptions::GetPersistenceType() const
{
    return persistenceType_;
}

uint32_t MqttClientOptions::GetMqttVersion() const
{
    return mqttVersion_;
}
}
} // namespace OHOS::PahoMqtt