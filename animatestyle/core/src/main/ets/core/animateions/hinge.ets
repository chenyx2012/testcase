import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { TranslateState } from '../states/TranslateState';
import { AnimateValue } from '../AnimateValue';
import { RotateState } from '../states/RotateState';
import BezierCurve from '../common/BezierCurve';


export const createHingeAnimator =
  defineKeyframeAnimator((userState?: AnimateValue<[RotateState, TranslateState]>, options?: AnimatorOptions) => {

    const duration = (options?.duration || DURATION) * 2
    const state = userState || new AnimateValue([
      new RotateState(), new TranslateState()
    ])
    const keyframe = new Keyframe();
    keyframe.from({
      event: () => {
        state.states[0].setRotateCenter(0, 0)
      }
    })
    keyframe.on([20, 60], {
      event: () => {
        state.states[0].setRotateZ(80)
      }
    })
    keyframe.on([40, 80], {
      event: () => {
        state.states[0].setRotateZ(60)
      }
    })
    keyframe.to({
      event: () => {
        state.states[1].setTranslateY(700)
      }
    })

    return {
      value: state,
      animateStates: [
        keyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseInOut),
      ]
    }
  })