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
import { mqttConnect, mqttSubscribe, mqttPublish, mqttUnSubscribe, mqttDisConnect } from './mqttClient'
import {
  MqttAsync,
  MqttClientOptions,
  MqttConnectOptions,
  MqttSubscribeOptions,
  MqttPublishOptions,
  MqttResponse,
  MqttMessage,
  MqttClient,
} from '@ohos/mqtt';
import { GlobalContext } from './globalThis'
let TAG: string = 'MqttDemo'
const HTTP_COUNT: number = 2;
export default function mqttAsyncClientTest() {
  let mqttAsyncClient: MqttClient | null = null
  let messageArrivedTopic: string = ''
  describe('mqttAsyncClientTest', () => {
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
    it('mqttAsyncClient', 0, async () => {
      let mqttClientOptions: MqttClientOptions = {
        url: "ws://broker.emqx.io:8083",
        clientId: "clientId_521354632",
        persistenceType: 1,
      }
      mqttAsyncClient = MqttAsync.createMqtt(mqttClientOptions);
      expect(mqttAsyncClient !== null).assertTrue()

      let options: MqttConnectOptions = {
        userName: "",
        password: "",
        connectTimeout: 300,
      };
      if (mqttAsyncClient !== null) {
        await mqttConnect(mqttAsyncClient, options).then((res: string) => {
          expect(res.toString()).assertEqual("Connect Success")
        })
        let isConnected: boolean = false
        await mqttAsyncClient.isConnected().then((data: boolean) => {
          isConnected = data
        })
        expect(isConnected).assertTrue()
        if (isConnected) {
          mqttAsyncClient.messageArrived((err: Error, data: MqttMessage) => {
            messageArrivedTopic = data.topic
            expect(messageArrivedTopic).assertEqual("demo")
          })

          mqttAsyncClient.connectLost((err: Error, data: MqttResponse) => {
            let result: boolean = data ? true : false
            expect(result).assertTrue()
          })

          let subscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttSubscribe(mqttAsyncClient, subscribeOption).then((res: string) => {
            expect(res.toString()).assertEqual("Subscribe Success")
          })
          let startTime = new Date().getTime()
          let configUrlTest: (index: number) => void = async (index) => {
            if (mqttAsyncClient !== null) {
              mqttSubscribe(mqttAsyncClient, subscribeOption).then((res: string) => {
                if (index < HTTP_COUNT) {
                  configUrlTest(index + 1)
                } else {
                  let endTime = new Date().getTime()
                  let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT
                  console.log(TAG, " get method averageTime: " + averageTime + ' μs')
                }
              })
            }
          }
          configUrlTest(0)
          let publishOption: MqttPublishOptions = {
            topic: "demo",
            qos: 1,
            payload: "Hello World"
          }

          await mqttPublish(mqttAsyncClient, publishOption).then((res: string) => {
            expect(res.toString()).assertEqual("Publish Success")
          })

          let unSubscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttUnSubscribe(mqttAsyncClient, unSubscribeOption).then((res: string) => {
            expect(res.toString()).assertEqual("UnSubscribe Success")
          })

          await mqttDisConnect(mqttAsyncClient).then((res: string) => {
            expect(res.toString()).assertEqual("Disconnect Success")
          })

          await mqttAsyncClient.isConnected().then((data: boolean) => {
            isConnected = data
          })
          expect(!isConnected).assertTrue()
          let isReConnected: boolean = false
          await mqttAsyncClient.reconnect().then((data: boolean) => {
            isReConnected = data
          });
          expect(isReConnected).assertTrue()

          let result: boolean = false
          await mqttAsyncClient.destroy().then((data: boolean) => {
            result = data
          });
          mqttAsyncClient = null;
          expect(result).assertTrue()
        }
      }
    })

    it('mqttAsyncClient_Multi_instance', 0, async () => {
      let clients: MqttClient[] = [];

      let mqttClientOptions: MqttClientOptions[] = [];

      mqttClientOptions[0] = {
        url: "ws://broker.emqx.io:8083",
        clientId: "clientId_" + Math.random(),
        persistenceType: 1,
      }

      mqttClientOptions[1] = {
        url: "ws://broker.emqx.io:8083",
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
      };
      for(let i = 0; i < mqttClientOptions.length; i++) {
        if (clients[i] !== null) {
          await mqttConnect(clients[i], options).then((res: string) => {
            expect(res.toString()).assertEqual("Connect Success")
          })
          let isConnected: boolean = false
          await clients[i].isConnected().then((data: boolean) => {
            isConnected = data
          })
          expect(isConnected).assertTrue()
          if (isConnected) {
            clients[i].messageArrived((err: Error, data: MqttMessage) => {
              messageArrivedTopic = data.topic
              expect(messageArrivedTopic).assertEqual("demo")
            })

            clients[i].connectLost((err: Error, data: MqttResponse) => {
              let result: boolean = data ? true : false
              expect(result).assertTrue()
            })

            let subscribeOption: MqttSubscribeOptions = {
              topic: "demo",
              qos: 2
            }

            await mqttSubscribe(clients[i], subscribeOption).then((res: string) => {
              expect(res.toString()).assertEqual("Subscribe Success")
            })
            let startTime = new Date().getTime()
            let configUrlTest: (index: number) => void = async (index) => {
              if (mqttAsyncClient !== null) {
                mqttSubscribe(mqttAsyncClient, subscribeOption).then((res: string) => {
                  if (index < HTTP_COUNT) {
                    configUrlTest(index + 1)
                  } else {
                    let endTime = new Date().getTime()
                    let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT
                    console.log(TAG, " get method averageTime: " + averageTime + ' μs')
                  }
                })
              }
            }
            configUrlTest(0)
            let publishOption: MqttPublishOptions = {
              topic: "demo",
              qos: 1,
              payload: "Hello World"
            }

            await mqttPublish(clients[i], publishOption).then((res: string) => {
              expect(res.toString()).assertEqual("Publish Success")
            })

            let unSubscribeOption: MqttSubscribeOptions = {
              topic: "demo",
              qos: 2
            }

            await mqttUnSubscribe(clients[i], unSubscribeOption).then((res: string) => {
              expect(res.toString()).assertEqual("UnSubscribe Success")
            })

            await mqttDisConnect(clients[i]).then((res: string) => {
              expect(res.toString()).assertEqual("Disconnect Success")
            })

            await clients[i].isConnected().then((data: boolean) => {
              isConnected = data
            })
            expect(!isConnected).assertTrue()
            let isReConnected: boolean = false
            await clients[i].reconnect().then((data: boolean) => {
              isReConnected = data
            });
            expect(isReConnected).assertTrue()

            let result: boolean = false
            await clients[i].destroy().then((data: boolean) => {
              result = data
            });
            expect(result).assertTrue()
          }
        }
      }

      clients = [];
    })

    it('mqttAsyncClientPromise', 0, async () => {
      let mqttClientOptions: MqttClientOptions = {
        url: "ws://broker.emqx.io:8083",
        clientId: "clientId_521354632",
        persistenceType: 1,
      }
      mqttAsyncClient = MqttAsync.createMqtt(mqttClientOptions);
      expect(mqttAsyncClient !== null).assertTrue()

      let options: MqttConnectOptions = {
        userName: "",
        password: "",
        connectTimeout: 300,
      };
      if (mqttAsyncClient !== null) {
        await mqttAsyncClient.connect(options).then((res: MqttResponse) => {
          expect(res.message.toString()).assertEqual("Connect Success")
        })
        let isConnected: boolean = false
        await mqttAsyncClient.isConnected().then((data: boolean) => {
          isConnected = data
        })
        expect(isConnected).assertTrue()
        if (isConnected) {
          mqttAsyncClient.messageArrived((err: Error, data: MqttMessage) => {
            messageArrivedTopic = data.topic
            expect(messageArrivedTopic).assertEqual("demo")
          })

          mqttAsyncClient.connectLost((err: Error, data: MqttResponse) => {
            let result: boolean = data ? true : false
            expect(result).assertTrue()
          })

          let subscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttAsyncClient.subscribe(subscribeOption).then((res: MqttResponse) => {
            expect(res.message.toString()).assertEqual("Subscribe Success")
          })
          let startTime = new Date().getTime()
          let configUrlTest: (index: number) => void = async (index) => {
            if (mqttAsyncClient !== null) {
              mqttAsyncClient.subscribe(subscribeOption).then(res => {
                if (index < HTTP_COUNT) {
                  configUrlTest(index + 1)
                } else {
                  let endTime = new Date().getTime()
                  let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT
                  console.log(TAG, " get method averageTime: " + averageTime + ' μs')
                }
              })
            }
          }
          configUrlTest(0)
          let publishOption: MqttPublishOptions = {
            topic: "demo",
            qos: 1,
            payload: "Hello World"
          }

          await mqttAsyncClient.publish(publishOption).then((res: MqttResponse) => {
            expect(res.message.toString()).assertEqual("Publish Success")
          })

          let unSubscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttAsyncClient.unsubscribe(unSubscribeOption).then((res: MqttResponse) => {
            expect(res.message.toString()).assertEqual("UnSubscribe Success")
          })

          await mqttAsyncClient.disconnect().then((res: MqttResponse) => {
            expect(res.message.toString()).assertEqual("Disconnect Success")
          })

          await mqttAsyncClient.isConnected().then((data: boolean) => {
            isConnected = data
          })
          expect(!isConnected).assertTrue()
          let isReConnected: boolean = false
          await mqttAsyncClient.reconnect().then((data: boolean) => {
            isReConnected = data
          });
          expect(isReConnected).assertTrue()

          let result: boolean = false
          await mqttAsyncClient.destroy().then((data: boolean) => {
            result = data
          });
          mqttAsyncClient = null;
          expect(result).assertTrue()
        }
      }
    })

    it('mqttAsyncClient_SSL', 0, async () => {
      let mqttClientOptions: MqttClientOptions = {
        url: "ssl://broker.emqx.io:8883",
        clientId: "clientId_521789645",
        persistenceType: 1,
      }
      mqttAsyncClient = MqttAsync.createMqtt(mqttClientOptions);
      expect(mqttAsyncClient !== null).assertTrue()

      let options: MqttConnectOptions = {
        userName: "",
        password: "",
        connectTimeout: 300,
        sslOptions: {}
      };
      if (mqttAsyncClient !== null) {
        await mqttConnect(mqttAsyncClient, options).then((res: string) => {
          expect(res.toString()).assertEqual("Connect Success")
        })
        let isConnected: boolean = false
        await mqttAsyncClient.isConnected().then((data: boolean) => {
          isConnected = data
        })
        expect(isConnected).assertTrue()
        if (isConnected) {
          mqttAsyncClient.messageArrived((err: Error, data: MqttMessage) => {
            messageArrivedTopic = data.topic
            expect(messageArrivedTopic).assertEqual("demo")
          })

          mqttAsyncClient.connectLost((err: Error, data: MqttResponse) => {
            let result: boolean = data ? true : false
            expect(result).assertTrue()
          })

          let subscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttSubscribe(mqttAsyncClient, subscribeOption).then((res: string) => {
            expect(res.toString()).assertEqual("Subscribe Success")
          })

          let publishOption: MqttPublishOptions = {
            topic: "demo",
            qos: 1,
            payload: "Hello World"
          }

          await mqttPublish(mqttAsyncClient, publishOption).then((res: string) => {
            expect(res.toString()).assertEqual("Publish Success")
          })

          let unSubscribeOption: MqttSubscribeOptions = {
            topic: "demo",
            qos: 2
          }

          await mqttUnSubscribe(mqttAsyncClient, unSubscribeOption).then((res: string) => {
            expect(res.toString()).assertEqual("UnSubscribe Success")
          })

          await mqttDisConnect(mqttAsyncClient).then((res: string) => {
            expect(res.toString()).assertEqual("Disconnect Success")
          })

          await mqttAsyncClient.isConnected().then((data: boolean) => {
            isConnected = data
          })
          expect(!isConnected).assertTrue()
          let isReConnected: boolean = false
          await mqttAsyncClient.reconnect().then((data: boolean) => {
            isReConnected = data
          });
          expect(isReConnected).assertTrue()

          let result: boolean = false
          await mqttAsyncClient.destroy().then((data: boolean) => {
            result = data
          });
          mqttAsyncClient = null;
          expect(result).assertTrue()
        }
      }
    })
  })
}