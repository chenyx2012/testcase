import { Animator, AnimatorOptions, AnimatorState, createBackInDownAnimator, createBackInLeftAnimator, createBackInRightAnimator, createBackInUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct BackEntrancesView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("BackInDown", createBackInDownAnimator(undefined, this.options))
    this.animates.set("BackInLeft", createBackInLeftAnimator(undefined, this.options))
    this.animates.set("BackInRight", createBackInRightAnimator(undefined, this.options))
    this.animates.set("BackInUp", createBackInUpAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}