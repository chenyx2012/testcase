import { DURATION } from '../common/Constants';
import { Keyframe } from '../common/Keyframe';
import { defineKeyframeAnimator } from '../Index';
import matrix4 from '@ohos.matrix4';
import { TranslateState } from '../states/TranslateState';
import { TransformState } from '../states/TransformState';
import { AnimateValue } from '../AnimateValue';


export type JelloState = [TranslateState, TransformState];

// TODO 还没搞明白度数怎么转换到数值
export const createJelloAnimator = defineKeyframeAnimator<JelloState>((userState, options) => {
  const state: AnimateValue<JelloState> = userState || AnimateValue.gets([
    new TranslateState(), new TransformState()
  ])
  const duration = options?.duration || DURATION;
  const setMatrixSkew = (x: number, y: number) => {
    state.states[1].setMatrix(matrix4.identity().skew(x, y))
  }
  const keyframe = new Keyframe();

  keyframe.fromTos(11.1, {
    event: () => {
      state.states[0].setTranslate(0)
    }
  })
  keyframe.on(22.2, {
    event: () => {
      setMatrixSkew(-0.125, -0.125)
    }
  });
  keyframe.on(33.3, {
    event: () => {
      setMatrixSkew(0.625, 0.625)
    }
  })
  keyframe.on(44.4, {
    event: () => {
      setMatrixSkew(-0.3125, -0.3125)
    }
  })
  keyframe.on(55.5, {
    event: () => {
      setMatrixSkew(0.15625, 0.15625)
    }
  })
  keyframe.on(66.6, {
    event: () => {
      setMatrixSkew(-0.078125, -0.078125)
    }
  })
  keyframe.on(77.7, {
    event: () => {
      setMatrixSkew(0.0390625, 0.0390625)
    }
  })
  keyframe.on(88.8, {
    event: () => {
      setMatrixSkew(-0.01953125, -0.01953125)
    }
  })
  return {
    value: state,
    keyframe
  }
})