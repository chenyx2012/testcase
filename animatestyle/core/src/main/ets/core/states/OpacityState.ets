import { ModifierState } from '../Index';
import { AnimateState } from '../AnimateState';

@ObservedV2
export class OpacityState implements AnimateState {
  @Trace opacity?: number
  private _init?: number;

  constructor(opacity?: number) {
    this.opacity = opacity;
    this._init = opacity;
  }

  setOpacity(value: number) {
    this.opacity = value
  }

  reset(): void {
    this.opacity = this._init;
  }

  modifier(instance: CommonAttribute): void {
    instance.opacity(this.opacity)
  }
}