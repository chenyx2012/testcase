import { AnimateView, Animator, AnimatorOptions, AnimatorState, DURATION, FullModifier } from '@animate/style';

@ComponentV2
export struct AnimateCard {
  @Require @Param name: string;
  @Require @Param animateCreator: (options?: AnimatorOptions) => Animator<AnimatorState>;
  @Param autoStart:boolean = true;
  @Param duration:number = DURATION
  private ctx?: UIContext;
  private animator?: Animator<AnimatorState>

  onDidBuild(): void {

  }

  aboutToAppear(): void {
    this.ctx = this.getUIContext()
    this.animator = this.animateCreator({
      playTimes: 1,
      duration: this.duration,
      fill: this.name.includes("Out") ? "none" : "forwards"
    })
    if (this.autoStart) {
      const start = () => {
        this.start()
      };
      setTimeout(start)
      let delay = Math.ceil(Math.random() * 5)
      setInterval(start, this.duration * (delay / 10 + 1))
    }
  }

  private start() {
    if (this.ctx) {
      this.animator?.animateTo(this.ctx)
    }
  }

  build() {
    Column() {
      Column() {
        AnimateView({ animator: this.animator }) {
          Column() {
            Text(this.name)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .attributeModifier(new FullModifier())
          }
          .width("100%")
          .aspectRatio(1)
          .backgroundColor("#46B1E3")
          .borderRadius(10)
        }
      }
      .onClick(e => {
        if (this.autoStart) {
          return;
        }
        this.start();
      })
    }
  }
}