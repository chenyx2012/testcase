/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import mqttAsync from 'libmqttasync.so';
import hilog from '@ohos.hilog';
import { MqttClientOptions, MqttClient } from 'libmqttasync.so'

class MqttAsync {
  static DOMAIN = 0x00FF
  static TAG = '[mqtt] mqttAsync: '

  public static createMqtt(options: MqttClientOptions): MqttClient {
    hilog.info(MqttAsync.DOMAIN, MqttAsync.TAG, 'AsyncMqtt createMqtt_napi start---')
    return mqttAsync.createMqttSync(options)
  };
}

export default MqttAsync

