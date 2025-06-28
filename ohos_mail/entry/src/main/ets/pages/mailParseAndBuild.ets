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
    EmlFormat,
    AttachmentBody,
    MimeMessage,
    MimeBodyPart,
    MailLogger,
    RecipientType,
    GlobalContext,
} from '@ohos/mail';
import prompt from '@ohos.promptAction';
import util from '@ohos.util';
import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct mailParseAndBuild {
    @State private pathParseResult: string = ""
    @State private buildResult: string = ""
    private from: string = "xx@qq.com";
    private to: string[] = ["xx@sina.com", "xx@hoperun.com"];
    private Cc: string[] = ["xx@qq.com"];
    private Bc: string[] = ["xx@qq.com"];
    private subject: string = getContext().resourceManager.getStringByNameSync("Test_email_sending");
    private text: string = getContext().resourceManager.getStringByNameSync("This_is_a_test_email");

    private filesPath:string = '';

    aboutToAppear() {
        this.filesPath = GlobalContext.getContext().getValue('filesPath') as string;
        let context = getContext(this) as common.UIAbilityContext;
        //获取图片arraybuffer
        let arrayBuff = context.resourceManager.getRawFileContentSync("sample.eml").buffer;
        //文件操作
        let file = fs.openSync(context.filesDir+"/sample.eml",fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd,arrayBuff);
    }

    build() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {

            List({ space: 20, initialIndex: 0 }) {
                ListItem() {
                    Text($r('app.string.Parse_and_Construct_Email'))
                        .fontColor('#333333')
                        .fontSize(20)
                        .fontWeight(800)
                        .margin({ top: 20 })
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button($r('app.string.Parse_Email'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                new EmlFormat().parse(this.filesPath + '/sample.eml', (success:boolean, result:ESObject) => {
                                    if (success) {
                                        MailLogger.info('ohos_mail-- parser file result----:' + JSON.stringify(result));
                                        this.pathParseResult = JSON.stringify(JSON.parse(JSON.stringify(result)), null, 4)
                                    } else {
                                        prompt.showToast({ message: getContext().resourceManager.getStringByNameSync("parsing_failed") + JSON.stringify(result), duration: 3000 })
                                        MailLogger.info('ohos_mail-- parser file fail : ' + JSON.stringify(result));
                                    }
                                });
                            })

                        Text($r('app.string.filename_sample_eml'))
                            .fontColor('#333333')
                            .fontSize(18)
                            .fontWeight(700)

                        Text(getContext().resourceManager.getStringByNameSync("parsing_results") + this.pathParseResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                            .fontWeight(700)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button($r('app.string.Email_construction'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .width('70%')
                            .margin({ top: 10 })
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                let mimeMessage = new MimeMessage()
                                mimeMessage.setFrom(this.from)
                                mimeMessage.setRecipients(RecipientType.TO, this.to)
                                mimeMessage.setRecipients(RecipientType.CC, this.Cc)
                                mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
                                mimeMessage.setSubject(this.subject)
                                mimeMessage.setMIMEVersion("1.0")

                                //设置纯文本格式的正文
                                mimeMessage.setText(this.text)
                                //设置html格式文件
                                //                                            mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + text + "</div>")
                                //设置html格式文件带图片
                                let contentId = "imag01"
                                mimeMessage.addImgInside(new MimeBodyPart(this.filesPath, "test.png", contentId))
                                let contentId1 = "imag02"
                                mimeMessage.addImgInside(new MimeBodyPart(this.filesPath, "test.png", contentId1))
                                mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">"
                                + "<div>" + this.text
                                + "<img src=\"" + "cid:" + contentId + "\""
                                + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
                                + "<img src=\"" + "cid:" + contentId1 + "\""
                                + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
                                + "</div><br>")

                                //设置附件
                                mimeMessage.addAttachmentBody(new AttachmentBody(this.filesPath, "test.png"))
                                mimeMessage.addAttachmentBody(new AttachmentBody(this.filesPath, "test.png"))
                                const decoder = util.TextDecoder.create('utf-8');
                                const utfStr = decoder.decodeWithStream(new Uint8Array(mimeMessage.getMimeMessage()));
                                this.buildResult = utfStr
                            })

                        Text(getContext().resourceManager.getStringByNameSync("construction_resules") +'\r\n' + this.buildResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                            .fontWeight(700)
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