# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5)
project(mqttasync)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(paho.mqtt.c)
add_subdirectory(mqtt_napi)
add_subdirectory(boundscheck)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${NATIVERENDER_ROOT_PATH}/paho.mqtt.c/paho.mqtt.c/src
                    ${NATIVERENDER_ROOT_PATH}/mqtt_napi
                    ${NATIVERENDER_ROOT_PATH}/boundscheck
                    )

add_library(mqttasync SHARED mqtt_module_exports.cpp)

target_link_libraries(mqttasync PUBLIC libace_napi.z.so libhilog_ndk.z.so libz.so mqtt_napi pahomqttc boundscheck libc++.a)