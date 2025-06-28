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

#include "mqtt_constant.h"

std::mutex publishMutex;

namespace OHOS {
namespace PahoMqtt {
/* client options key */
const char * const MqttConstant::PARAM_PERSISTENCE_TYPE = "persistenceType";
const char * const MqttConstant::PARAM_URL = "url";
const char * const MqttConstant::PARAM_CLIENT_ID = "clientId";

/* mqtt message key */
const char * const MqttConstant::PARAM_TOPIC = "topic";
const char * const MqttConstant::PARAM_PAYLOAD = "payload";
const char * const MqttConstant::PARAM_PAYLOAD_BINARY = "payloadBinary";
const char * const MqttConstant::PARAM_QOS = "qos";
const char * const MqttConstant::PARAM_RETAINED = "retained";
const char * const MqttConstant::PARAM_DUP = "dup";
const char * const MqttConstant::PARAM_MSGID = "msgid";
const char * const MqttConstant::PARAM_PROPERTIES = "properties";

/* connect options key */
const char * const MqttConstant::PARAM_PASSWORD = "password";
const char * const MqttConstant::PARAM_USERNAME = "userName";
const char * const MqttConstant::PARAM_CONNECT_TIMEOUT = "connectTimeout";
const char * const MqttConstant::PARAM_CLEANSESSION = "cleanSession";
const char * const MqttConstant::PARAM_RETRYINTERVAL = "retryInterval";
const char * const MqttConstant::PARAM_KEEPALIVE_INTERVAL = "keepAliveInterval";
const char * const MqttConstant::PARAM_MQTTVERSION = "MQTTVersion";
const char * const MqttConstant::PARAM_SERVERURIS = "serverURIs";
const char * const MqttConstant::PARAM_AUTOMATIC_RECONNECT = "automaticReconnect";
const char * const MqttConstant::PARAM_MIN_RETRYINTERVAL = "minRetryInterval";
const char * const MqttConstant::PARAM_MAX_RETRYINTERVAL = "maxRetryInterval";

/* ssl options key */
const char * const MqttConstant::PARAM_SSLOPTIONS = "sslOptions";
const char * const MqttConstant::PARAM_CAPATH = "caPath";
const char * const MqttConstant::PARAM_TRUSTSTORE = "trustStore";
const char * const MqttConstant::PARAM_KEYSTORE = "keyStore";
const char * const MqttConstant::PARAM_PRIVATEKEY = "privateKey";
const char * const MqttConstant::PARAM_PRIVATEKEY_PASSWORD = "privateKeyPassword";
const char * const MqttConstant::PARAM_ENABLEDCIPHER = "enabledCipherSuites";
const char * const MqttConstant::PARAM_ENABLE_SERVERCERT = "enableServerCertAuth";
const char * const MqttConstant::PARAM_VERIFY = "verify";
const char *const MqttConstant::PARAM_SSL_VERSION = "sslVersion";

/* will options key */
const char * const MqttConstant::PARAM_WILLOPTIONS = "willOptions";
const char * const MqttConstant::PARAM_TOPICNAME = "topicName";
const char * const MqttConstant::PARAM_MESSAGE = "message";

const char * const MqttConstant::RESPONSE_KEY_MESSAGE = "message";
const char * const MqttConstant::RESPONSE_KEY_CODE = "code";
const char * const MqttConstant::RESPONSE_KEY_REASON_CODE = "reasonCode";
const char * const MqttConstant::RESPONSE_ERROR_MSG = "failed";
const int MqttConstant::RESPONSE_ERROR_CODE = -1;

const char * const MqttConstant::OHOS_CA_PATH = "/etc/ssl/certs/cacert.pem";
}
} // namespace OHOS::PahoMqtt