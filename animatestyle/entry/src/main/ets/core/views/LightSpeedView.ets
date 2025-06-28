import { Animator, AnimatorOptions, AnimatorState, createFlipAnimator, createFlipInXAnimator, createFlipInYAnimator, createFlipOutXAnimator, createFlipOutYAnimator, createLightSpeedInLeftAnimator, createLightSpeedInRightAnimator, createLightSpeedOutLeftAnimator, createLightSpeedOutRightAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';


@Preview({
  width: 1260,
  height: 2720,
  dpi: 420
})
@ComponentV2
export struct LightSpeedView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 900,
  }
  private animates = new HashMap<string, Animator<AnimatorState>>()

  aboutToAppear(): void {
    this.animates.set("LightSpeedInRight", createLightSpeedInRightAnimator(undefined, this.options))
    this.animates.set("LightSpeedInLeft", createLightSpeedInLeftAnimator(undefined, this.options))
    this.animates.set("LightSpeedOutRight", createLightSpeedOutRightAnimator(undefined, this.options))
    this.animates.set("LightSpeedOutLeft", createLightSpeedOutLeftAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}