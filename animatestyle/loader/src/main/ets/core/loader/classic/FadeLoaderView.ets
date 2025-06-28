import { AnimateView, Animator, AnimatorState, createFadeInAnimator, createFadeOutAnimator } from '@animate/style';

@ComponentV2
export struct FadeLoaderView {
  @Param text: string = "Loading..."
  @Param fontFamily: string | Resource = "";
  @Local private animator?: Animator<AnimatorState>;
  private ctx?: UIContext;
  private inAnimator = createFadeInAnimator;
  private outAnimator = createFadeOutAnimator;

  @Monitor("animator")
  runAnimate() {
    setTimeout(() => {
      if (this.ctx) {
        this.animator?.animateTo(this.ctx)
      }
    })
  }

  aboutToAppear(): void {
    const duration = 500
    this.ctx = this.getUIContext()
    const appear = this.inAnimator(undefined, {
      duration,
      onFinish: () => {
        this.animator = disappear;
      }
    })
    const disappear = this.outAnimator(undefined, {
      duration,
      onFinish: () => {
        this.animator = appear;
      }
    })
    this.animator = appear
  }

  build() {
    AnimateView({ animator: this.animator }) {
      Text(this.text)
        .fontWeight(800)
        .fontFamily(this.fontFamily)
        .fontSize(30)
    }
  }
}


/* HTML: <div class="loader"></div> */
// .loader {
//   font-weight: bold;
//   font-family: sans-serif;
//   font-size: 30px;
//   animation: l1 1s linear infinite alternate;
// }
// .loader:before {
//   content:"Loading..."
// }
// @keyframes l1 {to{opacity: 0}}