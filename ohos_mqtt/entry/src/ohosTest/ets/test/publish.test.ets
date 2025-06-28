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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  MqttAsync,
  MqttClientOptions,
  MqttConnectOptions,
  MqttPublishOptions,
  MqttResponse,
  MqttClient,
} from '@ohos/mqtt';
import { GlobalContext } from './globalThis'

export default function publishTest() {
  describe('publishTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('publishTest1', 0, async () => {
      let mqttClientOptions: MqttClientOptions = {
        url: "ssl://broker.emqx.io:8883",
        clientId: "clientId_521354632",
        persistenceType: 1,
      }
      let mqttAsyncClient: MqttClient | null = MqttAsync.createMqtt(mqttClientOptions);

      expect(mqttAsyncClient !== null).assertTrue()

      let options: MqttConnectOptions = {
        userName: "",
        password: "",
        connectTimeout: 300,
        sslOptions: {}
      };

      let connectResult: MqttResponse = await mqttAsyncClient.connect(options)
      expect(connectResult.message).assertEqual("Connect Success")
      let num: number = 0
      for (let i = 0; i < 4; i++) {
        let publishOption: MqttPublishOptions = {
          topic: "demo",
          qos: 1,
          payload: "Hello World"
        }
        mqttAsyncClient.publish(publishOption).then((res: MqttResponse) => {
          expect(res.message).assertEqual("Publish Success")
          num++
        })
      }
      while (num < 4) {
        await sleepFun(1)
      }
      let destoryResult: boolean = await mqttAsyncClient.destroy()
      expect(destoryResult).assertTrue()
      mqttAsyncClient = null;
    })

    it('publishTest1__Multi_instance', 0, async () => {


      let clients: MqttClient[] = [];

      let mqttClientOptions: MqttClientOptions[] = [];

      mqttClientOptions[0] = {
        url: "ssl://broker.emqx.io:8883",
        clientId: "clientId_" + Math.random(),
        persistenceType: 1,
      }

      mqttClientOptions[1] = {
        url: "ssl://broker.emqx.io:8883",
        clientId: "clientId_" + Math.random(),
        persistenceType: 1,
      }

      for(let i = 0; i < mqttClientOptions.length; i++) {
        clients[i] = new MqttClient(mqttClientOptions[i]);
        expect(clients[i] !== null).assertTrue()
      }

      let options: MqttConnectOptions = {
        userName: "",
        password: "",
        connectTimeout: 300,
        sslOptions: {}
      };

      for(let i = 0; i < mqttClientOptions.length; i++) {
        let connectResult: MqttResponse = await clients[i].connect(options)
        expect(connectResult.message).assertEqual("Connect Success")

        let num: number = 0
        for (let j = 0; j < 4; j++) {
          let publishOption: MqttPublishOptions = {
            topic: "demo",
            qos: 1,
            payload: "Hello World"
          }
          clients[i].publish(publishOption).then((res: MqttResponse) => {
            expect(res.message).assertEqual("Publish Success")
            num++
          })
        }
        while (num < 4) {
          await sleepFun(1)
        }
        let destoryResult: boolean = await clients[i].destroy()
        expect(destoryResult).assertTrue()
      }
      clients = [];
    })
  })
}

function sleepFun(str: number): Promise<number> {
  return new Promise((res) => {
    return setTimeout(() => {
      res(str)
    }, 1000)
  })
}