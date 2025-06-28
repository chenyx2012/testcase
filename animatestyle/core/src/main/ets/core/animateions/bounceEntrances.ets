import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import curves from '@ohos.curves';
import { TranslateState } from '../states/TranslateState';

export type BounceInState = [OpacityState, ScaleState, TranslateState];

const setTranslateX = (value: AnimateValue<BounceInState>, v: number | string) => {
  value.states[2].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<BounceInState>, v: number | string) => {
  value.states[2].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<BounceInState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setScale = (value: AnimateValue<BounceInState>, v: number) => {
  value.states[1].setScale(v)
}
const setScaleY = (value: AnimateValue<BounceInState>, v: number) => {
  value.states[1].setScaleY(v)
}
const setScaleX = (value: AnimateValue<BounceInState>, v: number) => {
  value.states[1].setScaleX(v)
}


const createBounceInState = (): AnimateValue<BounceInState> => {
  return AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
}

export const createBounceInAnimator = defineKeyframeAnimator<BounceInState>((userState, options) => {
  const state: AnimateValue<BounceInState> = userState || createBounceInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setScale(state, 0.3)
    }
  })
  keyframe.on(20, {
    event: () => {
      setOpacity(state, 0.5)
      setScale(state, 1.1)
    }
  })
  keyframe.on(40, {
    event: () => {
      setOpacity(state, 0.7)
      setScale(state, 0.9)
    }
  })
  keyframe.on(60, {
    event: () => {
      setOpacity(state, 1)
      setScale(state, 1.03)
    }
  })
  keyframe.on(80, {
    event: () => {
      setScale(state, 0.97)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve ??[0.215, 0.61, 0.355, 1])
  }
})


export const createBounceInDownAnimator = defineKeyframeAnimator<BounceInState>((userState, options) => {
  const state: AnimateValue<BounceInState> = userState || createBounceInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setTranslateY(state, "-1440lpx")
      setScaleY(state, 3)
    }
  })
  keyframe.on(60, {
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, "25lpx")
      setScaleY(state, 0.9)
    }
  })
  keyframe.on(75, {
    event: () => {
      setTranslateY(state, "-10lpx")
      setScaleY(state, 0.95)
    }
  })
  keyframe.on(90, {
    event: () => {
      setTranslateY(state, "5lpx")
      setScaleY(state, 0.985)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve??[0.215, 0.61, 0.355, 1])
  }
})


export const createBounceInLeftAnimator = defineKeyframeAnimator<BounceInState>((userState, options) => {
  const state: AnimateValue<BounceInState> = userState || createBounceInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setTranslateX(state, "-720lpx")
      setScaleX(state, 3)
    }
  })
  keyframe.on(60, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, "25lpx")
      setScaleX(state, 1)
    }
  })
  keyframe.on(75, {
    event: () => {
      setTranslateX(state, "-10lpx")
      setScaleX(state, 0.98)
    }
  })
  keyframe.on(90, {
    event: () => {
      setTranslateX(state, "5lpx")
      setScaleX(state, 0.995)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateX(state, 0)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration, options?.curve??[0.215, 0.61, 0.355, 1])
  }
})


export const createBounceInRightAnimator = defineKeyframeAnimator<BounceInState>((userState, options) => {
  const state: AnimateValue<BounceInState> = userState || createBounceInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setTranslateX(state, "720lpx")
      setScaleX(state, 3)
    }
  })
  keyframe.on(60, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, "-25lpx")
      setScaleX(state, 1)
    }
  })
  keyframe.on(75, {
    event: () => {
      setTranslateX(state, "10lpx")
      setScaleX(state, 0.98)
    }
  })
  keyframe.on(90, {
    event: () => {
      setTranslateX(state, "-5lpx")
      setScaleX(state, 0.995)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateX(state, 0)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration,options?.curve?? [0.215, 0.61, 0.355, 1])
  }
})


export const createBounceInUpAnimator = defineKeyframeAnimator<BounceInState>((userState, options) => {
  const state: AnimateValue<BounceInState> = userState || createBounceInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setTranslateY(state, "1440lpx")
      setScaleY(state, 3)
    }
  })
  keyframe.on(60, {
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, "-20lpx")
      setScaleY(state, 0.9)
    }
  })
  keyframe.on(75, {
    event: () => {
      setTranslateY(state, "10lpx")
      setScaleY(state, 0.95)
    }
  })
  keyframe.on(90, {
    event: () => {
      setTranslateY(state, "-5lpx")
      setScaleY(state, 0.985)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    animateStates: keyframe.makeKeyframeAnimateStates(duration,options?.curve?? [0.215, 0.61, 0.355, 1])
  }
})