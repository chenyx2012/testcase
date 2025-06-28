import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import { TranslateState } from '../states/TranslateState';

export type BackInState = [TranslateState, OpacityState, ScaleState];

const setTranslateY = (value: AnimateValue<BackInState>, v: number | string) => {
  value.states[0].setTranslateY(v)
}
const setTranslateX = (value: AnimateValue<BackInState>, v: number | string) => {
  value.states[0].setTranslateX(v)
}
const setScale = (value: AnimateValue<BackInState>, v: number) => {
  value.states[2].setScale(v)
}
const setOpacity = (value: AnimateValue<BackInState>, v: number) => {
  value.states[1].setOpacity(v)
}

const createBackInState = (): AnimateValue<BackInState> => {
  return AnimateValue.gets([new TranslateState(), new OpacityState(), new ScaleState()]);
}


export const createBackInDownAnimator = defineKeyframeAnimator<BackInState>((userState, options) => {
  const state: AnimateValue<BackInState> = userState || createBackInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setTranslateY(state, "-1440lpx")
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.on(80, {
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBackInLeftAnimator = defineKeyframeAnimator<BackInState>((userState, options) => {
  const state: AnimateValue<BackInState> = userState || createBackInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setTranslateX(state, "-720lpx")
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.on(80, {
    event: () => {
      setTranslateX(state, 0)
      setOpacity(state, .7)
      setScale(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBackInRightAnimator = defineKeyframeAnimator<BackInState>((userState, options) => {
  const state: AnimateValue<BackInState> = userState || createBackInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setTranslateX(state, "720lpx")
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.on(80, {
    event: () => {
      setTranslateX(state, 0)
      setOpacity(state, .7)
      setScale(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBackInUpAnimator = defineKeyframeAnimator<BackInState>((userState, options) => {
  const state: AnimateValue<BackInState> = userState || createBackInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setTranslateY(state, "1440lpx")
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.on(80, {
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
})