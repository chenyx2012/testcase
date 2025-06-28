import { matrix4 } from '@kit.ArkUI';
import { AnimateState } from '../AnimateState';

@ObservedV2
export class TransformState implements AnimateState {
  @Trace private matrix: matrix4.Matrix4Transit;
  private _init: matrix4.Matrix4Transit;

  constructor(matrix?: matrix4.Matrix4Transit) {
    this.matrix = matrix || matrix4.identity();
    this._init = matrix || matrix4.identity()
  }

  reset() {
    this.matrix = this._init;
  }

  modifier(instance: CommonAttribute): void {
    instance.transform(this.matrix)
  }


  getMatrix() {
    return this.matrix;
  }

  setMatrix(matrix: matrix4.Matrix4Transit) {
    this.matrix = matrix;
  }

  setMatrixSkewX(x: number) {
    this.setMatrixSkew(x, 0)
  }

  setMatrixSkewY(y: number) {
    this.setMatrixSkew(0, y)
  }

  setMatrixSkew(x: number, y: number) {
    this.matrix = matrix4.identity().skew(x, y)
  }
}