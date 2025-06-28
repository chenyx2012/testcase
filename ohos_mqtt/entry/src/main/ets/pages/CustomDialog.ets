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

import { MqttConnectOptions } from "@ohos/mqtt";
import { promptAction } from '@kit.ArkUI';
import { Client } from "../viewmodel/TabItem"
import LogUtil from './utils/LogUtil';

@CustomDialog
@Component
export struct CustomDialogCreateMqtt {
  @Link @Watch('inputValueChange') inputValue: Client
  private TAG = 'mqttasync';

  inputValueChange(inputValue: Client): void {
    LogUtil.info(this.TAG, "CustomDialogExample inputValueChange name " + inputValue.clientName);
  }

  @State name: string = '';
  @State url: string = 'ssl://broker-cn.emqx.io:8883';
  @State clientId: string = 'clientId' + Math.random().toString();
  @State userName: string = "";
  @State password: string = "";
  @State isSSL: boolean = true;
  @State isMQTTV5: boolean = true;
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text('new client').fontSize(20).margin({ top: 10, bottom: 10 })
      Text('Name').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.name }).height(60).width('90%')
        .onChange((value: string) => {
          this.name = value
        })
      Text('url').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.url }).height(60).width('90%')
        .onChange((value: string) => {
          this.url = value
        })

      Text('clientId').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.clientId }).height(60).width('90%')
        .onChange((value: string) => {
          this.clientId = value
        })

      Text('userName').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.userName }).height(60).width('90%')
        .onChange((value: string) => {
          this.userName = value
        })

      Text('password').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.password }).height(60).width('90%')
        .onChange((value: string) => {
          this.password = value
        })

      Text('SSL/TLS').fontSize(16).margin({ bottom: 10 })
      Toggle({ type: ToggleType.Switch, isOn: this.isSSL })
        .selectedColor('#007DFF')
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          this.isSSL = isOn
        })

      Text('MQTTV5').fontSize(16).margin({ bottom: 10 })
      Toggle({ type: ToggleType.Switch, isOn: this.isMQTTV5 })
        .selectedColor('#007DFF')
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          this.isMQTTV5 = isOn
        })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              let connectOption: MqttConnectOptions = {
                userName: this.userName,
                password: this.password,
                MQTTVersion: this.isMQTTV5 ? 5 : 0,
              };
              if (this.isSSL) {
                connectOption.sslOptions = {}
              }
              this.inputValue =
                new Client(this.name,
                  { url: this.url, clientId: this.clientId, persistenceType: 1, MQTTVersion: connectOption.MQTTVersion },
                  connectOption)
              this.controller.close()
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })

    }.borderRadius(10)
  }
}

@CustomDialog
@Component
export struct CustomDialogSubscribeOptions {
  @Link @Watch('inputValueChange') inputValue: string
  private TAG = 'mqttasync';

  inputValueChange(inputValue: string): void {
    LogUtil.info(this.TAG, "CustomDialogExample inputValueChange name " + inputValue);
  }

  @State topic: string = '';
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text('New SubscribeOptions').fontSize(20).margin({ top: 10, bottom: 10 })
      Text('topic').fontSize(16).margin({ bottom: 10 })
      TextInput({ placeholder: '', text: this.topic }).height(60).width('90%')
        .onChange((value: string) => {
          this.topic = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              this.inputValue = this.topic
              this.controller.close()
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })

    }.borderRadius(10)
  }
}

export function prompt(str: string) {
  promptAction.showToast({
    message: str,
    duration: 1000
  });
}