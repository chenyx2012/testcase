import { Animator, AnimatorOptions, AnimatorState, createBackOutDownAnimator, createBackOutLeftAnimator, createBackOutRightAnimator, createBackOutUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct BackExitsView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("BackOutDown", createBackOutDownAnimator(undefined, this.options))
    this.animates.set("BackOutLeft", createBackOutLeftAnimator(undefined, this.options))
    this.animates.set("BackOutRight", createBackOutRightAnimator(undefined, this.options))
    this.animates.set("BackOutUp", createBackOutUpAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}