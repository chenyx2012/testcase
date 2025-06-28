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

#include "mqtt_connect_options.h"

namespace OHOS {
namespace PahoMqtt {
MqttConnectOptions::MqttConnectOptions()
    : hasWillOptions_(false),
    hasSslOptions_(false),
    connectOptions_(MQTTAsync_connectOptions_initializer),
    sslOptions_(MQTTAsync_SSLOptions_initializer),
    willOptions_(MQTTAsync_willOptions_initializer)
    {}

void MqttConnectOptions::SetHasWillOptions(bool hasWillOptions)
{
    hasWillOptions_ = hasWillOptions;
}

void MqttConnectOptions::SetHasSslOptions(bool hasSslOptions)
{
    hasSslOptions_ = hasSslOptions;
}

void MqttConnectOptions::SetConnectOptions(MQTTAsync_connectOptions options)
{
    connectOptions_ = options;
}

void MqttConnectOptions::SetSslOptions(MQTTAsync_SSLOptions options)
{
    sslOptions_ = options;
}

void MqttConnectOptions::SetWillOptions(MQTTAsync_willOptions options)
{
    willOptions_ = options;
}

bool MqttConnectOptions::GetHasWillOptions() const
{
    return hasWillOptions_;
}

bool MqttConnectOptions::GetHasSslOptions() const
{
    return hasSslOptions_;
}

MQTTAsync_connectOptions MqttConnectOptions::GetConnectOptions()
{
    return connectOptions_;
}

MQTTAsync_SSLOptions MqttConnectOptions::GetSslOptions()
{
    return sslOptions_;
}

MQTTAsync_willOptions MqttConnectOptions::GetWillOptions()
{
    return willOptions_;
}
}
} // namespace OHOS::PahoMqtt