import { AnimateStyleModifier, AnimateView, Animator, AnimatorState, EmptyBuilder, FullModifier, ModifierState } from '@animate/style';
import { HashMap } from '@kit.ArkTS';
import { componentUtils, inspector } from '@kit.ArkUI';
import { cert } from '@kit.DeviceCertificateKit';


@Preview({
  width: 1260,
  height: 2720,
  dpi: 420
})
@ComponentV2
export struct Animates {
  @Local animator: Animator<AnimatorState> | undefined = undefined;
  private ctx?: UIContext;
  @Require @Param private animates: HashMap<string, Animator<AnimatorState>>;
  @Local w: number | string = ""

  @Computed
  get animateNames(): string[] {
    return Array.from(this.animates.keys()).sort((a, b) => a.localeCompare(b))
  }

  aboutToAppear(): void {
    this.ctx = this.getUIContext()
    if (this.animateNames.length > 0) {
      this.changeAnimate(this.animateNames[0])
    }
  }

  changeAnimate(name: string) {
    const animator = this.animates.get(name)
    if (animator) {
      this.animator = animator;
      setTimeout(() => {
        if (this.ctx) {
          this.animator?.animateTo(this.ctx)
        }
      }, 100)
    }
  }

  build() {
    if (this.animator) {
      Column() {
        // Stack() {
        //   Text("Animate for HarmonyOS")
        //     .height(60)
        //     .width(250)
        //     .fontSize(25)
        //     .fontWeight(900)
        //     .textAlign(TextAlign.Center)
        //     .backgroundColor(Color.Green)
        // }
        // .backgroundColor(Color.Red)
        // .border({
        //   width: 2,
        //   color: Color.Red
        // })
        // .width(this.w)
        // .animation({
        //   duration: 2000
        // })
        // .clip(true)
        // Button("Click")
        //   .onClick(e => {
        //     animateTo({}, () => {
        //       this.w = this.w == 300 ? 0 : 300
        //     })
        //   })

        Row() {
          AnimateView({ animator: this.animator }) {
            Text("Animate for HarmonyOS")
              .height(60)
              .fontSize(25)
              .fontWeight(900)
              .textAlign(TextAlign.Center)
              .width("100%")
          }
        }
        .width("100%")

        Blank()
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.animateNames, (name: string) => {
            Button(name)
              .onClick(e => this.changeAnimate(name))
              .buttonStyle(ButtonStyleMode.TEXTUAL)
              .controlSize(ControlSize.SMALL)
          }, (name: string) => name)
        }
        .padding({
          left: 10,
          right: 10,
          top: 0,
          bottom: 50
        })
      }
      .attributeModifier(new FullModifier())
    }
  }
}