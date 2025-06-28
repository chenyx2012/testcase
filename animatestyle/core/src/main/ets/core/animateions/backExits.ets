import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState'
import { ScaleState } from '../states/ScaleState'
import { TranslateState } from '../states/TranslateState'

export type BackOutState = [TranslateState, OpacityState, ScaleState];

const setTranslateY = (value: AnimateValue<BackOutState>, v: number | string) => {
  value.states[0].setTranslateY(v)
}
const setTranslateX = (value: AnimateValue<BackOutState>, v: number | string) => {
  value.states[0].setTranslateX(v)
}
const setScale = (value: AnimateValue<BackOutState>, v: number) => {
  value.states[2].setScale(v)
}
const setOpacity = (value: AnimateValue<BackOutState>, v: number) => {
  value.states[1].setOpacity(v)
}

const createBackOutState = (): AnimateValue<BackOutState> => {
  return AnimateValue.gets([new TranslateState(), new OpacityState(), new ScaleState()]);
}

export const createBackOutDownAnimator = defineKeyframeAnimator<BackOutState>((userState, options) => {
  const state: AnimateValue<BackOutState> = userState || createBackOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states[0].setTranslate(0)
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  keyframe.on(20, {
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateY(state, "1700px")
      setOpacity(state, 0.7)
    }
  })
  return {
    value: state,
    keyframe
  }
})

export const createBackOutLeftAnimator = defineKeyframeAnimator<BackOutState>((userState, options) => {
  const state: AnimateValue<BackOutState> = userState || createBackOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states[0].setTranslate(0)
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  keyframe.on(20, {
    event: () => {
      setTranslateX(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateX(state, "-1200px")
      setOpacity(state, 0.7)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBackOutRightAnimator = defineKeyframeAnimator<BackOutState>((userState, options) => {
  const state: AnimateValue<BackOutState> = userState || createBackOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states[0].setTranslate(0)
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  keyframe.on(20, {
    event: () => {
      setTranslateX(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateX(state, "1200px")
      setOpacity(state, 0.7)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createBackOutUpAnimator = defineKeyframeAnimator<BackOutState>((userState, options) => {
  const state: AnimateValue<BackOutState> = userState || createBackOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states[0].setTranslate(0)
      setScale(state, 1)
      setOpacity(state, 1)
    }
  })
  keyframe.on(20, {
    event: () => {
      setTranslateY(state, 0)
      setScale(state, 0.7)
      setOpacity(state, 0.7)
    }
  })
  keyframe.to({
    event: () => {
      setTranslateY(state, "-2000px")
      setOpacity(state, 0.7)
    }
  })
  return {
    value: state,
    keyframe
  }
})