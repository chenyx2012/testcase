import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import { OpacityState } from '../states/OpacityState';
import { TranslateState } from '../states/TranslateState';

export type FadeInState = [OpacityState, TranslateState];

const setTranslateX = (value: AnimateValue<FadeInState>, v: number | string) => {
  value.states[1].setTranslateX(v)
}
const setTranslateY = (value: AnimateValue<FadeInState>, v: number | string) => {
  value.states[1].setTranslateY(v)
}
const setOpacity = (value: AnimateValue<FadeInState>, v: number) => {
  value.states[0].setOpacity(v)
}

const createFadeInState = (): AnimateValue<FadeInState> => {
  return AnimateValue.gets([new OpacityState(), new TranslateState()]);
}
const createAnimator = (x?: number | string, y?: number | string) => {
  return defineKeyframeAnimator<FadeInState>((userState, options) => {
    const state: AnimateValue<FadeInState> = userState || createFadeInState()
    const duration = options?.duration || DURATION;
    const keyframe = new Keyframe();
    keyframe.from({
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
    keyframe.to({
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
    return {
      value: state,
      keyframe
    }
  })
}


export const createFadeInAnimator = createAnimator()


export const createFadeInDownAnimator = createAnimator(undefined, "-100%")

export const createFadeInDownBigAnimator = createAnimator(undefined, "-1440lpx")

export const createFadeInLeftAnimator = createAnimator("-100%")

export const createFadeInLeftBigAnimator = createAnimator("-720lpx")

export const createFadeInRightAnimator = createAnimator("100%")

export const createFadeInRightBigAnimator = createAnimator("720lpx")

export const createFadeInUpAnimator = createAnimator(undefined, "100%")

export const createFadeInUpBigAnimator = createAnimator(undefined, "1440lpx")

export const createFadeInBottomLeftAnimator = createAnimator("-100%", "100%")

export const createFadeInBottomRightAnimator = createAnimator("100%", "100%")

export const createFadeInTopLeftAnimator = createAnimator("-100%", "-100%")

export const createFadeInTopRightAnimator = createAnimator("100%", "-100%")

