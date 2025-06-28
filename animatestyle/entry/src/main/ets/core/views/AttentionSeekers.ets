import { AnimateCard } from '../../components/AnimateCard'
import { createBounceAnimator, createFlashAnimator, createHeadShakeAnimator, createHeartBeatAnimator, createJelloAnimator, createPulseAnimator, createRubberBandAnimator, createShakeXAnimator, createShakeYAnimator, createSwingAnimator, createTadaAnimator, createWobbleAnimator }  from '@animate/style/'

@ComponentV2
export struct AttentionSeekers {
  build() {
    Grid() {
      GridItem() {
        AnimateCard({
          name: "Bounce",
          animateCreator: (config) => createBounceAnimator(undefined, config)
        })
      }

      GridItem() {
        AnimateCard({ name: "Flash", animateCreator: (config) => createFlashAnimator(undefined, config) })
      }


      GridItem() {
        AnimateCard({ name: "HeadShake", animateCreator: config => createHeadShakeAnimator(undefined, config) })
      }


      GridItem() {
        AnimateCard({ name: "HeartBeat", animateCreator: config => createHeartBeatAnimator(undefined, config) })
      }


      GridItem() {
        AnimateCard({ name: "RubberBand", animateCreator: config => createRubberBandAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "Pulse", animateCreator: config => createPulseAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "ShakeX", animateCreator: config => createShakeXAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "ShakeY", animateCreator: config => createShakeYAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "Swing", animateCreator: config => createSwingAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "Tada", animateCreator: config => createTadaAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "Wobble", animateCreator: config => createWobbleAnimator(undefined, config) })
      }

      GridItem() {
        AnimateCard({ name: "Jello", animateCreator: config => createJelloAnimator(undefined, config) })
      }
    }
    .width("100%")
    .height("100%")
    .padding({
      top: 50,
      bottom: 50,
      left: 20,
      right: 20
    })
    .rowsGap(30)
    .columnsGap(30)
    .columnsTemplate("1fr 1fr 1fr")
  }
}