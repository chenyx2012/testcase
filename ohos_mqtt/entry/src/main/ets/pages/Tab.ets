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

import { Client } from '../viewmodel/TabItem';
import { CustomDialogCreateMqtt } from './CustomDialog'
import LogUtil from './utils/LogUtil';
import { DrawerTab } from './DrawerTab'

const TAG = 'mqttasync';

@Entry
@Component
struct Tab {
  @State tabArray: Array<Client> = [];
  @State focusIndex: number = 0;
  @State currentIndex: number = 0;
  @State subCurrentIndex: number = 0;
  private controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();
  private subController: TabsController = new TabsController();
  private panOptionRight: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left });
  private TAG = 'mqttasync';
  @State @Watch('inputValueChange') inputValue: Client | null = null;

  inputValueChange(inputValue: Client): void {
    LogUtil.info(this.TAG, "inputValueChange name " + inputValue.clientName);
  }

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor('#E6000000')
        .fontSize(this.currentIndex === index ? 20 : 18)
        .fontWeight(this.currentIndex === index ? 600 : FontWeight.Normal)
    }
    .width('100%')
  }

  @Builder
  subTabBuilder(tabName: string | Resource, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize(16)
        .fontColor(tabIndex === this.focusIndex ? '#0A59F7' : '#E6000000')
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: 12, right: 12 })
    .height(30)
    .onClick(() => {
      this.subController.changeIndex(tabIndex);
      this.focusIndex = tabIndex;
    })
  }

  @Builder
  contentBuilder(index: number, client: Client) {
    TabContent() {
      Column() {
        Row() {
          DrawerTab({ index: $currentIndex, tabArray: $tabArray })
            .margin({ top: 52 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
    }
    .tabBar(this.tabBuilder(index, client.clientName))
  }

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogCreateMqtt({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      },
      inputValue: $inputValue
    }),
    cancel: this.exitApp,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
      console.log("dialog onWillDismiss")
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss()
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss()
      }
    },
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })

  onCancel() {
    LogUtil.info(this.TAG, ' onCancel');
  }

  onAccept() {
    LogUtil.info(this.TAG, ' onAccept name: ' + this.inputValue?.clientName);
    if (this.inputValue) {
      this.tabArray.push(this.inputValue)
    }
  }

  exitApp() {
    LogUtil.info(this.TAG, 'exitApp ');
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {

        ForEach(this.tabArray, (item: Client, index: number) => {
          this.contentBuilder(index, item)
        }, (item: Client, index: number) => JSON.stringify(item) + index)

        TabContent() {
          Column() {
            Row() {
              Image($r('app.media.ic_add'))
                .width(20)
                .height(15)
                .margin({ left: 16 })
                .onClick(() => {
                  if (this.dialogController != null) {
                    this.dialogController.open()
                  }
                })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
        }.tabBar(this.tabBuilder(this.tabArray.length, " new mqtt"))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(52)
      .animationDuration(300)
      .onAnimationStart((index: number, targetIndex: number) => {
        LogUtil.info(this.TAG, "Tabs index " + index.toString());
        this.currentIndex = targetIndex;
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
  }
}