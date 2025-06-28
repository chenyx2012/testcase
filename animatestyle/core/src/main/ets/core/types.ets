import { UIContext } from '@kit.ArkUI'
import { AnimateState } from './AnimateState'

export type AnimatorState = AnimateState[] | AnimateState

export type AnimateTo = (ctx: UIContext) => void
