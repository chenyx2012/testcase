import { PhotoGesture } from '../model/GestureData';
import { MyDataSource } from '../model/MyDataSource';
import { IconData, StyleData } from '../interface/PicturePreviewInterface'
import { PictureCacheUtil } from '../utils/PictureCacheUtil';
import { PicturePreview } from '../PicturePreview';
import { Loading } from './Loading';
import { PicturePreviewDataModel } from '../model/PicturePreviewDataModel';

@Component
export struct Images{
  @Link index: number;
  @State styleData: StyleData = PicturePreviewDataModel.getInstance().styleData;
  @Prop iconDatas: MyDataSource<IconData>;
  @State isDisableSwipe: boolean = false
  private init: boolean = false;
  public loading: ((iconData: IconData)=>void) | undefined;

  private controller: SwiperController = new SwiperController()

  click(index: number, iconData: IconData) {
    // 执行点击事件，如果返回true，则默认已经处理了点击事件，则不执行关闭动作
    let fn = PicturePreviewDataModel.getInstance().listener.onClick!;
    let is = fn(index, iconData);
    if (is) return;

    // 如果设置了点击关闭，则关闭页面
    if (PicturePreviewDataModel.getInstance().functionData.isClickClose) {
      PicturePreview.close();
    }
  }

  doubleClick(index: number, iconData: IconData): boolean {
    let fn = PicturePreviewDataModel.getInstance().listener.onDoubleTap!;
    let is = fn(index, iconData);
    if (is) {
      return true
    } else {
      return false
    }
  }

  build() {
    Swiper(this.controller){
      LazyForEach(this.iconDatas, (item: IconData)=>{
        ImageIte({
          item: item,
          isDisableSwipe: this.isDisableSwipe,
          maxScale: this.styleData.maxScale,
          isZoom: this.styleData.isZoom,
          loading: this.loading,
          click: ()=>{
            this.click(this.index, item)
          },
          doubleClick: ()=>{
            return this.doubleClick(this.index, item)
          }
        })
      })
    }.indicator(false)
    .disableSwipe(this.isDisableSwipe)
    .loop(false)
    .onSizeChange(() => {
      if (!this.init) {
        this.controller.changeIndex(this.index, false)
        this.init = true;
      }
    })
    .onChange((index)=>{
      let fn = PicturePreviewDataModel.getInstance().listener.onChange!
      fn(index, this.iconDatas.getData(index))
    })
    .onAnimationStart((index: number, targetIndex: number)=>{
      this.index = targetIndex;
      let fn = PicturePreviewDataModel.getInstance().listener.onAnimationStart!
      if (targetIndex != index) {
        fn(index, this.iconDatas.getData(index), targetIndex, this.iconDatas.getData(targetIndex))
      }
    })
    .onAnimationEnd((index: number)=>{
      let fn = PicturePreviewDataModel.getInstance().listener.onAnimationEnd!
      fn(index, this.iconDatas.getData(index))
    })
  }
}

@Component
struct ImageIte{
  @Prop item: IconData
  @Link isDisableSwipe: boolean;
  @Prop isZoom: boolean
  @Prop maxScale: number = 5;
  @State @Watch("setIsDisableSwipe") photoPinchGesture: PhotoGesture = new PhotoGesture(this.maxScale);
  @State private isError: boolean = false;
  @State private isLoading: boolean = true;
  @BuilderParam public loading: ((iconData: IconData)=>void) | undefined;
  // 单击事件
  click: () => void = ()=>{

  }
  // 双击
  doubleClick: () => boolean = ()=>{
    return false
  }

  // 图片地址
  @State path: ResourceStr = $r('app.media.photo_gallery_image_loading')

  private pictureCacheUtil: PictureCacheUtil = new PictureCacheUtil(getContext());

  aboutToAppear(): void {
    this.getPath()
  }

  private getPath() {
    this.path = $r('app.media.photo_gallery_image_loading')
    this.path = this.pictureCacheUtil.getPathOrUrl(this.item.path!, this.item.url!);
  }

  setIsDisableSwipe(){
    this.isDisableSwipe = (this.photoPinchGesture.scale > 1.2)
  }

  @Styles _PanGestureGesture() {
    .gesture(
      GestureGroup(GestureMode.Parallel,
        PinchGesture({ fingers: 2})
          .onActionUpdate((e) => {
            if (this.isZoom)
              this.photoPinchGesture.onPinchGestureActionUpdate(e)
          })
          .onActionEnd(()=>{
            if (this.isZoom)
              this.photoPinchGesture.onPinchGestureActionEnd()
          }),
        PanGesture()
          .onActionStart((e)=>{
            this.photoPinchGesture.onPanGestureActionStart()
          })
          .onActionUpdate((e)=>{
            if (this.photoPinchGesture.scale > 1) {
              this.photoPinchGesture.onPanGestureActionUpdate(e)
            }
          })
          .onActionEnd(()=>{
            if (this.photoPinchGesture.scale > 1) {
              this.photoPinchGesture.onPanGestureActionEnd()
            }
          }),
      )
    )
  }

  @Styles _Gesture() {
    .gesture(
      PinchGesture({ fingers: 2})
        .onActionUpdate((e) => {
          if (this.isZoom)
            this.photoPinchGesture.onPinchGestureActionUpdate(e)
        })
        .onActionEnd(()=>{
          if (this.isZoom)
            this.photoPinchGesture.onPinchGestureActionEnd()
        })
    )
  }

  @Builder MyImage() {
    Image(this.path)
      .objectFit(ImageFit.Contain)
      .sharedTransition("image")
      .draggable(false)
      .width("100%")
      .onComplete((event)=>{
        // 图片加载完成
        this.isLoading = false;
        this.photoPinchGesture.imageWidth = px2vp(event?.contentWidth!);
        this.photoPinchGesture.imageHeight = px2vp(event?.contentHeight!);
      })
      .onError(()=>{
        this.isError = true;
        setTimeout(()=>{
          this.isLoading = true;
          this.pictureCacheUtil.deletePath(this.path as string);
          this.getPath();
        }, 100)
      })
      .scale({
        x: this.photoPinchGesture.scale,
        y: this.photoPinchGesture.scale,
      })
      .offset({
        x: this.photoPinchGesture.offsetX,
        y: this.photoPinchGesture.offsetY
      })
  }

  build() {
    Stack(){
      if (!this.isError) {
        Column(){
          this.MyImage()
        }.width("100%")
        .height("100%")
        .justifyContent(FlexAlign.Center)
        ._Gesture()

        if (this.photoPinchGesture.isPanImage) {
          Column(){
            this.MyImage()
          }.width("100%")
          .height("100%")
          .justifyContent(FlexAlign.Center)
          ._PanGestureGesture()
        }

        // loading
        if (this.isLoading) {
          // 自定义loading是否存在
          if (this.loading) {
            this.loading(this.item)
          } else {
            Loading()
          }
        }
      } else {
        Column({space: 10}){
          Image($r('app.media.ic_gallery_list_damage2'))
            .interpolation(ImageInterpolation.High)
            .width(40)
            .height(40)

          Text("加载失败 点击重试")
            .fontColor("#fff")
        }.width("100%")
        .height("100%")
        .justifyContent(FlexAlign.Center)
        .onTouch((e)=>{
          e.stopPropagation()
        })
        .onClick(()=>{
          this.getPath()
          this.isError = false;
          this.isLoading = true
        })
      }
    }.onTouch((event: TouchEvent)=>{
      this.photoPinchGesture.clickOrDoubleClick(event, (type: number) => {
        let is = false;
        switch (type) {
          case 0:
            this.click()
            break;
          case 1:
            is = this.doubleClick()
            break;
        }
        return is;
      }, this.isZoom);
    })
  }
}