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
#include "mqtt_subscribe_options.h"
#include <cstddef>

namespace OHOS {
namespace PahoMqtt {
MqttSubscribeOptions::MqttSubscribeOptions() {}

void MqttSubscribeOptions::ClearTopic()
{
    topics_.clear();
}

void MqttSubscribeOptions::AddTopic(const std::string &topic, uint32_t qos)
{
    topics_.emplace_back(topic, qos);
}

[[nodiscard]] const std::vector<std::pair<std::string, uint32_t>> &MqttSubscribeOptions::GetTopics() const
{
    return topics_;
}

[[nodiscard]] char **MqttSubscribeOptions::GetTopicList() const
{
    char **topicList = new char *[topics_.size()];
    for (size_t i = 0; i < topics_.size(); i++) {
        topicList[i] = const_cast<char *>(topics_[i].first.c_str());
    }
    return topicList;
}

[[nodiscard]] int *MqttSubscribeOptions::GetQosList() const
{
    int *qosList = new int[topics_.size()];
    for (size_t i = 0; i < topics_.size(); i++) {
        qosList[i] = topics_[i].second;
    }
    return qosList;
}
}
} // namespace OHOS::PahoMqtt