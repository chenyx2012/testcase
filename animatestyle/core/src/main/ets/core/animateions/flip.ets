import { AnimateValue } from '../AnimateValue';
import { AnimatorOptions } from '../Animator';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../common/defineAnimator';
import { Keyframe } from '../common/Keyframe';
import { OpacityState } from '../states/OpacityState';
import { RotateState } from '../states/RotateState';
import { ScaleState } from '../states/ScaleState';
import { TranslateState } from '../states/TranslateState';

export type FlipState = [ScaleState, TranslateState, RotateState, OpacityState];


const setScale = (state: AnimateValue<FlipState>, v: number) => {
  state.states[0].setScale(v)
}
const setTranslateZ = (state: AnimateValue<FlipState>, v: number | string) => {
  state.states[1].setTranslateZ(v)
}

const setRotateY = (state: AnimateValue<FlipState>, v: number) => {
  state.states[2].setRotateY(v)
}
const setRotateX = (state: AnimateValue<FlipState>, v: number) => {
  state.states[2].setRotateX(v)
}
const setOpacity = (state: AnimateValue<FlipState>, v: number) => {
  state.states[3].setOpacity(v)
}

const createState = (): AnimateValue<FlipState> => {
  return new AnimateValue([new ScaleState(), new TranslateState(), new RotateState(), new OpacityState()])
}

export const createFlipAnimator = defineKeyframeAnimator((userState?: AnimateValue<FlipState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()

  const keyframe = new Keyframe();
  keyframe.from({
    curve: Curve.EaseOut,
    event: () => {
      setScale(state, 1)
      setTranslateZ(state, 0)
      setRotateY(state, -360)
    }
  })

  keyframe.on(40, {
    curve: Curve.EaseOut,
    event: () => {
      setTranslateZ(state, -150)
      setRotateY(state, -190)
    }
  })

  keyframe.on(50, {
    curve: Curve.EaseIn,
    event: () => {
      setTranslateZ(state, -150)
      setRotateY(state, -170)
    }
  })

  keyframe.on(80, {
    curve: Curve.EaseIn,
    event: () => {
      setScale(state, 0.95)
      setTranslateZ(state, 0)
      setRotateY(state, 0)
    }
  })
  keyframe.to({
    curve: Curve.EaseIn,
    event: () => {
      setScale(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
});


export const createFlipInXAnimator = defineKeyframeAnimator((userState?: AnimateValue<FlipState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()


  const keyframe = new Keyframe();
  keyframe.from({
    curve: Curve.EaseIn,
    event: () => {
      setScale(state, 1)
      setRotateX(state, 90)
    }
  })

  keyframe.on(40, {
    curve: Curve.EaseIn,
    event: () => {
      setRotateX(state, -20)
    }
  })

  keyframe.on(60, {
    event: () => {
      setRotateX(state, 10)
    }
  })

  keyframe.on(80, {
    event: () => {
      setRotateX(state, -5)
    }
  })
  keyframe.to({
    event: () => {
      setRotateX(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
});


export const createFlipInYAnimator = defineKeyframeAnimator((userState?: AnimateValue<FlipState>, options?: AnimatorOptions) => {
  const duration = options?.duration || DURATION;
  const state = userState || createState()


  const keyframe = new Keyframe();
  keyframe.from({
    curve: Curve.EaseIn,
    event: () => {
      setScale(state, 1)
      setRotateY(state, 90)
    }
  })

  keyframe.on(40, {
    curve: Curve.EaseIn,
    event: () => {
      setRotateY(state, -20)
    }
  })

  keyframe.on(60, {
    event: () => {
      setRotateY(state, 10)
    }
  })

  keyframe.on(80, {
    event: () => {
      setRotateY(state, -5)
    }
  })
  keyframe.to({
    event: () => {
      setRotateY(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
});


export const createFlipOutXAnimator = defineKeyframeAnimator((userState?: AnimateValue<FlipState>, options?: AnimatorOptions) => {
  const duration = (options?.duration || DURATION) * 0.75;
  const state = userState || createState()

  const keyframe = new Keyframe();
  keyframe.from({
    curve: Curve.EaseIn,
    event: () => {
      setRotateX(state, 0)
    }
  })

  keyframe.on(30, {
    event: () => {
      setRotateX(state, -20)
      setOpacity(state, 1)
    }
  })
  keyframe.to({
    event: () => {
      setRotateX(state, 90)
      setOpacity(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
});


export const createFlipOutYAnimator = defineKeyframeAnimator((userState?: AnimateValue<FlipState>, options?: AnimatorOptions) => {
  const duration = (options?.duration || DURATION) * 0.75;
  const state = userState || createState()

  const keyframe = new Keyframe();
  keyframe.from({
    curve: Curve.EaseIn,
    event: () => {
      setRotateX(state, 0)
    }
  })

  keyframe.on(30, {
    event: () => {
      setRotateY(state, -15)
      setOpacity(state, 1)
    }
  })
  keyframe.to({
    event: () => {
      setRotateY(state, 90)
      setOpacity(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
});