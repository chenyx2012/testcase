# Animate Style

## 😃简介

[Animate.css](https://github.com/animate-css/animate.css) ，是一个现成的跨浏览器动画库，可用于您的 Web 项目。非常适合用于强调、主页、滑块和注意力引导提示。本库基于[Animate.css](https://github.com/animate-css/animate.css)原库v4.1.1版本进行适配，使其可以运行在 HarmonyOS。


![](https://s2.loli.net/2024/07/12/cMoTxd4wKkFtQGO.gif)

## 📦下载安装

```shell
ohpm install @animate/style
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 📚基本用法
安装 `@animate/style` 后，将需要动画的`ArkUI`组件使用 `AnimateView` 包装起来，并提供一个[animator参数](#预制全部动画)
```javascript
animator: Animator<AnimatorState> = createZoomInDownAnimator();
ctx?:UIContext;
aboutToAppear(): void {
    this.ctx = this.getUIContext()
}
AnimateView({ animator: this.animator }) {
  Text("Animate for HarmonyOS")
    .height(60)
    .fontSize(25)
    .fontWeight(900)
    .textAlign(TextAlign.Center)
    .onClick(e=> {
        if(!this.ctx){
            console.log("没有UIContext")
            return;
        }
        this.animator.animateTo(this.ctx)
    })
}
```
就这样，你得到了一个HarmonyOS动画，当点击文本 `Animate for HarmonOS` 时动画将会播放一次，默认持续时间1s
动画可以改善界面的用户体验，但请记住，它们也会妨碍用户！

## 🎨️选项配置
`createZoomInDownAnimator(ZoomInState,AnimatorOptions)` 包含两个参数，第一个为初始状态参数，第二个为[动画选项](#animatoroptions)参数

### 自定义初始参数
不同的动画创建函数使用不同的初始化参数，参数的类型为`AnimateState|AnimateState[]`的子类，子类将会对AnimateView设置不同的参数  
例如 TranslateState 子类将会设置translate属性，ScaleState 子类将会设置scale属性，全部预制的state的初始默认值为undefined


### AnimatorOptions
```javascript
// 动画的持续时间，毫秒
duration?: number = 1000
// 动画的播放次数
playTimes?: number = 1;
// 动画的延迟时间
delay?: number = 0;
// 动画完成回调
onFinish?: () => void;
// 动画结束后的状态， none=返回动画开始时状态，forwards=保持动画最后一帧的状态
fill?: 'none' | 'forwards' = 'none'
```



## 🔍应用限制
- AnimateView里面允许有多个子节点，但是只有第一个子节点会应用动画效果
- AnimateView组件不支持任何属性，此操作 `AnimateView().width(100)` 是无效的，运行时将抛出异常
- AnimateView如果自定义参数则必须在@ComponentV2组件中使用。查看如何在[V1版本](#在v1状态管理中使用)版本中使用


## 📖在V1状态管理中使用
由于动画参数中均使用V2版本的状态管理，所以在应用动画时如果指定了参数，并且参数为状态参数，则必须使用[V2版本](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/_u6001_u7ba1_u7406_uff08v2_u8bd5_u7528_u7248_uff09-V5)的状态参数装饰器

所以如果需要再V1版本中使用并且需要状态参数，则使用AnimateView的组件中必须是@ComponentV2装饰的组件，组件内的状态也只能在组件自身中使用



```javascript

@Entry
@Component
struct StateV1Page {

  build() {
    RelativeContainer() {
      // 这里不能传递状态参数，因为ZoomInDownComponent需要V2的状态参数，当前页面只能有V1的状态
      ZoomInDownComponent()
    }
    .height('100%')
    .width('100%')
  }
}


@ComponentV2
struct ZoomInDownComponent {
  @Local options: AnimatorOptions = {};
  animator?: Animator<AnimatorState>;
  ctx?: UIContext;

  aboutToAppear(): void {
    this.ctx = this.getUIContext();
    const zoomInState: AnimateValue<ZoomInState> = AnimateValue.gets([new OpacityState(), new ScaleState(), new TranslateState()]);
    this.animator = createZoomInDownAnimator(zoomInState, this.options);
  }

  build() {
    Flex({justifyContent:FlexAlign.Center,alignItems: ItemAlign.Center}){
      if (this.animator) {
        AnimateView({ animator: this.animator }) {
          Text("Animator for HarmonyOS")
            .fontSize(20)
            .fontWeight(900)
            .onClick(e => {
              if (!this.ctx) {
                return
              }
              this.animator?.animateTo(this.ctx)
            })
        }
      } else {
        Text("没有Animator")
      }
    }
    .width("100%")
      .height("100%")
  }
}
```


## 📚内置动画
`animator`动画创建函数名称格式： createXXXXAnimator, 支持全部的[Animate.css](https://animate.style)动画(与其相比动画的名称首字母大写)

### Attention seekers
- Bounce 
- Flash
- Pulse
- RubberBand
- ShakeX
- ShakeY
- HeadShake
- Swing
- Tada
- Wobble
- Jello
- HeartBeat

### Back entrances
- BackInDown
- BackInLeft
- BackInRight
- BackInUp

### Back exits
- BackOutDown
- BackOutLeft
- BackOutRight
- BackOutUp

### Bouncing entrances
- BounceIn
- BounceInDown
- BounceInLeft
- BounceInRight
- BounceInUp

### Bouncing exits 
- BounceOut
- BounceOutDown
- BounceOutLeft
- BounceOutRight
- BounceOutUp


### Fading entrances
- FadeIn
- FadeInDown
- FadeInDownBig
- FadeInLeft
- FadeInLeftBig
- FadeInRight
- FadeInRightBig
- FadeInUp
- FadeInUpBig
- FadeInTopLeft
- FadeInTopRight
- FadeInBottomLeft
- FadeInBottomRight

### Fading exits
- FadeOut
- FadeOutDown
- FadeOutDownBig
- FadeOutLeft
- FadeOutLeftBig
- FadeOutRight
- FadeOutRightBig
- FadeOutUp
- FadeOutUpBig
- FadeOutTopLeft
- FadeOutTopRight
- FadeOutBottomRight
- FadeOutBottomLeft

### Flippers
- Flip
- FlipInX
- FlipInY
- FlipOutX
- FlipOutY

### Lightspeed
- LightSpeedInRight
- LightSpeedInLeft
- LightSpeedOutRight
- LightSpeedOutLeft

### Rotating entrances
- RotateIn
- RotateInDownLeft
- RotateInDownRight
- RotateInUpLeft
- RotateInUpRight

### Rotating exits
- RotateOut
- RotateOutDownLeft
- RotateOutDownRight
- RotateOutUpLeft
- RotateOutUpRight

### Specials
- Hinge
- JackInTheBox
- RollIn
- RollOut

### Zooming entrances
- ZoomIn
- ZoomInDown
- ZoomInLeft
- ZoomInRight
- ZoomInUp

### Zooming exits
- ZoomOut
- ZoomOutDown
- ZoomOutLeft
- ZoomOutRight
- ZoomOutUp

### Sliding entrances
- SlideInDown
- SlideInLeft
- SlideInRight
- SlideInUp

### Sliding exits
- SlideOutDown
- SlideOutLeft
- SlideOutRight
- SlideOutUp


## 🔒约束与限制

在下述版本验证通过：
> DevEco Studio NEXT Developer Beta1  
> Build #DS-233.14475.28.36.503403  
> Build Version: 5.0.3.403, built on June 20, 2024  
> Runtime version: 17.0.10+1-b1087.17 aarch64  
> VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.  
> macOS 14.3  
> GC: G1 Young Generation, G1 Old Generation  
> Memory: 4096M  
> Cores: 12  
> Registry:  
> idea.plugins.compatible.build=IC-233.14475.28  

## 🛠️自定义动画
### 动画数据状态
首先需要定义你的动画需要操作哪些属性，比如translate，rotate等，库提供了以下属性状态
- OpacityState 操作opacity属性
- RotateState 操作rotate属性
- ScaleState 操作scale属性
- TranslateState 操作translate属性
- TransformState 操作transform属性，目前仅支持matrix4矩阵

如果你需要操作其他属性，可以自定义`xxxState`并实现`AnimateState`接口,自定义实现类顶部需要使用`@ObservedV2`装饰，内部属性值需要使用`@Trace装饰`

### 定义动画
给你的动画起一个名字，比如 `createFadeInDownAnimator`.   
然后使用 `defineKeyframeAnimator`辅助函数创建帧动画，如下：
```javascript
type FadeInState = [OpacityState, TranslateState];

const createFadeInDownAnimator = defineKeyframeAnimator<FadeInState>((userState,options)=>{
    const state: AnimateValue<FadeInState> = userState || AnimateValue.gets([new OpacityState(),new TranslateState()])
    const duration = options?.duration || DURATION;
    const keyframe = new Keyframe();
    keyframe.from({
        event: () => {
            state.states[0].setOpacity(0)
            state.states[1].setTranslateY("-100%")
        }
    })
    // 定义动画在50%时的状态
    keyframe.on(50,{
        event: ()=>{
            state.states[0].setOpacity(0.5)
            state.states[1].setTranslateY("-50%")
        }
    })
    keyframe.to({
        event: () => {
            state.states[0].setOpacity(1)
            state.states[1].setTranslateY(0)
        }
    })
    return {
        value: state,
        keyframe
    }
});
```





## 🌲目录结构
```javascript
AnimateStyle
├── entry # 实例代码
├── library # AnimateStyle库
│   ├── src
│   │   └── main
│   │       ├── ets
│   │           └── core # 核心模块代码
│   ├── Index.ets
│   └── oh-package.json5
├── screenshots # 截图
├── CHANGELOG.md # 更新日志
├── LICENSE # 开源协议
├── README.md # 使用方法

```

## 🙏贡献代码
使用过程中发现任何问题都可以提 Issue 给我们，当然，我们也非常欢迎你给我们发 PR 。

## 📚开源协议

本项目基于 [Hippocratic License 2.1](http://firstdonoharm.dev/) ，请自由地享受和参与开源。