import { AnimateValue, AnimateView, Animator, AnimatorOptions, AnimatorState, createZoomInDownAnimator, OpacityState, ScaleState, TranslateState, ZoomInState }  from '@animate/style/';

@Entry
@Component
struct StateV1 {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      ZoomInDownComponent()
    }
    .height('100%')
    .width('100%')
  }
}


@ComponentV2
struct ZoomInDownComponent {
  @Local options: AnimatorOptions = {};
  animator?: Animator<AnimatorState>;
  ctx?: UIContext;

  aboutToAppear(): void {
    this.ctx = this.getUIContext();
    const zoomInState: AnimateValue<ZoomInState> = AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
    this.animator = createZoomInDownAnimator(zoomInState, this.options);
  }

  build() {
    Flex({justifyContent:FlexAlign.Center,alignItems: ItemAlign.Center}){
      if (this.animator) {
        // AnimateView({ animator: this.animator }) {
        //   Text("Animator for HarmonyOS")
        //     .fontSize(20)
        //     .fontWeight(900)
        //     .onClick(e => {
        //       if (!this.ctx) {
        //         return
        //       }
        //       this.animator?.animateTo(this.ctx)
        //     })
        // }
      } else {
        Text("没有Animator")
      }
    }
    .width("100%")
    .height("100%")
  }
}