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


export const createRollInAnimator =
  defineKeyframeAnimator((userState?: AnimateValue<[OpacityState, TranslateState, RotateState]>, options?: AnimatorOptions) => {

    const duration = (options?.duration || DURATION)
    const state = userState || new AnimateValue([
      new OpacityState(), new TranslateState(), new RotateState()
    ])
    const setRotate = (v: number) => {
      state.states[2].setRotateZ(v)
    }
    const setOpacity = (v: number) => {
      state.states[0].setOpacity(v)
    }
    const setTranslateX = (v: number | string) => {
      state.states[1].setTranslateX(v)
    }


    const keyframe = new Keyframe();
    keyframe.from({
      event: () => {
        setOpacity(0)
        setRotate(-120)
        setTranslateX("-100%")
      }
    })
    keyframe.to({
      event: () => {
        setOpacity(1)
        setRotate(0)
        setTranslateX(0)
      }
    })

    return {
      value: state,
      animateStates: [
        keyframe.makeKeyframeAnimateStates(duration,options?.curve)
      ]
    }
  })


export const createRollOutAnimator = defineKeyframeAnimator((userState?: AnimateValue<[OpacityState, TranslateState, RotateState]>, options?: AnimatorOptions) => {

  const duration = (options?.duration || DURATION)
  const state = userState || new AnimateValue([
    new OpacityState(), new TranslateState(), new RotateState()
  ])
  const setRotate = (v: number) => {
    state.states[2].setRotateZ(v)
  }
  const setOpacity = (v: number) => {
    state.states[0].setOpacity(v)
  }
  const setTranslateX = (v: number | string) => {
    state.states[1].setTranslateX(v)
  }


  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(1)
      setRotate(0)
      setTranslateX(0)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(0)
      setRotate(120)
      setTranslateX("100%")
    }
  })

  return {
    value: state,
    animateStates: [
      keyframe.makeKeyframeAnimateStates(duration,options?.curve)
    ]
  }
})


