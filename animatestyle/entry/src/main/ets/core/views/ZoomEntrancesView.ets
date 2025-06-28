import { Animator, AnimatorOptions, AnimatorState, createZoomInAnimator, createZoomInDownAnimator, createZoomInLeftAnimator, createZoomInRightAnimator, createZoomInUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct ZoomEntrancesView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("ZoomIn", createZoomInAnimator(undefined, this.options))
    this.animates.set("ZoomInDown", createZoomInDownAnimator(undefined, this.options))
    this.animates.set("ZoomInLeft", createZoomInLeftAnimator(undefined, this.options))
    this.animates.set("ZoomInRight", createZoomInRightAnimator(undefined, this.options))
    this.animates.set("ZoomInUp", createZoomInUpAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}