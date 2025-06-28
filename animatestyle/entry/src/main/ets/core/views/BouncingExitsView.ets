import { Animator, AnimatorOptions, AnimatorState, createBounceOutAnimator, createBounceOutDownAnimator, createBounceOutLeftAnimator, createBounceOutRightAnimator, createBounceOutUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct BouncingExitsView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("BounceOut", createBounceOutAnimator(undefined, this.options))
    this.animates.set("BounceOutDown", createBounceOutDownAnimator(undefined, this.options))
    this.animates.set("BounceOutLeft", createBounceOutLeftAnimator(undefined, this.options))
    this.animates.set("BounceOutRight", createBounceOutRightAnimator(undefined, this.options))
    this.animates.set("BounceOutUp", createBounceOutUpAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}