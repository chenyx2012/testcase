import { AnimateState } from '../AnimateState';
import { shallowCopy } from '../common/Copy';

@ObservedV2
export class TranslateState implements AnimateState {
  @Trace translate?: TranslateOptions;
  private _init?: TranslateOptions;

  static get() {
    return new TranslateState()
  }

  constructor(translate?: TranslateOptions) {
    this.translate = translate;
    this._init = translate;
  }


  reset(): void {
    this.translate = this._init;
  }

  setTranslate3d(x?: number | string, y?: number | string, z?: number | string) {
    this.translate = shallowCopy(this.translate, {
      x, y, z
    })
  }

  setTranslate(v: number | string) {
    this.setTranslate3d(v, v, v)
  }

  setTranslateX(x: number | string) {
    this.translate = shallowCopy(this.translate, { x })
  }

  setTranslateY(y: number | string) {
    this.translate = shallowCopy(this.translate, { y })
  }

  setTranslateZ(z: number | string) {
    this.translate = shallowCopy(this.translate, { z })
  }

  modifier(instance: CommonAttribute): void {
    instance.translate(this.translate)
  }
}