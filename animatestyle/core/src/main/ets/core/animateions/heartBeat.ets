import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { ScaleState } from '../states/ScaleState';
import { AnimateValue } from '../AnimateValue';

export type HeartBeatState = ScaleState
export const createHeartBeatAnimator = defineKeyframeAnimator<HeartBeatState>((userState, options) => {
  const value: AnimateValue<ScaleState> = userState || AnimateValue.get(new ScaleState())

  const duration = options?.duration || DURATION
  const setScale = (v: number) => {
    value.states.setScale(v)
  }
  const curve = Curve.EaseInOut
  const keyframe = new Keyframe();
  keyframe.froms([28, 70], {
    event: () => {
      setScale(1)
    }
  })
  keyframe.on([14, 42], {
    event: () => {
      setScale(1.3)
    }
  })
  return {
    value: value,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve ?? curve)
  }
})