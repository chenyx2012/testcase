import { ModifierState } from '../common/ModifierState';


export class AnimateStyleModifier<S extends ModifierState> implements AttributeModifier<CommonAttribute> {
  private state: S;
  private enableAnimate: boolean = true;

  constructor(state: S) {
    this.state = state;
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    if (!this.enableAnimate) {
      return;
    }
    this.state.modifier(instance)
  }
}