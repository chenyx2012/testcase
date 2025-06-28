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

import { Constant, Flag, Folder,
    GlobalContext,
    MailLogger, Message, Properties, RecipientType, Store } from '@ohos/mail';
import prompt from '@ohos.promptAction';
import { CAUtil } from './CAUtil';
import taskpool from '@ohos.taskpool';

@Entry
@Component
struct Pop {
    @State private from: string = "xx@qq.com";
    @State private authorizationCode: string = ""
    @State private hostReceive: string = "pop.qq.com";
    @State private portReceive: number = 110;
    private readMsgIndex: number = 1;
    @State private parseResult: string = ""
    @State private msgList: string = ""
    private deleteMsgIndex: number = 1;
    private isSSL = false
    private ca: string[] = []
    private selectIndex = 0

    private supportMail:string[] = [];
    private popHost:string[] = [];
    private caList:string[] = [];
    private pass:Array<string> = new Array<string>();
    private user:Array<string> = new Array<string>();

    aboutToAppear() {
        this.supportMail = GlobalContext.getContext().getValue('supportMail') as string[];
        this.popHost = GlobalContext.getContext().getValue('popHost') as string[];
        this.caList = GlobalContext.getContext().getValue('caList') as string[];
        this.pass = GlobalContext.getContext().getValue('pass') as Array<string>;
        this.user = GlobalContext.getContext().getValue('user') as Array<string>;
        CAUtil.getCA(["qq.root.crt", "qq.crt"], (data:string[]) => {
            this.ca = data
        })
    }

    build() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
            List({ space: 20, initialIndex: 0 }) {
                ListItem() {
                    Row() {
                        Column() {
                            Text($r('app.string.Please_select_an_email_address'))
                                .fontSize("16fp")
                                .margin({ top: "2%" })

                            TextPicker({ range: this.supportMail, selected: this.selectIndex })
                                .height("300px")
                                .width("50%")
                                .margin({ top: "10%" })
                                .onChange((value: string | string[], index: number | number[]) => {
                                    if (typeof (index) == "number") {
                                        if (this.selectIndex == index) {
                                            return
                                        }
                                        this.hostReceive = this.popHost[index]
                                        if (!!this.pass) {
                                            this.authorizationCode = this.pass[index]
                                        }

                                        if (!!this.user) {
                                            this.from = this.user[index]
                                        }
                                        this.selectIndex = index
                                        let caList = this.caList
                                        CAUtil.getCA([caList[index][0], caList[index][1]], (data: string[]) => {
                                            this.ca = data
                                        })
                                    }
                                })
                        }
                        Row() {
                            Text($r('app.string.Enable_SSL'))
                                .fontSize("16fp")
                                .margin({ left: "20%" })

                            Toggle({ type: ToggleType.Switch, isOn: false })
                                .selectedColor(0x39a2db)
                                .onChange((isOn: boolean) => {
                                    this.isSSL = isOn
                                    if (isOn) {
                                        this.portReceive = 995
                                    } else {
                                        this.portReceive = 110
                                    }
                                })
                        }.width("50%")
                    }
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Text($r('app.string.Recipient_email'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.hostReceive, placeholder: $r('app.string.Please_enter_the_Recipient_email') })
                            .height(60)
                            .fontSize(18)
                            .onChange((value: string) => {
                                this.hostReceive = value
                            })
                        Text($r('app.string.Receiving_server_port'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.portReceive.toString(), placeholder: $r('app.string.Please_enter_the_Receiving_server_port') })
                            .height(60)
                            .fontSize(18)
                            .type(InputType.Number)
                            .onChange((value: string) => {
                                this.portReceive = Number(value).valueOf()
                            })
                        Text($r('app.string.Recipient_email'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.from, placeholder: $r('app.string.Please_enter_the_Recipient_email') })
                            .height(60)
                            .fontSize(18)
                            .onChange((value: string) => {
                                this.from = value
                            })
                        Text($r('app.string.Recipient_email_authorization_code'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.authorizationCode, placeholder: $r('app.string.Please_enter_the_Recipient_email_authorization_code') })
                            .height(60)
                            .fontSize(18)
                            .onChange((value: string) => {
                                this.authorizationCode = value
                            })
                        Text($r('app.string.Index_of_email_to_read'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.readMsgIndex + "", placeholder: $r('app.string.Index_of_email_to_read') })
                            .height(60)
                            .fontSize(18)
                            .type(InputType.Number)
                            .onChange((value: string) => {
                                this.readMsgIndex = Number.parseInt(value)
                            })
                        Button($r('app.string.Receive_Email'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                this.parseResult = ""
                                let properties = new Properties("pop3")
                                properties.setHost(this.hostReceive)
                                properties.setPort(this.portReceive)
                                properties.setFrom(this.from)
                                properties.setAuthorizationCode(this.authorizationCode)
                                properties.ssl(this.isSSL)
                                if (this.isSSL) {
                                    properties.ca(this.ca)
                                }

                                let store = new Store(properties)
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, async (err:Error) => {
                                                let messages = folder.getMessages()
                                                if (messages.length > 0 && messages.length >= this.readMsgIndex) {
                                                    let msg = messages[this.readMsgIndex-1]
                                                    try {
                                                        MailLogger.info("ohos_mail")
                                                        let message = await msg.syncGetContent()
                                                        let result = message as Message
                                                        this.parseResult = getContext().resourceManager.getStringByNameSync("Sender")+ result.getFrom()[0] + "\r\n\r\n"
                                                        + getContext().resourceManager.getStringByNameSync("Subject") + result.getSubject() + "\r\n\r\n"
                                                        + getContext().resourceManager.getStringByNameSync("Recipient")+ result.getRecipients(RecipientType.TO) + "\r\n\r\n"
                                                        + getContext().resourceManager.getStringByNameSync("main_body")+ result.getText() + "\r\n\r\n"
                                                        + getContext().resourceManager.getStringByNameSync("Html")+ result.getHtml() + "\r\n\r\n"

                                                        let files = result.getFiles()
                                                        if (!!files) {
                                                            let length = files.length
                                                            for (let i = 0; i < length; i++) {
                                                                this.parseResult += getContext().resourceManager.getStringByNameSync("annex") + (i + 1) + ": " + files[i].getFileName() + "\r\n"
                                                                + "    Content-Transfer-Encoding:" + files[i].getEncoding() + "\r\n"
                                                                + "    Content-Type:" + files[i].getMimeType() + "\r\n"
                                                                + "    Attachment content length:" + files[i].getData().length + "\r\n\r\n"
                                                            }
                                                        }

                                                        store.close((success:boolean) => {
                                                            if (success) {
                                                                MailLogger.info('ohos_mail-- close pop3 success')
                                                            } else {
                                                                MailLogger.info('ohos_mail-- close pop3 fail')
                                                            }
                                                        })
                                                    } catch (err) {
                                                        MailLogger.info('ohos_mail-- sync getContent fail:' + err)
                                                    }
                                                }
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- pop sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                                        MailLogger.info('ohos_mail-- login pop fail : ' + err)
                                    }
                                })
                            })

                        Button($r('app.string.Receive_Mail_taskpool'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                this.parseResult = ""
                                let task = new taskpool.Task(asyncTask, this.readMsgIndex, this.hostReceive, this.portReceive, this.from, this.authorizationCode, this.isSSL, this.ca);
                                taskpool.execute(task).then((result:Object) => {
                                    this.parseResult = result as string
                                });
                            })

                        Text(getContext().resourceManager.getStringByNameSync("Email_content")+"Email Content\r\n\r\n" + this.parseResult)
                            .width('90%')
                            .fontSize(20)
                            .padding({ left: 10 })
                            .fontWeight(FontWeight.Bold)
                            .border({ width: 2, radius: 10, color: Color.Black })
                            .margin({ top: 10 })
                    }
                    .width('100%')
                    .padding(10)
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }


                ListItem() {
                    Text($r('app.string.update'))
                        .fontColor('#333333')
                        .fontSize(20)
                        .fontWeight(800)
                        .margin({ top: 20 })
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button($r('app.string.Update_email'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                let properties = new Properties("pop3")
                                properties.setHost(this.hostReceive)
                                properties.setPort(this.portReceive)
                                properties.setFrom(this.from)
                                properties.setAuthorizationCode(this.authorizationCode)
                                properties.ssl(this.isSSL)
                                if (this.isSSL) {
                                    properties.ca(this.ca)
                                }
                                let map:Map<string, string> = new Map()
                                map.set("name", "myname");
                                map.set("version", "1.0.0");
                                map.set("vendor", "myclient");
                                map.set("support-email", "xx@test.com");

                                let store = new Store(properties)
                                //                                store.id(map)
                                this.msgList = ''
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, async (err:Error) => {
                                                let messages = folder.getMessages()
                                                this.msgList = ""
                                                let start = messages.length < 10 ? 0 : messages.length - 10
                                                for (let i = start; i < messages.length; i++) {
                                                    await new Promise<string>((resolve, reject) => {
                                                        messages[i].getAllHeaders((success:boolean, result:ESObject) => {
                                                            if(success){
                                                                this.msgList += i + 1 + getContext().resourceManager.getStringByNameSync("Sender") + result.getFrom()[0] + Constant.LINEFEED + Constant.LINEFEED
                                                                +getContext().resourceManager.getStringByNameSync("Subject") + result.getSubject() + Constant.LINEFEED + Constant.LINEFEED
                                                                +getContext().resourceManager.getStringByNameSync("Recipient") + JSON.stringify(result.getRecipients(RecipientType.TO)) + Constant.LINEFEED
                                                                +getContext().resourceManager.getStringByNameSync("Date") + result.getSentDate() + Constant.LINEFEED + Constant.LINEFEED
                                                                + "-----------------------------------------------------------------------\r\n\r\n"
                                                            }
                                                            resolve('')
                                                        })
                                                    })
                                                }
                                                store.close((success:boolean) => {
                                                    if (success) {
                                                        MailLogger.info('ohos_mail-- close pop3 success')
                                                    } else {
                                                        MailLogger.info('ohos_mail-- close pop3 fail')
                                                    }
                                                })
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- pop sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message:  JSON.stringify(err), duration: 2500 })
                                        MailLogger.info('ohos_mail-- login pop3 fail : ' + err)
                                    }
                                })
                            })

                        Text(getContext().resourceManager.getStringByNameSync("Email_content")+"\r\n\r\n" + this.msgList)
                            .width('90%')
                            .fontSize(20)
                            .padding({ left: 10 })
                            .fontWeight(FontWeight.Bold)
                            .border({ width: 2, radius: 10, color: Color.Black })
                            .margin({ top: 50 })
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }


                ListItem() {
                    Text($r('app.string.Delete_mail'))
                        .fontColor('#333333')
                        .fontSize(20)
                        .fontWeight(800)
                        .margin({ top: 20 })
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Text($r('app.string.The_number_of_the_mail_to_delete'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.deleteMsgIndex + "", placeholder: $r('app.string.The_number_of_the_mail_to_delete') })
                            .height(60)
                            .fontSize(18)
                            .type(InputType.Number)
                            .onChange((value: string) => {
                                this.deleteMsgIndex = Number.parseInt(value)
                            })
                        Button($r('app.string.Delete_mail'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                let properties = new Properties("pop3")
                                properties.setHost(this.hostReceive)
                                properties.setPort(this.portReceive)
                                properties.setFrom(this.from)
                                properties.setAuthorizationCode(this.authorizationCode)
                                properties.ssl(this.isSSL)
                                if (this.isSSL) {
                                    properties.ca(this.ca)
                                }
                                let map:Map<string, string> = new Map()
                                map.set("name", "myname");
                                map.set("version", "1.0.0");
                                map.set("vendor", "myclient");
                                map.set("support-email", "xx@test.com");

                                let store = new Store(properties)
                                store.id(map)
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, () => {
                                                let msgs = folder.getMessages()
                                                console.info("delete msg----" + msgs.length)
                                                if(msgs.length > 0 && this.deleteMsgIndex > 0 && this.deleteMsgIndex <= msgs.length){
                                                    msgs[this.deleteMsgIndex-1].setFlags([Flag.DELETED], true, async (err:Error) => {
                                                        if (!err) {
                                                            try {
                                                                await folder.syncExpunge()
                                                                MailLogger.info('ohos_mail-- expunge success')
                                                                prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Delete_successfully"), duration: 2500 })
                                                            } catch (err) {
                                                                MailLogger.info('ohos_mail-- expunge fail: ' + err)
                                                                prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Delete_failed") + err, duration: 2500 })
                                                            }
                                                            return
                                                        }
                                                        prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Delete_failed") + err, duration: 2500 })
                                                        store.close((success:boolean) => {
                                                            if (success) {
                                                                MailLogger.info('ohos_mail-- close pop3 success')
                                                            } else {
                                                                MailLogger.info('ohos_mail-- close pop3 fail')
                                                            }
                                                        })
                                                    })
                                                } else {
                                                    prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("This_email_does_not_exist") , duration: 2000 })
                                                }
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- pop sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                                        MailLogger.info('ohos_mail-- login pop3 fail : ' + err)
                                    }
                                })
                            })
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }
            }
        }
    }
}

async function asyncTask(index:number, hostReceive:string, portReceive:number, from:string, authorizationCode:string, isSSL:boolean, ca: string[]) {
    "use concurrent"

    let ret = await Promise.all<string>(
        [
        new Promise((resolve, reject) => {
            let parseResult = ""
            let properties = new Properties("pop3")
            properties.setHost(hostReceive)
            properties.setPort(portReceive)
            properties.setFrom(from)
            properties.setAuthorizationCode(authorizationCode)
            properties.ssl(isSSL)
            if (isSSL) {
                properties.ca(ca)
            }

            let store = new Store(properties)
            store.connect(async (success:boolean, err:Error) => {
                if (success) {
                    try {
                        let folder: Folder = await store.syncGetFolder("INBOX")
                        folder.open(Folder.READ_WRITE, async (err:Error) => {
                            if (!err) {
                                let messages = folder.getMessages()
                                if (messages.length > 0 && messages.length >= index) {
                                    let msg = messages[index-1]
                                    //获取解析后的邮件内容
                                    try {
                                        let message = await msg.syncGetContent()
                                        let result = message as Message

                                        parseResult = 'Sender:  ' + result.getFrom()[0] + "\r\n\r\n"
                                        + getContext().resourceManager.getStringByNameSync("Subject") + result.getSubject() + "\r\n\r\n"
                                        + getContext().resourceManager.getStringByNameSync("Recipient") + result.getRecipients(RecipientType.TO) + "\r\n\r\n"
                                        + getContext().resourceManager.getStringByNameSync("main_body") + result.getText() + "\r\n\r\n"
                                        + getContext().resourceManager.getStringByNameSync("Html")+ result.getHtml() + "\r\n\r\n"

                                        let files = result.getFiles()
                                        if (!!files) {
                                            let length = files.length
                                            for (let i = 0; i < length; i++) {
                                                parseResult += getContext().resourceManager.getStringByNameSync("annex") + (i + 1) + ": " + files[i].getFileName() + "\r\n\r\n"
                                                + "    Content-Transfer-Encoding:" + files[i].getEncoding() + "\r\n\r\n"
                                                + "    Content-Type:" + files[i].getMimeType() + "\r\n\r\n"
                                                + "    Attachment content length:" + files[i].getData().length + "\r\n\r\n"
                                            }
                                        }

                                        let lines = parseResult.split("\r\n\r\n")

                                        for (let i = 0; i < lines.length; i++) {
                                            MailLogger.info("ohos_mail-- server msg content : " + JSON.stringify(lines[i]))
                                        }
                                        resolve(parseResult)
                                        store.close((success:boolean) => {
                                            if (success) {
                                                MailLogger.info('ohos_mail-- close pop success')
                                            } else {
                                                MailLogger.info('ohos_mail-- close pop fail')
                                            }
                                        })

                                    } catch (err) {
                                        reject(err)
                                        MailLogger.info('ohos_mail-- pop3 sync getContent fail:' + err)
                                    }
                                }
                            }
                        })
                    } catch (err) {
                        reject(err)
                        MailLogger.info('ohos_mail-- sync get folder fail:' + err)
                    }
                } else {
                    reject(err)
                    MailLogger.info('ohos_mail-- login pop3 fail : ' + err)
                }
            })
        })
    ]);
    return ret;
}