import fs from '@ohos.file.fs';
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
import {
    AttachmentBody,
    Constant,
    Flag,
    Folder,
    GlobalContext,
    MailLogger,
    Message,
    MimeBodyPart,
    MimeMultipart,
    Properties,
    RecipientType,
    Store
} from '@ohos/mail';
import prompt from '@ohos.promptAction';
import { CAUtil } from './CAUtil';
import taskpool from '@ohos.taskpool';

@Entry
@Component
struct Imap {
    scroller: Scroller = new Scroller();
    @State private from: string = "xx@qq.com";
    @State private authorizationCode: string = ""
    @State private hostReceive: string = "imap.qq.com";
    @State private portReceive: number = 143;
    private readMsgIndex: number = 1;
    @State private parseResult: Object | null = null
    @State private msgList: string = ""
    private deleteMsgIndex: number = 1;
    private moveMsgIndex: number = 1;
    private isSSL = false
    private ca: string[] = []
    private selectIndex = 0

    private supportMail:string[] = [];
    private imapHost:string[] = [];
    private caList:string[] = [];
    private pass:Array<string> = new Array<string>();
    private user:Array<string> = new Array<string>();
    private filesPath:string = '';

    aboutToAppear() {
        this.supportMail = GlobalContext.getContext().getValue('supportMail') as string[];
        this.imapHost = GlobalContext.getContext().getValue('imapHost') as string[];
        this.caList = GlobalContext.getContext().getValue('caList') as string[];
        this.pass = GlobalContext.getContext().getValue('pass') as Array<string>;
        this.user = GlobalContext.getContext().getValue('user') as Array<string>;
        this.filesPath = GlobalContext.getContext().getValue('filesPath') as string;
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
                                        this.hostReceive = this.imapHost[index]
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
                                .switchPointColor(0xe5ffffff)
                                .onChange((isOn: boolean) => {
                                    this.isSSL = isOn
                                    if (isOn) {
                                        this.portReceive = 993
                                    } else {
                                        this.portReceive = 143
                                    }
                                })
                        }.width("50%")
                    }
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Text($r('app.string.Receiving_server'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.hostReceive, placeholder: $r('app.string.Please_enter_the_Receiving_server') })
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
                        Text($r('app.string.Receive_Email'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.from, placeholder: $r('app.string.Please_enter_the_Receive_Email') })
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
                        Button($r('app.string.Receive_Email') , { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                this.parseResult = ""
                                let properties = new Properties("imap")
                                properties.setHost(this.hostReceive)
                                properties.setPort(this.portReceive)
                                properties.setFrom(this.from)
                                properties.setAuthorizationCode(this.authorizationCode)
                                properties.ssl(this.isSSL)
                                if (this.isSSL) {
                                    properties.ca(this.ca)
                                }
                                let map: Map<string, string> = new Map()
                                map.set("name", "myname");
                                map.set("version", "1.0.0");
                                map.set("vendor", "myclient");
                                map.set("support-email", "xx@test.com");

                                let store = new Store(properties)
                                if (this.hostReceive.includes("126") || this.hostReceive.includes("163")
                                || this.hostReceive.includes("yeah")) {
                                    store.id(map)
                                }
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, async (err:Error) => {

                                                if (!err) {
                                                    let messages = folder.getMessages()
                                                    if (messages.length > 0 && messages.length >= this.readMsgIndex) {
                                                        let msg = messages[this.readMsgIndex-1]
                                                        msg.getAllHeaders(async (success:boolean, msg: Message) => {
                                                            if (success) {
                                                                this.parseResult += getContext().resourceManager.getStringByNameSync("Headers")  + '\r\n'
                                                                + getContext().resourceManager.getStringByNameSync("Sender") + msg.getFrom()[0] + "\r\n"
                                                                + getContext().resourceManager.getStringByNameSync("Recipient") + JSON.stringify(msg.getRecipients(RecipientType.TO)) + "\r\n"
                                                                + getContext().resourceManager.getStringByNameSync("Subject") + msg.getSubject() + "\r\n"
                                                                + getContext().resourceManager.getStringByNameSync("Date") + msg.getSentDate()
                                                                + "\r\n------------------------------------\r\n\r\n"
                                                            }

                                                            try {
                                                                let result = await msg.syncGetContent()
                                                                let mime = result as MimeMultipart

                                                                try {
                                                                    let textBody = await mime.syncGetText()
                                                                    this.parseResult += getContext().resourceManager.getStringByNameSync("main_body")  + '\r\n'
                                                                    + getContext().resourceManager.getStringByNameSync("Data") + textBody.getContent() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("CharSet") + textBody.getCharSet() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("MimeType")+ textBody.getMimeType() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("TransferEncoding") + textBody.getTransferEncoding()
                                                                    + "\r\n------------------------------------\r\n\r\n"
                                                                } catch (err) {
                                                                    MailLogger.info('ohos_mail-- sync getText fail:' + err)
                                                                }

                                                                try {
                                                                    let htmlBody = await mime.syncGetHtml()
                                                                    this.parseResult += getContext().resourceManager.getStringByNameSync("Html") + '\r\n'
                                                                    +  getContext().resourceManager.getStringByNameSync("Data") + htmlBody.getContent() + "\r\n"
                                                                    +  getContext().resourceManager.getStringByNameSync("CharSet") + htmlBody.getCharSet() + "\r\n"
                                                                    +  getContext().resourceManager.getStringByNameSync("MimeType")+ htmlBody.getMimeType() + "\r\n"
                                                                    +  getContext().resourceManager.getStringByNameSync("TransferEncoding") + htmlBody.getTransferEncoding()
                                                                    + "\r\n------------------------------------\r\n\r\n"
                                                                } catch (err) {
                                                                    MailLogger.info('ohos_mail-- sync getHtml fail:' + err)
                                                                }

                                                                try {
                                                                    let calendarBody = await mime.syncGetCalendar()
                                                                    this.parseResult += getContext().resourceManager.getStringByNameSync("Calendar") + '\r\n'
                                                                    + getContext().resourceManager.getStringByNameSync("Data")  + calendarBody.getContent() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("CharSet")  + calendarBody.getCharSet() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("MimeType")  + calendarBody.getMimeType() + "\r\n"
                                                                    + getContext().resourceManager.getStringByNameSync("TransferEncoding")  + calendarBody.getTransferEncoding()
                                                                    + "\r\n------------------------------------\r\n\r\n"
                                                                } catch (err) {
                                                                    MailLogger.info('ohos_mail-- sync getCalendar fail:' + err)
                                                                }

                                                                let attachCount = mime.getAttachmentSize()
                                                                //附件结尾标记
                                                                const endOfFile = new Uint8Array([10]);
                                                                for (let i = 0; i < attachCount; i++) {
                                                                    try {
                                                                        let attachBody = mime.getAttachment(i)
                                                                        this.parseResult += getContext().resourceManager.getStringByNameSync("annex") + i + '\r\n'
                                                                        +  getContext().resourceManager.getStringByNameSync("FileName")  + attachBody.getFileName() + "\r\n"
                                                                        + getContext().resourceManager.getStringByNameSync("CharSet") + attachBody.getCharSet() + "\r\n"
                                                                        + getContext().resourceManager.getStringByNameSync("MimeType") + attachBody.getMimeType() + "\r\n"
                                                                        + getContext().resourceManager.getStringByNameSync("TransferEncoding") + attachBody.getEncoding()
                                                                        + "\r\n------------------------------------\r\n\r\n"
                                                                        //接收附件数据的文件
                                                                        let attachmentFilePath = this.filesPath + "/" + i + ".txt";
                                                                        let attachmentFile = fs.openSync(
                                                                            attachmentFilePath,
                                                                            fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                                                                        );
                                                                        //获取附件数据
                                                                        await new Promise<string>((resolve, reject) => {
                                                                            mime.getAttachmentContent(i, (success:boolean, result:ESObject) => {
                                                                                if (success) {
                                                                                    if (result instanceof ArrayBuffer) {
                                                                                        if (result.byteLength === 1) {
                                                                                            const resultArray = new Uint8Array(result);
                                                                                            if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                                                                                fs.closeSync(attachmentFile);
                                                                                                resolve("ok");
                                                                                            }
                                                                                        } else {
                                                                                            fs.writeSync(attachmentFile.fd, result); //写入数据
                                                                                        }
                                                                                    }
                                                                                } else {
                                                                                    reject(result);
                                                                                }
                                                                            })
                                                                        })
                                                                    } catch (err) {
                                                                        MailLogger.info('ohos_mail-- sync getAttachment fail:' + err)
                                                                    }
                                                                }

                                                                store.close((success:boolean) => {
                                                                    if (success) {
                                                                        MailLogger.info('ohos_mail-- close imap success')
                                                                    } else {
                                                                        MailLogger.info('ohos_mail-- close imap fail')
                                                                    }
                                                                })
                                                            } catch (err) {
                                                                MailLogger.info('ohos_mail-- sync getContent fail:' + err)
                                                            }
                                                        })
                                                    }
                                                } else {
                                                    prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
                                                    MailLogger.info('ohos_mail-- open folder fail : ' + err)
                                                    return
                                                }
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
                                        MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
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
                                let task = new taskpool.Task(asyncTask, this.readMsgIndex, this.hostReceive, this.portReceive, this.from, this.authorizationCode, this.isSSL, this.ca, this.filesPath);
                                taskpool.execute(task).then((result:Object) => {
                                    this.parseResult = result
                                });
                            })

                        Text(getContext().resourceManager.getStringByNameSync("Email_content")+"\r\n\r\n" + this.parseResult)
                            .width('90%')
                            .fontSize(18)
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
                                let properties = new Properties("imap")
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
                                if (this.hostReceive.includes("126") || this.hostReceive.includes("163")||this.hostReceive.includes("yeah")) {
                                    store.id(map)
                                }
                                this.msgList = ''
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, async (err:Error) => {
                                                let messages = folder.getMessages()
                                                MailLogger.info('ohos_mail-- open-------------------------' + messages.length)
                                                this.msgList = ""
                                                let start = messages.length < 10 ? 0 : messages.length - 10
                                                for (let i = start; i < messages.length; i++) {
                                                    await new Promise<string>((resolve, reject) => {
                                                        messages[i].getAllHeaders((success:boolean, result:ESObject) => {
                                                            if (success) {
                                                                this.msgList += i + 1 + "\r\n"
                                                                + getContext().resourceManager.getStringByNameSync("Sender")  + result.getFrom()[0] + Constant.LINEFEED + Constant.LINEFEED
                                                                + getContext().resourceManager.getStringByNameSync("Subject") + result.getSubject() + Constant.LINEFEED + Constant.LINEFEED
                                                                + getContext().resourceManager.getStringByNameSync("Recipient") + JSON.stringify(result.getRecipients(RecipientType.TO)) + Constant.LINEFEED
                                                                + getContext().resourceManager.getStringByNameSync("Date") + result.getSentDate() + Constant.LINEFEED + Constant.LINEFEED
                                                                + "-----------------------------------------------------------------------\r\n\r\n"
                                                            }
                                                            resolve('')
                                                        })
                                                    })
                                                }

                                                store.close((success:boolean) => {
                                                    if (success) {
                                                        MailLogger.info('ohos_mail-- close imap success')
                                                    } else {
                                                        MailLogger.info('ohos_mail-- close imap fail')
                                                    }
                                                })
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
                                        MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
                                    }
                                })
                            })

                            Text(getContext().resourceManager.getStringByNameSync("Email_content")+"\r\n" + this.msgList)
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
                                let properties = new Properties("imap")
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
                                if (this.hostReceive.includes("126") || this.hostReceive.includes("163")||this.hostReceive.includes("yeah")) {
                                    store.id(map)
                                }
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, () => {
                                                let msgs = folder.getMessages()
                                                console.info("delete msg----" + msgs.length)
                                                if (msgs.length > 0 && this.deleteMsgIndex > 0 && this.deleteMsgIndex <= msgs.length) {
                                                    msgs[this.deleteMsgIndex-1].setFlags([Flag.DELETED], true, async (err:Error) => {
                                                        if (!err) {
                                                            try {
                                                                await folder.syncExpunge()
                                                                MailLogger.info('ohos_mail-- expunge success')
                                                                prompt.showToast({
                                                                    message:getContext().resourceManager.getStringByNameSync("Delete_successfully"),
                                                                    duration: 2500
                                                                })
                                                            } catch (err) {
                                                                MailLogger.info('ohos_mail-- expunge fail: ' + err)
                                                                prompt.showToast({
                                                                    message: getContext().resourceManager.getStringByNameSync("Delete_failed") + err,
                                                                    duration: 2500
                                                                })
                                                            }
                                                            return
                                                        }
                                                        prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Delete_failed") + err, duration: 2000 })
                                                        store.close((success:boolean) => {
                                                            if (success) {
                                                                MailLogger.info('ohos_mail-- close imap success')
                                                            } else {
                                                                MailLogger.info('ohos_mail-- close imap fail')
                                                            }
                                                        })
                                                    })
                                                } else {
                                                    prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("This_email_does_not_exist"), duration: 2000 })
                                                }
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
                                        MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
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

                ListItem() {
                    Text($r('app.string.move_Mail'))
                        .fontColor('#333333')
                        .fontSize(20)
                        .fontWeight(800)
                        .margin({ top: 20 })
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Text($r('app.string.To_move_the_email_number'))
                            .fontSize(16)
                            .margin({ top: 5 })
                        TextInput({ text: this.deleteMsgIndex + "", placeholder: $r('app.string.To_move_the_email_number') })
                            .height(60)
                            .fontSize(18)
                            .type(InputType.Number)
                            .onChange((value: string) => {
                                this.moveMsgIndex = Number.parseInt(value)
                            })
                        Button($r('app.string.move_Mail'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width(300)
                            .margin({ top: 20 })
                            .backgroundColor('#12939f')
                            .onClick(async () => {
                                let properties = new Properties("imap")
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
                                if (this.hostReceive.includes("126") || this.hostReceive.includes("163")||this.hostReceive.includes("yeah")) {
                                    store.id(map)
                                }
                                store.connect(async (success:boolean, err:Error) => {
                                    if (success) {
                                        try {
                                            let defaultFolder = store.getDefaultFolder()
                                            let list:Array<Folder> =await defaultFolder.syncList()
                                            for (let i = 0; i < list.length; i++) {
                                                MailLogger.info('ohos_mail-- folder list:' + list[i].getName())
                                            }
                                            let folder: Folder = await store.syncGetFolder("INBOX")
                                            folder.open(Folder.READ_WRITE, async (err:Error) => {
                                                if (!err) {
                                                    let messages = folder.getMessages()
                                                    await folder.syncMoveMessages([messages[this.moveMsgIndex-1]], new Folder('Drafts'))
                                                    MailLogger.info('ohos_mail-- moveMessages success')
                                                    prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Move_successful"), duration: 4000 })
                                                    await store.syncClose()
                                                } else {
                                                    MailLogger.info('ohos_mail-- imap open folder fail:' + err)
                                                }
                                            })
                                        } catch (err) {
                                            MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
                                        }
                                    } else {
                                        prompt.showToast({ message: JSON.stringify(err) , duration: 4000 })
                                        MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
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

async function asyncTask(index:number, hostReceive:string, portReceive:number, from:string, authorizationCode:string, isSSL:boolean, ca:string[], filesPath:string) {
    "use concurrent"
    let ret = await Promise.all<string>([
        new Promise((resolve, reject) => {
            let parseResult = ""

            let properties = new Properties("imap")
            properties.setHost(hostReceive)
            properties.setPort(portReceive)
            properties.setFrom(from)
            properties.setAuthorizationCode(authorizationCode)
            properties.ssl(isSSL)
            if (isSSL) {
                properties.ca(ca)
            }
            let map:Map<string, string> = new Map()
            map.set("name", "myname");
            map.set("version", "1.0.0");
            map.set("vendor", "myclient");
            map.set("support-email", "xx@test.com");

            let store = new Store(properties)
            if (hostReceive.includes("126") || hostReceive.includes("163")
            || hostReceive.includes("yeah")) {
                store.id(map)
            }
            store.connect(async (success:boolean, err:Error) => {
                if (success) {
                    try {
                        let folder: Folder = await store.syncGetFolder("INBOX")
                        folder.open(Folder.READ_WRITE, async (err:Error) => {
                            if (!err) {
                                let messages = folder.getMessages()
                                if (messages.length > 0 && messages.length >= index) {
                                    let msg = messages[index-1]
                                    msg.getAllHeaders(async (success:boolean, msg: Message) => {
                                        if (success) {
                                            parseResult +=getContext().resourceManager.getStringByNameSync("Headers")  + '\r\n'
                                            + getContext().resourceManager.getStringByNameSync("Sender") + msg.getFrom()[0] + "\r\n"
                                            + getContext().resourceManager.getStringByNameSync("Recipient") + JSON.stringify(msg.getRecipients(RecipientType.TO)) + "\r\n"
                                            + getContext().resourceManager.getStringByNameSync("Subject") + msg.getSubject() + "\r\n"
                                            + getContext().resourceManager.getStringByNameSync("Date")  + msg.getSentDate()
                                            + "\r\n------------------------------------\r\n\r\n"
                                        }

                                        try {
                                            let result = await msg.syncGetContent()
                                            let mime = result as MimeMultipart

                                            try {
                                                let textBody = await mime.syncGetText()
                                                parseResult += getContext().resourceManager.getStringByNameSync("main_body") + '\r\n'
                                                + getContext().resourceManager.getStringByNameSync("Data") + textBody.getContent() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("CharSet") + textBody.getCharSet() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("MimeType") + textBody.getMimeType() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("TransferEncoding") + textBody.getTransferEncoding()
                                                + "\r\n------------------------------------\r\n\r\n"
                                            } catch (err) {
                                                MailLogger.info('ohos_mail-- sync getText fail:' + err)
                                            }

                                            try {
                                                let htmlBody = await mime.syncGetHtml()
                                                parseResult += getContext().resourceManager.getStringByNameSync("Html")  + '\r\n'
                                                + getContext().resourceManager.getStringByNameSync("Data")  + htmlBody.getContent() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("CharSet")  + htmlBody.getCharSet() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("MimeType")  + htmlBody.getMimeType() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("TransferEncoding")  + htmlBody.getTransferEncoding()
                                                + "\r\n------------------------------------\r\n\r\n"
                                                MailLogger.info('ohos_mail--  data** :' + htmlBody.getContent())
                                            } catch (err) {
                                                MailLogger.info('ohos_mail-- sync getHtml fail:' + err)
                                            }

                                            try {
                                                let calendar = await mime.syncGetCalendar()
                                                parseResult += getContext().resourceManager.getStringByNameSync("Calendar") + '\r\n'
                                                + getContext().resourceManager.getStringByNameSync("Data")  + calendar.getContent() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("CharSet")  + calendar.getCharSet() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("MimeType") + calendar.getMimeType() + "\r\n"
                                                + getContext().resourceManager.getStringByNameSync("TransferEncoding")  + calendar.getTransferEncoding()
                                                + "\r\n------------------------------------\r\n\r\n"
                                            } catch (err) {
                                                MailLogger.info('ohos_mail-- sync getCalendar fail:' + err)
                                            }

                                            let attachCount = mime.getAttachmentSize()
                                            //附件结尾标记
                                            const endOfFile = new Uint8Array([10]);
                                            //遍历附件
                                            for (let i = 0; i < attachCount; i++) {
                                                try {
                                                    let attachBody = mime.getAttachment(i)
                                                    parseResult += getContext().resourceManager.getStringByNameSync("annex")  + i + '\r\n'
                                                    + getContext().resourceManager.getStringByNameSync("FileName")   + attachBody.getFileName() + "\r\n"
                                                    + getContext().resourceManager.getStringByNameSync("CharSet")  + attachBody.getCharSet() + "\r\n"
                                                    + getContext().resourceManager.getStringByNameSync("MimeType")   + attachBody.getMimeType() + "\r\n"
                                                    + getContext().resourceManager.getStringByNameSync("TransferEncoding") + attachBody.getEncoding()
                                                    + "\r\n------------------------------------\r\n\r\n"

                                                    //接收附件数据的文件
                                                    let attachmentFilePath = filesPath + "/" + i + ".txt";
                                                    let attachmentFile = fs.openSync(
                                                        attachmentFilePath,
                                                        fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                                                    );
                                                    //获取附件数据
                                                    await new Promise<string>((resolve, reject) => {
                                                        mime.getAttachmentContent(i, (success:boolean, result:ESObject) => {
                                                            if (success) {
                                                                if (result instanceof ArrayBuffer) {
                                                                    if (result.byteLength === 1) {
                                                                        const resultArray = new Uint8Array(result);
                                                                        if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                                                            fs.closeSync(attachmentFile);
                                                                            resolve("ok");
                                                                        }
                                                                    } else {
                                                                        fs.writeSync(attachmentFile.fd, result); //写入数据
                                                                    }
                                                                }
                                                            } else {
                                                                reject(result);
                                                            }
                                                        })
                                                    })
                                                } catch (err) {
                                                    MailLogger.info('ohos_mail-- sync getAttachment fail:' + err)
                                                }
                                            }

                                            resolve(parseResult)
                                            store.close((success:boolean) => {
                                                if (success) {
                                                    MailLogger.info('ohos_mail-- close imap success')
                                                } else {
                                                    MailLogger.info('ohos_mail-- close imap fail')
                                                }
                                            })
                                        } catch (err) {
                                            reject(err)
                                            MailLogger.info('ohos_mail-- sync getContent fail:' + err)
                                        }
                                    })
                                }
                            } else {
                                MailLogger.info('ohos_mail-- open folder fail : ' + err)
                                return
                            }
                        })
                    } catch (err) {
                        reject(err)
                        MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
                    }
                } else {
                    MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
                }
            })
        })
    ]);
    return ret;
}