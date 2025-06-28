import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { RotateState } from '../states/RotateState';

export type RotateOutState = [OpacityState, RotateState];

const setOpacity = (value: AnimateValue<RotateOutState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setRotateZ = (value: AnimateValue<RotateOutState>, v: number) => {
  value.states[1].setRotateZ(v)
}
const setRotateCenter = (value: AnimateValue<RotateOutState>, x: number | string, y: number | string) => {
  value.states[1].setRotateCenter(x, y)
}


const createRotateOutState = (): AnimateValue<RotateOutState> => {
  return AnimateValue.gets([new OpacityState(), new RotateState()]);
}

export const createRotateOutAnimator = defineKeyframeAnimator<RotateOutState>((userState, options) => {
  const state: AnimateValue<RotateOutState> = userState || createRotateOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
      setRotateCenter(state, "50%", "50%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0);
      setRotateZ(state, 200)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createRotateOutDownLeftAnimator = defineKeyframeAnimator<RotateOutState>((userState, options) => {
  const state: AnimateValue<RotateOutState> = userState || createRotateOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
      setRotateCenter(state, 0, "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0);
      setRotateZ(state, 45)
    }
  })
  return {
    value: state,
    keyframe
  }
})

export const createRotateOutDownRightAnimator = defineKeyframeAnimator<RotateOutState>((userState, options) => {
  const state: AnimateValue<RotateOutState> = userState || createRotateOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
      setRotateCenter(state, "100%", "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0);
      setRotateZ(state, -45)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createRotateOutUpLeftAnimator = defineKeyframeAnimator<RotateOutState>((userState, options) => {
  const state: AnimateValue<RotateOutState> = userState || createRotateOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
      setRotateCenter(state, 0, "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0);
      setRotateZ(state, -45)
    }
  })
  return {
    value: state,
    keyframe
  }
})

export const createRotateOutUpRightAnimator = defineKeyframeAnimator<RotateOutState>((userState, options) => {
  const state: AnimateValue<RotateOutState> = userState || createRotateOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setRotateZ(state, 0)
      setRotateCenter(state, "100%", "100%")
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0);
      setRotateZ(state, 90)
    }
  })
  return {
    value: state,
    keyframe
  }
})
