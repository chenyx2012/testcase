/**
This program is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the Free 
Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details.
*/

import { AnimateTo, AnimatorState, DURATION, Keyframe, ModifierState } from '../Index'
import { Animator, AnimatorOptions } from '../Animator'
import { AnimateValue } from '../AnimateValue';
import { AnimateState } from '../AnimateState';
import { shallowCopy } from './Copy';

export interface KeyframeAnimateInfo<S> {
  value: S;
  param?: KeyframeAnimateParam
  // 与keyframe 二选一必填
  animateStates?: KeyframeState[][] | KeyframeState[]
  // 与animateStates 二选一必填
  keyframe?: Keyframe
}

export type KeyframeAnimateInfoCreator<T extends AnimatorState, O extends AnimatorOptions> = (state?: AnimateValue<T>, options?: O) => KeyframeAnimateInfo<AnimateValue<T>>

export type AnimatorCreator<S extends AnimatorState, O extends AnimatorOptions> = (state?: AnimateValue<S>, options?: O) => Animator<S>

export const defineKeyframeAnimator = <S extends AnimatorState, O extends AnimatorOptions = AnimatorOptions>(creator: KeyframeAnimateInfoCreator<S, O>): AnimatorCreator<S, O> => {
  return (userState?: AnimateValue<S>, _options?: O): Animator<S> => {
    const options = shallowCopy(new AnimatorOptions(), _options) as O
    const animator = creator(userState, options)


    console.log("create Keyframe Animator: ", JSON.stringify(options))

    const state: AnimateValue<S> = userState || animator.value
    const states = animator.animateStates || animator.keyframe!.makeKeyframeAnimateStates(options.duration ?? DURATION, options.curve)
    const p = animator.param || {}

    const params: KeyframeAnimateParam = {
      delay: p.delay || options?.delay,
      iterations: options?.playTimes,
      onFinish: options?.onFinish
    }
    const animateTo: AnimateTo = (ctx: UIContext) => {
      console.log(`animator with params: ${JSON.stringify(params)}, states.len=${states.length}`,)
      if (states.length > 0) {
        const userFinish = params.onFinish;
        const finish = () => {
          console.log("Animate Finished! fill = " + options?.fill, options)
          if (options?.fill === 'none') {
            if (Array.isArray(state.states)) {
              for (let s of (state.states as AnimateState[])) {
                s.reset()
              }
            } else {
              state.states.reset()
            }
          }
          userFinish && userFinish()
        }
        params.onFinish = finish
        console.log("states is ", JSON.stringify(states))
        if (Array.isArray(states[0])) {
          for (let ss of states) {
            ctx.keyframeAnimateTo(params, ss as KeyframeState[])
          }
        } else {
          ctx.keyframeAnimateTo(params, states as KeyframeState[])
        }
      }
    }
    return new Animator(state, animateTo)
  };
}


// export type AnimatorCreator<S extends ModifierState> = (state?: S,
//   options?: AnimatorOptions) => Animator<S>


// export const defineKeyframeAnimator =
//   <S extends ModifierState>(creator: (state?: S,
//     options?: AnimatorOptions) => KeyframeAnimateInfo<S>): AnimatorCreator<S> => {
//
//     return (userState?: S, options?: AnimatorOptions): Animator<S> => {
//       const animator = creator(userState, options)
//
//       const state = userState || animator.valueState
//       const states = animator.animateStates
//       const p = animator.param || {}
//
//       const params: KeyframeAnimateParam = {
//         delay: p.delay || options?.delay,
//         iterations: options?.playTimes,
//       }
//       const animateTo: AnimateTo = (ctx: UIContext) => {
//         console.log(`animator with params: ${JSON.stringify(params)}, states.len=${states.length}`,)
//         if (states.length > 0) {
//           const userFinish = params.onFinish;
//           const finish = () => {
//             userFinish && userFinish()
//           }
//           params.onFinish = finish
//           ctx.keyframeAnimateTo(params, states)
//         }
//       }
//       return new Animator(state, animateTo)
//     }
//   }