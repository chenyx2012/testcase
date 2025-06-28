/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router'

@Entry
@Component
struct Index {
    build() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
            Button($r('app.string.smtp_protocol'))
                .backgroundColor(Color.Grey)
                .fontSize("18fp")
                .fontColor(Color.White)
                .type(ButtonType.Capsule)
                .width("90%")
                .margin({ "top": 50 })
                .height("120px")
                .onClick((event: ClickEvent) => {
                    router.pushUrl({
                        url: 'pages/smtp' })
                })

            Button($r('app.string.pop3_protocol'))
                .backgroundColor(Color.Grey)
                .fontSize("18fp")
                .fontColor(Color.White)
                .type(ButtonType.Capsule)
                .width("90%")
                .margin({ "top": 50 })
                .height("120px")
                .onClick((event: ClickEvent) => {
                    router.pushUrl({
                        url: 'pages/pop' })
                })

            Button($r('app.string.imap_protocol'))
                .backgroundColor(Color.Grey)
                .fontSize("18fp")
                .fontColor(Color.White)
                .type(ButtonType.Capsule)
                .width("90%")
                .margin({ "top": 50 })
                .height("120px")
                .onClick((event: ClickEvent) => {
                    router.pushUrl({
                        url: 'pages/imap' })
                })

            Button($r('app.string.Parse_Email'))
                .backgroundColor(Color.Grey)
                .fontSize("18fp")
                .fontColor(Color.White)
                .type(ButtonType.Capsule)
                .width("90%")
                .margin({ "top": 50 })
                .height("120px")
                .onClick((event: ClickEvent) => {
                    router.pushUrl({
                        url: 'pages/mailParseAndBuild' })
                })

            Button($r('app.string.mimeType'))
                .backgroundColor(Color.Grey)
                .fontSize("18fp")
                .fontColor(Color.White)
                .type(ButtonType.Capsule)
                .width("90%")
                .margin({ "top": 50 })
                .height("120px")
                .onClick((event: ClickEvent) => {
                    router.pushUrl({
                        url: 'pages/mimeType' })
                })
        }
        .margin(10)
    }
}

