/*
Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software must 
display the following acknowledgment: "This product includes software developed 
by the Apache Group for use in the Apache HTTP server project (http://www.apache.org/)."
4. The name "Apache Server" and "Apache Group" must not be used to endorse or promote 
products derived from this software without prior written permission. 
For written permission, please contact apache@apache.org.
5. Products derived from this software may not be called "Apache" nor may "Apache" 
appear in their name, without prior written permission of the Apache Group.
6. Redistributions of any form whatsoever must retain the following acknowledgment:
"This product includes software developed by the Apache Group for use in the Apache 
HTTP server project (http://www.apache.org/)."

THIS SOFTWARE IS PROVIDED BY THE APACHE GROUP ``AS IS'' AND ANY EXPRESSED OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE APACHE 
GROUP OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Client from "@ohos/newsie"
import promptAction from '@ohos.promptAction';

const tag = "dudu----"

class Value {
  value: ESObject
}
@Entry
@Component
struct Index {
  client: Client = new Client({});
  @State status: boolean = false;
  host: string = "xxx.xxx.xxx.xxx"
  port: number = 8084
  @State groups: Array<SelectOption> = [] //所有新闻组
  @State select_group: string = "" //选中新闻组

  @State articles: Array<SelectOption> = [] //所有文章
  @State select_article: string = "" //选中文章

  @State selected_date_time: Date = new Date();

  @Builder BuildLabel(text: string) {
    Text(text).fontSize(14)
  }

  @Builder BuildButton(text: string, callback: (() => Promise<void>) | undefined, bgColor:ResourceColor=Color.Green) {
    Button(text).margin({ right: 2, bottom: 1 }).fontSize(12).onClick(callback).height(30).backgroundColor(bgColor)
  }

  async aboutToAppear() {

  }

  build() {
    Column(){
      Column() {
        Row() {
          this.BuildLabel("Current connection status：")
          if (this.status) {
            Text("Success").fontColor(Color.Green)
          } else {
            Text("Failed").fontColor(Color.Red)
          }
        }.width("100%")


        Row() {
          this.BuildButton("Connect", this.safeCallFunc((async () => {
            this.client = new Client({
              host: "xxx.xxx.xxx.xxx",
              port: 8084
            })
            await this.client.connect();
            this.status = true;
            return "Connect success";
          })))
        }.margin({ top: 10 }).width("100%")

        Row() {
          this.BuildLabel("Time：")
          DatePicker({ selected: this.selected_date_time })
            .onChange((value: DatePickerResult) => {
              if (value && value.year !== undefined) {
                this.selected_date_time.setFullYear(value.year, value.month, value.day)
              }
            }).layoutWeight(1).height(70)
          TimePicker({ selected: this.selected_date_time }).onChange((value) => {
            this.selected_date_time.setHours(value.hour, value.minute)
          }).layoutWeight(1).height(70)
        }.width("100%")
      }.layoutWeight(0.2)
      Scroll() {

        Column() {
          // 新闻组
          Column() {
            Row() {
              this.BuildLabel("News group：")
              Select(this.groups)
                .value(this.select_group)
                .font({ size: 16, weight: 500 })
                .fontColor('#182431')
                .selectedOptionFont({ size: 16, weight: 400 })
                .optionFont({ size: 16, weight: 400 })
                .onSelect((index: number, text: string) => {
                  this.select_group = text
                })
            }.width("100%")

            Flex({ wrap: FlexWrap.Wrap }) {
              this.BuildButton("list()-Load all news group", this.safeCallFunc(async () => {
                const res: ESObject = await this.client.list()
                this.groups = res.newsgroups.map((v: ESObject) => ({ value: v.name } as Value))
                return res;
              }))
              this.BuildButton("group(group)-Retrieve and select articles", this.safeCallFunc(async () => {
                return await this.client.group(this.select_group)

              }),Color.Orange)

              this.BuildButton("newgroups(isoDateTime)-Get the news group for the time (later)", this.safeCallFunc(async () => {
                return await this.client.newgroups(this.selected_date_time)
              }),Color.Orange)

              this.BuildButton("newnews(wildmat,isoDateTime)-Retrieve articles from the news group and time (later)", this.safeCallFunc(async () => {
                return await this.client.newnews(this.select_group, this.selected_date_time)
              }),Color.Orange)

              this.BuildButton("listActive(wildmat?)", this.safeCallFunc(async () => {
                return await this.client.listActive(this.select_group)
              }))
















              this.BuildButton("listNewsgroups(wildmat?)", this.safeCallFunc(async () => {
                return await this.client.listNewsgroups(this.select_group)
              }))

              this.BuildButton("listOverviewFmt()", this.safeCallFunc(async () => {
                return await this.client.listOverviewFmt()
              }),Color.Green)

              this.BuildButton("hdr(field, messageIdOrRange)", this.safeCallFunc(async () => {
                return await this.client.hdr("field", this.select_article)
              }),Color.Orange)


              this.BuildButton("listHeaders(argument?: 'MSGID' | 'RANGE')-*", this.safeCallFunc(async () => {
                return await this.client.listHeaders('MSGID')
              }),Color.Red)

              this.BuildButton("last()-*", this.safeCallFunc(async () => {
                return await this.client.last()

              }),Color.Red)
              this.BuildButton("next()-*", this.safeCallFunc(async () => {
                return await this.client.next()
              }),Color.Red)

              this.BuildButton("listActiveTimes(wildmat?)-*", this.safeCallFunc(async () => {
                return await this.client.listActiveTimes(this.select_group)
              }),Color.Red)

              this.BuildButton("listDistribPats(wildmat?)-*", this.safeCallFunc(async () => {
                return await this.client.listDistribPats(this.select_group)
              }),Color.Red)
            }.margin({ top: 10 }).width("100%")

          }

          // 文章号
          Column() {
            Row() {
              this.BuildLabel("Article：")
              Select(this.articles)
                .value(this.select_article)
                .font({ size: 16, weight: 500 })
                .fontColor('#182431')
                .selectedOptionFont({ size: 16, weight: 400 })
                .optionFont({ size: 16, weight: 400 })
                .onSelect((index: number, text: string) => {
                  this.select_article = text
                })
            }.width("100%")

            Flex({ wrap: FlexWrap.Wrap }) {


              this.BuildButton("listGroup(group)-Load all articles", this.safeCallFunc(async () => {
                const res: ESObject = await this.client.listGroup(this.select_group)
                this.articles = res.group.articleNumbers.map((v: ESObject) => ({ value: v + "" } as Value));
                return res
              }),Color.Orange)


              this.BuildButton("article(messageId)-Article Details", this.safeCallFunc(async () => {
                return await this.client.article(this.select_article);
              }),Color.Orange)

              this.BuildButton("head(messageId)-头", this.safeCallFunc(async () => {
                return await this.client.head(this.select_article);
              }),Color.Orange)

              this.BuildButton("body(messageId)-Main body", this.safeCallFunc(async () => {
                return await this.client.body(this.select_article);
              }),Color.Orange)

              this.BuildButton("stat(messageId)-Is or not exist", this.safeCallFunc(async () => {
                return await this.client.stat(this.select_article);
              }),Color.Orange)
              this.BuildButton("over(messageId?)", this.safeCallFunc(async () => {
                return await this.client.over(this.select_article);
              }),Color.Orange)
              this.BuildButton("post()-*", this.safeCallFunc(async () => {
                return await this.client.post();
              }),Color.Red)

              this.BuildButton("ihave(messageId)-*", this.safeCallFunc(async () => {
                return await this.client.ihave(this.select_article);
              }),Color.Red)



              this.BuildButton("check(messageId)-*", this.safeCallFunc(async () => {
                return await this.client.check(this.select_article);
              }),Color.Red)





            }.margin({ top: 10 }).width("100%")
          }

          // 会话相关命令

          Column() {
            Text("Session related commands：").fontSize(14).width("100%")
            Flex({ wrap: FlexWrap.Wrap }) {
              this.BuildButton("help()-Help Instructions", this.safeCallFunc(async () => {
                return await this.client.help();
              }))
              this.BuildButton("capabilities()-capability list", this.safeCallFunc(async () => {
                const res: ESObject = await this.client.capabilities(); // 客户端获取服务端提供的能力列表
                return res;
              }))
              this.BuildButton("date()-Get server time", this.safeCallFunc(async () => {
                return await this.client.date();
              }))
              this.BuildButton("modeReader()-Mode switching", this.safeCallFunc(async () => {
                return await this.client.modeReader(); //触发服务端进行模式切换
              }))
              this.BuildButton("quit()-Terminate session", this.safeCallFunc(async () => {
                return await this.client.quit(); //触发服务端进行模式切换
              }))

              this.BuildButton("modeStream()-*", this.safeCallFunc(async () => {
                return await this.client.modeStream(); //触发服务端进行模式切换
              }),Color.Red)


              this.BuildButton("slave()-*", this.safeCallFunc(async () => {
                return await this.client.slave();
              }),Color.Red)

              this.BuildButton("compressDeflate()-*", this.safeCallFunc(async () => {
                return await this.client.compressDeflate();
              }),Color.Red)

            }.width("100%").margin({ top: 10 })

          }

        }
        .padding({ top: 20 })
      }
      .width('100%')
      .layoutWeight(2)
    }




  }

  log(info: string) {
    console.log(`${tag} ${info}`)
  }

  safeCallFunc(func: Function) {
    if (typeof func != "function") return;
    return async () => {
      try {
        const result: ESObject = await func();
        this.log(JSON.stringify(result));
        this.showMessage(`success, result：${JSON.stringify(result) || "null"}`)
      } catch (err) {
        this.showMessage(`failed, error message：${err.comment}`)
      }
    }

  }

  showMessage(message: string) {
    promptAction.showToast({ message })
  }
}