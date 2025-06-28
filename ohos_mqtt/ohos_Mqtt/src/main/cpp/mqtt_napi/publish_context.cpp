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

#include "publish_context.h"

#include "mqtt_constant.h"
#include "mqtt_impl.h"
#include "mqtt_log.h"
#include "mqtt_napi_utils.h"

namespace OHOS {
namespace PahoMqtt {
PublishContext::PublishContext(napi_env env, EventManager *manager) : BaseContext(env, manager) {}

void PublishContext::ParseParams(napi_value *params, size_t paramsCount)
{
    if (!CheckParamsType(params, paramsCount)) {
        return;
    }
    if (paramsCount == PARAM_JUST_OPTIONS) {
        ParsePublishOptions(params[0]);
        SetParseOK(true);
        return;
    }
    if (paramsCount == PARAM_OPTIONS_AND_CALLBACK) {
        ParsePublishOptions(params[0]);
        SetParseOK(SetCallback(params[1]) == napi_ok);
    }
}

bool PublishContext::CheckParamsType(napi_value *params, size_t paramsCount)
{
    if (paramsCount == PARAM_JUST_OPTIONS) {
        return NapiUtils::GetValueType(GetEnv(), params[0]) == napi_object;
    }
    if (paramsCount == PARAM_OPTIONS_AND_CALLBACK) {
        return NapiUtils::GetValueType(GetEnv(), params[0]) == napi_object &&
                NapiUtils::GetValueType(GetEnv(), params[1]) == napi_function;
    }
    return false;
}

void PublishContext::ParsePublishOptions(napi_value optionsValue)
{
    LOGD("AsyncMqtt ParsePublishOptions Start");
    mqttMessage.SetTopic(NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_TOPIC));
    mqttMessage.SetPayload(NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_PAYLOAD));
    mqttMessage.SetPayloadBinary(NapiUtils::GetStringPropertyVector(GetEnv(),
                                                                    optionsValue,
                                                                    MqttConstant::PARAM_PAYLOAD_BINARY));
    mqttMessage.SetQos(NapiUtils::GetUint32Property(GetEnv(), optionsValue, MqttConstant::PARAM_QOS));
    mqttMessage.SetRetained(NapiUtils::GetBooleanProperty(GetEnv(), optionsValue, MqttConstant::PARAM_RETAINED));
    mqttMessage.SetDup(NapiUtils::GetBooleanProperty(GetEnv(), optionsValue, MqttConstant::PARAM_DUP));
    mqttMessage.SetMsgid(NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_MSGID));
    mqttMessage.SetProperties(NapiUtils::GetMqttProperties(GetEnv(), optionsValue, MqttConstant::PARAM_PROPERTIES));
}
}
} // namespace OHOS::PahoMqtt