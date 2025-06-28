import { SwipeRefresher } from '@kit.ArkUI'

@Component
export struct Loading{
  build() {
    Column(){
      Column(){
        SwipeRefresher({isLoading: true, content: "加载中"})
      }.width("100")
      .height("100")
      .borderRadius(15)
      .justifyContent(FlexAlign.Center)
      .backgroundColor("#d8ffffff")
    }.width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}