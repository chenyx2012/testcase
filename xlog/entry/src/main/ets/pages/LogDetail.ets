import router from '@ohos.router'
import fs from '@ohos.file.fs';
import { MyNavBar } from './MyNavBar'
@Entry
@Component
struct LogDetail {
  private logFilePath: string = (router.getParams() as Record<string, string | number>).logFilePath as string;
  // private logFilePath: string = router.getParams()['logFilePath'];
  @State logStr: string = ""

  aboutToAppear() {
    this.logStr = fs.readTextSync(this.logFilePath)
  }

  build() {
    Column() {
      MyNavBar({ title: '日志详情' })
      Scroll() {
        Text(this.logStr).fontSize(14).width('100%').padding(8)
      }.layoutWeight(1).align(Alignment.Top)
    }.width('100%').height('100%')
  }
}