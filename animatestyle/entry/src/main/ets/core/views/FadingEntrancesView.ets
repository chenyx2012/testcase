import {
  Animator,
  AnimatorOptions,
  AnimatorState,
  createFadeInAnimator,
  createFadeInBottomLeftAnimator,
  createFadeInBottomRightAnimator,
  createFadeInDownAnimator,
  createFadeInDownBigAnimator,
  createFadeInLeftAnimator,
  createFadeInLeftBigAnimator,
  createFadeInRightAnimator,
  createFadeInRightBigAnimator,
  createFadeInTopLeftAnimator,
  createFadeInTopRightAnimator,
  createFadeInUpAnimator,
  createFadeInUpBigAnimator
}  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';


@Preview({
  width: 1260,
  height: 2720,
  dpi: 420
})
@ComponentV2
export struct FadingEntrancesView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>()

  aboutToAppear(): void {
    this.animates.set("FadeIn", createFadeInAnimator(undefined, this.options))
    this.animates.set("FadeInDown", createFadeInDownAnimator(undefined, this.options))
    this.animates.set("FadeInDownBig", createFadeInDownBigAnimator(undefined, this.options))
    this.animates.set("FadeInLeft", createFadeInLeftAnimator(undefined, this.options))
    this.animates.set("FadeInLeftBig", createFadeInLeftBigAnimator(undefined, this.options))
    this.animates.set("FadeInRight", createFadeInRightAnimator(undefined, this.options))
    this.animates.set("FadeInRightBig", createFadeInRightBigAnimator(undefined, this.options))
    this.animates.set("FadeInUp", createFadeInUpAnimator(undefined, this.options))
    this.animates.set("FadeInUpBig", createFadeInUpBigAnimator(undefined, this.options))
    this.animates.set("FadeInTopLeft", createFadeInTopLeftAnimator(undefined, this.options))
    this.animates.set("FadeInTopRight", createFadeInTopRightAnimator(undefined, this.options))
    this.animates.set("FadeInBottomLeft", createFadeInBottomLeftAnimator(undefined, this.options))
    this.animates.set("FadeInBottomRight", createFadeInBottomRightAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}