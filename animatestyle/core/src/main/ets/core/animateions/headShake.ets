import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { AnimateValue } from '../AnimateValue';
import { TranslateState } from '../states/TranslateState';
import { RotateState } from '../states/RotateState';

export type HeadShakeState = [TranslateState, RotateState]

export const createHeadShakeAnimator = defineKeyframeAnimator<HeadShakeState>((userState, options) => {
  const state: AnimateValue<HeadShakeState> = userState || new AnimateValue(
    [TranslateState.get(), RotateState.get()]
  )
  const setTranslateX = (x: number = 0) => {
    state.states[0].setTranslateX(x)
  }
  const setRotateY = (angle: number = 0) => {
    state.states[1].setRotateY(angle)
  }

  const duration = options?.duration || DURATION
  const curve = Curve.EaseInOut


  const keyframe = new Keyframe();
  keyframe.froms([50], {
    event: () => {
      setTranslateX()
      setRotateY()
    }
  })

  keyframe.on([6.5], {
    event: () => {
      setTranslateX(-6)
      setRotateY(-9)
    }
  })
  keyframe.on([18.5], {
    event: () => {
      setTranslateX(5)
      setRotateY(7)
    }
  })
  keyframe.on([31.5], {
    event: () => {
      setTranslateX(-3)
      setRotateY(-5)
    }
  })
  keyframe.on([43.5], {
    event: () => {
      setTranslateX(2)
      setRotateY(3)
    }
  })

  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve ?? curve)
  }
})