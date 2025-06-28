import { shallowCopy } from '../common/Copy';
import { AnimateState } from '../AnimateState';

@ObservedV2
export class RotateState implements AnimateState {
  static readonly ANGLE_DEFAULT = 0;
  @Trace rotate?: RotateOptions = undefined;
  private _init?: RotateOptions;

  static get() {
    return new RotateState()
  }

  constructor(rotate?: RotateOptions) {
    this.rotate = rotate;
    this._init = rotate;
  }

  reset(): void {
    this.rotate = this._init
  }

  modifier(instance: CommonAttribute): void {
    instance.rotate(this.rotate)
  }

  setRotate3D(angle: number | string) {
    this.rotate = shallowCopy(this.rotate, {
      x: 1,
      y: 1,
      z: 1,
      angle
    })
  }

  setRotateCenter(x?: number | string, y?: number | string, z?: number) {
    this.rotate = shallowCopy(this.rotate, {
      centerX: x,
      centerY: y,
      centerZ: z,
      angle: this.rotate?.angle || RotateState.ANGLE_DEFAULT
    })
  }

  setPerspective(v: number) {
    this.rotate = shallowCopy(this.rotate, {
      perspective: v,
      angle: this.rotate?.angle || RotateState.ANGLE_DEFAULT
    })
  }

  setRotate(angle: number | string) {
    this.setRotate3D(angle)
  }

  setRotateX(angle: number | string) {
    this.rotate = shallowCopy(this.rotate, {
      x: 1,
      y: 0,
      z: 0,
      angle
    })
  }

  setRotateY(angle: number | string) {
    this.rotate = shallowCopy(this.rotate, {
      x: 0,
      y: 1,
      z: 0,
      angle
    })
  }

  setRotateZ(angle: number | string) {
    this.rotate = shallowCopy(this.rotate, {
      x: 0,
      y: 0,
      z: 1,
      angle
    })
  }
}