import { AnimateStyleModifier, AnimateTo, AnimatorState, ModifierState } from './Index';
import { AnimateValue } from './AnimateValue';
import { DURATION } from './common/Constants';

export class AnimatorOptions {
  duration?: number = DURATION
  playTimes?: number = 1;
  delay?: number = 0;
  onFinish?: () => void;
  curve?: ICurve;
  fill?: 'none' | 'forwards' = 'none'
}

export class Animator<S extends AnimatorState> {
  readonly state: AnimateValue<S>;
  readonly animate: AnimateTo;

  constructor(state: AnimateValue<S>, animateTo: AnimateTo) {
    this.state = state;
    this.animate = animateTo;
  }

  getModifier(): AnimateStyleModifier<ModifierState> {
    return new AnimateStyleModifier(this.state)
  }

  getState(): AnimateValue<S> {
    return this.state;
  }

  animateTo(ctx: UIContext) {
    this.animate(ctx)
  }
}
