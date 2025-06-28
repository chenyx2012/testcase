import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { RotateState } from '../states/RotateState';

export type SwingState = RotateState;


export const createSwingAnimator = defineKeyframeAnimator<SwingState>((userState, options) => {
  const state: AnimateValue<SwingState> = userState || AnimateValue.get(new RotateState())
  const duration = options?.duration || DURATION;
  const setRotate = (angle: number) => {
    state.states.setRotateZ(angle)
  }
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setRotateCenter("50%", 0)
      setRotate(0)
    }
  })
  keyframe.on(20, {
    event: () => {
      setRotate(15)
    }
  })
  keyframe.on(40, {
    event: () => {
      setRotate(-10)
    }
  })
  keyframe.on(60, {
    event: () => {
      setRotate(5)
    }
  })
  keyframe.on(80, {
    event: () => {
      setRotate(-5)
    }
  })
  keyframe.to({
    event: () => {
      setRotate(0)
    }
  })
  return {
    value: state,
    keyframe
  }
})