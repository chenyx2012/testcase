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

#include "mqtt_module_exports.h"

#include "connect_context.h"
#include "event_list.h"
#include "mqtt_impl.h"
#include "mqtt_log.h"
#include "publish_context.h"
#include "subscribe_context.h"
#include "mqtt_client.h"
#include <cstddef>
#include <map>
#include <string>

static constexpr const char *MQTT_MODULE_NAME = "mqttasync";


namespace OHOS {
namespace PahoMqtt {
napi_value MqttModuleExports::InitMqttModule(napi_env env, napi_value exports)
{
    DefineMqttAsyncClientClass(env, exports);
    InitMqttProperties(env, exports);

    return exports;
}

napi_value MqttModuleExports::CreateMqtt(napi_env env, napi_callback_info info)
{
    LOGI("AsyncMqtt CreateMqtt Start");
    return NewInstance(env, info, INTERFACE_MQTT_CLIENT, [](napi_env, void *data, void *) {
        LOGD("AsyncMqtt is finalized_cb");
        (void)data;
    });
}

void MqttModuleExports::DefineMqttAsyncClientClass(napi_env env, napi_value exports)
{
    std::initializer_list<napi_property_descriptor> properties = {
        { "connect", nullptr, MqttAsyncClient::Connect, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "destroy", nullptr, MqttAsyncClient::Destroy, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "connectLost", nullptr, MqttAsyncClient::ConnectLost, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "subscribe", nullptr, MqttAsyncClient::Subscribe, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "subscribeMany", nullptr, MqttAsyncClient::SubscribeMany, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "unsubscribe", nullptr, MqttAsyncClient::Unsubscribe, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "unsubscribeMany", nullptr, MqttAsyncClient::UnsubscribeMany, nullptr, nullptr, nullptr, napi_default,
          nullptr },
        { "publish", nullptr, MqttAsyncClient::Publish, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "messageArrived", nullptr, MqttAsyncClient::MessageArrived, nullptr, nullptr, nullptr, napi_default, nullptr},
        { "disconnect", nullptr, MqttAsyncClient::Disconnect, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isConnected", nullptr, MqttAsyncClient::IsConnected, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "reconnect", nullptr, MqttAsyncClient::Reconnect, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setMqttTrace", nullptr, MqttAsyncClient::SetMqttTrace, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    DefineClass(env, exports, properties, INTERFACE_MQTT_CLIENT);
}

void MqttModuleExports::InitMqttProperties(napi_env env, napi_value exports)
{
    std::initializer_list<napi_property_descriptor> properties = {
        { "createMqttSync", nullptr, CreateMqtt, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    NapiUtils::DefineProperties(env, exports, properties);
}

void MqttModuleExports::ParseClientOptions(napi_env env, napi_value objValue, MqttClientOptions *options)
{
    LOGD("AsyncMqtt ParseClientOptions Start");
    if (NapiUtils::GetValueType(env, objValue) != napi_object) {
        LOGE("AsyncMqtt clientOptions error");
        return;
    }
    options->SetUrl(NapiUtils::GetStringPropertyUtf8(env, objValue, MqttConstant::PARAM_URL));
    options->SetClientId(NapiUtils::GetStringPropertyUtf8(env, objValue, MqttConstant::PARAM_CLIENT_ID));
    options->SetPersistenceType(NapiUtils::GetUint32Property(env, objValue, MqttConstant::PARAM_PERSISTENCE_TYPE));
}

void MqttModuleExports::DefineClass(napi_env env, napi_value exports,
                                    const std::initializer_list<napi_property_descriptor> &properties,
                                    const std::string &className)
{
    napi_value jsConstructor = nullptr;
    napi_status status;
    napi_ref *ref = new napi_ref;
    napi_property_descriptor descriptors[properties.size()];
    std::copy(properties.begin(), properties.end(), descriptors);

    napi_define_class(env, className.c_str(), NAPI_AUTO_LENGTH, MqttAsyncClient::Construct, nullptr,
            properties.size(), descriptors, &jsConstructor);

    status = napi_create_reference(env, jsConstructor, 1, ref);
    if (status != napi_ok) {
        LOGE("AsyncMqtt napi_create_reference fail!");
    }
    NapiUtils::SetNamedProperty(env, exports, className, jsConstructor);
}


napi_value MqttModuleExports::NewInstance(napi_env env, napi_callback_info info, const std::string &className,
                                          Finalizer finalizer)
{
    napi_value thisVal = nullptr;
    napi_value constructs;
    napi_status status;
    size_t paramsCount = MAX_PARAM_NUM;
    napi_value params[MAX_PARAM_NUM] = {nullptr};
    napi_get_cb_info(env, info, &paramsCount, params, &thisVal, nullptr);

    napi_value jsConstructor = NapiUtils::GetNamedProperty(env, thisVal, className);
    if (NapiUtils::GetValueType(env, jsConstructor) == napi_undefined) {
        return nullptr;
    }
    napi_value result = nullptr;
    napi_new_instance(env, jsConstructor, 0, nullptr, &result);

    MqttAsyncClient *client = new MqttAsyncClient();
    auto manager = new EventManager();
    client->manager = manager;
    client->mqttImpl = new MqttImpl();
    ParseClientOptions(env, params[0], &(manager->options));
    if (!client->mqttImpl->Initialize(manager->options)) {
        return nullptr;
    }
    napi_wrap(env, result, client, finalizer, nullptr, nullptr);
    return result;
}

static napi_module g_mqttModule = {
.nm_version = 1,
.nm_flags = 0,
.nm_filename = nullptr,
.nm_register_func = MqttModuleExports::InitMqttModule,
.nm_modname = MQTT_MODULE_NAME,
.nm_priv = nullptr,
.reserved = { nullptr },
};

extern "C" __attribute__((constructor)) void RegisterMqttModule(void)
{
napi_module_register(&g_mqttModule);
}
}
} // namespace OHOS::PahoMqtt
