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

namespace OHOS {
namespace PahoMqtt {
MqttResponse::MqttResponse() : message_(""), code_(0), reasonCode_(0) {}

void MqttResponse::SetMessage(const std::string &message)
{
    message_ = message;
}

const std::string &MqttResponse::GetMessage() const
{
    return message_;
}

void MqttResponse::SetCode(int32_t code)
{
    code_ = code;
}

int32_t MqttResponse::GetCode() const
{
    return code_;
}

void MqttResponse::SetReasonCode(int32_t reasonCode)
{
    reasonCode_ = reasonCode;
}

int32_t MqttResponse::GetReasonCode() const
{
    return reasonCode_;
}

void MqttResponse::SetProperties(const std::shared_ptr<Properties>& properties)
{
    properties_ = properties;
}

const std::shared_ptr<Properties>& MqttResponse::GetProperties() const
{
    return properties_;
}
}
} // namespace OHOS::PahoMqtt