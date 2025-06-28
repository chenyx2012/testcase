import {
  Animator,
  AnimatorOptions,
  AnimatorState,
  createFadeOutAnimator,
  createFadeOutBottomLeftAnimator,
  createFadeOutBottomRightAnimator,
  createFadeOutDownAnimator,
  createFadeOutDownBigAnimator,
  createFadeOutLeftAnimator,
  createFadeOutLeftBigAnimator,
  createFadeOutRightAnimator,
  createFadeOutRightBigAnimator,
  createFadeOutTopLeftAnimator,
  createFadeOutTopRightAnimator,
  createFadeOutUpAnimator,
  createFadeOutUpBigAnimator
}  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';


@Preview({
  width: 1260,
  height: 2720,
  dpi: 420
})
@ComponentV2
export struct FadingExitsView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>()

  aboutToAppear(): void {
    this.animates.set("FadeOut", createFadeOutAnimator(undefined, this.options))
    this.animates.set("FadeOutDown", createFadeOutDownAnimator(undefined, this.options))
    this.animates.set("FadeOutDownBig", createFadeOutDownBigAnimator(undefined, this.options))
    this.animates.set("FadeOutLeft", createFadeOutLeftAnimator(undefined, this.options))
    this.animates.set("FadeOutLeftBig", createFadeOutLeftBigAnimator(undefined, this.options))
    this.animates.set("FadeOutRight", createFadeOutRightAnimator(undefined, this.options))
    this.animates.set("FadeOutRightBig", createFadeOutRightBigAnimator(undefined, this.options))
    this.animates.set("FadeOutUp", createFadeOutUpAnimator(undefined, this.options))
    this.animates.set("FadeOutUpBig", createFadeOutUpBigAnimator(undefined, this.options))
    this.animates.set("FadeOutTopLeft", createFadeOutTopLeftAnimator(undefined, this.options))
    this.animates.set("FadeOutTopRight", createFadeOutTopRightAnimator(undefined, this.options))
    this.animates.set("FadeOutBottomLeft", createFadeOutBottomLeftAnimator(undefined, this.options))
    this.animates.set("FadeOutBottomRight", createFadeOutBottomRightAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}