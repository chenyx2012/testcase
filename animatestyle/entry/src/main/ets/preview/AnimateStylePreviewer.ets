import { AttentionSeekers } from '../core/views/AttentionSeekers'
import { BackEntrancesView } from '../core/views/BackEntracesView'
import { BackExitsView } from '../core/views/BackExitsView'
import { BouncingExitsView } from '../core/views/BouncingExitsView'
import { BouncingEntrancesView } from '../core/views/BouncingEntrancesView'
import { FadingEntrancesView } from '../core/views/FadingEntrancesView'
import { FadingExitsView } from '../core/views/FadingExitsView'
import { FlippersView } from '../core/views/FlippersView'
import { LightSpeedView } from '../core/views/LightSpeedView'
import { RotateEntrancesView } from '../core/views/RotateEntrancesView'
import { RotateExitsView } from '../core/views/RotateExits'
import { SpecialView } from '../core/views/SpeicalView'
import { ZoomEntrancesView } from '../core/views/ZoomEntrancesView'
import { ZoomExitsView } from '../core/views/ZoomExitsView'
import { SlidingView as SlidingView } from '../core/views/SlideView'

@Component
export struct AnimateStylePreviewer {
  private scroller: ListScroller = new ListScroller();

  @Builder
  navRouterTitle(name: string) {
    Text(name)
      .width("100%")
      .height(60)
      .backgroundColor(Color.White)
      .borderRadius(24)
      .fontSize(20)
      .fontWeight(500)
      .textAlign(TextAlign.Center)
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Text("Animate Style For HarmonyOS")
          .fontSize(20)
          .height(100)
          .fontWeight(900)
        Stack() {
          List({ space: 10, scroller: this.scroller }) {
            ListItem() {
              NavRouter() {
                this.navRouterTitle("Attention seekers")
                NavDestination() {
                  AttentionSeekers()
                }
                .title("Attention seekers")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Back entrances")
                NavDestination() {
                  BackEntrancesView()
                }
                .title("Back entrances")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Back exits")
                NavDestination() {
                  BackExitsView()
                }
                .title("Back exits")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Bouncing entrances")
                NavDestination() {
                  BouncingEntrancesView()
                }
                .title("Bouncing entrances")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Bouncing exits")
                NavDestination() {
                  BouncingExitsView()
                }
                .title("Bouncing exits")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Fading entrances")
                NavDestination() {
                  FadingEntrancesView()
                }
                .title("Fading entrances")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Fading exits")
                NavDestination() {
                  FadingExitsView()
                }
                .title("Fading exits")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Flippers")
                NavDestination() {
                  FlippersView()
                }
                .title("Flippers")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Lightspeed")
                NavDestination() {
                  LightSpeedView()
                }
                .title("Lightspeed")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Rotate entrances")
                NavDestination() {
                  RotateEntrancesView()
                }
                .title("Rotate entrances")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Rotate exits")
                NavDestination() {
                  RotateExitsView()
                }
                .title("Rotate exits")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Special")
                NavDestination() {
                  SpecialView()
                }
                .title("Special")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Zoom entrances")
                NavDestination() {
                  ZoomEntrancesView()
                }
                .title("Zoom entrances")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Zoom exits")
                NavDestination() {
                  ZoomExitsView()
                }
                .title("Zoom exits")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Sliding")
                NavDestination() {
                  SlidingView()
                }
                .title("Sliding")
              }
            }

            ListItem() {
              NavRouter() {
                this.navRouterTitle("Stretch")
                NavDestination() {
                  // StretchView()
                }
                .title("Sliding")
              }
            }
          }
          .width("100%")
          .height("100%")
          .contentEndOffset(40)
          .scrollBar(BarState.Off)
        }
        .width("90%")
        .flexGrow(1)
        .flexShrink(1)
        .flexBasis(1)
      }
      .height("100%")
      .width("100%")
    }
    .backgroundColor('#F1F3F5')
    .hideTitleBar(true)
  }
}