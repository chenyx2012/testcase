export class FullModifier implements AttributeModifier<CommonAttribute> {
  applyNormalAttribute(instance: CommonAttribute): void {
    instance.width("100%")
      .height("100%")
  }
}