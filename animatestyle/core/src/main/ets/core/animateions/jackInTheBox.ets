import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { TranslateState } from '../states/TranslateState';
import { AnimateValue } from '../AnimateValue';
import { RotateState } from '../states/RotateState';
import BezierCurve from '../common/BezierCurve';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';


export const createJackInTheBoxAnimator =
  defineKeyframeAnimator((userState?: AnimateValue<[OpacityState, ScaleState, RotateState]>, options?: AnimatorOptions) => {

    const duration = (options?.duration || DURATION)
    const state = userState || new AnimateValue([
      new OpacityState(), new ScaleState(), new RotateState()
    ])
    const setRotate = (v: number) => {
      state.states[2].setRotateZ(v)
    }
    const setOpacity = (v: number) => {
      state.states[0].setOpacity(v)
    }
    const setScale = (v: number) => {
      state.states[1].setScale(v)
      state.states[1].setScaleCenter("50%", "100%")
    }

    const k2 = new Keyframe();
    k2.from({
      event: () => {
        setOpacity(0)
      }
    })
    k2.to({
      event: () => {
        setOpacity(1)
      }
    })


    const keyframe = new Keyframe();
    keyframe.from({
      event: () => {
        setRotate(30)
        setScale(0.1)
        state.states[1].setScaleCenter("50%", "100%")
        state.states[2].setRotateCenter("50%", "100%")
      }
    })
    keyframe.on(50, {
      event: () => {
        setRotate(-10)
        setScale(1)
      }
    })
    keyframe.on(70, {
      event: () => {
        setRotate(3)
      }
    })
    keyframe.to({
      event: () => {
        setRotate(1)
      }
    })

    return {
      value: state,
      animateStates: [
        keyframe.makeKeyframeAnimateStates(duration,options?.curve),
        k2.makeKeyframeAnimateStates(duration,options?.curve)
      ]
    }
  })