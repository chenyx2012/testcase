import { NavStack } from '../core/NavStack'
import { AnimateLoaderPreviewer } from '../preview/AnimateLoaderPreviewer'
import { AnimateStylePreviewer } from '../preview/AnimateStylePreviewer'
import { LengthMetrics, LengthMetricsUnit } from '@ohos.arkui.node'
import { OhosSmartDialog } from 'ohos_smart_dialog'

@Entry
@Component
struct Index {
  build() {
    Stack() {
      Navigation(OhosSmartDialog.registerRouter(NavStack.stack)) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
          space: {
            main: LengthMetrics.vp(100)
          }
        }) {
          NavRouter() {
            Button("AnimateStyle")
              .fontSize(24)
              .padding({
                top: 20,
                bottom: 20,
                left: 50,
                right: 50
              })
            NavDestination() {
              AnimateStylePreviewer();
            }
            .hideTitleBar(true)
          }

          NavRouter() {
            Button("AnimateLoader")
              .fontSize(24)
              .padding({
                top: 20,
                bottom: 20,
                left: 50,
                right: 50
              })
            NavDestination() {
              AnimateLoaderPreviewer()
            }
            .hideTitleBar(true)
          }
        }
      }
      .hideTitleBar(true)
      .hideToolBar(true)
      .hideBackButton(true)

      OhosSmartDialog()
    }
  }
}