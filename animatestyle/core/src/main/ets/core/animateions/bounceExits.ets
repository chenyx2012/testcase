import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import curves from '@ohos.curves';
import { TranslateState } from '../states/TranslateState';

export type BounceOutState = [OpacityState, ScaleState, TranslateState];

const setTranslateX = (value: AnimateValue<BounceOutState>, v: number | string) => {
  value.states[2].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<BounceOutState>, v: number | string) => {
  value.states[2].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<BounceOutState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setScale = (value: AnimateValue<BounceOutState>, v: number) => {
  value.states[1].setScale(v)
}
const setScaleY = (value: AnimateValue<BounceOutState>, v: number) => {
  value.states[1].setScaleY(v)
}
const setScaleX = (value: AnimateValue<BounceOutState>, v: number) => {
  value.states[1].setScaleX(v)
}


const createBounceOutState = (): AnimateValue<BounceOutState> => {
  return AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
}

export const createBounceOutAnimator = defineKeyframeAnimator<BounceOutState>((userState, options) => {
  const state: AnimateValue<BounceOutState> = userState || createBounceOutState()
  const duration = (options?.duration || DURATION) * 0.75;
  const keyframe = new Keyframe();
  keyframe.on(20, {
    event: () => {
      setScale(state, 0.9)
    }
  })
  keyframe.on([50, 55], {
    event: () => {
      setOpacity(state, 1)
      setScale(state, 1.1)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScale(state, 0.3)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBounceOutDownAnimator = defineKeyframeAnimator<BounceOutState>((userState, options) => {
  const state: AnimateValue<BounceOutState> = userState || createBounceOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.on(20, {
    event: () => {
      setTranslateY(state, 10)
      setScaleY(state, 0.985)
    }
  })
  keyframe.on([40, 45], {
    event: () => {
      setOpacity(state, 1)
      setScaleY(state, 0.9)
      setTranslateY(state, -20)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScaleY(state, 3)
      setTranslateY(state, "1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBounceOutLeftAnimator = defineKeyframeAnimator<BounceOutState>((userState, options) => {
  const state: AnimateValue<BounceOutState> = userState || createBounceOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.on(20, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, 20)
      setScaleX(state, 0.9)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScaleX(state, 2)
      setTranslateX(state, "-720lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBounceOutRightAnimator = defineKeyframeAnimator<BounceOutState>((userState, options) => {
  const state: AnimateValue<BounceOutState> = userState || createBounceOutState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.on(20, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, -20)
      setScaleX(state, 0.9)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScaleX(state, 2)
      setTranslateX(state, "720lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBounceOutUpAnimator = defineKeyframeAnimator<BounceOutState>((userState, options) => {
  const state: AnimateValue<BounceOutState> = userState || createBounceOutState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.on(20, {
    event: () => {
      setScaleY(state, 0.985)
      setTranslateY(state, -10)
    }
  })
  keyframe.on([40, 45], {
    event: () => {
      setOpacity(state, 1)
      setScaleY(state, 0.9)
      setTranslateY(state, 20)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScaleY(state, 3)
      setTranslateY(state, "-1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})