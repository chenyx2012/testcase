import { AnimateState } from '../AnimateState';

@ObservedV2
export class BackgroundSizeState implements AnimateState {
  @Trace private size?: SizeOptions;
  private _init?: SizeOptions;

  constructor(size?: SizeOptions) {
    this.size = size;
    this._init = size;
  }

  reset(): void {
    this.size = this._init;
  }

  modifier(instance: CommonAttribute): void {
    instance.backgroundImageSize(this.size)
  }
}