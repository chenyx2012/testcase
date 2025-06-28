import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import curves from '@ohos.curves';
import { TranslateState } from '../states/TranslateState';

export type ZoomOutState = [OpacityState, ScaleState, TranslateState];

const setTranslateX = (value: AnimateValue<ZoomOutState>, v: number | string) => {
  value.states[2].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<ZoomOutState>, v: number | string) => {
  value.states[2].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<ZoomOutState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setScale = (value: AnimateValue<ZoomOutState>, v: number) => {
  value.states[1].setScale(v)
}
const setScaleY = (value: AnimateValue<ZoomOutState>, v: number) => {
  value.states[1].setScaleY(v)
}
const setScaleX = (value: AnimateValue<ZoomOutState>, v: number) => {
  value.states[1].setScaleX(v)
}


const createZoomOutState = (): AnimateValue<ZoomOutState> => {
  return AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
}

export const createZoomOutAnimator = defineKeyframeAnimator<ZoomOutState>((userState, options) => {
  const state: AnimateValue<ZoomOutState> = userState || createZoomOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
    }
  })
  keyframe.on(50, {
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


export const createZoomOutDownAnimator = defineKeyframeAnimator<ZoomOutState>((userState, options) => {
  const state: AnimateValue<ZoomOutState> = userState || createZoomOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 0)
      setScale(state, 1)
      state.states[1].setScaleCenter("50%", "100%")
    }
  })
  keyframe.on(40, {
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, -60)
      setScale(state, 0.475)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScale(state, 0.1)
      setTranslateY(state, "1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createZoomOutLeftAnimator = defineKeyframeAnimator<ZoomOutState>((userState, options) => {
  const state: AnimateValue<ZoomOutState> = userState || createZoomOutState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 0)
      setScale(state, 1)
      state.states[1].setScaleCenter(0, "50%")
    }
  })
  keyframe.on(40, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, 42)
      setScale(state, 0.475)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 0.1)
      setOpacity(state, 0)
      setTranslateX(state, "-1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createZoomOutRightAnimator = defineKeyframeAnimator<ZoomOutState>((userState, options) => {
  const state: AnimateValue<ZoomOutState> = userState || createZoomOutState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 0)
      setScale(state, 1)
      state.states[1].setScaleCenter("100%", "50%")
    }
  })
  keyframe.on(40, {
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, -42)
      setScale(state, 0.475)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 0.1)
      setOpacity(state, 0)
      setTranslateX(state, "1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createZoomOutUpAnimator = defineKeyframeAnimator<ZoomOutState>((userState, options) => {
  const state: AnimateValue<ZoomOutState> = userState || createZoomOutState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 0)
      setScale(state, 1)
      state.states[1].setScaleCenter("50%", "100%")
    }
  })
  keyframe.on(40, {
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 60)
      setScale(state, 0.475)
    }
  })
  keyframe.to({
    event: () => {
      setOpacity(state, 0)
      setScale(state, 0.1)
      setTranslateY(state, "-1440lpx")
    }
  })
  return {
    value: state,
    keyframe
  }
})