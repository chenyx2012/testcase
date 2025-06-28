import { Animator, AnimatorOptions, AnimatorState, createZoomOutAnimator, createZoomOutDownAnimator, createZoomOutLeftAnimator, createZoomOutRightAnimator, createZoomOutUpAnimator }  from '@animate/style/';
import { HashMap } from '@kit.ArkTS';
import { Animates } from '../../components/Animates';

@ComponentV2
export struct ZoomExitsView {
  options: AnimatorOptions = {
    playTimes: 1,
    duration: 1000
  }
  private animates = new HashMap<string, Animator<AnimatorState>>();

  aboutToAppear(): void {
    this.animates.set("ZoomOut", createZoomOutAnimator(undefined, this.options))
    this.animates.set("ZoomOutDown", createZoomOutDownAnimator(undefined, this.options))
    this.animates.set("ZoomOutLeft", createZoomOutLeftAnimator(undefined, this.options))
    this.animates.set("ZoomOutRight", createZoomOutRightAnimator(undefined, this.options))
    this.animates.set("ZoomOutUp", createZoomOutUpAnimator(undefined, this.options))

  }

  build() {
    Animates({
      animates: this.animates
    })
  }
}