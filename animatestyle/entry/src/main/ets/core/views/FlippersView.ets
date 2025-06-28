import { Animator, AnimatorOptions, AnimatorState, createFlipAnimator, createFlipInXAnimator, createFlipInYAnimator, createFlipOutXAnimator, createFlipOutYAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';


@Preview({
  width: 1260,
  height: 2720,
  dpi: 420
})
@ComponentV2
export struct FlippersView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000,
    fill: 'none'
  }
  private animates = new HashMap<string, Animator<AnimatorState>>()

  aboutToAppear(): void {
    this.animates.set("Flip", createFlipAnimator(undefined, this.options))
    this.animates.set("FlipInX", createFlipInXAnimator(undefined, this.options))
    this.animates.set("FlipInY", createFlipInYAnimator(undefined, this.options))
    this.animates.set("FlipOutX", createFlipOutXAnimator(undefined, this.options))
    this.animates.set("FlipOutY", createFlipOutYAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}