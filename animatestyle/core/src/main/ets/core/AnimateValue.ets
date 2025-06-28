import { AnimateState } from './AnimateState';
import { AnimatorState } from './Index';


@ObservedV2
export class AnimateValue<T extends AnimatorState> implements AnimateState {
  @Trace states: T;
  private afterReset?: () => void;
  private afterModifier?: (instance: CommonAttribute) => void;

  constructor(states: T) {
    this.states = states;
  }

  static get<T extends AnimateState>(state: T) {
    return new AnimateValue(state)
  }

  static gets<T extends AnimateState[]>(state: T) {
    return new AnimateValue(state)
  }


  onAfterReset(cb: () => void): AnimateValue<T> {
    this.afterReset = cb;
    return this;
  }

  onAfterModifier(cb: (instance: CommonAttribute) => void): AnimateValue<T> {
    this.afterModifier = cb;
    return this;
  }


  reset(): void {
    if (Array.isArray(this.states)) {
      this.states.forEach(state => state.reset())
    } else {
      this.states.reset()
    }
    this.afterReset && this.afterReset()
  }

  modifier(instance: CommonAttribute): void {
    if (Array.isArray(this.states)) {
      this.states.forEach((state: AnimateState) => {
        state.modifier(instance)
      })
    } else {
      this.states.modifier(instance)
    }
    this.afterModifier && this.afterModifier(instance)
  }
}