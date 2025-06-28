import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { ScaleState } from '../states/ScaleState';
import curves from '@ohos.curves';
import { TranslateState } from '../states/TranslateState';

export type ZoomInState = [OpacityState, ScaleState, TranslateState];

const setTranslateX = (value: AnimateValue<ZoomInState>, v: number | string) => {
  value.states[2].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<ZoomInState>, v: number | string) => {
  value.states[2].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<ZoomInState>, v: number) => {
  value.states[0].setOpacity(v)
}
const setScale = (value: AnimateValue<ZoomInState>, v: number) => {
  value.states[1].setScale(v)
}
const setScaleY = (value: AnimateValue<ZoomInState>, v: number) => {
  value.states[1].setScaleY(v)
}
const setScaleX = (value: AnimateValue<ZoomInState>, v: number) => {
  value.states[1].setScaleX(v)
}


const createZoomInState = (): AnimateValue<ZoomInState> => {
  return AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
}

export const createZoomInAnimator = defineKeyframeAnimator<ZoomInState>((userState, options) => {
  const state: AnimateValue<ZoomInState> = userState || createZoomInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    event: () => {
      setOpacity(state, 0)
      setScale(state, 0.3)
    }
  })
  keyframe.on(50, {
    event: () => {
      setOpacity(state, 1)
      setScale(state, 1)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createZoomInDownAnimator = defineKeyframeAnimator<ZoomInState>((userState, options) => {
  const state: AnimateValue<ZoomInState> = userState || createZoomInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 0)
      setTranslateY(state, "-720lpx")
      setScale(state, 0.1)
    }
  })
  keyframe.on(60, {
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, 60)
      setScale(state, 0.475)
    }
  })
  keyframe.to({
    event: () => {
      setScale(state, 1)
      setTranslateY(state, 0)
    }
  })
  return {
    value: state,
    keyframe
  }
})


export const createZoomInLeftAnimator = defineKeyframeAnimator<ZoomInState>((userState, options) => {
  const state: AnimateValue<ZoomInState> = userState || createZoomInState()
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 0)
      setTranslateX(state, "-720lpx")
      setScale(state, 0.1)
    }
  })
  keyframe.on(60, {
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, 10)
      setScale(state, 0.475)
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
    keyframe
  }
})


export const createZoomInRightAnimator = defineKeyframeAnimator<ZoomInState>((userState, options) => {
  const state: AnimateValue<ZoomInState> = userState || createZoomInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 0)
      setTranslateX(state, "720lpx")
      setScale(state, 0.1)
    }
  })
  keyframe.on(60, {
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateX(state, -10)
      setScale(state, 0.475)
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
    keyframe
  }
})


export const createZoomInUpAnimator = defineKeyframeAnimator<ZoomInState>((userState, options) => {
  const state: AnimateValue<ZoomInState> = userState || createZoomInState();
  const duration = options?.duration || DURATION;
  const keyframe = new Keyframe();
  keyframe.from({
    curve: curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19),
    event: () => {
      setOpacity(state, 0)
      setTranslateY(state, "720lpx")
      setScale(state, 0.1)
    }
  })
  keyframe.on(60, {
    curve: curves.cubicBezierCurve(0.175, 0.885, 0.32, 1),
    event: () => {
      setOpacity(state, 1)
      setTranslateY(state, -60)
      setScale(state, 0.475)
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
    keyframe
  }
})