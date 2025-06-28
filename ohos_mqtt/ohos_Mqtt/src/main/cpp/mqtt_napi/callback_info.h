/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#ifndef MQTT_CALLBACK_INFO_H
#define MQTT_CALLBACK_INFO_H

#include "base_context.h"
#include <cstddef>

#define WORK_IS_FINISH 1

namespace OHOS {
namespace PahoMqtt {

class MqttAsyncClient;
struct AsyncCallbackInfo {
    OHOS::PahoMqtt::BaseContext *context{nullptr};
    MqttAsyncClient *client{nullptr};
    bool param;
    napi_async_work async_work;
    napi_deferred deferred;
    // 这里增加一个引用计数，用于判别是否释放内存
    int count{0};
    int work_finished{0};
};
}
}
#endif