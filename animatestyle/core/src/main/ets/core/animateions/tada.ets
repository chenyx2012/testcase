import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { RotateState } from '../states/RotateState';
import { ScaleState } from '../states/ScaleState';

export type TadaState = [RotateState, ScaleState];

export const createTadaAnimator = defineKeyframeAnimator<TadaState>((userState, options) => {
  const state: AnimateValue<TadaState> = userState || AnimateValue.gets([new RotateState(), new ScaleState()])
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  const setScale = (v: number) => {
    state.states[1].setScale(v)
  }
  const setRotate = (v: number) => {
    state.states[0].setRotateZ(v)
  }

  keyframe.fromTo({
    event: () => {
      setScale(1)
      setRotate(0)
    }
  })
  keyframe.on([10, 20], {
    event: () => {
      setScale(0.9)
      setRotate(-3)
    }
  })
  keyframe.on([30, 50, 70, 90], {
    event: () => {
      setScale(1.1)
      setRotate(3)
    }
  })
  keyframe.on([40, 60, 80], {
    event: () => {
      setScale(1.1)
      setRotate(-3)
    }
  })

  return {
    value: state,
    keyframe
  }
})