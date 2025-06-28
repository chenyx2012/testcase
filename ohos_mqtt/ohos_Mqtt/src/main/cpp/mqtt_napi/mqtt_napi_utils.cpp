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

#include "mqtt_napi_utils.h"
#include <cstring>
#include <initializer_list>
#include <memory>

#include "securec.h"

namespace OHOS {
namespace PahoMqtt {
namespace NapiUtils {
static constexpr const int MAX_STRING_LENGTH = 65536;

static constexpr const char *GLOBAL_JSON = "JSON";

static constexpr const char *GLOBAL_JSON_STRINGIFY = "stringify";

static constexpr const char *GLOBAL_JSON_PARSE = "parse";

static constexpr size_t USER_PROPERTIE_SIZE = 2;

napi_valuetype GetValueType(napi_env env, napi_value value)
{
    if (value == nullptr) {
        return napi_undefined;
    }

    napi_valuetype valueType = napi_undefined;
    napi_typeof(env, value, &valueType);
    return valueType;
}

/* named property */
bool HasNamedProperty(napi_env env, napi_value object, const std::string &propertyName)
{
    bool hasProperty = false;
    napi_has_named_property(env, object, propertyName.c_str(), &hasProperty);
    return hasProperty;
}

napi_value GetNamedProperty(napi_env env, napi_value object, const std::string &propertyName)
{
    napi_value value = nullptr;
    napi_get_named_property(env, object, propertyName.c_str(), &value);
    return value;
}

void SetNamedProperty(napi_env env, napi_value object, const std::string &name, napi_value value)
{
    (void)napi_set_named_property(env, object, name.c_str(), value);
}

std::vector<std::string> GetPropertyNames(napi_env env, napi_value object)
{
    std::vector<std::string> ret;
    napi_value names = nullptr;
    napi_get_property_names(env, object, &names);
    uint32_t length = 0;
    napi_get_array_length(env, names, &length);
    for (uint32_t index = 0; index < length; ++index) {
        napi_value name = nullptr;
        if (napi_get_element(env, names, index, &name) != napi_ok) {
            continue;
        }
        if (GetValueType(env, name) != napi_string) {
            continue;
        }
        ret.emplace_back(GetStringFromValueUtf8(env, name));
    }
    return ret;
}

/* UINT32 */
napi_value CreateUint32(napi_env env, uint32_t code)
{
    napi_value value = nullptr;
    if (napi_create_uint32(env, code, &value) != napi_ok) {
        return nullptr;
    }
    return value;
}

uint32_t GetUint32FromValue(napi_env env, napi_value value)
{
    uint32_t ret = 0;
    napi_get_value_uint32(env, value, &ret);
    return ret;
}

uint32_t GetUint32Property(napi_env env, napi_value object, const std::string &propertyName)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        return 0;
    }
    napi_value value = GetNamedProperty(env, object, propertyName);
    return GetUint32FromValue(env, value);
}

void SetUint32Property(napi_env env, napi_value object, const std::string &name, uint32_t value)
{
    napi_value jsValue = CreateUint32(env, value);
    if (GetValueType(env, jsValue) != napi_number) {
        return;
    }

    napi_set_named_property(env, object, name.c_str(), jsValue);
}

/* INT32 */
napi_value CreateInt32(napi_env env, int32_t code)
{
    napi_value value = nullptr;
    if (napi_create_int32(env, code, &value) != napi_ok) {
        return nullptr;
    }
    return value;
}

int32_t GetInt32FromValue(napi_env env, napi_value value)
{
    int32_t ret = 0;
    napi_get_value_int32(env, value, &ret);
    return ret;
}

int32_t GetInt32Property(napi_env env, napi_value object, const std::string &propertyName)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        return 0;
    }
    napi_value value = GetNamedProperty(env, object, propertyName);
    return GetInt32FromValue(env, value);
}

napi_value CreateInt64(napi_env env, int32_t code)
{
    napi_value value = nullptr;
    if (napi_create_int64(env, code, &value) != napi_ok) {
        return nullptr;
    }
    return value;
}

std::string GetString(napi_env env, napi_value value)
{
    size_t length;
    napi_status status;
    status = napi_get_value_string_utf8(env, value, nullptr, 0, &length);
    if (status != napi_ok) {
        LOGE("AsyncMqtt GetString Failed to get the length of the string");
        return "";
    }
    std::string buffer(length, '\0');
    status = napi_get_value_string_utf8(env, value, &buffer[0], length + 1, &length);
    if (status != napi_ok) {
        LOGE("AsyncMqtt GetString Failed to get the string data");
        return "";
    }
    return buffer;
}

napi_value GetArrayElement(napi_env env, napi_value array, uint32_t index)
{
    napi_value result;
    auto status = napi_get_element(env, array, index, &result);
    if (status != napi_ok) {
        LOGE("AsyncMqtt GetArrayElement Failed to retrieve value at index");
        return result;
    }
    return result;
}

uint32_t GetArrayLength(napi_env env, napi_value array)
{
    uint32_t length;
    auto status = napi_get_array_length(env, array, &length);
    if (status != napi_ok) {
        LOGE("AsyncMqtt GetArrayLength Failed to read array length");
        return 0;
    }
    return length;
}

static bool GetUserProperties(napi_env env, napi_value object, const std::string &propertyName, std::vector<UserPropertiesType>& userProperties)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        LOGE("AsyncMqtt GetUserProperties haven't %{public}s", propertyName.c_str());
        return false;
    }
    napi_value array = GetNamedProperty(env, object, propertyName);
    bool result = false;
    auto status = napi_is_array(env, array, &result);
    if (status != napi_ok) {
        LOGE("AsyncMqtt GetUserProperties isn't array");
        return false;
    }
    
    uint32_t length = GetArrayLength(env, array);   
    if (length == 0) {
        LOGE("AsyncMqtt GetUserProperties isn't array");
        return false;
    }
    for (int i = 0; i < length; i++) {
        auto element = GetArrayElement(env, array, i);
        auto elementLength = GetArrayLength(env, element);
        if (elementLength == USER_PROPERTIE_SIZE) {
            auto key = GetString(env, GetArrayElement(env, element, 0));
            auto val = GetString(env, GetArrayElement(env, element, 1));
            userProperties.push_back({.key = std::move(key), .val = std::move(val)});
        } else {
            LOGE("AsyncMqtt GetUserProperties element size is error:%{public}d", elementLength);
            return false;
        }
    }
    return true;
}

std::shared_ptr<Properties> GetMqttProperties(napi_env env, napi_value object, const std::string &propertyName)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        LOGE("AsyncMqtt GetMqttProperties haven't %{public}s", propertyName.c_str());
        return nullptr;
    }
    auto properties = std::make_shared<Properties>();
    napi_value value = GetNamedProperty(env, object, propertyName);
    properties->contentType = GetStringPropertyUtf8(env, value, "contentType");
    LOGI("AsyncMqtt GetMqttProperties contentType=%{public}s", properties->contentType.c_str());
    auto ret = GetUserProperties(env, value, "userProperties", properties->userProperties);
    if (!ret) {
        return nullptr;
    }
    return properties;
}

static napi_value CreateUserPropertiesObject(napi_env env, const UserPropertiesType& userProperty) {
    napi_value obj;
    napi_create_object(env, &obj);

    napi_value keyValue = CreateStringUtf8(env,userProperty.key);
    napi_set_named_property(env, obj, "key", keyValue);

    napi_value valValue = CreateStringUtf8(env,userProperty.val);
    napi_set_named_property(env, obj, "val", valValue);
    return obj;
}

void SetMqttProperties(napi_env env, napi_value object, const std::string &name, const std::shared_ptr<Properties>& properties)
{
    napi_value propertiesObj;
    napi_create_object(env, &propertiesObj);
    if (!properties) {
        return; 
    }
    napi_value contentTypeValue = CreateStringUtf8(env,properties->contentType );
    napi_set_named_property(env, propertiesObj, "contentType", contentTypeValue);
    
    napi_value userPropertiesArray;
    napi_create_array(env, &userPropertiesArray);
    for (size_t i = 0; i < properties->userProperties.size(); ++i) {
        napi_value userPropertyObj = CreateUserPropertiesObject(env, properties->userProperties[i]);
        napi_set_element(env, userPropertiesArray, i, userPropertyObj);
    }
    
    napi_value integerPropertiesArray;
    napi_create_array(env, &integerPropertiesArray);
    for (size_t i = 0; i < properties->integerProperties.size(); ++i) {
        napi_value int64PropertyObj = CreateInt64(env, properties->integerProperties[i]);
        napi_set_element(env, integerPropertiesArray, i, int64PropertyObj);
    }
    
    napi_value strPropertiesArray;
    napi_create_array(env, &strPropertiesArray);
    for (size_t i = 0; i < properties->strProperties.size(); ++i) {
        napi_value strPropertyObj = CreateStringUtf8(env, properties->strProperties[i]);
        napi_set_element(env, strPropertiesArray, i, strPropertyObj);
    }
    napi_set_named_property(env, propertiesObj, "userProperties", userPropertiesArray);
    napi_set_named_property(env, propertiesObj, "integerProperties", integerPropertiesArray);
    napi_set_named_property(env, propertiesObj, "strProperties", strPropertiesArray);
    napi_set_named_property(env, object, name.c_str(), propertiesObj);
}

void SetInt32Property(napi_env env, napi_value object, const std::string &name, int32_t value)
{
    napi_value jsValue = CreateInt32(env, value);
    if (GetValueType(env, jsValue) != napi_number) {
        return;
    }

    napi_set_named_property(env, object, name.c_str(), jsValue);
}

/* String UTF8 */
napi_value CreateStringUtf8(napi_env env, const std::string &str)
{
    napi_value value = nullptr;
    if (napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &value) != napi_ok) {
        return nullptr;
    }
    return value;
}

std::string GetStringFromValueUtf8(napi_env env, napi_value value)
{
    std::string result;
    size_t length = 0;
    napi_get_value_string_utf8(env, value, nullptr, 0, &length);
    auto deleter = [](char *s) { free(reinterpret_cast<void *>(s)); };
    std::unique_ptr<char, decltype(deleter)> str(static_cast<char *>(malloc(length + 1)), deleter);
    if(str.get()){
        (void)memset_s(str.get(), length + 1, 0, length + 1);
        napi_get_value_string_utf8(env, value, str.get(), length + 1, &length);
        if (length > 0) {
            return result.append(str.get(), length);
        }
    }
    return result;
}

std::vector<uint8_t> GetStringPropertyVector(napi_env env, napi_value object, const std::string &propertyName)
{
    void *buf;
    size_t len;
    std::vector<uint8_t> vec;
    napi_value value = GetNamedProperty(env, object, propertyName);
    napi_valuetype type;
    napi_typeof(env, value, &type);

    if (type != napi_object) {
        return vec;
    }

    napi_status status = napi_get_arraybuffer_info(env, value, &buf, &len);
    if (status != napi_ok) {
        return vec;
    }

    uint8_t *tmp = (uint8_t *) buf;
    for (int i = 0; i < len; i++) {
        vec.push_back(tmp[i]);
    }

    return vec;
}

void SetStringPropertyVector(napi_env env, napi_value object, const std::string &name, const std::vector<uint8_t> &vec)
{
    napi_value arraybuff;
    uint8_t *buf;
    napi_create_arraybuffer(env, vec.size(), (void**)&buf, &arraybuff);
    (void)memcpy_s(buf, vec.size(), vec.data(), vec.size());
    napi_set_named_property(env, object, name.c_str(), arraybuff);
}

std::string GetStringPropertyUtf8(napi_env env, napi_value object, const std::string &propertyName)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        return "";
    }
    napi_value value = GetNamedProperty(env, object, propertyName);
    return GetStringFromValueUtf8(env, value);
}

void SetStringPropertyUtf8(napi_env env, napi_value object, const std::string &name, const std::string &value)
{
    napi_value jsValue = CreateStringUtf8(env, value);
    if (GetValueType(env, jsValue) != napi_string) {
        return;
    }
    napi_set_named_property(env, object, name.c_str(), jsValue);
}

/* array buffer */
bool ValueIsArrayBuffer(napi_env env, napi_value value)
{
    if (value == nullptr) {
        return false;
    }
    bool isArrayBuffer = false;
    napi_is_arraybuffer(env, value, &isArrayBuffer);
    return isArrayBuffer;
}

void *GetInfoFromArrayBufferValue(napi_env env, napi_value value, size_t *length)
{
    if (length == nullptr) {
        return nullptr;
    }

    void *data = nullptr;
    napi_get_arraybuffer_info(env, value, &data, length);
    return data;
}

napi_value CreateArrayBuffer(napi_env env, size_t length, void **data)
{
    if (length == 0) {
        return nullptr;
    }
    napi_value result = nullptr;
    napi_create_arraybuffer(env, length, data, &result);
    return result;
}

/* object */
napi_value CreateObject(napi_env env)
{
    napi_value object = nullptr;
    napi_create_object(env, &object);
    return object;
}

/* undefined */
napi_value GetUndefined(napi_env env)
{
    napi_value undefined = nullptr;
    napi_get_undefined(env, &undefined);
    return undefined;
}

/* function */
napi_value CallFunction(napi_env env, napi_value recv, napi_value func, size_t argc, const napi_value *argv)
{
    napi_value res = nullptr;
    napi_call_function(env, recv, func, argc, argv, &res);
    return res;
}

napi_value CreateFunction(napi_env env, const std::string &name, napi_callback func, void *arg)
{
    napi_value res = nullptr;
    napi_create_function(env, name.c_str(), strlen(name.c_str()), func, arg, &res);
    return res;
}

/* reference */
napi_ref CreateReference(napi_env env, napi_value callback)
{
    napi_ref callbackRef = nullptr;
    napi_create_reference(env, callback, 1, &callbackRef);
    return callbackRef;
}

napi_value GetReference(napi_env env, napi_ref callbackRef)
{
    napi_value callback = nullptr;
    napi_get_reference_value(env, callbackRef, &callback);
    return callback;
}

void DeleteReference(napi_env env, napi_ref callbackRef)
{
    (void)napi_delete_reference(env, callbackRef);
}

/* boolean */
bool GetBooleanProperty(napi_env env, napi_value object, const std::string &propertyName)
{
    if (!HasNamedProperty(env, object, propertyName)) {
        return false;
    }
    napi_value value = GetNamedProperty(env, object, propertyName);
    bool ret = false;
    napi_get_value_bool(env, value, &ret);
    return ret;
}

void SetBooleanProperty(napi_env env, napi_value object, const std::string &name, bool value)
{
    napi_value jsValue = nullptr;
    napi_get_boolean(env, value, &jsValue);
    if (GetValueType(env, jsValue) != napi_boolean) {
        return;
    }

    napi_set_named_property(env, object, name.c_str(), jsValue);
}

napi_value GetBoolean(napi_env env, bool value)
{
    napi_value jsValue = nullptr;
    napi_get_boolean(env, value, &jsValue);
    return jsValue;
}

/* define properties */
void DefineProperties(napi_env env, napi_value object,
                      const std::initializer_list<napi_property_descriptor> &properties)
{
    napi_property_descriptor descriptors[properties.size()];
    std::copy(properties.begin(), properties.end(), descriptors);

    (void)napi_define_properties(env, object, properties.size(), descriptors);
}

/* JSON */
napi_value JsonStringify(napi_env env, napi_value object)
{
    napi_value undefined = GetUndefined(env);

    if (GetValueType(env, object) != napi_object) {
        return undefined;
    }

    napi_value global = nullptr;
    napi_get_global(env, &global);
    napi_value json = nullptr;
    napi_get_named_property(env, global, GLOBAL_JSON, &json);
    napi_value stringify = nullptr;
    napi_get_named_property(env, json, GLOBAL_JSON_STRINGIFY, &stringify);
    if (GetValueType(env, stringify) != napi_function) {
        return undefined;
    }

    napi_value res = nullptr;
    napi_value argv[1] = {object};
    napi_call_function(env, json, stringify, 1, argv, &res);
    return res;
}

napi_value JsonParse(napi_env env, napi_value str)
{
    napi_value undefined = GetUndefined(env);

    if (GetValueType(env, str) != napi_string) {
        return undefined;
    }

    napi_value global = nullptr;
    napi_get_global(env, &global);
    napi_value json = nullptr;
    napi_get_named_property(env, global, GLOBAL_JSON, &json);
    napi_value parse = nullptr;
    napi_get_named_property(env, json, GLOBAL_JSON_PARSE, &parse);
    if (GetValueType(env, parse) != napi_function) {
        return undefined;
    }

    napi_value res = nullptr;
    napi_value argv[1] = {str};
    napi_call_function(env, json, parse, 1, argv, &res);
    return res;
}

/* libuv */
void CreateUvQueueWork(napi_env env, void *data, void(Handler)(uv_work_t *, int status))
{
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);

    auto work = new uv_work_t;
    work->data = data;

//    (void)uv_queue_work(
//            loop, work, [](uv_work_t *) {}, Handler);
}

/* scope */
napi_handle_scope OpenScope(napi_env env)
{
    napi_handle_scope scope = nullptr;
    napi_open_handle_scope(env, &scope);
    return scope;
}

void CloseScope(napi_env env, napi_handle_scope scope)
{
    (void)napi_close_handle_scope(env, scope);
}

bool ValueIsArray(napi_env env, napi_value object)
{
    bool isArray = false;
    napi_status status = napi_is_array(env, object, &isArray);
    return status == napi_ok && isArray;
}

std::vector<napi_value> GetArrayValue(napi_env env, napi_value object)
{
    std::vector<napi_value> objectVector;
    bool isArray = ValueIsArray(env, object);
    if (!isArray) {
        return objectVector;
    }
    uint32_t len = 0;
    napi_status status = napi_get_array_length(env, object, &len);
    if (!(status == napi_ok && len > 0)) {
        return objectVector;
    }
    for (int i = 0; i < len; i++) {
        napi_value value;
        status = napi_get_element(env, object, i, &value);
        if (status != napi_ok) {
            continue;
        }
        objectVector.push_back(value);
    }
    return objectVector;
}

std::vector<std::string> GetStringArrayProperty(napi_env env, napi_value object, const std::string &propertyName)
{
    std::vector<std::string> stringVector;
    napi_value array = nullptr;
    napi_status status = napi_get_named_property(env, object, propertyName.c_str(), &array);
    if (status != napi_ok) {
        return stringVector;
    }
    bool isArray = false;
    status = napi_is_array(env, array, &isArray);
    if (!(status == napi_ok && isArray)) {
        return stringVector;
    }
    uint32_t len = 0;
    status = napi_get_array_length(env, array, &len);
    if (!(status == napi_ok && len > 0)) {
        return stringVector;
    }
    for (int i = 0; i < len; i++) {
        napi_value value;
        status = napi_get_element(env, array, i, &value);
        if (status != napi_ok) {
            continue;
        }
        stringVector.push_back(GetStringFromValueUtf8(env, value));
    }
    return stringVector;
}

void CreateTsFunction(napi_env env, napi_value func, napi_value asyncResource, const std::string &resourceName,
                      uint32_t maxQueueSize, uint32_t threadCnt, void *threadFinalizeData, napi_finalize threadFinalizeCb, void *context,
                      napi_threadsafe_function_call_js callJsCallback, napi_threadsafe_function *result)
{
    LOGD("AsyncMqtt napi_create_threadsafe_function start");
    napi_value resourceValue = CreateStringUtf8(env, resourceName);
    napi_create_threadsafe_function(env, func, asyncResource, resourceValue, maxQueueSize, threadCnt,
            threadFinalizeData, threadFinalizeCb, context, callJsCallback, result);
}

napi_value CreatePromise(napi_env env, napi_deferred *deferred)
{
    napi_value result = nullptr;
    napi_create_promise(env, deferred, &result);
    return result;
}

void FinalizeCallBack(napi_env env, void *finalizeData, void *hint)
{
    LOGD("AsyncMqtt FinalizeCallBack");
    delete finalizeData;
}
}
}
} // namespace OHOS::PahoMqtt::NapiUtils