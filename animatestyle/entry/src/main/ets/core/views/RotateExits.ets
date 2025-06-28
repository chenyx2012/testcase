import { Animator, AnimatorOptions, AnimatorState, createRotateOutAnimator, createRotateOutDownLeftAnimator, createRotateOutDownRightAnimator, createRotateOutUpLeftAnimator, createRotateOutUpRightAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct RotateExitsView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("RotateOut", createRotateOutAnimator(undefined, this.options))
    this.animates.set("RotateOutDownLeft", createRotateOutDownLeftAnimator(undefined, this.options))
    this.animates.set("RotateOutDownRight", createRotateOutDownRightAnimator(undefined, this.options))
    this.animates.set("RotateOutUpLeft", createRotateOutUpLeftAnimator(undefined, this.options))
    this.animates.set("RotateOutUpRight", createRotateOutUpRightAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}