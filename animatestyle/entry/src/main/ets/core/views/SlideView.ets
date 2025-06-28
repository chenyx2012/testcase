import { Animator, AnimatorOptions, AnimatorState, createSlideInDownAnimator, createSlideInLeftAnimator, createSlideInRightAnimator, createSlideInUpAnimator, createSlideOutDownAnimator, createSlideOutLeftAnimator, createSlideOutRightAnimator, createSlideOutUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct SlidingView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("SlideInDown", createSlideInDownAnimator(undefined, this.options))
    this.animates.set("SlideInLeft", createSlideInLeftAnimator(undefined, this.options))
    this.animates.set("SlideInRight", createSlideInRightAnimator(undefined, this.options))
    this.animates.set("SlideInUp", createSlideInUpAnimator(undefined, this.options))
    this.animates.set("SlideOutDown", createSlideOutDownAnimator(undefined, this.options))
    this.animates.set("SlideOutLeft", createSlideOutLeftAnimator(undefined, this.options))
    this.animates.set("SlideOutRight", createSlideOutRightAnimator(undefined, this.options))
    this.animates.set("SlideOutUp", createSlideOutUpAnimator(undefined, this.options))
  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}