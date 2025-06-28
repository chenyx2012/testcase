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

#include "mqtt_message.h"

namespace OHOS {
namespace PahoMqtt {
MqttMessage::MqttMessage() : topic_(""), payload_(""), qos_(0), retained_(0), dup_(0), msgid_(0)
{
    payloadBinary_.clear();
}

void MqttMessage::SetTopic(const std::string &topic)
{
    topic_ = topic;
}

const std::string MqttMessage::GetTopic() const
{
    return topic_;
}

void MqttMessage::SetPayload(const std::string &payload)
{
    payload_ = payload;
}

void MqttMessage::SetPayloadBinary(const std::vector<uint8_t> &payload)
{
    payloadBinary_ = payload;
}

const std::string &MqttMessage::GetPayload() const
{
    return payload_;
}

const std::vector<uint8_t> & MqttMessage::GetPayloadBinary() const
{
    return payloadBinary_;
}

void MqttMessage::SetQos(uint32_t qos)
{
    qos_ = qos;
}

uint32_t MqttMessage::GetQos() const
{
    return qos_;
}

void MqttMessage::SetRetained(int32_t retained)
{
    retained_ = retained;
}

int32_t MqttMessage::GetRetained() const
{
    return retained_;
}

void MqttMessage::SetDup(int32_t dup)
{
    dup_ = dup;
}

int32_t MqttMessage::GetDup() const
{
    return dup_;
}

void MqttMessage::SetMsgid(int32_t msgid)
{
    msgid_ = msgid;
}

int32_t MqttMessage::GetMsgid() const
{
    return msgid_;
}

void MqttMessage::SetProperties(const std::shared_ptr<Properties>& properties)
{
    properties_ = properties;
}

const std::shared_ptr<Properties>& MqttMessage::GetProperties() const
{
    return properties_;
}
}
} // namespace OHOS::PahoMqtt