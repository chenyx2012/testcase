import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { RotateState } from '../states/RotateState';

export type RotateInState = [OpacityState, RotateState];

const setOpacity = (value: AnimateValue<RotateInState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setRotateZ = (value: AnimateValue<RotateInState>, v: number) => {
  value.states[1].setRotateZ(v)
}
const setRotateCenter = (value: AnimateValue<RotateInState>, x: number | string, y: number | string) => {
  value.states[1].setRotateCenter(x, y)
}


const createRotateInState = (): AnimateValue<RotateInState> => {
  return AnimateValue.gets([new OpacityState(), new RotateState()]);
}

export const createRotateInAnimator = defineKeyframeAnimator<RotateInState>((userState, options) => {
  const state: AnimateValue<RotateInState> = userState || createRotateInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setRotateZ(state, -200)
      setRotateCenter(state, "50%", "50%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createRotateInDownLeftAnimator = defineKeyframeAnimator<RotateInState>((userState, options) => {
  const state: AnimateValue<RotateInState> = userState || createRotateInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setRotateZ(state, -45)
      setRotateCenter(state, 0, "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})

export const createRotateInDownRightAnimator = defineKeyframeAnimator<RotateInState>((userState, options) => {
  const state: AnimateValue<RotateInState> = userState || createRotateInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setRotateZ(state, 45)
      setRotateCenter(state, "100%", "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createRotateInUpLeftAnimator = defineKeyframeAnimator<RotateInState>((userState, options) => {
  const state: AnimateValue<RotateInState> = userState || createRotateInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setRotateZ(state, 45)
      setRotateCenter(state, 0, "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})

export const createRotateInUpRightAnimator = defineKeyframeAnimator<RotateInState>((userState, options) => {
  const state: AnimateValue<RotateInState> = userState || createRotateInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setRotateZ(state, -90)
      setRotateCenter(state, "100%", "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})
