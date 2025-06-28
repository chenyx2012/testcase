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

import router from '@ohos.router';

async function routePage(page: string) {
  let options: router.RouterOptions = {
    url: 'pages/' + page,
  }
  try {
    await router.pushUrl(options)
  } catch (err) {
    console.error(`fail callback, code: ${err.code}, msg: ${err.msg}`)
  }
}

@Entry
@Component

struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.entry_MainAbility'))
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text($r('app.string.emqx'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor(0xffffff)
          .padding({ left: 16, right: 16 })
      }
      .margin({
        top: 20
      })
      .backgroundColor(0x1677ff)
      .onClick(() => {
        routePage('Tab')
      })
    }
    .width('100%')
    .height('100%')
  }
}