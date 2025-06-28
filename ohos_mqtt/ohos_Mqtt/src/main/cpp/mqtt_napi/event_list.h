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
#ifndef PAHOMQTT_EVENT_LIST_H
#define PAHOMQTT_EVENT_LIST_H

static constexpr const char *MQTT_CONNECT_EVENT = "connect";

static constexpr const char *MQTT_SUBSCRIBE_EVENT = "subscribe";

static constexpr const char *MQTT_UNSUBSCRIBE_EVENT = "unsubscribe";

static constexpr const char *MQTT_DISCONNECT_EVENT = "disconnect";

static constexpr const char *MQTT_PUBLISH_EVENT = "publish";

static constexpr const char *MQTT_RECONNECT_EVENT = "reconnect";

static constexpr const char *MQTT_MESSAGE_ARRIVED_EVENT = "messageArrived";

static constexpr const char *MQTT_CONNECT_LOST_EVENT = "connectLost";

#endif /* PAHOMQTT_EVENT_LIST_H */
