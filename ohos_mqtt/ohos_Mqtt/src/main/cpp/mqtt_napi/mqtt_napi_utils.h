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

#ifndef PAHOMQTT_NAPI_UTILS_H
#define PAHOMQTT_NAPI_UTILS_H

#include <string>
#include <vector>

#include "napi/native_api.h"
#include "uv.h"
#include "mqtt_log.h"
#include "mqtt_message.h"

namespace OHOS {
namespace PahoMqtt {
namespace NapiUtils {
napi_valuetype GetValueType(napi_env env, napi_value value);

/* named property */
bool HasNamedProperty(napi_env env, napi_value object, const std::string &propertyName);

napi_value GetNamedProperty(napi_env env, napi_value object, const std::string &propertyName);

void SetNamedProperty(napi_env env, napi_value object, const std::string &name, napi_value value);

std::vector<std::string> GetPropertyNames(napi_env env, napi_value object);

/* UINT32 */
napi_value CreateUint32(napi_env env, uint32_t code);

uint32_t GetUint32FromValue(napi_env env, napi_value value);

uint32_t GetUint32Property(napi_env env, napi_value object, const std::string &propertyName);

void SetUint32Property(napi_env env, napi_value object, const std::string &name, uint32_t value);

/* INT32 */
napi_value CreateInt32(napi_env env, int32_t code);

int32_t GetInt32FromValue(napi_env env, napi_value value);

int32_t GetInt32Property(napi_env env, napi_value object, const std::string &propertyName);

void SetInt32Property(napi_env env, napi_value object, const std::string &name, int32_t value);

/* INT64 */
napi_value CreateInt64(napi_env env, int32_t code);

std::string GetString(napi_env env, napi_value value);

napi_value GetArrayElement(napi_env env, napi_value array, uint32_t index);

uint32_t GetArrayLength(napi_env env, napi_value array);

std::shared_ptr<Properties> GetMqttProperties(napi_env env, napi_value object, const std::string &propertyName);

void SetMqttProperties(napi_env env, napi_value object, const std::string &name, const std::shared_ptr<Properties>& properties);


/* String UTF8 */
napi_value CreateStringUtf8(napi_env env, const std::string &str);

std::string GetStringFromValueUtf8(napi_env env, napi_value value);

std::string GetStringPropertyUtf8(napi_env env, napi_value object, const std::string &propertyName);

std::vector<uint8_t> GetStringPropertyVector(napi_env env, napi_value object, const std::string &propertyName);

void SetStringPropertyVector(napi_env env, napi_value object, const std::string &name, const std::vector<uint8_t> &vec);

void SetStringPropertyUtf8(napi_env env, napi_value object, const std::string &name, const std::string &value);

/* array buffer */
bool ValueIsArrayBuffer(napi_env env, napi_value value);

void *GetInfoFromArrayBufferValue(napi_env env, napi_value value, size_t *length);

napi_value CreateArrayBuffer(napi_env env, size_t length, void **data);

/* object */
napi_value CreateObject(napi_env env);

/* undefined */
napi_value GetUndefined(napi_env env);

/* function */
napi_value CallFunction(napi_env env, napi_value recv, napi_value func, size_t argc, const napi_value *argv);

napi_value CreateFunction(napi_env env, const std::string &name, napi_callback func, void *arg);

/* reference */
napi_ref CreateReference(napi_env env, napi_value callback);

napi_value GetReference(napi_env env, napi_ref callbackRef);

void DeleteReference(napi_env env, napi_ref callbackRef);

/* boolean */
bool GetBooleanProperty(napi_env env, napi_value object, const std::string &propertyName);

void SetBooleanProperty(napi_env env, napi_value object, const std::string &name, bool value);

napi_value GetBoolean(napi_env env, bool value);

/* define properties */
void DefineProperties(napi_env env, napi_value object,
                      const std::initializer_list<napi_property_descriptor> &properties);

/* JSON */
napi_value JsonStringify(napi_env env, napi_value object);

napi_value JsonParse(napi_env env, napi_value str);

/* libuv */
void CreateUvQueueWork(napi_env env, void *data, void(Handler)(uv_work_t *, int status));

/* scope */
napi_handle_scope OpenScope(napi_env env);

void CloseScope(napi_env env, napi_handle_scope scope);

/* Array */
bool ValueIsArray(napi_env env, napi_value object);

std::vector<napi_value> GetArrayValue(napi_env env, napi_value object);

std::vector<std::string> GetStringArrayProperty(napi_env env, napi_value object, const std::string &propertyName);

void CreateTsFunction(napi_env env, napi_value func, napi_value asyncResource, const std::string &resourceName,
                      uint32_t maxQueueSize, uint32_t threadCnt, void *threadFinalizeData, 
                      napi_finalize threadFinalizeCb, void *context,
                      napi_threadsafe_function_call_js callJsCallback, napi_threadsafe_function *result);

napi_value CreatePromise(napi_env env, napi_deferred *deferred);

void FinalizeCallBack(napi_env env, void *finalizeData, void *hint);
}
}
} // namespace OHOS::PahoMqtt::NapiUtils

#endif /* PAHOMQTT_NAPI_UTILS_H */
