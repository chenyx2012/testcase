import { curves } from '@kit.ArkUI'

export default class BezierCurve {
  private constructor() {
  }

  static Linear = curves.cubicBezierCurve(0, 0, 1, 1);
  static Ease = curves.cubicBezierCurve(0.25, 0.1, 0.25, 1.0)
  static EaseIn = curves.cubicBezierCurve(.42, 0, 1, 1)
  static EaseOut = curves.cubicBezierCurve(1, 1, 0.58, 1)
  static EaseInOut = curves.cubicBezierCurve(0.42, 0, 0.58, 1)
  static FastOutSlowIn = curves.cubicBezierCurve(0.4, 0, 0.2, 1);
  static LinearOutSlowIn = curves.cubicBezierCurve(0.0, 0.0, 0.2, 1.0)
  static FastOutLinearIn = curves.cubicBezierCurve(0.4, 0.0, 1.0, 1.0)
  static ExtremeDeceleration = curves.cubicBezierCurve(0.0, 0.0, 0.0, 1.0)
  static Sharp = curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0)
  static Rhythm = curves.cubicBezierCurve(0.7, 0.0, 0.2, 1.0)
  static Smooth = curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0)
  static Friction = curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0)
  static EaseInSine = curves.cubicBezierCurve(0.47, 0, 0.745, 0.715);
  static EaseOutSine = curves.cubicBezierCurve(0.39, 0.575, 0.565, 1);
  static EaseInOutSine = curves.cubicBezierCurve(0.445, 0.05, 0.55, 0.95);
  static EaseInQuad = curves.cubicBezierCurve(0.55, 0.085, 0.68, 0.53);
  static EaseOutQuad = curves.cubicBezierCurve(0.25, 0.46, 0.45, 0.94);
  static EaseInOutQuad = curves.cubicBezierCurve(0.455, 0.03, 0.515, 0.955);
  static EaseInCubic = curves.cubicBezierCurve(0.55, 0.055, 0.675, 0.19);
  static EaseOutCubic = curves.cubicBezierCurve(0.215, 0.61, 0.355, 1);
  static EaseInOutCubic = curves.cubicBezierCurve(0.645, 0.045, 0.355, 1);
  static EaseInQuart = curves.cubicBezierCurve(0.895, 0.03, 0.685, 0.22);
  static EaseOutQuart = curves.cubicBezierCurve(0.165, 0.84, 0.44, 1);
  static EaseInOutQuart = curves.cubicBezierCurve(0.77, 0, 0.175, 1);
}

