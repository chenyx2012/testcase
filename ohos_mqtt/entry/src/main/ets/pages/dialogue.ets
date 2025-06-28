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

import { MqttClient, MqttPublishOptions, MqttResponse } from '@ohos/mqtt'
import LogUtil from './utils/LogUtil';
import { MQTT_STATE } from './utils/MqttState'
import { prompt } from './CustomDialog'

export class MessageBase {
  msg: string;
  userId: string;

  constructor(msg: string, userId: string) {
    this.msg = msg;
    this.userId = userId;
  }
}

const TAG = 'mqttasync';

@Component
export struct Dialogue {
  @State pushArr: string[] = [];
  @Link @Watch("topicChange") topic: string;
  topicChange() {
    LogUtil.debug(TAG, "topicChange topic = " + this.topic + "messageLength = " + this.messageArr.length)
    this.messageArr = this.getMessage();
  }

  scroller: Scroller = new Scroller();
  @Link @Watch("clientChange") mqttAsyncClient: MqttClient;
  clientChange(mqttAsyncClient: MqttClient) {}

  @Link @Watch("messageChange") messageList: Map<string, Array<MessageBase>>
  messageChange() {
    LogUtil.debug(TAG, "messageChange topic = " + this.topic + "messageLength = " + this.messageArr.length)
    this.messageArr = this.getMessage();
  }

  @Link @Watch("stateChange") state: MQTT_STATE;
  stateChange(state: MQTT_STATE) {}

  @State messageArr: MessageBase[] = this.getMessage();
  @State keyboardStr: string = '';
  @State msgLength: number = 0;

  build() {
    Column() {
      Text(this.topic)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      List({ scroller: this.scroller, initialIndex: this.msgLength - 1 }) {
        ForEach(this.messageArr, (msg: MessageBase, index: number) => {
          ListItem() {
            ChatItemView({ msg: msg });
          }
        }, (msg: MessageBase, index: number) => JSON.stringify(msg) + index)
      }
      .listDirection(Axis.Vertical)
      .padding({
        left: 10,
        right: 10,
        bottom: 10
      })
      .width("100%")
      .layoutWeight(1)

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.keyboardStr })
          .id('bottomTextInput')
          .height(40)
          .layoutWeight(1)
          .borderRadius("20")
          .backgroundColor("rgba(0,0,0,0.05)")
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.keyboardStr = value;
          })
          .onSubmit(async () => {
            if(this.state !== MQTT_STATE.CONNECTED) {
              prompt("client not connected")
              return;
            }
            this.publish(this.topic, this.keyboardStr);
            let msg: MessageBase = new MessageBase(this.keyboardStr, "1")
            this.messageArr.push(msg)
            this.msgLength = this.messageArr.length;
            this.scroller.scrollToIndex(this.msgLength - 1);
            this.keyboardStr = '';
          })
      }
      .borderRadius({
        topLeft: 20,
        topRight: 20
      })
      .backgroundColor(Color.White)
      .width("90%")
      .height(56)
      .margin(20)
    }.width("100%").height("100%")
  }

  async publish(topic: string, payload: string): Promise<undefined | void> {
    LogUtil.info(TAG, "publish");
    let binary: Uint8Array = new Uint8Array([97, 98, 99, 100])

    let publishOption: MqttPublishOptions = {
      topic: topic,
      qos: 1,
      payload: payload,
      // payloadBinary : binary.buffer
      properties: {
        contentType: "application/json",
        userProperties: [
          ["region", "China"],
          ["type", "JSON"],
        ]
      },
    }
    if (this.mqttAsyncClient == null) {
      LogUtil.info(TAG, "client not created");
      return;
    }
    this.mqttAsyncClient.publish(publishOption).then((data: MqttResponse) => {
      LogUtil.info(TAG, "publish success result:" + JSON.stringify(data));
    }).catch((err: MqttResponse) => {
      LogUtil.info(TAG, "publish fail result:" + JSON.stringify(err));
    })
  }

  getMessage(): MessageBase[] {
    if (!this.messageList || !this.messageList.has(this.topic)) {
      return []
    }

    let messages = this.messageList.get(this.topic);
    if (messages) {
      return messages
    } else {
      return []
    }
  }
}

@Component
export struct ChatItemView {
  public msg: MessageBase = new MessageBase("", "0");

  build() {
    Column() {
      if (this.msg.userId != '1') {
        Row() {
          Column() {
            Row() {
              Text(this.msg.msg)
                .lineHeight(22)
                .constraintSize({ minHeight: 40 })
                .fontSize(16)
                .fontColor("#182431")
                .backgroundColor(Color.Orange)
                .padding({
                  top: 8,
                  left: 13,
                  bottom: 8,
                  right: 13
                })
                .borderRadius({
                  topLeft: 4,
                  topRight: 24,
                  bottomLeft: 24,
                  bottomRight: 24
                })
            }
          }
          .margin({ left: 8 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .margin({ top: 12 })
        .padding({ right: 64 })
      } else {
        Row() {
          Column() {
            Row() {
              Text(this.msg.msg)
                .lineHeight(22)
                .constraintSize({ minHeight: 40 })
                .fontSize(16)
                .backgroundColor("#D0E9F3")
                .fontColor("#182431")
                .padding({
                  top: 8,
                  left: 13,
                  bottom: 8,
                  right: 13
                })
                .borderRadius({
                  topLeft: 24,
                  topRight: 4,
                  bottomLeft: 24,
                  bottomRight: 24
                })
            }
          }
          .margin({ right: 8 })
          .alignItems(HorizontalAlign.End)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .direction(Direction.Rtl)
        .padding({ left: 64 })
        .margin({ top: 12 })
      }
    }
  }
}