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

project(pahomqttc)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

set(TAGET_MQTT_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR}/paho.mqtt.c)
add_library(pahomqttc

        # Sets the library as a shared library.
        STATIC

        # Provides a relative path to your source file(s).
        ${TAGET_MQTT_SRC_PATH}/src/Thread.c
        ${TAGET_MQTT_SRC_PATH}/src/Heap.c
        ${TAGET_MQTT_SRC_PATH}/src/SSLSocket.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTPacket.c
        ${TAGET_MQTT_SRC_PATH}/src/OsWrapper.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTAsync.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTProtocolOut.c
        ${TAGET_MQTT_SRC_PATH}/src/Clients.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTPacketOut.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTPersistenceDefault.c
        ${TAGET_MQTT_SRC_PATH}/src/WebSocket.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTPersistence.c
        ${TAGET_MQTT_SRC_PATH}/src/Log.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTProperties.c
        ${TAGET_MQTT_SRC_PATH}/src/Messages.c
        ${TAGET_MQTT_SRC_PATH}/src/StackTrace.c
        ${TAGET_MQTT_SRC_PATH}/src/LinkedList.c
        ${TAGET_MQTT_SRC_PATH}/src/Base64.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTTime.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTReasonCodes.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTAsyncUtils.c
        ${TAGET_MQTT_SRC_PATH}/src/SHA1.c
        ${TAGET_MQTT_SRC_PATH}/src/Socket.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTVersion.c
        ${TAGET_MQTT_SRC_PATH}/src/MQTTProtocolClient.c
        ${TAGET_MQTT_SRC_PATH}/src/SocketBuffer.c
        ${TAGET_MQTT_SRC_PATH}/src/Tree.c
        ${TAGET_MQTT_SRC_PATH}/src/utf-8.c
        ${TAGET_MQTT_SRC_PATH}/src/Proxy.c
        )

target_link_libraries(pahomqttc)
target_include_directories(pahomqttc PUBLIC ${NATIVERENDER_ROOT_PATH}
                                            ${NATIVERENDER_ROOT_PATH}/paho.mqtt.c/paho.mqtt.c/src
                                            ${NATIVERENDER_ROOT_PATH}/paho.mqtt.c/adapted/include
                                            )


