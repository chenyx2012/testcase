#
# Tencent is pleased to support the open source community by making
# MMKV available.
#
# Copyright (C) 2019 THL A29 Limited, a Tencent company.
# All rights reserved.
#
# Licensed under the BSD 3-Clause License (the "License"); you may not use
# this file except in compliance with the License. You may obtain a copy of
# the License at
#
#       https://opensource.org/licenses/BSD-3-Clause
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.5)


set(can_use_assembler TRUE)
enable_language(ASM)
IF("${OHOS_ARCH}" STREQUAL "arm64-v8a")
 SET(ASM_OPTIONS "-x assembler-with-cpp")
 SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS} -march=armv8+crypto -D__OHOS__")
ENDIF()



project(mqtt_napi)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.


add_library(mqtt_napi
            STATIC
             base_context.cpp
             connect_context.cpp
             mqtt_constant.cpp
             mqtt_client_options.cpp
             mqtt_connect_options.cpp
             event_listener.cpp
             event_manager.cpp
             mqtt_impl.cpp
             mqtt_message.cpp
             mqtt_napi_utils.cpp
             mqtt_response.cpp
             mqtt_subscribe_options.cpp
             publish_context.cpp
             subscribe_context.cpp
             mqtt_client.cpp
             task_pool/task_pool.cpp
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
                    ${NATIVERENDER_ROOT_PATH}/paho.mqtt.c/paho.mqtt.c/src
                    ${NATIVERENDER_ROOT_PATH}/boundscheck/third_party_bounds_checking_function/include
                    ${NATIVERENDER_ROOT_PATH}/boundscheck/third_party_bounds_checking_function/src
                    )

target_link_libraries(mqtt_napi pahomqttc boundscheck libc++.a libhilog_ndk.z.so libffrt.z.so)


