import { AnimateState } from '../AnimateState';

export type Width = string | number

@ObservedV2
export class WidthState implements AnimateState {
  @Trace width?: Width;
  private _init?: Width;

  constructor(width?: Width) {
    this.width = width;
    this._init = width;
  }
  setNone(){
    this.width = this._init
  }

  setWidth(v?: Width) {
    this.width = v;
  }

  setFull() {
    this.width = "100%"
  }

  setZero() {
    this.width = 0;
  }

  setHalf() {
    this.width = "50%"
  }


  reset(): void {
    this.width = this._init
  }

  modifier(instance: CommonAttribute): void {
    instance.width(this.width)
  }
}