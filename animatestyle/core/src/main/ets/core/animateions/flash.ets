import { AnimateValue } from '../AnimateValue';
import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { OpacityState } from '../states/OpacityState';

export const createFlashAnimator = defineKeyframeAnimator((userState?: AnimateValue<OpacityState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || new AnimateValue(new OpacityState())
  const keyframe = new Keyframe();
  keyframe.fromTos(50, {
    event: () => {
      state.states.setOpacity(1)
    }
  })
  keyframe.on([25, 75], {
    event: () => {
      state.states.setOpacity(0)
    }
  })
  return {
    value: state,
    keyframe
  }
});