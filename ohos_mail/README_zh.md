# mail

## Deprecated
这个三方库已不维护，推荐使用[@coremail/mail_base](https://ohpm.openharmony.cn/#/cn/detail/@coremail%2Fmail_base)

## 简介

> ohos_mail主要提供电子邮件SMTP、POP3、IMAP协议的发送、接收、移动、删除等功能，能够解析和构建eml格式的电子邮件，识别电子邮件的MIME类型消息头和消息体，方便开发者执行一些常用的邮件传输。
> 其中本软件/mail/src/main/ets/mail/目录下的代码是开源软件 [mail](https://github.com/eclipse-ee4j/mail) 的TypeScript语言实现；
> 以及本软件/mail/src/main/ets/mime_types/目录下的代码是开源软件 [mime-types](https://github.com/overview/mime-types) 的TypeScript语言实现。

## 下载安装

```shell
ohpm install @ohos/mail
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 测试资源使用注意事项

内置的测试资源文件放在./testFile目录下,通过git lfs的方式上传的，如果直接下载项目的zip包，得到的资源文件只是一个快捷方式，需要进资源文件目录手动下载。或者通过git clone的方式下载代码，这样得到的资源文件是完整的。

## 使用说明

#### 使用前在demo或者XTS中的xx改为正确的邮箱账号和授权码，才可正常的使用demo。

1、引入依赖

 ``` 
   import { MimeTypeDetector,EmlFormat,Store,Attachment } from '@ohos/mail';
 ```

2、在module.json5中添加权限

 ```
     "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET"
      },
      {
        "name": "ohos.permission.GET_NETWORK_INFO"
      },
      {
        "name": "ohos.permission.GET_WIFI_INFO"
      }
    ]
 ```

3、在EntryAbility初始化MimeTypeDetector

 ```
    onWindowStageCreate(windowStage) {
        MimeTypeDetector.init((data)=>{
            GlobalContext.getContext().setValue("cacheContent", data);
        })
    }
 ```

4、文件Mime类型解析

 ```
    //解析文件的MimeType
    let mimetype =MimeTypeDetector.detectMimeType(path + "/logdemo.bat")
    console.log('sample mimetype detectMimeType bat:' + mimetype);
 ```

5、邮件解析

 ```
    //解析邮件文件
    let filePath = path + '/sample.eml'
    new EmlFormat().parse(filePath, function (error, result) {
        console.info('result-------' + JSON.stringify(result))
    });
      
    //解析string类型的邮件内容
    let content="'
    EmlFormat.parseString(content, (error, msg: Message) => {
        //获取邮件各种详细信息
        MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getFrom()[0]))
        MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getSubject()))
        MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getRecipients(RecipientType.TO)))
        MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getText()))
        MailLogger.info('ohos_test-- html--' + JSON.stringify(result.getHtml()))
        MailLogger.info('ohos_test-- file--' + JSON.stringify(result.getFiles()))
        ...
    });
 ```

6、构建邮件

 ```
        private from: string = "xx@qq.com";
        private to: string[] = ["xx@sina.com", "xx@hoperun.com"];
        private Cc: string[] = ["xx@qq.com"];
        private Bc: string[] = ["xx@qq.com"];
 
        let mimeMessage = new MimeMessage()
        mimeMessage.setFrom(this.from)
        mimeMessage.setRecipients(RecipientType.TO, this.to)
        mimeMessage.setRecipients(RecipientType.CC, this.Cc)
        mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
        mimeMessage.setSubject("")
        mimeMessage.setMIMEVersion("1.0")

        let path:string="/data/app/el2/100/base/cn.openharmony.mail/haps/entry/files"
        //设置纯文本格式的正文
        mimeMessage.setText("test")
        //设置html格式文件
        //   mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + text + "</div>")
        //设置html格式文件带图片
        let contentId = "imag01"
        mimeMessage.addImgInside(new MimeBodyPart(path, "test.png", contentId))
        let contentId1 = "imag02"
        mimeMessage.addImgInside(new MimeBodyPart(path, "test.png", contentId1))
        mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">"
        + "<div>" + this.text
        + "<img src=\"" + "cid:" + contentId + "\""
        + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
        + "<img src=\"" + "cid:" + contentId1 + "\""
        + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
        + "</div><br>")

        //设置附件
        mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.png"))
        mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.png"))
        let buildResult:string = mimeMessage.getMimeMessage()
 ```

7、设置读取邮箱的协议(支持IMAP和POP3协议)

 ```
    //设置imap协议
    let properties = new Properties("imap")
    //设置imap服务器地址
    properties.setHost("imap.qq.com")
    //设置imap服务器端口
    properties.setPort(143)
    //设置是否使用ssl
    properties.ssl(true)
    //设置ca证书
    properties.ca(this.ca)
    //设置pop3协议
    let properties = new Properties("pop3")
    //设置pop3服务器地址
    properties.setHost("pop.qq.com")
    //设置pop3服务器端口
    properties.setPort(110)
 ```

8、发送邮件

 ```
    private from: string = "xx@qq.com";
    private to: string[] = ["xx@sina.com", "xx@hoperun.com"];
    private Cc: string[] = ["xx@qq.com"];
    private Bc: string[] = ["xx@qq.com"];
 
    let properties = new Properties()
    properties.setFrom(this.from)
    properties.setHost(this.host)
    properties.setPort(this.port)
    //设置是否使用ssl
    properties.ssl(true)
    //设置ca证书
    properties.ca(this.ca)
    properties.setAuthorizationCode(this.authorizationCode)
    this.transport = new TransPort()
    //连接服务
    this.transport.connect(properties, (success:boolean, err:Error) =>{
        if (success) {
            MailLogger.info('ohos_mail-- login smtp success:')
            let mimeMessage = new MimeMessage()
            mimeMessage.setFrom(this.from)
            mimeMessage.setRecipients(RecipientType.TO, this.to)
            mimeMessage.setRecipients(RecipientType.CC, this.Cc)
            mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
            mimeMessage.setSubject("")
            mimeMessage.setMIMEVersion("1.0")

            let path:string="/data/app/el2/100/base/cn.openharmony.mail/haps/entry/files"
            //设置纯文本格式的正文
            mimeMessage.setText("")
            //设置html格式文件
            //    mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + text + "</div>")
            //设置html格式文件带图片
            let contentId = "imag01"
            mimeMessage.addImgInside(new MimeBodyPart(GlobalContext.getContext().getValue('filesPath') as string, "test.png", contentId))
            let contentId1 = "imag02"
            mimeMessage.addImgInside(new MimeBodyPart(GlobalContext.getContext().getValue('filesPath') as string, "test.png", contentId1))
            mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">"
                    + "<div>" + this.text
                    + "<img src=\"" + "cid:" + contentId + "\""
                    + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
                    + "<img src=\"" + "cid:" + contentId1 + "\""
                    + "id=\"" + "img_insert_165510789654906970130739777411" + "\"" + ">"
                    + "</div><br>")

            //设置附件
            let attachment1=new AttachmentBody(path, "test.txt")
            //如果是在taskpool中使用需要调用下面方法将GlobalContext.getContext().getValue('cacheContent')传递进去，反之可以不用调
            //attachment1.setCacheContent(GlobalContext.getContext().getValue('cacheContent'))
            mimeMessage.addAttachmentBody(attachment1)
            mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.docx"))
            //发送邮件
            this.transport.sendMessage(mimeMessage, (success：boolean, err:Error) =>{
                if (success) {
                    MailLogger.info('ohos_mail-- send mail success!');
                    prompt.showToast({message:"发送成功！", duration:4000})
                } else {
                    prompt.showToast({message:"发送失败：" + JSON.stringify(err), duration:4000})
                }
                //关闭连接
                 this.transport.close((err:Error) => {
                     if (!err) {
                         MailLogger.info('ohos_mail-- socket close success!');
                     } else {
                         MailLogger.info('ohos_mail-- socket close fail:' + err);
                     }
                  })
            })

        } else {
            prompt.showToast({message:JSON.stringify(err), duration:4000})
            MailLogger.error('ohos_mail-- login smtp fail:' + err);
        }
    });
 ```

9、接收邮件(imap)

 ```
    let properties = new Properties("imap")
    properties.setHost(this.hostReceive)
    properties.setPort(this.portReceive)
    properties.setFrom(this.from)
    properties.setAuthorizationCode(this.authorizationCode)
    properties.ssl(this.isSSL)
    if (this.isSSL) {
        properties.ca(this.ca)
    }
    let map::Map<string, string> = new Map()
    map.set("name", "myname");
    map.set("version", "1.0.0");
    map.set("vendor", "myclient");
    map.set("support-email", "xx@test.com");

    let store = new Store(properties)
    if (this.hostReceive.includes("126") || this.hostReceive.includes("163")
        || this.hostReceive.includes("yeah")) {
        store.id(map)
    }
    store.connect(async (success: boolean, err:Error) => {
        if (success) {
            //获取文件夹列表
            store.getDefaultFolder().list((success:boolean, folders:Folder) => {
                if (success) {
                    for (let i = 0; i < folders.length; i++) {
                         MailLogger.info("ohos_mail folder list----"+folders[i].getName())
                     }
                }
            })
            let folder: Folder = store.getFolder("INBOX")
            folder.open(Folder.READ_WRITE, async (err:Error) => {
            if (!err) {
                let messages = folder.getMessages()
                if (messages.length > 0 && messages.length >= this.readMsgIndex) {
                    let msg = messages[this.readMsgIndex-1]
                    msg.getAllHeaders(async (success:boolean, msg: Message) => {
                        if (success) {
                            this.parseResult += 'Headers ' + '\r\n'
                                    + '发件人:  ' + msg.getFrom()[0] + "\r\n"
                                    + '收件人:  ' + JSON.stringify(msg.getRecipients(RecipientType.TO)) + "\r\n"
                                    + '主题:  ' + msg.getSubject() + "\r\n"
                                    + '日期:  ' + msg.getSentDate()
                                    + "\r\n------------------------------------\r\n\r\n"
                        }

                        try {
                            let result = await msg.syncGetContent()
                            let mime = result as MimeMultipart

                            try {
                                let textBody = await mime.syncGetText()
                                this.parseResult += '正文 ' + '\r\n'
                                        + 'Data:  ' + textBody.getContent() + "\r\n"
                                        + 'CharSet:  ' + textBody.getCharSet() + "\r\n"
                                        + 'MimeType:  ' + textBody.getMimeType() + "\r\n"
                                        + 'TransferEncoding:  ' + textBody.getTransferEncoding()
                                        + "\r\n------------------------------------\r\n\r\n"
                            } catch (err:Error) {
                                MailLogger.info('ohos_mail-- sync getText fail:' + err)
                            }

                            try {
                                let htmlBody = await mime.syncGetHtml()
                                this.parseResult += 'Html ' + '\r\n'
                                        + 'Data:  ' + htmlBody.getContent() + "\r\n"
                                        + 'CharSet:  ' + htmlBody.getCharSet() + "\r\n"
                                        + 'MimeType:  ' + htmlBody.getMimeType() + "\r\n"
                                        + 'TransferEncoding:  ' + htmlBody.getTransferEncoding()
                                        + "\r\n------------------------------------\r\n\r\n"
                            } catch (err:Error) {
                                MailLogger.info('ohos_mail-- sync getHtml fail:' + err)
                            }

                            let attachCount = mime.getAttachmentSize()
                            for (let i = 0; i < attachCount; i++) {
                                try {
                                    let attachBody = await mime.syncGetAttachment(i)
                                    this.parseResult += '附件 ' + i + '\r\n'
                                            + 'FileName:  ' + attachBody.getFileName() + "\r\n"
                                            + 'Data:  ' + attachBody.getContent() + "\r\n"
                                            + 'CharSet:  ' + attachBody.getCharSet() + "\r\n"
                                            + 'MimeType:  ' + attachBody.getMimeType() + "\r\n"
                                            + 'TransferEncoding:  ' + attachBody.getEncoding()
                                            + "\r\n------------------------------------\r\n\r\n"
                                } catch (err:Error) {
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
                        } catch (err:Error) {
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
        } else {
            prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
            MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
        }
    })
 ```

10、接收邮件(pop3)

 ```
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
    store.connect((success:boolean, err:Error) => {
        if (success) {
            let folder: Folder = store.getFolder("INBOX")
            folder.open(Folder.READ_WRITE, async (err:Error) => {
            let messages = folder.getMessages()
            if (messages.length > 0 && messages.length >= this.readMsgIndex) {
                let msg = messages[this.readMsgIndex-1]
                //获取解析后的邮件内容
                try {
                    let message = await msg.syncGetContent()
                    let result = message as Message
                    this.parseResult = '发件人:  ' + result.getFrom()[0] + "\r\n\r\n"
                            + '主题:  ' + result.getSubject() + "\r\n\r\n"
                            + '收件人:  ' + result.getRecipients(RecipientType.TO) + "\r\n\r\n"
                            + '正文:  ' + result.getText() + "\r\n\r\n"
                            + 'HTML:  ' + result.getHtml() + "\r\n\r\n"

                    let files = result.getFiles()
                    if (!!files) {
                        let length = files.length
                        for (let i = 0; i < length; i++) {
                            this.parseResult += "附件  " + (i + 1) + ": " + files[i].getFileName() + "\r\n"
                                    + "    Content-Transfer-Encoding:" + files[i].getEncoding() + "\r\n"
                                    + "    Content-Type:" + files[i].getMimeType() + "\r\n"
                                    + "    附件内容:" + files[i].getData() + "\r\n"
                        }
                    }

                    store.close((success:boolean) => {
                    if (success) {
                        MailLogger.info('ohos_mail-- close imap success')
                    } else {
                        MailLogger.info('ohos_mail-- close imap fail')
                    }
                                                    })
                } catch (e) {
                    MailLogger.info('ohos_mail-- sync getContent fail:' + err)
                }
            }
          })
        } else {
            prompt.showToast({ message: JSON.stringify(err), duration: 2500 })
            MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
        }
    })
 ```

11、删除邮件

 ```
  let properties = new Properties("imap")
  properties.setHost("imap.qq.com")
  properties.setPort(143)
  properties.setFrom("xxx@qq.com")
  properties.setAuthorizationCode("xx")
  //设置是否使用ssl
  properties.ssl(true)
  //设置ca证书
  properties.ca(this.ca)
  let store = new Store(properties)
  store.connect(async (success: boolean, err:Error) => {
    if (success) {
      let folder: Folder = store.getFolder("INBOX")
      folder.open(Folder.READ_WRITE, () => {
        let msgs = folder.getMessages()
        msgs[this.deleteMsgIndex-1].setFlag(Flag.DELETED, (success, result) => {
          if (success) {
             folder.expunge()
          }
        })
      })
    } else {
      prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
      MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
    }
  })
 ```

12、移动邮件

 ```
    let properties = new Properties("imap")
    properties.setHost("imap.qq.com")
    properties.setPort(143)
    properties.setFrom(this.from)
    properties.setAuthorizationCode("xx")
    //设置是否使用ssl
    properties.ssl(true)
    //设置ca证书
    properties.ca(this.ca)
    let store = new Store(properties)
    store.connect(async (success:boolean, err:Error) => {
      if (success) {
        //获取INBOX邮箱对象(收件箱)
        let folder: Folder = store.getFolder("INBOX")
        //打开INBOX邮箱
        folder.open(Folder.READ_WRITE, async () => {
            //获取当前邮箱的所有邮件
            let messages = folder.getMessages()
            folder.moveMessages([messages[0]], new Folder('Sent Messages'),(success,err)=>{
                if(success){
                   MailLogger.info('ohos_mail-- moveMessages success')
                }else{
                   MailLogger.info('ohos_mail-- moveMessages fail : ' + err)
                 }
            })
            
           //部分邮箱不支持MOVE  可以使用以下方式实现MOVE功能
           folder.copyMessages([messages[0]], new Folder('草稿箱'), (success, err) => {
               if (success) {
                   MailLogger.info('ohos_mail-- copyMessages success')
               } else {
                   MailLogger.info('ohos_mail-- copyMessages fail : ' + err)
               }
               messages[0].setFlag(Flag.DELETED, (err:Error) => {
                   if (!err) {
                       MailLogger.info('ohos_mail-- set flag success')
                   } else {
                       MailLogger.info('ohos_mail-- set flag fail')
                   }
                   store.close((success:boolean) => {
                       if (success) {
                           MailLogger.info('ohos_mail-- set flag close success')
                       } else {
                           MailLogger.info('ohos_mail-- set flag close fail')
                       }
                    })
               })
           })
        })
 ```

13、转发/回复 邮件

 ```
  private from: string = "xx@qq.com";
  private to: string[] = ["xx@sina.com", "xx@hoperun.com"];
  private Cc: string[] = ["xx@qq.com"];
  private Bc: string[] = ["xx@qq.com"];
 
  let properties = new Properties("imap")
  properties.setHost("imap.qq.com")
  properties.setPort("143")
  properties.setFrom(this.from)
  properties.setAuthorizationCode("xx")
  //设置是否使用ssl
  properties.ssl(true)
  //设置ca证书
  properties.ca(this.ca)
  let store = new Store(properties)
  store.connect((success:boolean, err:Error) => {
    if (success) {
      let folder: Folder = store.getFolder("INBOX")
      folder.open(Folder.READ_WRITE, async () => {
        let messages = folder.getMessages()
        messages[0].getContent((success, message: Message) => {
          let properties = new Properties()
          properties.setFrom(this.from)
          properties.setHost("smtp.qq.com")
          properties.setPort(25)
          properties.setAuthorizationCode("xx")
          this.transport = new TransPort()
          //连接服务
          this.transport.connect(properties, (success:boolean, err:Error) => {
            if (success) {
              MailLogger.info('ohos_mail-- login smtp success:');
              let mimeMessage = new MimeMessage()
              mimeMessage.setFrom(this.from)
              mimeMessage.setRecipients(RecipientType.TO, this.to)
              mimeMessage.setRecipients(RecipientType.CC, this.Cc)
              mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
              mimeMessage.setSubject("转发:" + message.getSubject())

              let text = "转发测试\r\n\r\n\r\n"
              + "------------------ 原始邮件 ------------------\r\n"
              + "发件人: " + message.getFrom()[0] + "\r\n"
              + "发送时间: " + message.getSentDate() + "\r\n"
              let to = message.getRecipients(RecipientType.TO)
              if (!!to) {
                text += "收件人: "
                for (let i = 0; i < to.length; i++) {
                  if (i != to.length - 1) {
                    text += to[i] + " , "
                  } else {
                    text += to[i] + "\r\n"
                  }
                }
              }

              text += "主题: " + message.getSubject() + "\r\n"
              let cc = message.getRecipients(RecipientType.CC)
              if (!!cc) {
                text += "抄送: "
                for (let i = 0; i < cc.length; i++) {
                  if (i != cc.length - 1) {
                    text += cc[i] + " , "
                  } else {
                    text += cc[i] + "\r\n"
                  }
                }
              }
              +"\r\n\r\n"
              + message.getText()
              //设置纯文本格式的正文
              mimeMessage.setText(text)
              //设置html
              mimeMessage.setHtml(message.getHtml())
              let files = message.getFiles()
              let path:string="/data/app/el2/100/base/cn.openharmony.mail/haps/entry/files"
              if (!!files) {
                for (let i = 0;i < files.length; i++) {
                  let file = files[i]
                  if (!!file.getContentID()) {
                    var mimeBody = new MimeBodyPart(path, file.getFileName(), file.getContentID())
                    mimeBody.setDta(file.getUint8ArrayData())
                    mimeBody.setMimeType(file.getMimeType())
                    mimeMessage.addImgInside(mimeBody)
                  } else {
                    mimeMessage.addAttachmentBody(file)
                  }
                }
              }
              //转发邮件
              this.transport.sendMessage(mimeMessage, (success:boolean, err:Error) => {
                if (success) {
                  MailLogger.info('ohos_mail-- send message success');
                  prompt.showToast({ message: "转发成功！", duration: 4000 })
                } else {
                  prompt.showToast({ message: "转发失败：" + JSON.stringify(err), duration: 4000 })
                }

                store.close((success:boolean) => {
                    if (success) {
                       MailLogger.info('ohos_mail-- close imap success')
                    } else {
                        MailLogger.info('ohos_mail-- close imap fail')
                    }
                })
              })
            } else {
              prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
              MailLogger.info('ohos_mail-- login smtp fail:' + err);
            }
          });
        })
      })
    } else {
      prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
      MailLogger.info('ohos_mail-- login IMAP fail : ' + err);
    }
  })
 ```

14、邮箱管理

 ```
    let properties = new Properties("imap")
    properties.setHost("imap.qq.com")
    properties.setPort(25)
    properties.setFrom(this.from)
    properties.setAuthorizationCode("xx")
    //设置是否使用ssl
    properties.ssl(true)
    //设置ca证书
    properties.ca(this.ca)
    let store = new Store(properties)
    store.connect(async (success:boolean, err:Error) => {
      if (success) {
        //创建邮箱(文件夹)
        store.createFolder("Test", (success, err) =>{
            if (success) {
                console.info('ohos_mail-- create mail success')
            } else {
                console.info('ohos_mail-- create mail fail:' + err)
            }
        })

        //重命名邮箱(文件夹)
        store.renameFolder("Test", "TestMail", (success, err) =>{
            if (success) {
                console.info('ohos_mail-- rename mail success')
            } else {
                console.info('ohos_mail-- rename mail fail:' + err)
            }
        })

        //删除邮箱(文件夹)
        store.deleteFolder("TestMail", (success, err) =>{
            if (success) {
                console.info('ohos_mail-- delete mail success')
            } else {
                console.info('ohos_mail-- delete mail fail:' + err)
            }
        })
      
        //获取INBOX邮箱对象(收件箱)
        let folder: Folder = store.getFolder("INBOX")
        //打开INBOX邮箱
        folder.open(Folder.READ_WRITE, async () => {
          //获取邮箱的相关信息
          MailLogger.info('ohos_test-- messageCount--' + folder.getMessageCount())
          MailLogger.info('ohos_test-- unreadMessageCount--' + folder.getUnreadMessageCount())
          MailLogger.info('ohos_test-- newMessageCount--' + folder.getNewMessageCount())
          MailLogger.info('ohos_test-- uidNext--' + folder.getUIDNext())
          MailLogger.info('ohos_test-- UIDValidity--' + folder.getUIDValidity())
          MailLogger.info('ohos_test-- mode--' + folder.getMode())
          MailLogger.info('ohos_test-- name--' + folder.getName())
          MailLogger.info('ohos_test-- fullname--' + folder.getFullName())

          await new Promise<string>((resolve, reject) => {
            //获取已删除邮件个数
            folder.getDeletedMessageCount((success, result) => {
              MailLogger.info('ohos_test-- deletedMessageCount--' + result)
              resolve('');
            })
          })
            .then((result) => {
              return new Promise<string>((resolve, reject) => {
                //判断当前邮箱是否存在
                folder.exists((success, result) => {
                  MailLogger.info('ohos_test-- exists--' + result)
                  resolve('');
                })
              })
            })
            .then((result) => {
              return new Promise<string>((resolve, reject) => {
                //获取邮箱列表
                folder.list((success, result) => {
                  MailLogger.info('ohos_test-- list--' + JSON.stringify(result))
                  resolve('');
                })
              })
            })

            //获取当前邮箱的所有邮件
            let messages = folder.getMessages()
        })
      }
 ```

14、添加邮件到指定文件夹（只支持QQ、Sina邮箱）

 ```
   let properties = new Properties("imap")
    properties.setHost("imap.qq.com")
    properties.setPort(143)
    properties.setFrom(this.from)
    properties.setAuthorizationCode("xx")
    let store = new Store(properties)
    store.connect(async (success:boolean, err:Error) => {
       if (success) {
           try {
               let folder: Folder = await store.syncGetFolder("Sent Messages")
               folder.open(Folder.READ_WRITE, async (err:Error) => {
                  if (!err) {
                      let to: string[] = ["xx@qq.com", "xx@sina.com"];
                      let Cc: string[] = ["xx@yeah.net"];
                      let Bc: string[] = ["xx@qq.com"];
                      let mimeMessage = new MimeMessage()
                      mimeMessage.setFrom(this.from)
                      mimeMessage.setRecipients(RecipientType.TO, to)
                      mimeMessage.setRecipients(RecipientType.CC, Cc)
                      mimeMessage.setRecipients(RecipientType.BCC, Bc)
                      mimeMessage.setSubject("主题")
                      mimeMessage.setMIMEVersion("1.0")
                      mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + "测试" + "</div>")
                      mimeMessage.addAttachmentBody(new AttachmentBody(globalThis.filesPath, "test.jpg"))

                      //设置纯文本格式的正文
                      mimeMessage.setText("TEST")
                      await folder.syncAppendMessage(mimeMessage)
                      await folder.syncExpunge()
                      MailLogger.info('ohos_mail-- expunge success!')
                      await store.syncClose()
                      MailLogger.info('ohos_mail-- close imap success')
                  } else {
                    prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
                    MailLogger.info('ohos_mail-- open folder fail : ' + err)
                    return
                  }
               })
          } catch (err:Error) {
              MailLogger.info('ohos_mail-- imap sync get folder fail:' + err)
          }
       } else {
           prompt.showToast({ message: JSON.stringify(err), duration: 4000 })
           MailLogger.info('ohos_mail-- login IMAP fail : ' + err)
       }
    })
 ```

## 接口说明

### EmlFormat(邮件解析)

* 解析邮件类型的文件

  `parse(path: string, callback)`

* 解析string型的邮件内容

  `parseString(eml: string, parseCallBack)`

* 构建邮件

  `buildEml(data: Data, callback?)`

### MimeTypeDetector(检测文件Mime类型)

* 检测文件Mime类型

  `detectMimeType(path: string)`

### Properties(连接邮件服务器的会话信息)

* 设置发件人(用户名)

  `setFrom(from: string)`

* 设置服务器地址

  `setHost(host: string)`

* 设置端口

  `setPort(port: number)`

* 设置邮箱授权码

  `setAuthorizationCode(authorizationCode: string)`

* 设置是否使用ssl

  `ssl(flag:boolean)`

* 设置ca证书

  `ca(ca:string[])`

### TransPort(邮件发送)

* 连接接并登录SMTP发件服务器

  `connect(properties: Properties, loginEvent: (success:boolean, err?:Error) => void)`

* 发送邮件

  `sendMessage(mimeMessage: MimeMessage, event: (err:Error) => void)`

* 关闭服务器连接

  `close(event: (err) => void)`

* 发送空消息

  `noop(event: (err) => void)`

* 设置服务器连接超时时间

  `setTimeOut(timeout:number)`

### Store(主要链接服务器，创建、删除、重命名邮箱操作)

* 连接并登录Imap收件服务器

  `connect(connectCallback: (success:boolean, err?:Error) => void)`

* 设置连接超时时间

  `setConnectTimeOut(timeout:number))`

* 关闭链接

  `close(callback)`

* 发送空消息

  `noop() `

* 获取默认Folder

  ` getDefaultFolder(): Folder`

* 更具邮箱名称获取邮箱对象（Promise）

  `syncGetFolder(name: string): Promise<Folder>`

* 更具邮箱名称获取邮箱对象(callback形式)

  `getFolder(name: string,callback)`

* 创建邮箱(文件夹)

  `createFolder(name: string, callBack)`

* 删除邮箱(文件夹)

  `deleteFolder(name: string, callBack)`

* 重命名邮箱(文件夹)

  `renameFolder(oldName: string, newName: string, callBack)`

* 结束邮件接收过程，pop3接收到此命令后删除所有设置删除标记的邮件，并关闭与pop3客户端程序的网络链接。

  `quit()`

### MimeMessage(构建邮件结构体)

* 设置发件人

  `setFrom(from: string)`

* 设置收件人

  `setRecipients(addressType: RecipientType, addresses: string[])`

* 通过收件人类型追加收件人

  `addRecipients(addressType: RecipientType, addresses: string[])`

* 设置html

  `setHtml(html: string)`

* 添加html内嵌图片

  `addImgInside(imgInside: MimeBodyPart)`

* 设置日期

  `setSentDate(date: Date)`

* 添加附件

  `addAttachmentBody(attachmentBody: AttachmentBody)`

* 设置主题

  `setSubject("测试邮件发送")`

* 设置邮件正文

  `setText("这是一个邮件测试邮件")`

* 设置MIMEVersion

  `setMIMEVersion("1.0")`

* 获取构建的邮件内容

  `getMimeMessage()`

### Message(读取邮件后解析的结果集)

* 获取Folder

  `getFolder(): Folder`

* 设置邮件Flag

  `setFlags(flags: Flag[], isAdd: boolean, callback)`

* 获取邮件Flag

  `getFlags(callback)`

* 同步获取邮件Flag

  `syncGetFlags(): Promise<String[]>`

* 获取发送日期

  `getSentDate(): string`

* 获取邮件行数

  `getLineCount():number`

* 获取邮件大小

  `getSize(callback)`

* 获取邮件完整内容(callback形式)

  `getContent(callback)`

* 获取邮件完整内容(promise形式)

  `syncGetContent()：Promise<MimeMultipart | Message>`

* POP3同步获取邮件Header以及正文的前几行(promise形式)

  `syncGetLineContent(lineCount): Promise<Message>`

* POP3获取邮件Header以及正文的前几行(promise形式)

  `getLineContent(lineCount, callback)`

* 获取邮件标号

  `getMessageNumber(): number`

* 获取邮件主题

  `getSubject(): string`

* 获取发件人

  `getFrom(): string[]`

* 获取ReplyTo

  `getReplyTo(): string[]`

* 获取收件人

  `getRecipients(addressType: RecipientType): string[]`

* 获取所有收件人

  `getAllRecipients(): string[]`

* 获取邮件文本内容

  `getText()`

* 获取附件列表

  `getFiles()`

* 获取内联附件列表

  `getInlineFiles()`

* 获取html

  `getHtml()`

* 获取MIMEVersion

  `getMIMEVersion(callback)`

* 获取Header

  `getHeader(headerName: string, callback)`

* 获取所有Header

  `getAllHeaders(callback)`

* 获取所是否含有附件(包括内联图片)

  `isIncludeAttachment(): boolean`

### Folder(邮箱工具类)

* 获取Store

  `getStore(): Store`

* 获取邮箱列表

  `list(callback)`

* 打开Folder

  `open(mode: number, callback)`

* 关闭连接

  `close()`

* 获取当前Folder是否打开

  `isOpen(): boolean`

* 通过编号获取邮件对象

  `getMessage(msgNums: number)`

* 移动邮件

  `moveMessages(srcMsg: Message[], folder: Folder, callback)`

* 复制邮件到指定文件夹

  `copyMessages(srcMsg: Message[], folder: Folder, callback)`

* 判断folder是否存在

  `exists(callback)`

* 删除被标记为delete的邮件(callback形式)

  `expunge(callback)`

* 删除被标记为delete的邮件(promise形式)

  `syncExpunge(): Promise<String> `

* 获取所有邮件个数

  `getMessageCount(): number`

* 获取未读邮件个数

  `getUnreadMessageCount(): number`

* 获取最新邮件个数

  `getNewMessageCount(): number`

* 获取删除邮件个数

  `getDeletedMessageCount(callback)`

* 获取打开模式

  `getMode(): number`

* 获取folder名称

  `getName(): string`

* 获取下一封新邮件的UID

  `getUIDNext(): number`

* 获取UIDValidity

  `getUIDValidity(): number`

* 获取获取所有邮件

  `getMessages(): Message[]`

* 获取邮件UID

  `getUID(message: Message, callback)`

* 同步获取邮件UID

  `syncGetUID(message: Message): Promise<String>`

* 通过UID获取邮件

  `getMessageByUID(uid: string,callback)`

* 通过UID同步获取邮件

  `syncGetMessageByUID(uid: string):Promise<Message>`

* 添加邮件到指定文件夹(callback形式)

  `appendMessage(message: MimeMessage, callback:(err) => void)`

* 添加邮件到指定文件夹(promise形式)

  `syncAppendMessage(message: MimeMessage): Promise<String>`


### MimeMultipart(imap 邮件实体类)

* 获取TextSize

  `getTextSize():number`


* 获取Store

  `getCount():number`

* 获取所有附件

  `getAttachmentFilesDigest(): Array<AttachmentBody>`

* 获取所有内联附件

  `getInlineAttachmentFilesDigest(): Array<AttachmentBody>`

* 获取附件个数

  `getAttachmentSize(): number`

* 获取内联附件个数

  `getInlineAttachmentSize(): number`

* 是否包含附件

  `isIncludeAttachment(): boolean`

* 是否包含内联附件

  `isIncludeInlineAttachment(): boolean`

* 获取正文（Promise形式）

  `syncGetText(): Promise<MimeBodyPart>`

* IMAP获取正文前几行（Promise形式）

  `syncGetPartText(size: number): Promise<MimeBodyPart>`

* 获取正文（callback形式）

  `getText(callback)`

* IMAP获取正文前几行（callback形式）

  `getPartText(size: number, callback)`

* 获取Html（Promise形式）

  `syncGetHtml(): Promise<MimeBodyPart>`

* IMAP获取Html前几行（Promise形式）

  `syncGetPartHtml(size: number): Promise<MimeBodyPart>`

* 获取Html（callback形式）

  `getHtml(callback)`

* IMAP获取Html前几行（callback形式）

  `getPartHtml(size: number, callback)`

* 获取calendar（Promise形式）

  `syncGetCalendar(): Promise<MimeBodyPart>`

* 获取calendar（callback形式）

  `getCalendar(callback)`

* 获取calendar长度

  `getCalendarSize()`

* 获取第index个附件，不包括附件内容数据，附件内容数据通过getAttachmentContent获取
  `getAttachment(index)`

* 获取第index个内联附件，不包括附件内容数据，附件内容数据通过getInlineAttachmentContent获取
  `getInlineAttachment(index)`

* 获取指定附件内容（callback形式）

  `getAttachmentContent(index, callback)`

* 获取指定内联附件内容（callback形式）

  `getInlineAttachmentContent(index, callback)`

## 约束与限制

在下述版本验证通过：

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.1 Canary2(4.1.3.325), SDK: API11 Release(4.1.0.36)
- DevEco Studio: 4.0 Release(4.0.3.415), SDK: API10 Release(4.0.10.6)

## 目录结构

````
|---- mail
|     |---- entry  # 示例代码文件夹
|     |---- library  # mail库文件夹
|         |---- src
|             |---- main
|                  |---- ets
|                      |---- mime_types
|                          |---- JList.ts  # 数据集合
|                          |---- MimeTypeDetector.ts  # MIME文件探测器
|                          |---- WeightedMimeType.ts  # MIME文件属性
|                      |---- emlformat
|                          |---- Attachment.ts  # 附件实体
|                          |---- Boundary.ts  # 邮件解析辅助   
|                          |---- Data.ts  # 构造邮件数据实体
|                          |---- EmlFormat.ts  # 邮件解析      
|                          |---- Result.ts  #  邮件解析结果
|                      |---- mail
|                          |---- AttachmentBody.ts  # 附件实体
|                          |---- Flag.ts  # 连接邮件服务器的会话信息                
|                          |---- Folder.ts  # 邮箱管理     
|                          |---- Message.ts  # 邮件实体类             
|                          |---- MimeBodyPart.ts  # HTML内嵌图片实体       
|                          |---- MimeMessage.ts  # 邮件实体       
|                          |---- MimeMultipart.ts  # imap邮件实体       
|                          |---- Properties.ts  # 连接邮件服务器的会话信息                
|                          |---- RecipientType.ts  # 收件人类型     
|                          |---- ResponseCode.ts  # smtp服务器响应码     
|                          |---- SocketUtil.ts  # socket工具     
|                          |---- Store.ts  # 邮件接收、管理      
|                          |---- TransPort.ts  # 邮件发送
                       |---- GlobalContext.ts  # GlobalContext替代globalThis     
|                      |---- Constant.ts 常量
|                      |---- MailLogger.ts 日志工具
|                      |---- Uft7Base64.ts utf7转base64工具
|                      |---- Utf7Util.ts utf7编解码工具
|                      |---- Util.ts 工具
|         |---- index.ets  # 对外接口
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/ohos_mail/issues)给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/ohos_mail/pulls)
。

## 开源协议

本项目基于 [Eclipse Public License version 2.0](https://gitee.com/openharmony-tpc/ohos_mail/blob/master/LICENSE-EPL-2.0-GPL-2.0-with-classpath-exception) ，请自由地享受和参与开源。

## 相关项目

- [emlformat](https://github.com/papnkukn/eml-format) —— 用于解析和构建EML文件的纯Node.js库，即RFC 822中描述的电子邮件格式。
- [emailjs-utf7](https://github.com/emailjs/emailjs-utf7) —— 将JavaScript（Unicode/UCS-2）字符串编码和解码为UTF-7 ASCII字符串。
- [emailjs-base64](https://github.com/emailjs/emailjs-base64) —— Base64对字符串和类型化数组进行编码。