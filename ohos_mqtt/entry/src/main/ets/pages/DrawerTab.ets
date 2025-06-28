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

import {
  MqttAsync,
  MqttClient,
  MqttClientOptions,
  MqttConnectOptions,
  MqttMessage,
  MqttResponse,
  MqttSubscribeOptions
} from '@ohos/mqtt'
import LogUtil from './utils/LogUtil';
import { CustomDialogSubscribeOptions, prompt } from './CustomDialog'
import { Dialogue, MessageBase } from './dialogue'
import { Client } from '../viewmodel/TabItem';
import { MQTT_STATE } from './utils/MqttState'

const TAG = 'mqttasync';

@Component
export struct DrawerTab {
  scroller: Scroller = new Scroller();
  @Link @Watch('indexChange') index: number;

  indexChange(index: number) {
    LogUtil.log(TAG + "index indexChange ")
  }

  @Link @Watch('clientChange') tabArray: Array<Client>;

  clientChange(tabArray: Array<Client>) {
    LogUtil.log(TAG + "tabArray clientChange ")
  }

  @State messageList: Map<string, Array<MessageBase>> = new Map()
  @State navList: Array<string> = [];
  @State active: string = '';
  @State show: boolean = false;
  @State inputValue: string = '';
  @State isLoading: boolean = true;
  @State connectFail: boolean = false;
  private TAG = 'mqttasync';
  @State isConnect: boolean = false;
  @State connectedCount: number = 0;
  @State state: MQTT_STATE = MQTT_STATE.INITIALIZE;
  @State mqttAsyncClient: MqttClient | null =
    this.tabArray[this.index]?.client ? this.tabArray[this.index]?.client : null;
  @State clientOptions: MqttClientOptions | null =
    this.tabArray[this.index]?.clientOption.url ? this.tabArray[this.index]?.clientOption : null;
  @State connectOptions: MqttConnectOptions | null =
    this.tabArray[this.index]?.connectOption ? this.tabArray[this.index]?.connectOption : null;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogSubscribeOptions({
      cancel: () => {
        this.onCancel();
      },
      confirm: () => {
        this.onAccept();
      },
      inputValue: $inputValue
    }),
    cancel: this.exitApp,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
      console.log("dialog onWillDismiss")
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss();
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss();
      }
    },
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })

  @Builder
  deleteAction(topic: string) {
    Row() {
      Image(($r('app.media.Delete')))
        .onClick(() => {
          animateTo({ duration: 500 }, () => {
            let index = this.navList.indexOf(topic);
            this.navList.splice(index, 1);
            this.unsubscribe({ topic: topic, qos: 2 })
          })
        })
        .width(40)
        .height(40)
    }
    .width(64)
    .height("100%")
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  onCancel() {
    LogUtil.info(this.TAG, ' onCancel');
  }

  onAccept() {
    LogUtil.info(this.TAG, ' onAccept name: ' + this.inputValue);
    if (this.inputValue) {
      let subscribeOptions: MqttSubscribeOptions = {
        topic: this.inputValue,
        qos: 2
      }
      this.subscribe(subscribeOptions).then(() => {
        this.navList.push(this.inputValue);
      })
    }
  }

  exitApp() {
    LogUtil.info(this.TAG, 'exitApp ');
  }

  aboutToAppear() {
    LogUtil.info(this.TAG, 'aboutToAppear ');
    this.createClient()
  }

  build() {
    Stack() {
      if (this.isLoading && !this.connectFail) {
        Column() {
          LoadingProgress()
            .color(Color.Orange)
            .width(80).height(80)
          Text('Loading..')
            .fontSize(16)
            .fontColor(Color.Orange)
        }
      } else if (this.isLoading && this.connectFail) {
        Column() {
          Text('Mqtt Failed!!')
            .fontSize(30)
            .fontColor(Color.Orange)
          Button() {
            Text('CreateClient')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.white"))
              .textAlign(TextAlign.Center)
          }
          .backgroundColor($r("app.color.blue_1677ff"))
          .width("40%")
          .margin({ right: 8 })
          .onClick(() => {
            this.createClient()
          })
        }
      } else {
        SideBarContainer(SideBarContainerType.Overlay) {
          Column() {
            List({ space: 20 }) {
              ForEach(this.navList, (item: string, index: number) => {
                ListItem() {
                  Column() {
                    Row() {
                      Image(this.active === item ? $r('app.media.activeList') : $r('app.media.list'))
                        .width(24)
                        .height(24)
                      Text(item)
                        .fontSize(16)
                        .fontColor(Color.Black)
                        .fontWeight(FontWeight.Medium)
                        .margin({ left: 17 })

                    }
                    .height(48)
                    .width('100%')

                    if (this.navList.length - 1 !== index) {
                      Row()
                        .height(0.5)
                        .backgroundColor('#0D000000')
                        .width('90%')
                    }
                  }
                  .onClick(() => {
                    this.active = item;
                  })
                  .margin({
                    top: 4,
                    left: 4,
                    right: 4,
                    bottom: 4
                  })
                  .justifyContent(FlexAlign.Center)
                  .width(264)
                  .height(48)
                  .padding({ left: 13 })
                  .borderRadius(16)
                  .backgroundColor(this.active === item ? '#1A0A59F7' : '')
                }
                .transition(TransitionEffect.OPACITY)
                .swipeAction({
                  end: this.deleteAction(item),
                })
              }, (item: string, index: number) => JSON.stringify(item) + index)

              ListItem() {
                Row() {
                  Image($r('app.media.add'))
                    .width(40)
                    .height(40)
                    .onClick(() => {
                      if (this.dialogController != null) {
                        this.dialogController.open()
                      }
                    })
                  Text("New SubscribeOptions").margin({ left: 8 })
                }
                .width('100%')
                .margin({ top: 10, left: 10 })
              }

              ListItem() {
                Row() {
                  Image($r('app.media.Delete'))
                    .width(40)
                    .height(40)
                    .onClick(() => {
                      this.destroy(this.tabArray[this.index]).then(() => {
                        this.mqttAsyncClient = null;
                        this.connectedCount = 0;
                        this.tabArray[this.index].client = null;
                        this.tabArray.splice(this.index, 1)
                      })
                    })
                }
                .width('100%')
                .margin({ top: 10, left: 10 })
              }

              ListItem() {
                Stack() {
                  if (this.state == MQTT_STATE.CONNECTING || this.state == MQTT_STATE.DISCONNECTING) {
                    Row() {
                      LoadingProgress()
                        .color(Color.Orange)
                        .width(80).height(80)
                    }
                    .width('100%')
                    .margin({ top: 10, left: 10, bottom: 10 })
                  } else {
                    Row() {
                      Image(this.isConnect ? $r('app.media.disconnect') : $r('app.media.play'))
                        .width(40)
                        .height(40)
                        .onClick(async () => {
                          if (await this.isConnected()) {
                            await this.disconnect()
                          } else {
                            await this.reconnect();
                          }
                        })
                    }
                    .width('100%')
                    .margin({ top: 10, left: 10, bottom: 10 })
                  }
                }
              }
            }
          }
          .width(272)
          .height(344)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .height('100%')
          .padding({ top: 104 })
          .backgroundColor('#E9EAEC')

          ForEach(this.navList, (item: string, index: number) => {
            Column() {
              Dialogue({
                topic: $active,
                mqttAsyncClient: $mqttAsyncClient,
                messageList: $messageList,
                state: $state
              })
            }
          }, (item: string, index: number) => JSON.stringify(item) + index)
        }
        .showSideBar(this.show)
        .controlButton({
          left: 16,
          top: 48,
          height: 40,
          width: 40,
          icons: {
            shown: $r('app.media.changeBack'),
            hidden: $r('app.media.change'),
            switching: $r('app.media.change')
          }
        })
        .onChange((value: boolean) => {
          this.show = value;
        })
        .sideBarWidth('85%')
        .minSideBarWidth('85%')
        .width('100%')
        .height('110%')
        .translate({ y: -40 })
      }
    }
  }

  createClient() {
    if (!this.mqttAsyncClient) {
      prompt("Client create fail!!");
      return;
    }
    this.messageArrived();
    this.connectLost();
    this.connect();
  }

  messageArrived(): undefined | void {
    LogUtil.debug(TAG, "messageArrived");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    this.mqttAsyncClient?.messageArrived((err: Error, data: MqttMessage) => {
      if (!err) {
        let msg = "messageArrived topic:" + data.topic + ", msg:" + data.payload;
        LogUtil.debug(TAG, msg);

        this.messageList.forEach((messages, key) => {
          if (key.includes(data.topic)) {
            console.log(`Key: ${key}`);
            console.log(`Messages:`, messages);
            LogUtil.debug(TAG, "----messageList change topic:" + data.topic)
            messages.push(new MessageBase(msg, "0"));
            this.messageList.set(key, messages);
          }
        });

        let tmp: Uint8Array = new Uint8Array(data.payloadBinary)
        LogUtil.debug(TAG, "msg Uint8Array:" + tmp.toString())

        LogUtil.debug(TAG, "messageArrived message:" + JSON.stringify(data));
      } else {
        LogUtil.error(TAG, "messageArrived error:" + JSON.stringify(err));
      }
    });
  }

  connectLost(): undefined | void {
    LogUtil.debug(TAG, "connectLost");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    this.mqttAsyncClient?.connectLost((err: Error, data: MqttResponse) => {
      if (!err) {
        LogUtil.debug(TAG, "connect lost cause:" + JSON.stringify(data));
        this.state = MQTT_STATE.DISCONNECTED;
      } else {
        LogUtil.error(TAG, "connect lost error:" + JSON.stringify(err));
      }
    });
  }

  async connect(): Promise<undefined | void> {
    LogUtil.debug(TAG, "connect");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (!(await this.isConnected())) {
      this.state = MQTT_STATE.CONNECTING;
      this.mqttAsyncClient.connect(this.connectOptions).then((data: MqttResponse) => {
        LogUtil.debug(TAG, "connect result:" + JSON.stringify(data));
        this.connectedCount++;
        this.isConnect = true;
        this.isLoading = false;
        this.connectFail = false;
        this.state = MQTT_STATE.CONNECTED;
        prompt(data.message);
      }).catch((data: MqttResponse) => {
        LogUtil.error(TAG, "connect fail result:" + JSON.stringify(data));
        this.connectFail = true;
        prompt(data.message);
      })
    }
  }

  async isConnected(): Promise<undefined | boolean> {
    LogUtil.debug(TAG, "isConnected");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      prompt("client not created")
      return;
    }
    return this.mqttAsyncClient?.isConnected().then((data: boolean) => {
      LogUtil.debug(TAG, "isConnected result:" + data);
      if (!data) {
        LogUtil.debug(TAG, "client not connect");
      }
      return data;
    })
  }

  async subscribe(subscribeOptions: MqttSubscribeOptions): Promise<undefined | void> {
    LogUtil.debug(TAG, "subscribe");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (await this.isConnected() && this.state == MQTT_STATE.CONNECTED) {
      this.mqttAsyncClient.subscribe(subscribeOptions).then((data: MqttResponse) => {
        LogUtil.debug(TAG, "subscribe success result:" + JSON.stringify(data));
        this.messageList.set(subscribeOptions.topic, []);
      }).catch((err: MqttResponse) => {
        LogUtil.error(TAG, "subscribe fail result:" + JSON.stringify(err));
        prompt("subscribe fail!!")
      })
    } else {
      prompt("client not connect")
    }
  }

  async subscribeMany(subscribeOptions: MqttSubscribeOptions[]): Promise<undefined | void> {
    LogUtil.debug(TAG, "subscribe");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (await this.isConnected() && this.state == MQTT_STATE.CONNECTED) {
      this.mqttAsyncClient.subscribeMany(subscribeOptions).then((data: MqttResponse) => {
        LogUtil.debug(TAG, "subscribe success result:" + JSON.stringify(data));
      }).catch((err: MqttResponse) => {
        LogUtil.error(TAG, "subscribe fail result:" + JSON.stringify(err));
        prompt("subscribe fail!!")
      })
    } else {
      prompt("client not connect")
    }
  }

  async unsubscribe(subscribeOptions: MqttSubscribeOptions): Promise<undefined | void> {
    LogUtil.debug(TAG, "unsubscribe");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (await this.isConnected() && this.state == MQTT_STATE.CONNECTED) {
      this.mqttAsyncClient.unsubscribe(subscribeOptions).then((data: MqttResponse) => {
        LogUtil.debug(TAG, "unsubscribe success result:" + JSON.stringify(data));
        this.messageList.delete(subscribeOptions.topic);
      }).catch((err: MqttResponse) => {
        LogUtil.error(TAG, "unsubscribe fail result:" + JSON.stringify(err));
        prompt("unsubscribe fail!!")
      })
    } else {
      prompt("client not connect")
    }
  }

  async disconnect(): Promise<undefined | void> {
    LogUtil.debug(TAG, "disconnect");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (await this.isConnected() && this.state == MQTT_STATE.CONNECTED) {
      this.state = MQTT_STATE.DISCONNECTING;
      this.mqttAsyncClient.disconnect().then((data: MqttResponse) => {
        LogUtil.debug(TAG, "disconnect success result:" + JSON.stringify(data));
        this.isConnect = false;
        this.state = MQTT_STATE.DISCONNECTED;

        prompt("DisConnected")
      }).catch((err: MqttResponse) => {
        LogUtil.error(TAG, "disconnect fail result:" + JSON.stringify(err));
        this.state = MQTT_STATE.CONNECTED;
        prompt("DisConnected fail!!")
      })
    }
  }

  async reconnect(): Promise<undefined | void> {
    LogUtil.debug(TAG, "reconnect");
    if (this.mqttAsyncClient == null) {
      LogUtil.error(TAG, "client not created");
      return;
    }
    if (!(await this.isConnected())) {
      if (this.state !== MQTT_STATE.DISCONNECTED) {
        LogUtil.error(TAG, "reconnect: client previously not connected");
        return;
      }
      this.state = MQTT_STATE.CONNECTING;
      await this.mqttAsyncClient.reconnect().then(async (data: boolean) => {
        LogUtil.debug(TAG, "reConnected result:" + data);
        this.isConnect = data;
        if (data) {
          this.state = MQTT_STATE.CONNECTED;
        } else {
          this.state = MQTT_STATE.DISCONNECTED;
        }
        prompt("reConnected:" + data)
      });

      if (this.navList.length === 0) {
        return;
      }
      let subscribeOptions: MqttSubscribeOptions[] = []
      this.navList.forEach((item: string, index: number) => {
        subscribeOptions.push({ topic: item, qos: 2 });
      })
      LogUtil.debug(TAG, "navList :" + JSON.stringify(this.navList));
      LogUtil.debug(TAG, "subscribeOptions :" + JSON.stringify(subscribeOptions));
      this.subscribeMany(subscribeOptions);
    }
  }

  async destroy(client: Client): Promise<undefined | void> {
    LogUtil.debug(TAG, "destroy");
    if (client.client == null) {
      return;
    }
    client.client.destroy().then((data: boolean) => {
      LogUtil.debug(TAG, "destroy result:" + data);
    });
  }
}