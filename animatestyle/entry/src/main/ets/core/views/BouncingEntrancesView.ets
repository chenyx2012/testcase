import { Animator, AnimatorOptions, AnimatorState, createBounceInAnimator, createBounceInDownAnimator, createBounceInLeftAnimator, createBounceInRightAnimator, createBounceInUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct BouncingEntrancesView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("BounceIn", createBounceInAnimator(undefined, this.options))
    this.animates.set("BounceInDown", createBounceInDownAnimator(undefined, this.options))
    this.animates.set("BounceInLeft", createBounceInLeftAnimator(undefined, this.options))
    this.animates.set("BounceInRight", createBounceInRightAnimator(undefined, this.options))
    this.animates.set("BounceInUp", createBounceInUpAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}