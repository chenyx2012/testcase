import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { TranslateState } from '../states/TranslateState';

export type FadeOutState = [OpacityState, TranslateState];

const setTranslateX = (value: AnimateValue<FadeOutState>, v: number | string) => {
  value.states[1].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<FadeOutState>, v: number | string) => {
  value.states[1].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<FadeOutState>, v: number) => {
  value.states[0].setOpacity(v)
}

const createFadeOutState = (): AnimateValue<FadeOutState> => {
  return AnimateValue.gets([new OpacityState(), new TranslateState()]);
}
const createAnimator = (x?: number | string, y?: number | string) => {
  return defineKeyframeAnimator<FadeOutState>((userState, options) => {
    const state: AnimateValue<FadeOutState> = userState || createFadeOutState()
    const duration = options?.duration || DURATION;
    const keyframe = new Keyframe();
    keyframe.from({
      event: () => {
        setOpacity(state, 1)
        if (x) {
          setTranslateX(state, 0)
        }
        if (y) {
          setTranslateY(state, 0)
        }
      }
    })
    keyframe.to({
      event: () => {
        setOpacity(state, 0)
        if (x) {
          setTranslateX(state, x)
        }
        if (y) {
          setTranslateY(state, y)
        }

      }
    })
    return {
      value: state,
      keyframe
    }
  })
}


export const createFadeOutAnimator = createAnimator()


export const createFadeOutDownAnimator = createAnimator(undefined, "100%")

export const createFadeOutDownBigAnimator = createAnimator(undefined, "1440lpx")

export const createFadeOutLeftAnimator = createAnimator("-100%")

export const createFadeOutLeftBigAnimator = createAnimator("-720lpx")

export const createFadeOutRightAnimator = createAnimator("100%")

export const createFadeOutRightBigAnimator = createAnimator("720lpx")

export const createFadeOutUpAnimator = createAnimator(undefined, "-100%")

export const createFadeOutUpBigAnimator = createAnimator(undefined, "-1440lpx")

export const createFadeOutBottomLeftAnimator = createAnimator("-100%", "100%")

export const createFadeOutBottomRightAnimator = createAnimator("100%", "100%")

export const createFadeOutTopLeftAnimator = createAnimator("-100%", "-100%")

export const createFadeOutTopRightAnimator = createAnimator("100%", "-100%")

