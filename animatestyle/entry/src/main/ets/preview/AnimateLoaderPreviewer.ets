import { SmartDialog } from 'ohos_smart_dialog';
import { FadeLoaderView, StepLoading } from '@animate/loader';

@ComponentV2
export struct AnimateLoaderPreviewer {
  navPathStack: NavPathStack = new NavPathStack();
  @Local name: string = "Fade";
  private names = ["Fade", "Indicator","StepLoader"]

  @Builder
  dialog(name: string) {
    if (name === 'Fade') {
      FadeLoaderView();
    } else if (name === 'Indicator') {
      // IndicatorLoaderView()
    }else if(name === 'StepLoader'){
      StepLoading()
    }
  }

  @Builder
  navRouterTitle(name: string, onclick: () => void) {
    Text(name)
      .width("100%")
      .height(60)
      .backgroundColor(Color.White)
      .borderRadius(24)
      .fontSize(20)
      .fontWeight(500)
      .textAlign(TextAlign.Center)
      .onClick(e => onclick())
  }

  build() {
    Column() {
      Text("Animate Loading")
        .fontSize(24)
        .fontWeight(900)
        .textAlign(TextAlign.Center)
        .height(60)
      NavDestination() {
        Stack(){
          List({ space: 10 }) {
            Repeat(this.names).each((item) => {
              ListItem() {
                this.navRouterTitle(item.item, () => {
                  setTimeout(() => {
                    SmartDialog.show({
                      builder: this.dialog,
                      builderArgs: item.item
                    })
                  })
                })
              }
            })
          }
          .width("100%")
          .height("100%")
          .contentEndOffset(40)
          // .scrollBar(BarState.Off)
        }.width("90%")
      }
      .hideTitleBar(true)
      .backgroundColor('#F1F3F5')
    }
    .backgroundColor('#F1F3F5')
  }
}