# mail

## Deprecated
This third-party library is no longer maintained and we recommend using[@coremail/mail_base](https://ohpm.openharmony.cn/#/cn/detail/@coremail%2Fmail_base)

## Introduction

> ohos_mail provides features such as sending, receiving, moving, and deleting emails in accordance with the SMTP, POP3, and IMAP protocols. It can parse and construct emails in EML format and identify MIME message headers and bodies of emails.
> The code in the `/mail/src/main/ets/mail/` directory is the implementation of the open source software [mail](https://github.com/eclipse-ee4j/mail) using TypeScript.
> The code in the `/mail/src/main/ets/mime_types/` directory is the implementation of the open source software [mime-types](https://github.com/overview/mime-types) using TypeScript.

## How to Install

```shell
ohpm install @ohos/mail
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## Precautions for Using Test Resources

The test resource files are uploaded to the `./testFile` directory in git lfs mode. If you directly download the .zip package of the project, only the shortcuts of the resource files are obtained. You need to manually download the files from the resource file directory. Alternatively, download the code in git clone mode. In this way, the obtained resource files are complete.

## How to Use

#### Before using the demo, change *xx* in the demo or XTS to the correct email account and authorization code.

1. Import the dependency.

    ``` 
      import { MimeTypeDetector,EmlFormat,Store,Attachment } from '@ohos/mail';
    ```

2. Add permissions in the `module.json5` file.

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

3. Initialize `MimeTypeDetector` in the EntryAbility.

    ```
       onWindowStageCreate(windowStage) {
           MimeTypeDetector.init((data)=>{
               GlobalContext.getContext().setValue("cacheContent", data);
           })
       }
    ```

4. Parse the MIME type of a file.

    ```
       // Parse the MIME type of a file.
       let mimetype =MimeTypeDetector.detectMimeType(path + "/logdemo.bat")
       console.log('sample mimetype detectMimeType bat:' + mimetype);
    ```

5. Parse an email.

    ```
       // Parse an email.
       let filePath = path + '/sample.eml'
       new EmlFormat().parse(filePath, function (error, result) {
           console.info('result-------' + JSON.stringify(result))
       });
         
       // Parse the email content of the string type.
       let content="'
       EmlFormat.parseString(content, (error, msg: Message) => {
           // Obtain the detailed information about the email.
           MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getFrom()[0]))
           MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getSubject()))
           MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getRecipients(RecipientType.TO)))
           MailLogger.info('ohos_test-- text--' + JSON.stringify(result.getText()))
           MailLogger.info('ohos_test-- html--' + JSON.stringify(result.getHtml()))
           MailLogger.info('ohos_test-- file--' + JSON.stringify(result.getFiles()))
           ...
       });
    ```

6. Construct an email.

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
           // Set the body in plain text format.
           mimeMessage.setText("test")
           // Set an HTML file.
           //   mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + text + "</div>")
           // Set an HTML file with an image.
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
   
           // Set an attachment.
           mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.png"))
           mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.png"))
           let buildResult:string = mimeMessage.getMimeMessage()
    ```

7. Set the protocol for reading the email. (IMAP and POP3 are supported.)

    ```
       // Set the IMAP protocol.
       let properties = new Properties("imap")
       // Set the address of the IMAP server.
       properties.setHost("imap.qq.com")
       // Set the port number of the IMAP server.
       properties.setPort(143)
       // Set whether to use SSL.
       properties.ssl(true)
       // Set the CA certificate.
       properties.ca(this.ca)
       // Set the POP3 protocol.
       let properties = new Properties("pop3")
       // Set the address of the POP3 server.
       properties.setHost("pop.qq.com")
       // Set the port number of the POP3 server.
       properties.setPort(110)
    ```

8. Send an email.

    ```
       private from: string = "xx@qq.com";
       private to: string[] = ["xx@sina.com", "xx@hoperun.com"];
       private Cc: string[] = ["xx@qq.com"];
       private Bc: string[] = ["xx@qq.com"];
    
       let properties = new Properties()
       properties.setFrom(this.from)
       properties.setHost(this.host)
       properties.setPort(this.port)
       // Set whether to use SSL.
       properties.ssl(true)
       // Set the CA certificate.
       properties.ca(this.ca)
       properties.setAuthorizationCode(this.authorizationCode)
       this.transport = new TransPort()
       // Connect to the service.
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
               // Set the body in plain text format.
               mimeMessage.setText("")
               // Set an HTML file.
               //    mimeMessage.setHtml("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + text + "</div>")
               // Set an HTML file with an image.
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
   
               // Set an attachment.
               let attachment1=new AttachmentBody(path, "test.txt")
               // Call the following method to pass in GlobalContext.getContext().getValue('cacheContent') only if the function is used in the TaskPool.
               //attachment1.setCacheContent(GlobalContext.getContext().getValue('cacheContent'))
               mimeMessage.addAttachmentBody(attachment1)
               mimeMessage.addAttachmentBody(new AttachmentBody(path, "test.docx"))
               // Send the email.
               this.transport.sendMessage(mimeMessage, (success: boolean, err:Error) =>{
                   if (success) {
                       MailLogger.info('ohos_mail-- send mail success!');
                       prompt.showToast({message:"Sent successfully.", duration:4000})
                   } else {
                       prompt.showToast({message:"Sending failed: "+ JSON.stringify(err), duration:4000})
                   }
                   // Close the connection.
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

9. Receive an email (IMAP).

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
               // Obtain the folder list.
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
                                       + 'From:' + msg.getFrom()[0] + "\r\n"
                                       + 'To:' + JSON.stringify(msg.getRecipients(RecipientType.TO)) + "\r\n"
                                       + 'Subject:' + msg.getSubject() + "\r\n"
                                       + 'Date: ' + msg.getSentDate ()
                                       + "\r\n------------------------------------\r\n\r\n"
                           }
   
                           try {
                               let result = await msg.syncGetContent()
                               let mime = result as MimeMultipart
   
                               try {
                                   let textBody = await mime.syncGetText()
                                   this.parseResult += 'Body' + '\r\n'
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
                                       this.parseResult += 'Attachment' + i + '\r\n'
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

10. Receive an email (POP3).

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
                    // Obtain the parsed email content.
                    try {
                        let message = await msg.syncGetContent()
                        let result = message as Message
                        this.parseResult = 'From:' + result.getFrom()[0] + "\r\n\r\n"
                                + 'Subject:' + result.getSubject() + "\r\n\r\n"
                                + 'To:' + result.getRecipients(RecipientType.TO) + "\r\n\r\n"
                                + 'Body:' + result.getText() + "\r\n\r\n"
                                + 'HTML:  ' + result.getHtml() + "\r\n\r\n"
    
                        let files = result.getFiles()
                        if (!!files) {
                            let length = files.length
                            for (let i = 0; i < length; i++) {
                                this.parseResult += "Attachment" + (i + 1) +": " + files[i].getFileName() + "\r\n"
                                        + "    Content-Transfer-Encoding:" + files[i].getEncoding() + "\r\n"
                                        + "    Content-Type:" + files[i].getMimeType() + "\r\n"
                                        + "    Attachment content: " + files[i].getData() + "\r\n"
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

11. Delete an email.

     ```
      let properties = new Properties("imap")
      properties.setHost("imap.qq.com")
      properties.setPort(143)
      properties.setFrom("xxx@qq.com")
      properties.setAuthorizationCode("xx")
      // Set whether to use SSL.
      properties.ssl(true)
      // Set the CA certificate.
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

12. Move an email.

     ```
        let properties = new Properties("imap")
        properties.setHost("imap.qq.com")
        properties.setPort(143)
        properties.setFrom(this.from)
        properties.setAuthorizationCode("xx")
        // Set whether to use SSL.
        properties.ssl(true)
        // Set the CA certificate.
        properties.ca(this.ca)
        let store = new Store(properties)
        store.connect(async (success:boolean, err:Error) => {
          if (success) {
            // Obtain an INBOX object.
            let folder: Folder = store.getFolder("INBOX")
            // Open the inbox.
            folder.open(Folder.READ_WRITE, async () => {
                // Obtain all emails in the mailbox.
                let messages = folder.getMessages()
                folder.moveMessages([messages[0]], new Folder('Sent Messages'),(success,err)=>{
                    if(success){
                       MailLogger.info('ohos_mail-- moveMessages success')
                    }else{
                       MailLogger.info('ohos_mail-- moveMessages fail : ' + err)
                     }
                })
                
               // Some mailboxes do not support the move function. You can use the following method to implement move:
               folder.copyMessages([messages[0]], new Folder('Drafts'), (success, err) => {
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

13. Forward or reply to an email.

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
      // Set whether to use SSL.
      properties.ssl(true)
      // Set the CA certificate.
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
              // Connect to the service.
              this.transport.connect(properties, (success:boolean, err:Error) => {
                if (success) {
                  MailLogger.info('ohos_mail-- login smtp success:');
                  let mimeMessage = new MimeMessage()
                  mimeMessage.setFrom(this.from)
                  mimeMessage.setRecipients(RecipientType.TO, this.to)
                  mimeMessage.setRecipients(RecipientType.CC, this.Cc)
                  mimeMessage.setRecipients(RecipientType.BCC, this.Bc)
                  mimeMessage.setSubject ("Forward:"+ message.getSubject ())
    
                  let text = "Forward Test\r\n\r\n\r\n"
                  + "------------------ Original email ------------------\r\n"
                  + "From: " + message.getFrom()[0] + "\r\n"
                  + "Sent at: " + message.getSentDate() + "\r\n"
                  let to = message.getRecipients(RecipientType.TO)
                  if (!!to) {
                    text += "To:"
                    for (let i = 0; i < to.length; i++) {
                      if (i != to.length - 1) {
                        text += to[i] + " , "
                      } else {
                        text += to[i] + "\r\n"
                      }
                    }
                  }
    
                  text += "Subject: " + message.getSubject() + "\r\n"
                  let cc = message.getRecipients(RecipientType.CC)
                  if (!!cc) {
                    text += "Cc:"
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
                  // Set the body in plain text format.
                  mimeMessage.setText(text)
                  // Set an HTML file.
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
                  // Forward the email.
                  this.transport.sendMessage(mimeMessage, (success:boolean, err:Error) => {
                    if (success) {
                      MailLogger.info('ohos_mail-- send message success');
                      prompt.showToast({ message: "Forwarded successfully.", duration: 4000 })
                    } else {
                      prompt.showToast({ message:"Forwarding failed: "+ JSON.stringify(err), duration: 4000 })
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

14. Manage the mailbox.

     ```
        let properties = new Properties("imap")
        properties.setHost("imap.qq.com")
        properties.setPort(25)
        properties.setFrom(this.from)
        properties.setAuthorizationCode("xx")
        // Set whether to use SSL.
        properties.ssl(true)
        // Set the CA certificate.
        properties.ca(this.ca)
        let store = new Store(properties)
        store.connect(async (success:boolean, err:Error) => {
          if (success) {
            // Create a mailbox (folder).
            store.createFolder("Test", (success, err) =>{
                if (success) {
                    console.info('ohos_mail-- create mail success')
                } else {
                    console.info('ohos_mail-- create mail fail:' + err)
                }
            })
    
            // Rename a mailbox (folder).
            store.renameFolder("Test", "TestMail", (success, err) =>{
                if (success) {
                    console.info('ohos_mail-- rename mail success')
                } else {
                    console.info('ohos_mail-- rename mail fail:' + err)
                }
            })
    
            // Delete a mailbox (folder).
            store.deleteFolder("TestMail", (success, err) =>{
                if (success) {
                    console.info('ohos_mail-- delete mail success')
                } else {
                    console.info('ohos_mail-- delete mail fail:' + err)
                }
            })
          
            // Obtain an INBOX object.
            let folder: Folder = store.getFolder("INBOX")
            // Open the inbox.
            folder.open(Folder.READ_WRITE, async () => {
              // Obtain the mailbox information.
              MailLogger.info('ohos_test-- messageCount--' + folder.getMessageCount())
              MailLogger.info('ohos_test-- unreadMessageCount--' + folder.getUnreadMessageCount())
              MailLogger.info('ohos_test-- newMessageCount--' + folder.getNewMessageCount())
              MailLogger.info('ohos_test-- uidNext--' + folder.getUIDNext())
              MailLogger.info('ohos_test-- UIDValidity--' + folder.getUIDValidity())
              MailLogger.info('ohos_test-- mode--' + folder.getMode())
              MailLogger.info('ohos_test-- name--' + folder.getName())
              MailLogger.info('ohos_test-- fullname--' + folder.getFullName())
    
              await new Promise<string>((resolve, reject) => {
                // Obtain the number of deleted emails.
                folder.getDeletedMessageCount((success, result) => {
                  MailLogger.info('ohos_test-- deletedMessageCount--' + result)
                  resolve('');
                })
              })
                .then((result) => {
                  return new Promise<string>((resolve, reject) => {
                    // Check whether a mailbox exists.
                    folder.exists((success, result) => {
                      MailLogger.info('ohos_test-- exists--' + result)
                      resolve('');
                    })
                  })
                })
                .then((result) => {
                  return new Promise<string>((resolve, reject) => {
                    // Obtain the mailbox list.
                    folder.list((success, result) => {
                      MailLogger.info('ohos_test-- list--' + JSON.stringify(result))
                      resolve('');
                    })
                  })
                })
    
                // Obtain all emails in the mailbox.
                let messages = folder.getMessages()
            })
          }
     ```

15. Add emails to a specified folder (valid only for QQ and Sina mailboxes).

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
                          mimeMessage.setSubject ("Subject")
                          mimeMessage.setMIMEVersion("1.0")
                          mimeMessage.setHtml ("<meta http-equiv=\"" + "Content-Type" + "\"" + "content=\"" + "text/html; charset=GB2312" + "\">" + "<div>" + " test "+ "</div>")
                          mimeMessage.addAttachmentBody(new AttachmentBody(globalThis.filesPath, "test.jpg"))
    
                          // Set the body in plain text format.
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

## Available APIs

### EmlFormat (Parsing an Email)

* Parses an email.

  `parse(path: string, callback)`

* Parses the email content of the string type.

  `parseString(eml: string, parseCallBack)`

* Builds an email.

  `buildEml(data: Data, callback?)`

### MimeTypeDetector (Testing MIME Type)

* Detects the MIME type of a file.

  `detectMimeType(path: string)`

### Properties (Session Information for Connecting to the Email Server)

* Sets a sender (user name).

  `setFrom(from: string)`

* Sets a server address.

  `setHost(host: string)`

* Sets a port number.

  `setPort(port: number)`

* Sets the email authorization code.

  `setAuthorizationCode(authorizationCode: string)`

* Sets whether to use SSL.

  `ssl(flag:boolean)`

* Sets the CA certificate.

  `ca(ca:string[])`

### TransPort (Sending an Email)

* Connects to and logs in to the SMTP sending server.

  `connect(properties: Properties, loginEvent: (success:boolean, err?:Error) => void)`

* Sends an email.

  `sendMessage(mimeMessage: MimeMessage, event: (err:Error) => void)`

* Closes server connection.

  `close(event: (err) => void)`

* Sends an empty message.

  `noop(event: (err) => void)`

* Sets the server connection timeout interval.

  `setTimeOut(timeout:number)`

### Store (Connecting to a Server, and Creating, Deleting, and Renaming a Mailbox)

* Connects to and logs in to the IMAP receiving server.

  `connect(connectCallback: (success:boolean, err?:Error) => void)`

* Sets the connection timeout interval.

  `setConnectTimeOut(timeout:number))`

* Closes the connection.

  `close(callback)`

* Sends an empty message.

  `noop() `

* Obtains the default folder.

  ` getDefaultFolder(): Folder`

* Obtains a mailbox object based on the mailbox name (in promise mode).

  `syncGetFolder(name: string): Promise<Folder>`

* Obtains a mailbox object based on the mailbox name (in callback mode).

  `getFolder(name: string,callback)`

* Creates a mailbox (folder).

  `createFolder(name: string, callBack)`

* Deletes a mailbox (folder).

  `deleteFolder(name: string, callBack)`

* Renames a mailbox (folder).

  `renameFolder(oldName: string, newName: string, callBack)`

* Ends the mail receiving process. After receiving this command, POP3 deletes all emails with the DELE flag and closes the network connection with the POP3 client.

  `quit()`

### MimeMessage (Building Email Structure)

* Sets a sender.

  `setFrom(from: string)`

* Sets a recipient.

  `setRecipients(addressType: RecipientType, addresses: string[])`

* Adds recipients by recipient type.

  `addRecipients(addressType: RecipientType, addresses: string[])`

* Sets an HTML file.

  `setHtml(html: string)`

* Adds an HTML embedded image.

  `addImgInside(imgInside: MimeBodyPart)`

* Sets a date.

  `setSentDate(date: Date)`

* Adds an attachment.

  `addAttachmentBody(attachmentBody: AttachmentBody)`

* Sets the subject.

  `setSubject ("Email sending test")`

* Sets the email body.

  `setText("This is a test email.")`

* Sets the MIME version.

  `setMIMEVersion("1.0")`

* Obtains the email content.

  `getMimeMessage()`

### Message (Result Set Parsed After the Email Is Read)

* Obtains a folder.

  `getFolder(): Folder`

* Sets an email flag.

  `setFlags(flags: Flag[], isAdd: boolean, callback)`

* Obtains an email flag.

  `getFlags(callback)`

* Synchronously obtains an email flag.

  `syncGetFlags(): Promise<String[]>`

* Obtains the date when the email was sent.

  `getSentDate(): string`

* Obtains the number of lines in the email body.

  `getLineCount():number`

* Obtains the email size.

  `getSize(callback)`

* Obtains the complete email content (in callback mode).

  `getContent(callback)`

* Obtains the complete email content (in promise mode).

  `syncGetContent(): Promise<MimeMultipart | Message>`

* Synchronously obtains the email header and the first several lines of the email body (in promise mode).

  `syncGetLineContent(lineCount): Promise<Message>`

* Obtains the email header and the first several lines of the email body (in promise mode).

  `getLineContent(lineCount, callback)`

* Obtains the email number.

  `getMessageNumber(): number`

* Obtains the email subject.

  `getSubject(): string`

* Obtains the sender.

  `getFrom(): string[]`

* Obtains ReplyTo.

  `getReplyTo(): string[]`

* Obtains the recipients.

  `getRecipients(addressType: RecipientType): string[]`

* Obtains all recipients.

  `getAllRecipients(): string[]`

* Obtains the email content.

  `getText()`

* Obtains the attachments.

  `getFiles()`

* Obtains the inline attachments.

  `getInlineFiles()`

* Obtains the HTML content.

  `getHtml()`

* Obtains the MIME version.

  `getMIMEVersion(callback)`

* Obtains the header.

  `getHeader(headerName: string, callback)`

* Obtains all headers.

  `getAllHeaders(callback)`

* Checks whether attachments (including inline images) are contained.

  `isIncludeAttachment(): boolean`

### Folder (Mailbox Utility Class)

* Obtains the store.

  `getStore(): Store`

* Obtains the folder list.

  `list(callback)`

* Opens a folder

  `open(mode: number, callback)`

* Closes the connection.

  `close()`

* Checks whether the folder is opened.

  `isOpen(): boolean`

* Obtains an email object based on the number.

  `getMessage(msgNums: number)`

* Moves an email.

  `moveMessages(srcMsg: Message[], folder: Folder, callback)`

* Copies an email to the specified folder.

  `copyMessages(srcMsg: Message[], folder: Folder, callback)`

* Checks whether a folder exists.

  `exists(callback)`

* Deletes emails marked as delete (in callback mode).

  `expunge(callback)`

* Deletes emails marked as delete (in promise mode).

  `syncExpunge(): Promise<String> `

* Obtains the number of all emails.

  `getMessageCount(): number`

* Obtains the number of unread emails.

  `getUnreadMessageCount(): number`

* Obtains the number of latest emails.

  `getNewMessageCount(): number`

* Obtains the number of deleted emails.

  `getDeletedMessageCount(callback)`

* Obtains the open mode.

  `getMode(): number`

* Obtains the folder name.

  `getName(): string`

* Obtains the UID of the next new email.

  `getUIDNext(): number`

* Checks the validity of a UID.

  `getUIDValidity(): number`

* Obtains all emails.

  `getMessages(): Message[]`

* Obtains the UID of an email.

  `getUID(message: Message, callback)`

* Synchronously obtains the UID of an email.

  `syncGetUID(message: Message): Promise<String>`

* Obtains an email by UID.

  `getMessageByUID(uid: string,callback)`

* Synchronously obtains an email by UID.

  `syncGetMessageByUID(uid: string):Promise<Message>`

* Adds an email to the specified folder (in callback mode).

  `appendMessage(message: MimeMessage, callback:(err) => void)`

* Adds an email to the specified folder (in promise mode).

  `syncAppendMessage(message: MimeMessage): Promise<String>`


### MimeMultipart (IMAP Mail Entity Class)

* Obtains the text size.

  `getTextSize():number`


* Obtains the store.

  `getCount():number`

* Obtains all attachments.

  `getAttachmentFilesDigest(): Array<AttachmentBody>`

* Obtains all inline attachments.

  `getInlineAttachmentFilesDigest(): Array<AttachmentBody>`

* Obtains the number of attachments.

  `getAttachmentSize(): number`

* Obtains the number of inline attachments.

  `getInlineAttachmentSize(): number`

* Checks whether attachments are included.

  `isIncludeAttachment(): boolean`

* Checks whether inline attachments are included.

  `isIncludeInlineAttachment(): boolean`

* Obtains the email body (in promise mode).

  `syncGetText(): Promise<MimeBodyPart>`

* Obtains the first several lines of the email body (in promise mode).

  `syncGetPartText(size: number): Promise<MimeBodyPart>`

* Obtains the email body (in callback mode).

  `getText(callback)`

* Obtains the first several lines of the email body (in callback mode).

  `getPartText(size: number, callback)`

* Obtains the HTML content (in promise mode).

  `syncGetHtml(): Promise<MimeBodyPart>`

* Obtains the first several lines of the HTML content (in promise mode).

  `syncGetPartHtml(size: number): Promise<MimeBodyPart>`

* Obtains the HTML content (in callback mode).

  `getHtml(callback)`

* Obtains the first several lines of the HTML content (in callback mode).

  `getPartHtml(size: number, callback)`

* Obtains the calendar (in promise mode).

  `syncGetCalendar(): Promise<MimeBodyPart>`

* Obtains the calendar (in callback mode).

  `getCalendar(callback)`

* Obtains the calendar length.

  `getCalendarSize()`

* Obtains the attachment with the given index, excluding the attachment content, which can be obtained through `getAttachmentContent`.
  `getAttachment(index)`

* Obtains the inline attachment with the given index, excluding the attachment content, which can be obtained through `getInlineAttachmentContent`.
  `getInlineAttachment(index)`

* Obtains the content of the specified attachment (in callback mode).

  `getAttachmentContent(index, callback)`

* Obtains the content of the specified inline attachment (in callback mode).

  `getInlineAttachmentContent(index, callback)`

## Constraints

This project has been verified in the following versions:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.1 Canary2 (4.1.3.325), SDK: API 11 Release (4.1.0.36)
- DevEco Studio: 4.0 Release (4.0.3.415), SDK: API 10 Release (4.0.10.6)

## Directory Structure

````
|---- mail
|     |---- entry  # Sample code
|     |---- library  # mail library
|         |---- src
|             |---- main
|                  |---- ets
|                      |---- mime_types
|                          |---- JList.ts  # Data set
|                          |---- MimeTypeDetector.ts  # MIME file detector
|                          |---- WeightedMimeType.ts  # MIME file attributes
|                      |---- emlformat
|                          |---- Attachment.ts  # Attachment entity
|                          |---- Boundary.ts  # Email parsing assistance  
|                          |---- Data.ts  # Used to construct email data
|                          |---- EmlFormat.ts  # Used to parse emails     
|                          |---- Result.ts  #  Email parsing result
|                      |---- mail
|                          |---- AttachmentBody.ts  # Attachment entity
|                          |---- Flag.ts  # Session information for connection to the email server               
|                          |---- Folder.ts  # Email management    
|                          |---- Message.ts  # Email entity class            
|                          |---- MimeBodyPart.ts  # HTML embedded image entity      
|                          |---- MimeMessage.ts  # Email entity      
|                          |---- MimeMultipart.ts  # IMAP email entity      
|                          |---- Properties.ts  # Session information for connection to the email server               
|                          |---- RecipientType.ts  # Recipient type    
|                          |---- ResponseCode.ts  # SMTP server response code    
|                          |---- SocketUtil.ts  # Socket utility    
|                          |---- Store.ts  # Email receiving and management     
|                          |---- TransPort.ts  # Email sending
                       |---- GlobalContext.ts # GlobalContext replaces globalThis.    
|                      |---- Constant.ts # Constants
|                      |---- MailLogger.ts # Logger
|                      |---- Uft7Base64.ts # Utility for converting UTF-7 to Base64
|                      |---- Utf7Util.ts # Utility for encoding and decoding UTF-7
|                      |---- Util.ts # Utilities
|           |---- index.ets  # External APIs
|     |---- README.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/ohos_mail/issues) or a [PR](https://gitee.com/openharmony-tpc/ohos_mail/pulls).

## License

This project is licensed under [Eclipse Public License version 2.0](https://gitee.com/openharmony-tpc/ohos_mail/blob/master/LICENSE-EPL-2.0-GPL-2.0-with-classpath-exception).

## Related Projects

- [emlformat](https://github.com/papnkukn/eml-format): A pure Node.js library for parsing and building EML files, that is, email format described in RFC 822.
- [emailjs-utf7](https://github.com/emailjs/emailjs-utf7): A library for encoding and decoding JavaScript (Unicode/UCS-2) strings into UTF-7 ASCII strings.
- [emailjs-base64](https://github.com/emailjs/emailjs-base64): A library for encoding strings and typed arrays using Base64.
