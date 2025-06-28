import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { ScaleState } from '../states/ScaleState';

export type PulseState = ScaleState

export const createPulseAnimator = defineKeyframeAnimator<PulseState>((userState, options) => {
  const state: AnimateValue<PulseState> = userState || AnimateValue.get(new ScaleState())
  const duration = options?.duration || DURATION
  const keyframe = new Keyframe();
  keyframe.fromTo({
    event: () => {
      state.states.setScale(1)
    }
  })
  keyframe.on(50, {
    event: () => {
      state.states.setScale(1.05)
    }
  })

  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve ?? Curve.EaseInOut)
  }
})