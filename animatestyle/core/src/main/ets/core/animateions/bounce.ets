import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { TranslateState } from '../states/TranslateState';
import { ScaleState } from '../states/ScaleState';
import { AnimateValue } from '../AnimateValue';


export const createBounceAnimator =
  defineKeyframeAnimator((userState?: AnimateValue<[TranslateState, ScaleState]>, options?: AnimatorOptions) => {

    const duration = options?.duration || DURATION
    const state = userState || new AnimateValue([new TranslateState(), new ScaleState()])
    const keyframe = new Keyframe();

    const setTranslateY = (y: number) => {
      state.states[0].setTranslateY(y)
    }
    const setScaleY = (v: number) => {
      state.states[1].setScaleY(v)
    }


    keyframe.fromTos([20, 53], {
      curve: [0.215, 0.61, 0.355, 1],
      event: () => {
        setTranslateY(0)
        setScaleY(1)
      }
    })

    keyframe.on([40, 43], {
      curve: [0.755, 0.05, 0.855, 0.06],
      event: () => {
        setScaleY(1.1)
        setTranslateY(-30)
      }
    })

    keyframe.on([70], {
      curve: [0.755, 0.05, 0.855, 0.06],
      event: () => {
        setScaleY(1.05)
        setTranslateY(-15)
      }
    })

    keyframe.on([80], {
      curve: [0.215, 0.61, 0.355, 1],
      event: () => {
        setScaleY(0.95)
        setTranslateY(0)
      }
    })
    keyframe.on([90], {
      event: () => {
        setTranslateY(-4)
        setScaleY(1.02)
      }
    })

    return {
      value: state,
      keyframe
    }
  })