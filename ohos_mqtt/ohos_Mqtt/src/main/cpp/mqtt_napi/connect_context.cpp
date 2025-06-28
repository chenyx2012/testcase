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

#include "connect_context.h"
#include "mqtt_constant.h"
#include "mqtt_impl.h"
#include "mqtt_log.h"
#include "mqtt_napi_utils.h"
#include <string>
#include "securec.h"

namespace OHOS {
namespace PahoMqtt {
ConnectContext::ConnectContext(napi_env env, EventManager *manager) : BaseContext(env, manager) {}

void ConnectContext::ParseParams(napi_value *params, size_t paramsCount)
{
    if (!CheckParamsType(params, paramsCount)) {
        return;
    }
    if (paramsCount == PARAM_JUST_OPTIONS) {
        ParseConnectOptions(params[0]);
        SetParseOK(true);
        return;
    }
    if (paramsCount == PARAM_OPTIONS_AND_CALLBACK) {
        ParseConnectOptions(params[0]);
        SetParseOK(SetCallback(params[1]) == napi_ok);
    }
}

bool ConnectContext::CheckParamsType(napi_value *params, size_t paramsCount)
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

bool ConnectContext::ParseBuff(char *dest, size_t destMax, const char *src, size_t count)
{
    errno_t err = EOK;
    err = memcpy_s(dest, destMax, src, count);
    if (err != EOK) {
        LOGE("AsyncMqtt memcpy_s failed, err = %{public}d", err);
        return false; // 返回失败
    }
    return true;
}

void ConnectContext::ParseConnectOptions(napi_value optionsValue)
{
    LOGI("AsyncMqtt ParseConnectOptions start.");
    std::string tempStr = "";
    int mqttVersion = MQTTVERSION_DEFAULT;
    MQTTAsync_connectOptions connectOptions;
    
    bool result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_MQTTVERSION);
    if (result) {
        mqttVersion = NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_MQTTVERSION);
    }
    if (mqttVersion == MQTTVERSION_5) {
        connectOptions = MQTTAsync_connectOptions_initializer5;
        LOGD("connectOptions is MQTTAsync_connectOptions_initializer5, MQTTVersion=%{public}d", connectOptions.MQTTVersion);
    } else { // MQTTVERSION_DEFAULT or other
        connectOptions = MQTTAsync_connectOptions_initializer;
        LOGD("connectOptions is MQTTAsync_connectOptions_initializer, MQTTVersion=%{public}d", connectOptions.MQTTVersion);
    }
    
    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_PASSWORD);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_PASSWORD);
        size_t strLen = tempStr.size() + 1;
        char *password = new char[strLen];
        memset_s(password, strLen, '\0', strLen);
        if (ParseBuff(password, strLen, tempStr.c_str(), tempStr.size())) {
            connectOptions.password = password;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_USERNAME);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_USERNAME);
        size_t strLen = tempStr.size() + 1;
        char *userName = new char[strLen];
        memset_s(userName, strLen, '\0', strLen);
        if (ParseBuff(userName, strLen, tempStr.c_str(), tempStr.size())) {
            connectOptions.username = userName;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_CONNECT_TIMEOUT);
    if (result) {
        connectOptions.connectTimeout =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_CONNECT_TIMEOUT);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_CLEANSESSION);
    if (result) {
        connectOptions.cleansession =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_CLEANSESSION);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_RETRYINTERVAL);
    if (result) {
        connectOptions.retryInterval =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_RETRYINTERVAL);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_KEEPALIVE_INTERVAL);
    if (result) {
        connectOptions.keepAliveInterval =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_KEEPALIVE_INTERVAL);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_SERVERURIS);
    if (result) {
        std::vector<std::string> stringVec =
        NapiUtils::GetStringArrayProperty(GetEnv(), optionsValue, MqttConstant::PARAM_SERVERURIS);
        uint32_t serverURIcount = stringVec.size();
        char **serverURIs = new char *[serverURIcount];
        for (int i = 0; i < serverURIcount; i++) {
            std::string uri = stringVec.at(i);
            size_t uriLen = uri.size();
            serverURIs[i] = new char[uriLen + 1];
            memset_s(serverURIs[i], uriLen + 1, 0, uriLen + 1);
            ParseBuff(serverURIs[i], uriLen + 1, uri.c_str(), uriLen);
        }
        connectOptions.serverURIcount = serverURIcount;
        connectOptions.serverURIs = serverURIs;
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue,
                                         MqttConstant::PARAM_AUTOMATIC_RECONNECT);
    if (result) {
        connectOptions.automaticReconnect =
        NapiUtils::GetBooleanProperty(GetEnv(), optionsValue,
                                      MqttConstant::PARAM_AUTOMATIC_RECONNECT);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue,
                                         MqttConstant::PARAM_MIN_RETRYINTERVAL);
    if (result) {
        connectOptions.minRetryInterval =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue,
                                    MqttConstant::PARAM_MIN_RETRYINTERVAL);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue,
                                         MqttConstant::PARAM_MAX_RETRYINTERVAL);
    if (result) {
        connectOptions.maxRetryInterval =
        NapiUtils::GetInt32Property(GetEnv(), optionsValue,
                                    MqttConstant::PARAM_MAX_RETRYINTERVAL);
    }

    options.SetConnectOptions(connectOptions);
    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue,
                                         MqttConstant::PARAM_SSLOPTIONS);
    if (result) {
        napi_value value = NapiUtils::GetNamedProperty(GetEnv(), optionsValue,
                                                       MqttConstant::PARAM_SSLOPTIONS);
        ParseSslOptions(value);
        options.SetHasSslOptions(true);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue,
                                         MqttConstant::PARAM_WILLOPTIONS);
    if (result) {
        napi_value value = NapiUtils::GetNamedProperty(GetEnv(), optionsValue,
                                                       MqttConstant::PARAM_WILLOPTIONS);
        ParseWillOptions(value);
        options.SetHasWillOptions(true);
    }
}

void ConnectContext::ParseSslOptions(napi_value optionsValue)
{
    LOGD("AsyncMqtt ParseSslOptions Start");
    MQTTAsync_SSLOptions sslOptions = MQTTAsync_SSLOptions_initializer;
    bool result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_CAPATH);
    std::string tempStr = "";
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_CAPATH);
        size_t strLen = tempStr.size() + 1;
        char *caPath = new char[strLen];
        memset_s(caPath, strLen, '\0', strLen);
        if (ParseBuff(caPath, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.CApath = caPath;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_TRUSTSTORE);
    sslOptions.trustStore = MqttConstant::OHOS_CA_PATH;
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_TRUSTSTORE);
        size_t strLen = tempStr.size() + 1;
        char *trustStore = new char[strLen];
        memset_s(trustStore, strLen, '\0', strLen);
        if (ParseBuff(trustStore, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.trustStore = trustStore;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_KEYSTORE);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_KEYSTORE);
        size_t strLen = tempStr.size() + 1;
        char *keyStore = new char[strLen];
        memset_s(keyStore, strLen, '\0', strLen);
        if (ParseBuff(keyStore, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.keyStore = keyStore;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_PRIVATEKEY);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_PRIVATEKEY);
        size_t strLen = tempStr.size() + 1;
        char *privateKey = new char[strLen];
        memset_s(privateKey, strLen, '\0', strLen);
        if (ParseBuff(privateKey, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.privateKey = privateKey;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_PRIVATEKEY_PASSWORD);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_PRIVATEKEY_PASSWORD);
        size_t strLen = tempStr.size() + 1;
        char *privateKeyPassword = new char[strLen];
        memset_s(privateKeyPassword, strLen, '\0', strLen);
        if (ParseBuff(privateKeyPassword, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.privateKeyPassword = privateKeyPassword;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_ENABLEDCIPHER);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_ENABLEDCIPHER);
        size_t strLen = tempStr.size() + 1;
        char *enabledCipherSuites = new char[strLen];
        memset_s(enabledCipherSuites, strLen, '\0', strLen);
        if (ParseBuff(enabledCipherSuites, strLen, tempStr.c_str(), tempStr.size())) {
            sslOptions.enabledCipherSuites = enabledCipherSuites;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_ENABLE_SERVERCERT);
    if (result) {
        sslOptions.enableServerCertAuth =
        NapiUtils::GetBooleanProperty(GetEnv(), optionsValue, MqttConstant::PARAM_ENABLE_SERVERCERT);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_VERIFY);
    if (result) {
        sslOptions.verify = NapiUtils::GetBooleanProperty(GetEnv(), optionsValue, MqttConstant::PARAM_VERIFY);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_SSL_VERSION);
    if (result) {
        sslOptions.sslVersion = NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_SSL_VERSION);
    }
    options.SetSslOptions(sslOptions);
}

void ConnectContext::ParseWillOptions(napi_value optionsValue)
{
    LOGD("AsyncMqtt ParseWillOptions Start");
    MQTTAsync_willOptions willOptions = MQTTAsync_willOptions_initializer;
    bool result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_TOPICNAME);
    std::string tempStr = "";
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_TOPICNAME);
        size_t strLen = tempStr.size() + 1;
        char *topicName = new char[strLen];
        memset_s(topicName, strLen, '\0', strLen);
        if (ParseBuff(topicName, strLen, tempStr.c_str(), tempStr.size())) {
            willOptions.topicName = topicName;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_MESSAGE);
    if (result) {
        tempStr = NapiUtils::GetStringPropertyUtf8(GetEnv(), optionsValue, MqttConstant::PARAM_MESSAGE);
        size_t strLen = tempStr.size() + 1;
        char *message = new char[strLen];
        memset_s(message, strLen, '\0', strLen);
        if (ParseBuff(message, strLen, tempStr.c_str(), tempStr.size())) {
            willOptions.message = message;
        }
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_RETAINED);
    if (result) {
        willOptions.retained = NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_RETAINED);
    }

    result = NapiUtils::HasNamedProperty(GetEnv(), optionsValue, MqttConstant::PARAM_QOS);
    if (result) {
        willOptions.qos = NapiUtils::GetInt32Property(GetEnv(), optionsValue, MqttConstant::PARAM_QOS);
    }
    options.SetWillOptions(willOptions);
}
}
} // namespace OHOS::PahoMqtt