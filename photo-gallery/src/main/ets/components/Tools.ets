import { IconData } from '../interface/PicturePreviewInterface'

@Component
export struct Tools{
  @Builder private test(){}
  @Prop iconData: IconData
  @BuilderParam tools: (iconData: IconData) => void = this.test;
  build() {
    Column(){
      Row(){
        Row(){
          this.tools(this.iconData)
        }.onTouch((e)=>{
          e.stopPropagation()
        })
      }.width("100%")
      .justifyContent(FlexAlign.End)
    }.height("100%")
    .width("100%")
    .justifyContent(FlexAlign.End)
    .hitTestBehavior(HitTestMode.Transparent)
  }
}