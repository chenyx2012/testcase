// import { AnimateView, Animator, AnimatorState } from '@animate/style';
//
// @ComponentV2
// export struct IndicatorLoaderView {
//   @Param text: string = "Loading..."
//   @Param fontSize: number = 30
//   @Param indicatorWidth: number | string = 200
//   @Param indicatorHeight: number = 3
//   @Param indicatorColor: ResourceColor = Color.Black
//   @BuilderParam loadingContent: () => void = this.defaultLoadingContent
//
//   @Builder
//   defaultLoadingContent() {
//     Text(this.text)
//       .fontWeight(800)
//       .fontSize(this.fontSize)
//   }
//
//   private ctx?: UIContext;
//
//   @Computed
//   private get boxHeight(): number {
//     return this.fontSize * 1.5
//   }
//
//   runAnimate() {
//   }
//
//   aboutToAppear(): void {
//     this.ctx = this.getUIContext()
//
//   }
//
//   build() {
//     Column() {
//       this.loadingContent()
//       Blank()
//       Column() {
//         AnimateView({ animator: this.animator }) {
//           Column()
//             .height(this.indicatorHeight)
//             .backgroundColor(this.indicatorColor)
//             .width("100%")
//         }
//       }
//       .width("100%")
//       .translate({ x: "-50%" })
//     }
//     .height(this.boxHeight)
//     .width(this.indicatorWidth)
//   }
// }