import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import curves from '@ohos.curves';
import { TranslateState } from '../states/TranslateState';

export type SlideState = TranslateState


const createSlideState = (): AnimateValue<SlideState> => {
  return AnimateValue.get(new TranslateState());
}

export const createSlideInDownAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateY("-100%")
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateY(0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideInLeftAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateX("-100%")
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateX(0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideInRightAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateX("100%")
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateX(0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideInUpAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateY("100%")
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateY(0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideOutDownAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateY(0)

    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateY("100%")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideOutLeftAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateX(0)
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateX("100%")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideOutRightAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateX(0)
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateX("-100%")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createSlideOutUpAnimator = defineKeyframeAnimator<SlideState>((userState, options) => {
  const state: AnimateValue<SlideState> = userState || createSlideState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      state.states.setTranslateY(0)
    }
  })
  keyframe.to({
    event: () => {
      state.states.setTranslateY("-100%")
    }
  })
  return {
    value: state,
    keyframe
  }
})