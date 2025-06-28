import { Animator, AnimatorOptions, AnimatorState, createHingeAnimator, createJackInTheBoxAnimator, createRollInAnimator, createRollOutAnimator, createRotateOutAnimator, createRotateOutDownLeftAnimator, createRotateOutDownRightAnimator, createRotateOutUpLeftAnimator, createRotateOutUpRightAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct SpecialView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("Hinge", createHingeAnimator(undefined, this.options))
    this.animates.set("JackInTheBox", createJackInTheBoxAnimator(undefined, this.options))
    this.animates.set("RollIn", createRollInAnimator(undefined, this.options))
    this.animates.set("RollOut", createRollOutAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}