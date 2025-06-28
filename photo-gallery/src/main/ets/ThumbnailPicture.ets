import { ImageComplete } from './interface/imageinterface'
import { IconData } from './interface/PicturePreviewInterface'
import { PictureCacheUtil } from './utils/PictureCacheUtil'
import { PicturePreview } from './PicturePreview'
import { SwipeRefresher } from '@ohos.arkui.advanced.SwipeRefresher'

@Component
export struct ThumbnailPicture{
  // 图片是否正在下载中
  @State private isLoading: boolean = true;
  // 图片是否加载失败
  @State private isError: boolean = false;
  // 图片地址
  @State private path: ResourceStr = $r('app.media.photo_gallery_image_loading')
  // 自定义浮层
  @Builder private test() {};
  @BuilderParam FloatingLayer: ()=>void = this.test;

  // 图片数据
  @Prop iconData: IconData
  // 图片宽度
  @State imageWidth: number | string = 150;
  // 图片高度
  @State imageHeight: number | string = 150;
  // 边框圆角
  radius: number = 5;
  // 图片的点击回调
  click: (clickEvent: ClickEvent)=>void = ()=>{};
  // 图片加载完成后的回调
  complete: (event?: ImageComplete | undefined) => void = ()=>{}
  // 是否可以默认跳转预览页面
  isToPreview: boolean = false;

  private pictureCacheUtil: PictureCacheUtil = new PictureCacheUtil(getContext());

  aboutToAppear(): void {
    this.getPath()
  }

  private getPath(){
    this.path = $r('app.media.photo_gallery_image_loading')
    this.path = this.pictureCacheUtil.getPathOrUrl(this.iconData.path!, this.iconData.url!);
  }

  build() {
    Stack(){
      if (!this.isError) {
        Image(this.path)
          .width("100%")
          .sharedTransition("image")
          .height("100%")
          .onComplete((event)=>{
            this.isLoading = false
            this.complete(event)
          })
          .onError(()=>{
            this.isError = true;
            this.pictureCacheUtil.deletePath(this.path as string);
            this.getPath();
          })

        if (this.isLoading) {
          Column(){
            SwipeRefresher({isLoading: true, content: "加载中"})
          }.width("100%")
          .height("100%")
          .justifyContent(FlexAlign.Center)
          .backgroundColor("#d8ffffff")
        } else {
          this.FloatingLayer()
        }
      } else {
        Column(){
          Image($r('app.media.ic_gallery_list_damage'))
            .width(25)
            .height(25)
        }.width("100%")
        .height("100%")
        .borderRadius(this.radius)
        .borderWidth(1)
        .borderColor("#ddd")
        .justifyContent(FlexAlign.Center)
        .backgroundColor("#55ffffff")
        .onClick(()=>{
          this.getPath()
          this.isError = false;
          this.isLoading = true
        })
      }
    }.width(this.imageWidth)
    .height(this.imageHeight)
    .constraintSize({
      minWidth: 30,
      minHeight: 30
    })
    .borderRadius(this.radius)
    .clip(true)
    .onClick(event => {
      if (this.isToPreview) {
        PicturePreview.open({
          iconDatas: [this.iconData],
          index: 0,
        });
      }
      this.click(event)
    })
  }
}