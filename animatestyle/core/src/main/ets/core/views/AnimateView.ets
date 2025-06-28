import { EmptyBuilder } from '../common/Constants';
import { AnimateStyleModifier, Animator, AnimatorState, ModifierState } from '../Index';

@ComponentV2
export struct AnimateView {
  @BuilderParam view: (modifier?: AnimateStyleModifier<ModifierState>) => void = EmptyBuilder
  @Require @Param animator: Animator<AnimatorState>;
  private uniqueId?: number;
  @Local private modifier?: AnimateStyleModifier<ModifierState>

  @Monitor("animator")
  changeModifier() {
    this.modifier = this.animator.getModifier()
  }

  aboutToAppear(): void {
    this.uniqueId = this.getUniqueId();
    this.modifier = this.animator.getModifier()
  }

  onDidBuild(): void {
    const node = this.getUIContext().getFrameNodeByUniqueId(this.uniqueId)
    const targetNode = node?.getFirstChild()
    if (!targetNode) {
      throw new Error("AnimateView必须有子节点")
    }
  }

  build() {
    Stack() {
      this.view();
    }
    .attributeModifier(this.modifier)
  }
}