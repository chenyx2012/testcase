import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { RotateState } from '../states/RotateState';
import { TranslateState } from '../states/TranslateState';


export type WobbleState = [RotateState, TranslateState]

export const createWobbleAnimator = defineKeyframeAnimator<WobbleState>((userState, options) => {
  const state: AnimateValue<WobbleState> = userState || AnimateValue.gets([new RotateState(), new TranslateState()])

  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  const setRotate = (angle: number) => {
    state.states[0].setRotateZ(angle)
  }
  const setTranslateX = (v: string) => {
    state.states[1].setTranslate3d(v, 0, 0)
  }
  keyframe.fromTo({
    event: () => {
      setTranslateX("0%")
      setRotate(0)
    }
  })
  keyframe.on(15, {
    event: () => {
      setTranslateX("-25%")
      setRotate(-5)
    }
  })
  keyframe.on(30, {
    event: () => {
      setTranslateX("20%")
      setRotate(3)
    }
  })
  keyframe.on(45, {
    event: () => {
      setTranslateX("-15%")
      setRotate(-3)
    }
  })
  keyframe.on(60, {
    event: () => {
      setTranslateX("10%")
      setRotate(2)
    }
  })
  keyframe.on(75, {
    event: () => {
      setTranslateX("-5%")
      setRotate(-1)
    }
  })
  return {
    value: state,
    keyframe
  }
})