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

#ifndef PAHOMQTT_LOG
#define PAHOMQTT_LOG

#include <cstring>
#include <string>

#define MQTTNAPI_MAJOR_VERSION 2
#define MQTTNAPI_MINOR_VERSION 0
#define MQTTNAPI_PATCH_LEVEL 23

#define MQTTNAPI_SX(x) #x
#define MQTTNAPI_S(x) MQTTNAPI_SX(x)

#define MQTTNAPI_VERSION_STRING                                        \
    MQTTNAPI_S(MQTTNAPI_MAJOR_VERSION)                                         \
    "." MQTTNAPI_S(MQTTNAPI_MINOR_VERSION) \
    "." MQTTNAPI_S(MQTTNAPI_PATCH_LEVEL)

#define MAKE_FILE_NAME (strrchr(__FILE__, '/') + 1)

#if !defined(_WIN32) && !defined(__APPLE__)

#include <hilog/log.h>

#define MQTT_LOG_TAG "AsyncMqtt"

#define MQTT_LOG_DOMAIN 0xD0015B0

#define  LOGD(...) OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "AsyncMqtt", __VA_ARGS__)
#define  LOGE(...) OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "AsyncMqtt", __VA_ARGS__)
#define  LOGI(...) OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "AsyncMqtt", __VA_ARGS__)

#else

#ifdef _WIN32
#undef MAKE_FILE_NAME
#define MAKE_FILE_NAME (strrchr(__FILE__, '\\') + 1)
#endif /* _WIN32 */
#endif

#endif /* PAHOMQTT_LOG */