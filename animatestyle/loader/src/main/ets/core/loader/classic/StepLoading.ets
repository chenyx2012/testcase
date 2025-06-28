// /* HTML: <div class="loader"></div> */
import curves from '@ohos.curves';

// .loader {
//   width: fit-content;
//   font-weight: bold;
//   font-family: sans-serif;
//   font-size: 30px;
//   padding: 0 5px 8px 0;
//   background: repeating-linear-gradient(90deg,currentColor 0 8%,#0000 0 10%) 200% 100%/200% 3px no-repeat;
//   animation: l3 2s steps(6) infinite;
// }
// .loader:before {
//   content:"Loading..."
// }
// @keyframes l3 {to{background-position: 80% 100%}}

@Preview({
  width: 326,
  height: 272
})
@ComponentV2
export struct StepLoading {
  @Local x?: number | string = "200%";
  @Local y?: number | string = "100%";

  build() {
    Column() {
      Text("Loading...")
        .fontSize(30)
        .fontWeight(900)
        .margin({ bottom: 5 })
      Row()
        .linearGradient({
          repeating: true,
          direction: GradientDirection.Right,
          colors: [
            [Color.Red, 0],
            [Color.Red, 0.16],
            [Color.Transparent, 0.16],
            [Color.Transparent, 0.20]
          ]
        })
        .height(3)
        .width("100%")

      Button("Animate").onClick((event: ClickEvent) => {

      })
    }
  }
}