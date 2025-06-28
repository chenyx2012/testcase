import { ModifierState } from '../Index';
import { shallowCopy } from '../common/Copy';
import { AnimateState } from '../AnimateState';

@ObservedV2
export class ScaleState implements AnimateState {
  @Trace scale?: ScaleOptions;
  private _init?: ScaleOptions;

  constructor(scale?: ScaleOptions) {
    this.scale = scale;
    this._init = scale;
  }

  modifier(instance: CommonAttribute): void {
    instance.scale(this.scale)
  }

  reset(): void {
    this.scale = this._init;
  }

  setScaleCenter(x?: number | string, y?: number | string) {
    this.scale = shallowCopy(this.scale, { centerX: x, centerY: y })
  }

  setScale3d(x: number, y: number, z: number) {
    this.scale = shallowCopy(this.scale, { x, y, z })
  }

  setScale(v: number) {
    this.setScale3d(v, v, v)
  }

  setScaleX(x: number) {
    this.scale = shallowCopy(this.scale, { x })
  }

  setScaleY(y: number) {
    this.scale = shallowCopy(this.scale, { y })
  }

  setScaleZ(z: number) {
    this.scale = shallowCopy(this.scale, { z })
  }
}