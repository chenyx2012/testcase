/**
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 */
import { PicturePreviewDataModel } from '../model/PicturePreviewDataModel';
import { PictureCacheUtil } from '../utils/PictureCacheUtil';

@Component
export struct Head{
  @Link index: number;
  iconSum: number = 0;
  backIcon: ResourceStr = $r('app.media.photo_gallery_public_arrow_left')
  onBack: ()=>void = ()=>{}

  build() {
    Stack() {
      // 是否展示返回按钮
      if (PicturePreviewDataModel.getInstance().functionData.isBack) {
        Row() {
          if (this.backIcon.toString() == "[object Object]" || this.backIcon.toString().includes("http")) {
            Image(this.backIcon.toString().includes('http')?new PictureCacheUtil(getContext()).getPathOrUrl('', this.backIcon as string,):this.backIcon)
              .height(35)
              .width(35)
              .onClick(()=>{
                this.onBack()
              })
          } else {
            Text(this.backIcon)
              .fontColor("#fff")
              .onClick(()=>{
                this.onBack()
              })
          }
        }.width("100%")
        .justifyContent(FlexAlign.Start)
        .padding({top: 35, left: 15, right: 15})
      }

      Row() {
        Text((this.index + 1) + "/" +this.iconSum)
          .fontSize(18)
          .fontColor("#fff")
      }.width("100%")
      .justifyContent(FlexAlign.Center)
      .padding({top: 35, left: 15, right: 15})
    }
  }
}