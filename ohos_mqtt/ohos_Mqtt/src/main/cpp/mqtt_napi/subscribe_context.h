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

#ifndef PAHOMQTT_SUBSCRIBE_CONTEXT_H
#define PAHOMQTT_SUBSCRIBE_CONTEXT_H

#include "mqtt_subscribe_options.h"
#include "mqtt_response.h"
#include "base_context.h"

namespace OHOS {
namespace PahoMqtt {
class SubscribeContext final : public BaseContext {
public:

    SubscribeContext() = delete;

    explicit SubscribeContext(napi_env env, EventManager *manager);

    void ParseParams(napi_value *params, size_t paramsCount);

    MqttSubscribeOptions options;

private:
    bool CheckParamsType(napi_value *params, size_t paramsCount);

    void ParseSubScribeOptions(napi_value optionsValue);
};
}
} // namespace OHOS::PahoMqtt

#endif /* PAHOMQTT_SUBSCRIBE_CONTEXT_H */
