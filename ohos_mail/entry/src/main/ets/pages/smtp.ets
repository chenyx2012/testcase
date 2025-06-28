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
  Folder,
  MailLogger,
  Message,
  MimeBodyPart,
  MimeMessage,
  Properties,
  RecipientType,
  Store,
  TransPort,
  MimeMultipart,
  GlobalContext
} from '@ohos/mail';
import prompt from '@ohos.promptAction';
import { CAUtil } from './CAUtil';
import util from '@ohos.util';
import fs from '@ohos.file.fs';
import taskpool from '@ohos.taskpool';


@Entry
@Component
struct Smtp {
  @State private from: string = "xx@qq.com";
  @State private authorizationCode: string = "";
  @State private host: string = "smtp.qq.com";
  private hostReceive: string = "imap.qq.com";
  private to: string[] = ["xx@qq.com", "xx@sina.com"];
  private Cc: string[] = ["xx@yeah.net"];
  private Bc: string[] = ["xx@qq.com"];
  @State private port: number = 25;
  private transport: TransPort | null = null
  private subject: string = "This is subject";
  private text: string = "this is text";
  private replyMsgIndex: number = 1;
  private frowardMsgIndex: number = 1;
  @State private portReceive: number = 143;
  private isSSL = false
  private ca: string[] = []
  private selectIndex = 0
  private supportMail:string[] = [];
  private smtpHost:string[] = [];
  private imapHost:string[] = [];
  private caList:string[] = [];
  private pass:Array<string> = new Array<string>();
  private user:Array<string> = new Array<string>();
  private filesPath:string = '';

  aboutToAppear() {
    this.supportMail = GlobalContext.getContext().getValue('supportMail') as string[];
    this.smtpHost = GlobalContext.getContext().getValue('smtpHost') as string[];
    this.imapHost = GlobalContext.getContext().getValue('imapHost') as string[];
    this.caList = GlobalContext.getContext().getValue('caList') as string[];
    this.pass = GlobalContext.getContext().getValue('pass') as Array<string>;
    this.user = GlobalContext.getContext().getValue('user') as Array<string>;
    this.filesPath = GlobalContext.getContext().getValue('filesPath') as string;
    CAUtil.getCA(["qq.root.crt", "qq.crt"], (data: string[]) => {
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
                    this.host = this.smtpHost[index]
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
                    this.port = 465
                    this.portReceive = 993
                    return
                  } else {
                    this.port = 25
                    this.portReceive = 143
                  }
                })
            }.width("50%")
          }
        }

        ListItem() {
          Column({ space: 12 }) {
            Text($r('app.string.Sending_server'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.host, placeholder: $r('app.string.Please_enter_the_Sending_server') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.host = value
              })
            Text($r('app.string.Sending_server_port'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.port.toString(), placeholder: $r('app.string.Please_enter_the_Sending_server_port') })
              .height(60)
              .fontSize(18)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.port = Number(value).valueOf()
              })
            Text($r('app.string.Send_Email'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.from, placeholder:$r('app.string.Please_enter_the_sending_email_address') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.from = value
              })
            Text($r('app.string.Sender_email_authorization_code'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.authorizationCode, placeholder: $r('app.string.Please_enter_the_Sender_email_authorization_code')})
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.authorizationCode = value
              })
            Text($r('app.string.Receive_Email'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.getRecipient(this.to), placeholder: $r('app.string.Please_enter_the_recipient_email_address_multiple_email_addresses_separated') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.to = value.split(",")
              })
            Text($r('app.string.CC_email'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.getRecipient(this.Cc), placeholder: $r('app.string.Please_ente_the_cc_recipients_email_address') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.Cc = value.split(",")
              })
            Text($r('app.string.BCC_email'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.getRecipient(this.Bc), placeholder: $r('app.string.Please_enter_the_BCC_email') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.Bc = value.split(",")
              })
            Text($r('app.string.Subject'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.subject, placeholder: $r('app.string.Please_enter_the_Subject')})
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.subject = value
              })
            Text($r('app.string.Body'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.text, placeholder: $r('app.string.Please_enter_the_Body') })
              .height(60)
              .fontSize(18)
              .onChange((value: string) => {
                this.text = value
              })
            Button($r('app.string.Send_Email'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(async (event: ClickEvent) => {
                let task = new taskpool.Task(asyncTask, this.host, this.port, this.from, this.to, this.Cc, this.Cc, this.authorizationCode, this.isSSL, this.ca);
                try {
                  await taskpool.execute(task)
                  prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("Sent_successfully"), duration: 2500 })
                } catch (e) {
                  prompt.showToast({
                    message: getContext().resourceManager.getStringByNameSync("Send_failure")+ JSON.stringify(e),
                    duration: 2500
                  })
                }
              })
          }
          .width('100%')
          .padding(10)
          .margin({ top: 10 })
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#cbd0cf')
        }

        ListItem() {
          Text($r('app.string.Forward'))
            .fontColor('#333333')
            .fontSize(20)
            .fontWeight(800)
            .margin({ top: 20 })
        }

        ListItem() {
          Column({ space: 12 }) {
            Text($r('app.string.Index_of_email_to_forward'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.frowardMsgIndex + "", placeholder: $r('app.string.Index_of_email_to_forward') })
              .height(60)
              .fontSize(18)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.frowardMsgIndex = Number.parseInt(value)
              })
            Button($r('app.string.Forward'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick((event: ClickEvent) => {
                let properties = new Properties("imap")
                properties.setHost(this.hostReceive)
                properties.setPort(this.portReceive)
                properties.setFrom(this.from)
                properties.setAuthorizationCode(this.authorizationCode)
                properties.ssl(this.isSSL)
                if (this.isSSL) {
                  properties.ca(this.ca)
                }
                let store = new Store(properties)
                store.connect(async (success: boolean, err: Error) => {
                  if (success) {
                    try {
                      let folder: Folder = await store.syncGetFolder("INBOX")
                      folder.open(Folder.READ_WRITE, async () => {
                        let messages = folder.getMessages()
                        let msg = messages[this.frowardMsgIndex-1]
                        msg.getAllHeaders(async (success: boolean, message: Message) => {
                          if (success) {
                            message.getSubject()
                          }
                          let result = await msg.syncGetContent()
                          let mime = result as MimeMultipart
                          let textBody: MimeBodyPart;
                          let htmlBody: MimeBodyPart;
                          try {
                            textBody = await mime.syncGetText()
                          } catch (err) {

                          }
                          try {
                            htmlBody = await mime.syncGetHtml()
                          } catch (err) {

                          }

                          let mimeMessage = new MimeMessage()
                          let attachCount = mime.getAttachmentSize()
                          //附件结尾标记
                          const endOfFile = new Uint8Array([10]);
                          //遍历附件
                          for (let i = 0; i < attachCount; i++) {
                            try {
                              let attachBody = mime.getAttachment(i)
                              //接收附件数据的文件
                              let attachmentFilePath = this.filesPath + "/" + this.frowardMsgIndex + "-"+getContext().resourceManager.getStringByNameSync("annex")+"-" + i + ".txt";
                              let attachmentFile = fs.openSync(
                                attachmentFilePath,
                                fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                              );
                              //获取附件数据
                              await new Promise<string>((resolve, reject) => {
                                mime.getAttachmentContent(i, (success: boolean, result: ArrayBufferConstructor) => {
                                  if (success) {
                                    if (result instanceof ArrayBuffer) {
                                      if (result.byteLength === 1) {
                                        const resultArray = new Uint8Array(result);
                                        if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                          fs.closeSync(attachmentFile);
                                          let attachmentStr = fs.readTextSync(attachmentFilePath)
                                          let encoder = new util.TextEncoder();
                                          let buffer = encoder.encode(attachmentStr);
                                          attachBody.setUint8ArrayData(buffer)
                                          mimeMessage.addAttachmentBody(attachBody)
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

                          let inlineAttachmentSize = mime.getInlineAttachmentSize()
                          //遍历附件
                          for (let i = 0; i < inlineAttachmentSize; i++) {
                            try {
                              let attachBody = mime.getInlineAttachment(i)
                              //接收附件数据的文件
                              let attachmentFilePath = this.filesPath + "/" + this.frowardMsgIndex + "-"+getContext().resourceManager.getStringByNameSync("Inline_attachments")+"-" + i + ".txt";
                              let attachmentFile = fs.openSync(
                                attachmentFilePath,
                                fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                              );
                              //获取附件数据
                              await new Promise<string>((resolve, reject) => {
                                mime.getInlineAttachmentContent(i, (success: boolean, result: ArrayBufferConstructor) => {
                                  if (success) {
                                    if (result instanceof ArrayBuffer) {
                                      if (result.byteLength === 1) {
                                        const resultArray = new Uint8Array(result);
                                        if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                          fs.closeSync(attachmentFile);
                                          let attachmentStr = fs.readTextSync(attachmentFilePath)
                                          let encoder = new util.TextEncoder();
                                          let buffer = encoder.encode(attachmentStr);
                                          attachBody.setUint8ArrayData(buffer)
                                          mimeMessage.addAttachmentBody(attachBody)
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

                          let properties = new Properties()
                          properties.setFrom(this.from)
                          properties.setHost(this.host)
                          properties.setPort(this.port)
                          properties.setAuthorizationCode(this.authorizationCode)
                          this.transport = new TransPort()
                          //连接服务
                          this.transport.connect(properties, async (success: boolean, err: Error) => {
                            if (success) {
                              MailLogger.info('ohos_mail-- login smtp success:');
                              mimeMessage.setFrom(this.from)
                              mimeMessage.setRecipients(RecipientType.TO, this.to)
                              mimeMessage.setRecipients(RecipientType.CC, this.Cc)
                              mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
                              mimeMessage.setSubject("forward:" + message.getSubject())

                              let text = getContext().resourceManager.getStringByNameSync("Forwarding_test")+"\r\n\r\n\r\n"
                                + "------------------ "+getContext().resourceManager.getStringByNameSync("original_email")+" ------------------\r\n"
                                + getContext().resourceManager.getStringByNameSync("Sender") + message.getFrom()[0] + "\r\n"
                                + getContext().resourceManager.getStringByNameSync("Sending_time") + message.getSentDate() + "\r\n"
                              let to = message.getRecipients(RecipientType.TO)
                              if (!!to) {
                                text += getContext().resourceManager.getStringByNameSync("Recipient")
                                for (let i = 0; i < to.length; i++) {
                                  if (i != to.length - 1) {
                                    text += to[i] + " , "
                                  } else {
                                    text += to[i] + "\r\n"
                                  }
                                }
                              }

                              text += getContext().resourceManager.getStringByNameSync("Subject") + message.getSubject() + "\r\n"
                              let cc = message.getRecipients(RecipientType.CC)
                              if (!!cc) {
                                text += getContext().resourceManager.getStringByNameSync("CC")
                                for (let i = 0; i < cc.length; i++) {
                                  if (i != cc.length - 1) {
                                    text += cc[i] + " , "
                                  } else {
                                    text += cc[i] + "\r\n"
                                  }
                                }
                              }
                              text += "\r\n\r\n"
                              if (!!textBody) {
                                text += textBody.getContent()
                              }
                              //设置纯文本格式的正文
                              mimeMessage.setText(text)
                              if (!!htmlBody) {
                                let htmlContent: string = htmlBody.getContent()
                                //设置html
                                MailLogger.info('ohos_mail-- html-----' + JSON.stringify(htmlContent
                                  .substring(htmlContent
                                    .length - 100, htmlContent.length)));
                                mimeMessage.setHtml(htmlContent)
                              }

                              if (this.transport != null) {
                                //转发邮件
                                this.transport.sendMessage(mimeMessage, (err: Error) => {
                                  if (!err) {
                                    MailLogger.info('ohos_mail-- send message success');
                                    prompt.showToast({
                                      message: getContext().resourceManager.getStringByNameSync("Forwarded_successfully"),
                                      duration: 2500
                                    })
                                  } else {
                                    prompt.showToast({
                                      message: getContext().resourceManager.getStringByNameSync("Forwarded_failure") + JSON.stringify(err),
                                      duration: 2500
                                    })
                                  }

                                  if (this.transport != null) {
                                    this.transport.close((err: Error) => {
                                      if (!err) {
                                        MailLogger.info('ohos_mail-- socket close success!');
                                      } else {
                                        MailLogger.info('ohos_mail-- socket close fail:' + err);
                                      }
                                    })
                                  }
                                })
                              }
                            } else {
                              prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                              MailLogger.info('ohos_mail-- login smtp fail:' + err);
                            }
                          });

                          store.close((success: boolean) => {
                            if (success) {
                              MailLogger.info('ohos_mail-- close imap success')
                            } else {
                              MailLogger.info('ohos_mail-- close imap fail')
                            }
                          })
                        })
                      })
                    } catch (err) {
                      MailLogger.info('ohos_mail-- smtp sync get folder fail :' + err);
                    }
                  } else {
                    prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                    MailLogger.info('ohos_mail-- login IMAP fail : ' + err);
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
          Text($r('app.string.Reply_to_Email'))
            .fontColor('#333333')
            .fontSize(20)
            .fontWeight(800)
            .margin({ top: 20 })
        }

        ListItem() {
          Column({ space: 12 }) {
            Text($r('app.string.Index_of_email_to_reply_to'))
              .fontSize(16)
              .margin({ top: 5 })
            TextInput({ text: this.replyMsgIndex + "", placeholder: $r('app.string.Index_of_email_to_reply_to')})
              .height(60)
              .fontSize(18)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.replyMsgIndex = Number.parseInt(value)
              })
            Button($r('app.string.Reply_to_Email'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick((event: ClickEvent) => {
                let properties = new Properties("imap")
                properties.setHost(this.hostReceive)
                properties.setPort(this.portReceive)
                properties.setFrom(this.from)
                properties.setAuthorizationCode(this.authorizationCode)
                properties.ssl(this.isSSL)
                if (this.isSSL) {
                  properties.ca(this.ca)
                }
                let store = new Store(properties)
                store.connect(async (success: boolean, err: Error) => {
                  let properties = new Properties("imap")
                  properties.setHost(this.hostReceive)
                  properties.setPort(this.portReceive)
                  properties.setFrom(this.from)
                  properties.setAuthorizationCode(this.authorizationCode)
                  properties.ssl(this.isSSL)
                  if (this.isSSL) {
                    properties.ca(this.ca)
                  }
                  let store = new Store(properties)
                  store.connect(async (success: boolean, err: Error) => {
                    if (success) {
                      try {
                        let folder: Folder = await store.syncGetFolder("INBOX")
                        folder.open(Folder.READ_WRITE, async () => {
                          let messages = folder.getMessages()
                          let msg = messages[this.replyMsgIndex-1]
                          msg.getAllHeaders(async (success: boolean, message: Message) => {
                            if (success) {
                              message.getSubject()
                            }
                            let result = await msg.syncGetContent()
                            let mime = result as MimeMultipart
                            let textBody: MimeBodyPart;
                            let htmlBody: MimeBodyPart;
                            try {
                              textBody = await mime.syncGetText()
                            } catch (err) {
                              MailLogger.info('ohos_mail-- sync getTextBody fail:' + err)
                            }
                            try {
                              htmlBody = await mime.syncGetHtml()
                            } catch (err) {
                              MailLogger.info('ohos_mail-- sync getHtmlBody fail:' + err)
                            }

                            let mimeMessage = new MimeMessage()
                            let attachCount = mime.getAttachmentSize()
                            //附件结尾标记
                            const endOfFile = new Uint8Array([10]);
                            //遍历附件
                            for (let i = 0; i < attachCount; i++) {
                              try {
                                let attachBody = mime.getAttachment(i)
                                //接收附件数据的文件
                                let attachmentFilePath = this.filesPath + "/" + this.frowardMsgIndex + "-"+getContext().resourceManager.getStringByNameSync("annex")+"-" + i + ".txt";
                                let attachmentFile = fs.openSync(
                                  attachmentFilePath,
                                  fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                                );
                                //获取附件数据
                                await new Promise<string>((resolve, reject) => {
                                  mime.getAttachmentContent(i, (success: boolean, result: ArrayBufferConstructor) => {
                                    if (success) {
                                      if (result instanceof ArrayBuffer) {
                                        if (result.byteLength === 1) {
                                          const resultArray = new Uint8Array(result);
                                          if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                            fs.closeSync(attachmentFile);
                                            let attachmentStr = fs.readTextSync(attachmentFilePath)
                                            let encoder = new util.TextEncoder();
                                            let buffer = encoder.encode(attachmentStr);
                                            attachBody.setUint8ArrayData(buffer)
                                            mimeMessage.addAttachmentBody(attachBody)
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

                            let inlineAttachmentSize = mime.getInlineAttachmentSize()
                            //遍历附件
                            for (let i = 0; i < inlineAttachmentSize; i++) {
                              try {
                                let attachBody = mime.getInlineAttachment(i)
                                //接收附件数据的文件
                                let attachmentFilePath = this.filesPath + "/" + this.frowardMsgIndex + "-"+getContext().resourceManager.getStringByNameSync("Inline_attachments")+"-" + i + ".txt";
                                let attachmentFile = fs.openSync(
                                  attachmentFilePath,
                                  fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.APPEND
                                );
                                //获取附件数据
                                await new Promise<string>((resolve, reject) => {
                                  mime.getInlineAttachmentContent(i, (success: boolean, result: ArrayBufferConstructor) => {
                                    if (success) {
                                      if (result instanceof ArrayBuffer) {
                                        if (result.byteLength === 1) {
                                          const resultArray = new Uint8Array(result);
                                          if (resultArray[0] === endOfFile[0]) { //遇到结尾标记，停止写入
                                            fs.closeSync(attachmentFile);
                                            let attachmentStr = fs.readTextSync(attachmentFilePath)
                                            let encoder = new util.TextEncoder();
                                            let buffer = encoder.encode(attachmentStr);
                                            attachBody.setUint8ArrayData(buffer)
                                            mimeMessage.addAttachmentBody(attachBody)
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

                            let properties = new Properties()
                            properties.setFrom(this.from)
                            properties.setHost(this.host)
                            properties.setPort(this.port)
                            properties.setAuthorizationCode(this.authorizationCode)
                            this.transport = new TransPort()
                            //连接服务
                            this.transport.connect(properties, (success: boolean, err: Error) => {
                              if (success) {
                                MailLogger.info('ohos_mail-- login smtp success:');
                                let mimeMessage = new MimeMessage()
                                mimeMessage.setFrom(this.from)
                                mimeMessage.setRecipients(RecipientType.TO, this.to)
                                mimeMessage.setRecipients(RecipientType.CC, this.Cc)
                                mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
                                mimeMessage.setSubject("reply:" + message.getSubject())

                                let text = getContext().resourceManager.getStringByNameSync("Reply_testing")+ "\r\n\r\n\r\n"
                                  + "------------------ "+getContext().resourceManager.getStringByNameSync("original_email")+" ------------------\r\n"
                                  + getContext().resourceManager.getStringByNameSync("Sender") + message.getFrom() + "\r\n"
                                  + getContext().resourceManager.getStringByNameSync("Sending_time") + message.getSentDate() + "\r\n"
                                let to = message.getRecipients(RecipientType.TO)
                                if (!!to) {
                                  text += getContext().resourceManager.getStringByNameSync("Recipient")
                                  for (let i = 0; i < to.length; i++) {
                                    if (i != to.length - 1) {
                                      text += to[i] + ","
                                    } else {
                                      text += to[i] + "\r\n"
                                    }
                                  }
                                }

                                text += getContext().resourceManager.getStringByNameSync("Subject") + message.getSubject() + "\r\n"
                                let cc = message.getRecipients(RecipientType.CC)
                                if (!!cc) {
                                  text += getContext().resourceManager.getStringByNameSync("CC")
                                  for (let i = 0; i < cc.length; i++) {
                                    if (i != cc.length - 1) {
                                      text += cc[i] + ","
                                    } else {
                                      text += cc[i] + "\r\n"
                                    }
                                  }
                                }
                                if (!!message.getRecipients(RecipientType.BCC)) {
                                  text += getContext().resourceManager.getStringByNameSync("bcc") + message.getRecipients(RecipientType.BCC) + "\r\n"
                                }
                                text += "\r\n\r\n"
                                if (!!textBody) {
                                  text += textBody.getContent()
                                }
                                //设置纯文本格式的正文
                                mimeMessage.setText(text)
                                if (!!htmlBody) {
                                  let htmlContent: string = htmlBody.getContent()
                                  //设置html
                                  MailLogger.info('ohos_mail-- html-----' + JSON.stringify(htmlContent
                                    .substring(htmlContent
                                      .length - 100, htmlContent.length)));
                                  mimeMessage.setHtml(htmlContent)
                                }

                                if(this.transport != null) {
                                  //回复邮件
                                  this.transport.sendMessage(mimeMessage, (err: Error) => {
                                    if (!err) {
                                      MailLogger.info('ohos_mail-- send message success');
                                      prompt.showToast({
                                        message: getContext().resourceManager.getStringByNameSync("Replied_successfully"),
                                        duration: 2500
                                      })
                                    } else {
                                      prompt.showToast({
                                        message: getContext().resourceManager.getStringByNameSync("Replied_failure") + JSON.stringify(err),
                                        duration: 2500
                                      })
                                    }
                                    if(this.transport != null) {
                                      this.transport.close((err: Error) => {
                                        if (!err) {
                                          MailLogger.info('ohos_mail-- socket close success!');
                                        } else {
                                          MailLogger.info('ohos_mail-- socket close fail:' + err);
                                        }
                                      })
                                    }
                                  })
                                }
                              } else {
                                prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                                MailLogger.info('ohos_mail-- login smtp fail:' + err);
                              }
                            });

                            store.close((success: boolean) => {
                              if (success) {
                                MailLogger.info('ohos_mail-- close imap success')
                              } else {
                                MailLogger.info('ohos_mail-- close imap fail')
                              }
                            })
                          })
                        })
                      } catch (err) {
                        MailLogger.info('ohos_mail-- smtp sync get folder fail :' + err);
                      }
                    } else {
                      prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
                      MailLogger.info('ohos_mail-- connect IMAP fail : ' + err);
                    }
                  })
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
    .margin(10)
  }

  private getRecipient(arr: string[]) {
    let recipient = ""
    for (let i = 0; i < arr.length; i++) {
      if (i != arr.length - 1) {
        recipient += arr[i] + ","
      } else {
        recipient += arr[i]
      }
    }
    return recipient
  }
}

async function asyncTask(host: string, port: number, sendFrom: string, to: string[], Cc: string[], Bc: string[], authorizationCode: string, isSSL: boolean, ca: string[]) {
  "use concurrent"
  let cacheContent = GlobalContext.getContext().getValue('cacheContent');
  let ret = await Promise.all<string>([
    new Promise((resolve, reject) => {
      let subject = getContext().resourceManager.getStringByNameSync("This_is_subject")
      let text = getContext().resourceManager.getStringByNameSync("This_is_text")
      let properties = new Properties()
      properties.setFrom(sendFrom)
      properties.setHost(host)
      properties.setPort(port)
      properties.ssl(isSSL)
      if (isSSL) {
        properties.ca(ca)
      }
      properties.setAuthorizationCode(authorizationCode)
      let transport = new TransPort()
      //连接服务
      transport.connect(properties, (success: boolean, err: Error) => {
        if (success) {
          MailLogger.info('ohos_mail-- login smtp success:')
          let mimeMessage = new MimeMessage()
          mimeMessage.setFrom(sendFrom)
          mimeMessage.setRecipients(RecipientType.TO, to)
          mimeMessage.setRecipients(RecipientType.CC, Cc)
          mimeMessage.setRecipients(RecipientType.BCC, Bc)
          mimeMessage.setSubject(subject)
          mimeMessage.setMIMEVersion("1.0")

          //设置纯文本格式的正文
          mimeMessage.setText(text)
          //设置html格式文件
          //mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + this.text + "</div>")
          //设置html格式文件带图片
          //                                        let contentId = "imag01"
          //                                        mimeMessage.addImgInside(new MimeBodyPart(this.filesPath, "test.png", contentId))
          //                                        let contentId1 = "imag02"
          //                                        mimeMessage.addImgInside(new MimeBodyPart(this.filesPath, "test.png", contentId1))
          //                                        mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">"
          //                                        + "<div>" + this.text
          //                                        + "<img src=\"" + "cid:" + contentId + "\""
          //                                        + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
          //                                        + "<img src=\"" + "cid:" + contentId1 + "\""
          //                                        + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
          //                                        + "</div><br>")

          //设置附件
          let attach = new AttachmentBody("/data/storage/el2/base/haps/entry/files", "test.jpg")
          attach.setCacheContent(cacheContent)
          mimeMessage.addAttachmentBody(attach)
          //send mail
          transport.sendMessage(mimeMessage, (err: Error) => {
            if (!err) {
              MailLogger.info('ohos_mail-- send mail success!');
              resolve("Successfully sent！")
            } else {
              reject(JSON.stringify(err))
            }
            transport.close((err: Error) => {
              if (!err) {
                MailLogger.info('ohos_mail-- smtp socket close success!');
              } else {
                MailLogger.info('ohos_mail-- smtp socket close fail:' + err);
              }
            })
          })
        } else {
          MailLogger.error('ohos_mail-- login smtp fail:' + JSON.stringify(err));
          reject(JSON.stringify(err))
        }
      })
    })
  ]);
  return ret;
}
