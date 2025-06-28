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

#include "subscribe_context.h"

#include "mqtt_constant.h"
#include "mqtt_impl.h"
#include "mqtt_log.h"
#include "mqtt_napi_utils.h"

namespace OHOS {
namespace PahoMqtt {
SubscribeContext::SubscribeContext(napi_env env, EventManager *manager) : BaseContext(env, manager) {}

void SubscribeContext::ParseParams(napi_value *params, size_t paramsCount)
{
    if (!CheckParamsType(params, paramsCount)) {
        return;
    }
    if (paramsCount == PARAM_JUST_OPTIONS) {
        ParseSubScribeOptions(params[0]);
        SetParseOK(true);
        return;
    }
    if (paramsCount == PARAM_OPTIONS_AND_CALLBACK) {
        ParseSubScribeOptions(params[0]);
        SetParseOK(SetCallback(params[1]) == napi_ok);
    }
}

bool SubscribeContext::CheckParamsType(napi_value *params, size_t paramsCount)
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

void SubscribeContext::ParseSubScribeOptions(napi_value optionsValue)
{
    options.ClearTopic();
    bool isArray = NapiUtils::ValueIsArray(GetEnv(), optionsValue);
    if (isArray) {
        std::vector<napi_value> value = NapiUtils::GetArrayValue(GetEnv(), optionsValue);
        for (const auto &opt : value) {
            options.AddTopic(NapiUtils::GetStringPropertyUtf8(GetEnv(), opt, MqttConstant::PARAM_TOPIC),
                             NapiUtils::GetUint32Property(GetEnv(), opt, MqttConstant::PARAM_QOS));
        }
    } else {
        options.AddTopic(NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_TOPIC),
                         NapiUtils::GetUint32Property(GetEnv(), optionsValue, MqttConstant::PARAM_QOS));
    }
}
}
} // namespace OHOS::PahoMqtt