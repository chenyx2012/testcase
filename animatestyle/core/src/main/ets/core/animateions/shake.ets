import { defineKeyframeAnimator } from '../Index';
import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { TranslateState } from '../states/TranslateState';

export type ShakeState = TranslateState;

export const createShakeState = (): AnimateValue<ShakeState> => {
  return AnimateValue.get(new TranslateState())
}


export const createShakeXAnimator = defineKeyframeAnimator<ShakeState>((userState, options) => {
  const state: AnimateValue<ShakeState> = userState || createShakeState()

  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.fromTo({
    event: () => {
      state.states.setTranslate(0)
    }
  })
  keyframe.on([10, 30, 50, 70, 90], {
    event: () => {
      state.states.setTranslateX(-10)
    }
  })

  keyframe.on([20, 40, 60, 80], {
    event: () => {
      state.states.setTranslateX(10)
    }
  })

  return {
    value: state,
    keyframe
  }
})


export const createShakeYAnimator = defineKeyframeAnimator<ShakeState>((userState, options) => {
  const state: AnimateValue<ShakeState> = userState || createShakeState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.fromTo({
    event: () => {
      state.states.setTranslate(0)
    }
  })
  keyframe.on([10, 30, 50, 70, 90], {
    event: () => {
      state.states.setTranslateY(-10)
    }
  })

  keyframe.on([20, 40, 60, 80], {
    event: () => {
      state.states.setTranslateY(10)
    }
  })

  return {
    value: state,
    keyframe
  }
})