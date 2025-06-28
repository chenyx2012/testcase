import { AnimateValue } from '../AnimateValue';
import { DURATION } from '../common/Constants';
import { defineKeyframeAnimator } from '../Index';
import { ScaleState } from '../states/ScaleState';

export type RubberBandState = ScaleState

export const createRubberBandAnimator = defineKeyframeAnimator<RubberBandState>((userState, options) => {
  const state: AnimateValue<RubberBandState> = userState || AnimateValue.get(new ScaleState())
  const duration = options?.duration || DURATION
  return {
    value: state,
    animateStates: [{
      duration: 0.3 * duration,
      event: () => {
        state.states.setScale3d(1.25, 0.75, 1)
      }
    }, {
      duration: 0.1 * duration,
      event: () => {
        state.states.setScale3d(0.75, 1.25, 1)
      }
    }, {
      duration: 0.1 * duration,
      event: () => {
        state.states.setScale3d(1.15, 0.85, 1)
      }
    }, {
      duration: 0.15 * duration,
      event: () => {
        state.states.setScale3d(0.95, 1.05, 1)
      }
    }, {
      duration: 0.1 * duration,
      event: () => {
        state.states.setScale3d(1.05, 0.95, 1)
      }
    }, {
      duration: 0.25 * duration,
      event: () => {
        state.states.setScale3d(1, 1, 1)
      }
    }]
  }
})