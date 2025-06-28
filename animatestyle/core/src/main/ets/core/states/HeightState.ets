import { AnimateState } from '../AnimateState';

export type Height = string | number

@ObservedV2
export class HeightState implements AnimateState {
  @Trace height?: Height;
  private _init?: Height;

  constructor(Height?: Height) {
    this.height = Height;
    this._init = Height;
  }

  setNone() {
    this.height = this._init;
  }

  setHeight(v: Height) {
    this.height = v;
  }

  setFull() {
    this.height = "100%"
  }

  setZero() {
    this.height = 0;
  }

  setHalf() {
    this.height = "50%"
  }


  reset(): void {
    this.height = this._init
  }

  modifier(instance: CommonAttribute): void {
    instance.height(this.height)
  }
}