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

#ifndef PAHOMQTT_CONSTANT_H
#define PAHOMQTT_CONSTANT_H

#include <cstdint>
#include <mutex>

const int PARAM_JUST_OPTIONS = 1;

const int PARAM_OPTIONS_AND_CALLBACK = 2;

extern std::mutex publishMutex;

namespace OHOS {
namespace PahoMqtt {
class MqttConstant final {
public:

/* client options key */
static const char * const PARAM_PERSISTENCE_TYPE;
static const char * const PARAM_URL;
static const char * const PARAM_CLIENT_ID;

/* mqtt message key */
static const char * const PARAM_TOPIC;
static const char * const PARAM_PAYLOAD;
static const char * const PARAM_PAYLOAD_BINARY;
static const char * const PARAM_QOS;
static const char * const PARAM_RETAINED;
static const char * const PARAM_DUP;
static const char * const PARAM_MSGID;
static const char * const PARAM_PROPERTIES;

/* connect options key */
static const char * const PARAM_PASSWORD;
static const char * const PARAM_USERNAME;
static const char * const PARAM_CONNECT_TIMEOUT;
static const char * const PARAM_CLEANSESSION;
static const char * const PARAM_RETRYINTERVAL;
static const char * const PARAM_KEEPALIVE_INTERVAL;
static const char * const PARAM_MQTTVERSION;
static const char * const PARAM_SERVERURIS;
static const char * const PARAM_AUTOMATIC_RECONNECT;
static const char * const PARAM_MIN_RETRYINTERVAL;
static const char * const PARAM_MAX_RETRYINTERVAL;

/* ssl options key */
static const char * const PARAM_SSLOPTIONS;
static const char * const PARAM_CAPATH;
static const char * const PARAM_TRUSTSTORE;
static const char * const PARAM_KEYSTORE;
static const char * const PARAM_PRIVATEKEY;
static const char * const PARAM_PRIVATEKEY_PASSWORD;
static const char * const PARAM_ENABLEDCIPHER;
static const char * const PARAM_ENABLE_SERVERCERT;
static const char * const PARAM_VERIFY;
static const char *const PARAM_SSL_VERSION;

/* will options key */
static const char * const PARAM_WILLOPTIONS;
static const char * const PARAM_TOPICNAME;
static const char * const PARAM_MESSAGE;

static const char * const RESPONSE_KEY_MESSAGE;
static const char * const RESPONSE_KEY_CODE;
static const char * const RESPONSE_KEY_REASON_CODE;
static const char * const RESPONSE_ERROR_MSG;
static const int RESPONSE_ERROR_CODE;

/* trustStore default value */
static const char * const OHOS_CA_PATH;
};
}
} // namespace OHOS::PahoMqtt

#endif /* PAHOMQTT_CONSTANT_H */
