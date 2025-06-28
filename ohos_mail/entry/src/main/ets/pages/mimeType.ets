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

import { GlobalContext, MailLogger, MimeTypeDetector, } from '@ohos/mail';

@Entry
@Component
struct MimeType {
    private path: string = "/data/storage/el2/base/haps/entry/files";
    @State private otherFileResult: string = ""
    @State private mimetypeResult: string = ""
    @State private globLiteralResult: string = ""
    @State private globExtensionResult: string = ""
    @State private globFilenameResult: string = ""
    @State private octetStreamResult: string = ""
    @State private magicAndMagicIndentResult: string = ""
    @State private textResult: string = ""
    @State private respectsMagicFileOrderingAndMPEG4Result: string = ""
    @State private emptyFileAndFileResult: string = ""
    private filesPath:string = '';

    aboutToAppear() {
        this.filesPath = GlobalContext.getContext().getValue('filesPath') as string;
        this.path = this.filesPath
    }

    build() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
            List({ space: 20, initialIndex: 0 }) {
                ListItem() {
                    Text($r('app.string.Test_MIME_Type'))
                        .fontColor('#333333')
                        .fontSize(20)
                        .fontWeight(800)
                        .margin({ top: 20 })
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button($r('app.string.test_otherfile_mimetype'), { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.otherFileResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.otherFileResult = "\r\n" + "mimeType bat :  " + MimeTypeDetector.detectMimeType(this.path + "/logdemo.bat") + "\r\n"
                                    + "mimeType properties :  " + MimeTypeDetector.detectMimeType(this.path + "/logdemo.properties") + "\r\n"
                                    + "mimeType afp :  " + MimeTypeDetector.detectMimeType(this.path + "/afpfile.afp")
                                } catch (error) {
                                    MailLogger.error('sample mimetype test otherfile:' + error);
                                    this.otherFileResult = error
                                }
                            })
                            .align(Alignment.Start)

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nlogdemo.bat\r\nlogdemo.properties\r\nafpfile.afp')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text('MimeType : ' + this.otherFileResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .padding(10)
                    .width('100%')
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('Test mimetype', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.mimetypeResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.mimetypeResult = "\r\n"
                                    + "mimeType java :  " + MimeTypeDetector.detectMimeType("logdemo.java") + "\r\n"
                                    + "mimeType mp3 :  " + MimeTypeDetector.detectMimeType("logdemo.mp3") + "\r\n"
                                    + "mimeType zip :  " + MimeTypeDetector.detectMimeType("logdemo.zip") + "\r\n"
                                    + "mimeType jar :  " + MimeTypeDetector.detectMimeType("logdemo.jar") + "\r\n"
                                    + "mimeType rar :  " + MimeTypeDetector.detectMimeType("logdemo.rar") + "\r\n"
                                    + "mimeType mp4 :  " + MimeTypeDetector.detectMimeType("logdemo.mp4") + "\r\n"
                                    + "mimeType tar.gz :  " + MimeTypeDetector.detectMimeType("logdemo.tar.gz") + "\r\n"
                                    + "mimeType png :  " + MimeTypeDetector.detectMimeType("logdemo.png") + "\r\n"
                                    + "mimeType gif :  " + MimeTypeDetector.detectMimeType("logdemo.gif") + "\r\n"
                                    + "mimeType img :  " + MimeTypeDetector.detectMimeType("logdemo.img") + "\r\n"
                                    + "mimeType svg :  " + MimeTypeDetector.detectMimeType("logdemo.svg") + "\r\n"
                                    + "mimeType xml :  " + MimeTypeDetector.detectMimeType("logdemo.xml")
                                } catch (error) {
                                    MailLogger.error('sample mimetype test mimetype:' + error);
                                    this.mimetypeResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nlogdemo.java\r\nlogdemo.mp3\r\nlogdemo.zip\r\nlogdemo.jar\r\nlogdemo.rar\r\nlogdemo.mp4\r\nlogdemo.tar.gz\r\nlogdemo.png\r\nlogdemo.gif\r\nlogdemo.img\r\nlogdemo.svg\r\nlogdemo.xml')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text('MimeType : ' + this.mimetypeResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testGlobLiteral', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.globLiteralResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.globLiteralResult = "\r\n"
                                    + "mimeType makefile :  " + MimeTypeDetector.detectMimeType("makefile") + "\r\n"
                                    + "mimeType Makefile :  " + MimeTypeDetector.detectMimeType("Makefile")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testGlobLiteral:' + error);
                                    this.globLiteralResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nmakefile\r\nMakefile')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result") + this.globLiteralResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testGlobExtension', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.globExtensionResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.globExtensionResult = "\r\n"
                                    + "mimeType txt :  " + MimeTypeDetector.detectMimeType("abc.txt") + "\r\n"
                                    + "mimeType cur :  " + MimeTypeDetector.detectMimeType("x.cur") + "\r\n"
                                    + "mimeType dat :  " + MimeTypeDetector.detectMimeType("winmail.dat") + "\r\n"
                                    + "mimeType mm :  " + MimeTypeDetector.detectMimeType("abc.mm") + "\r\n"
                                    + "mimeType anim5 :  " + MimeTypeDetector.detectMimeType("abc.anim5") + "\r\n"
                                    + "mimeType animj :  " + MimeTypeDetector.detectMimeType("abc.animj") + "\r\n"
                                    + "mimeType Z :  " + MimeTypeDetector.detectMimeType("README.Z") + "\r\n"
                                    + "mimeType pst :  " + MimeTypeDetector.detectMimeType("t.pst")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testGlobExtension:' + error);
                                    this.globExtensionResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nabc.txt\r\nx.cur\r\nwinmail.dat\r\nabc.mm\r\nabc.anim5\r\nabc.animj\r\nREADME.Z\r\nt.pst')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.globExtensionResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testGlobFilename', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.globFilenameResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.globFilenameResult = "\r\n"
                                    + "mimeType README :  " + MimeTypeDetector.detectMimeType("README") + "\r\n"
                                    + "mimeType READMEFILE :  " + MimeTypeDetector.detectMimeType("READMEFILE") + "\r\n"
                                    + "mimeType READMEanim3 :  " + MimeTypeDetector.detectMimeType("READMEanim3") + "\r\n"
                                    + "mimeType README.log :  " + MimeTypeDetector.detectMimeType("README.log") + "\r\n"
                                    + "mimeType README.file :  " + MimeTypeDetector.detectMimeType("README.file")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testGlobFilename:' + error);
                                    this.globFilenameResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nREADME\r\nREADMEFILE\r\nREADMEanim3\r\nREADME.log\r\nREADME.file')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.globFilenameResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testOctetStream', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.octetStreamResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.octetStreamResult = "\r\n"
                                    + "mimeType empty :  " + MimeTypeDetector.detectMimeType(this.path + "/empty") + "\r\n"
                                    + "mimeType octet-stream :  " + MimeTypeDetector.detectMimeType(this.path + "/octet-stream")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testOctetStream:' + error);
                                    this.octetStreamResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nempty\r\noctet-stream')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.octetStreamResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testMagic and testMagicIndent', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.magicAndMagicIndentResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.magicAndMagicIndentResult = "\r\n"
                                    + "mimeType a :  " + MimeTypeDetector.detectMimeType(this.path + "/a") + "\r\n"
                                    + "mimeType e[xml] :  " + MimeTypeDetector.detectMimeType(this.path + "/e[xml]")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testMagic and testMagicIndent:' + error);
                                    this.magicAndMagicIndentResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\na\r\ne[xml]')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.magicAndMagicIndentResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testText', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.textResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.textResult = "\r\n"
                                    + "mimeType plaintext :  " + MimeTypeDetector.detectMimeType(this.path + "/plaintext")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testText:' + error);
                                    this.textResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'plaintext')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.textResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('testRespectsMagicFileOrdering and testMPEG4', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.respectsMagicFileOrderingAndMPEG4Result = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.respectsMagicFileOrderingAndMPEG4Result = "\r\n"
                                    + "mimeType ogv-video-header :  " + MimeTypeDetector.detectMimeType(this.path + "/ogv-video-header") + "\r\n"
                                    + "mimeType mp4v1-video-header :  " + MimeTypeDetector.detectMimeType(this.path + "/mp4v1-video-header") + "\r\n"
                                    + "mimeType mp4v2-video-header :  " + MimeTypeDetector.detectMimeType(this.path + "/mp4v2-video-header")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testRespectsMagicFileOrdering and testMPEG4:' + error);
                                    this.respectsMagicFileOrderingAndMPEG4Result = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'\r\nogv-video-header\r\nmp4v1-video-header\r\nmp4v2-video-header')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.respectsMagicFileOrderingAndMPEG4Result)
                            .fontColor('#ff206adf')
                            .fontSize(16)
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 10 })
                    .alignItems(HorizontalAlign.Start)
                    .backgroundColor('#cbd0cf')
                }

                ListItem() {
                    Column({ space: 12 }) {
                        Button('test EmptyFile and file', { type: ButtonType.Normal })
                            .fontSize(18)
                            .fontColor('#000')
                            .height(60)
                            .backgroundColor('#12939f')
                            .onClick((event: ClickEvent) => {
                                this.emptyFileAndFileResult = getContext().resourceManager.getStringByNameSync("Resolving")
                                try {
                                    this.emptyFileAndFileResult = "\r\n"
                                    + " mime-type-test.weird file not exist :  " + MimeTypeDetector.detectMimeType("mime-type-test.weird") + "\r\n"
                                    + " mime-type-test.weird file exist :  " + MimeTypeDetector.detectMimeType(this.path + "/mime-type-test.weird")
                                } catch (error) {
                                    MailLogger.error('sample mimetype testEmptyFile:' + error);
                                    this.emptyFileAndFileResult = error
                                }
                            })

                        Text(getContext().resourceManager.getStringByNameSync("FileName")+'mime-type-test.weird')
                            .fontColor('#333333')
                            .fontSize(16)

                        Text(getContext().resourceManager.getStringByNameSync("Resolving_result")  + this.emptyFileAndFileResult)
                            .fontColor('#ff206adf')
                            .fontSize(16)
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