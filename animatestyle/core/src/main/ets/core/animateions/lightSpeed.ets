import { AnimateValue } from '../AnimateValue';
import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import BezierCurve from '../common/BezierCurve';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { TransformState } from '../states/TransformState';
import { OpacityState } from '../states/OpacityState';
import { TranslateState } from '../states/TranslateState';

export type LightSpeedState = [TranslateState, TransformState, OpacityState];


const setTranslateX = (state: AnimateValue<LightSpeedState>, v: number | string) => {
  state.states[0].setTranslateX(v)
}
const setSkewX = (state: AnimateValue<LightSpeedState>, v: number) => {
  state.states[1].setMatrixSkewX(v)
}
const setOpacity = (state: AnimateValue<LightSpeedState>, v: number) => {
  state.states[2].setOpacity(v)
}

const createState = (): AnimateValue<LightSpeedState> => {
  return new AnimateValue([new TranslateState(), new TransformState(), new OpacityState()])
}


export const createLightSpeedInRightAnimator = defineKeyframeAnimator((userState?: AnimateValue<LightSpeedState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()
  const translateKeyframe = new Keyframe();
  translateKeyframe.from({
    event: () => {
      setTranslateX(state, "100%")
    }
  })
  translateKeyframe.to({
    event: () => {
      setTranslateX(state, 0)
    }
  })

  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setSkewX(state, -0.3)
    }
  })

  keyframe.on(60, {
    event: () => {
      setSkewX(state, 0.2);
    }
  })

  keyframe.on(80, {
    event: () => {
      setSkewX(state, -0.05)
    }
  })
  keyframe.to({
    event: () => {
      setSkewX(state, 0)
    }
  })
  return {
    value: state,
    animateStates: [
      keyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseOut),
      translateKeyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseOut)
    ]
  }
});


export const createLightSpeedInLeftAnimator = defineKeyframeAnimator((userState?: AnimateValue<LightSpeedState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()
  const translateKeyframe = new Keyframe();
  translateKeyframe.from({
    event: () => {
      setTranslateX(state, "-100%")
    }
  })
  translateKeyframe.to({
    event: () => {
      setTranslateX(state, 0)
    }
  })

  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setSkewX(state, 0.3)
    }
  })

  keyframe.on(60, {
    event: () => {
      setSkewX(state, -0.2);
    }
  })

  keyframe.on(80, {
    event: () => {
      setSkewX(state, 0.05)
    }
  })
  keyframe.to({
    event: () => {
      setSkewX(state, 0)
    }
  })
  return {
    value: state,
    animateStates: [
      keyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseOut),
      translateKeyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseOut)
    ]
  }
});


export const createLightSpeedOutLeftAnimator = defineKeyframeAnimator((userState?: AnimateValue<LightSpeedState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setSkewX(state, 0)
      setOpacity(state, 1)
      setTranslateX(state, 0)
    }
  })
  keyframe.to({
    event: () => {
      setSkewX(state, -0.3)
      setOpacity(state, 0)
      setTranslateX(state, "-100%")
    }
  })
  return {
    value: state,
    animateStates: [
      keyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseIn)
    ]
  }
});

export const createLightSpeedOutRightAnimator = defineKeyframeAnimator((userState?: AnimateValue<LightSpeedState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setSkewX(state, 0)
      setOpacity(state, 1)
      setTranslateX(state, 0)
    }
  })
  keyframe.to({
    event: () => {
      setSkewX(state, 0.3)
      setOpacity(state, 0)
      setTranslateX(state, "100%")
    }
  })
  return {
    value: state,
    animateStates: [
      keyframe.makeKeyframeAnimateStates(duration, options?.curve ??  BezierCurve.EaseIn)
    ]
  }
});