import { Animator, AnimatorOptions, AnimatorState, createRotateInAnimator, createRotateInDownLeftAnimator, createRotateInDownRightAnimator, createRotateInUpLeftAnimator, createRotateInUpRightAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct RotateEntrancesView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("RotateIn", createRotateInAnimator(undefined, this.options))
    this.animates.set("RotateInDownLeft", createRotateInDownLeftAnimator(undefined, this.options))
    this.animates.set("RotateInDownRight", createRotateInDownRightAnimator(undefined, this.options))
    this.animates.set("RotateInUpLeft", createRotateInUpLeftAnimator(undefined, this.options))
    this.animates.set("RotateInUpRight", createRotateInUpRightAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}