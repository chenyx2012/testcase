import { HashMap, JSON } from '@kit.ArkTS';
import curves from '@ohos.curves';
import BezierCurve from './BezierCurve';

export type CurveDefine = Curve | ICurve | [number, number, number, number]

export interface FrameHandler {
  curve?: CurveDefine,
  event: () => void
}

function resolveCurve(curve?: CurveDefine): Curve | ICurve | undefined {
  if (Array.isArray(curve)) {
    return curves.cubicBezierCurve(curve[0], curve[1], curve[2], curve[3])
  }
  return curve
}

function resolveICurve(curve?: CurveDefine) {
  const c = resolveCurve(curve)
  if (typeof (c as ICurve)['interpolate'] !== undefined) {
    return c as ICurve;
  } else {
    return curves.initCurve(c as Curve)
  }
}


export class Keyframe {
  private readonly maps: HashMap<number, FrameHandler> = new HashMap<number, FrameHandler>();

  from(handle: FrameHandler) {
    this.on([0], handle)
  }

  froms(rates: number | number[], handle: FrameHandler) {
    if (typeof rates === 'number') {
      rates = [rates];
    }
    this.on([0, ...rates], handle)
  }

  to(handle: FrameHandler) {
    this.on([100], handle)
  }

  tos(rates: number | number[], handle: FrameHandler) {
    if (typeof rates === 'number') {
      rates = [rates];
    }
    this.on([100, ...rates], handle)
  }

  fromTos(rates: number[] | number, handle: FrameHandler) {
    if (typeof rates === 'number') {
      rates = [rates];
    }
    this.on([0, 100, ...(rates ?? [])], handle)
  }

  fromTo(handle: FrameHandler) {
    this.on([0, 100], handle)
  }

  on(rates: number[] | number, handle: FrameHandler) {
    const _add = (handle: FrameHandler, rate: number) => {
      if (rate < 0 || rate > 100) {
        throw new Error("动画比例必须在0-100之间")
      }
      this.maps.set(rate, handle)
    }
    if (typeof rates === 'number') {
      _add(handle, rates as number)
    } else if (Array.isArray(rates)) {
      rates.forEach(e => {
        _add(handle, e)
      })
    }
  }

  makeKeyframeAnimateStates(duration: number, curve?: CurveDefine): KeyframeState[] {
    const rates = Array.from(this.maps.keys()).sort((a, b) => a - b)

    let prev = 0;
    let prevCurve: CurveDefine | undefined = curve;

    // console.log(`makeKeyframeAnimateStates rates=${JSON.stringify(rates)}`)
    const states = rates.map((rate, index) => {
      const config = this.maps.get(rate)
      const diff = rate - prev;
      const curveToUse = prevCurve;

      prevCurve = config?.curve
      const state: KeyframeState = {
        duration: diff / 100 * duration,
        curve: resolveCurve(curveToUse ?? curve) ?? BezierCurve.Ease,
        event: this.maps.get(rate)?.event
      }
      prev = rate;
      return state;
    })
    // console.log(`makeKeyframeAnimateStates states=${JSON.stringify(states)}`)
    return states;
  }
}