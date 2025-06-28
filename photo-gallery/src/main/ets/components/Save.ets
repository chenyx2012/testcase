/**
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
import { IconData, StyleData, ToolBuild } from '../interface/PicturePreviewInterface'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';
import { PicturePreviewDataModel } from '../model/PicturePreviewDataModel';

@Component
export struct Save{
  @Link saveIs: boolean
  @Prop styleData: StyleData = PicturePreviewDataModel.getInstance().styleData;
  @Prop toolBuild: ToolBuild = PicturePreviewDataModel.getInstance().toolBuild;
  @Prop iconData: IconData;
  private close: ()=>void = ()=>{
    this.saveIs = false;
  }

  private async saveImage(result:SaveButtonOnClickResult, uri: string) {
    let path: string = "";
    path = uri.replace(fileUri.getUriFromPath(""), "");

    if (result == SaveButtonOnClickResult.SUCCESS) {
      try {
        const context = getContext(this);
        let helper = photoAccessHelper.getPhotoAccessHelper(context);
        // onClick触发后10秒内通过createAsset接口创建图片文件，10秒后createAsset权限收回。
        let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
        // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
        let file = fileIo.openSync(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        let file2 = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        // 写入文件
        fileIo.copyFileSync(file2.fd, file.fd)
        // 关闭文件
        fileIo.closeSync(file.fd);
        fileIo.closeSync(file2.fd);

        promptAction.showToast({message: "保存成功"})
        this.close()
      } catch (error) {
        console.error("error is "+ JSON.stringify(error));
        promptAction.showToast({message: "保存失败"})
      }
    }
  }

  @Builder Save(){
    Column({space: 10}){
      Text("保存到相册")
        .margin({top: 20})
      Row(){
        SaveButton({text: SaveDescription.SAVE_TO_GALLERY})
          .width("50%")
          .height("50")
          .fontColor("#ff3cc800")
          .backgroundColor("#fff")
          .onClick((event:ClickEvent, result:SaveButtonOnClickResult) => {
            this.saveImage(result, this.iconData.path!)
          })

        Text("取消")
          .width("50%")
          .height("50")
          .textAlign(TextAlign.Center)
          .fontColor("#ffb30000")
          .onClick(()=>{
            this.saveIs = false;
          })
      }.width("100%")
    }.width("90%")
    .constraintSize({
      maxWidth: 500
    })
    .backgroundColor("#fff")
    .borderRadius(15)
    .margin({bottom: 30})
    .onClick(()=>{})
  }


  // 自定义的保存按钮
  @BuilderParam saveDialog: (iconData: IconData, close: ()=>void)=>void = this.Save

  aboutToAppear(): void {
    if (this.toolBuild?.saveDialog) {
      this.saveDialog = this.toolBuild.saveDialog;
    }
  }

  build() {
    Column(){
      this.saveDialog(this.iconData, this.close)
    }.width("100%")
    .height("100%")
    .justifyContent(this.styleData?.saveLocation? this.styleData?.saveLocation : FlexAlign.End)
    .backgroundColor("#8f000000")
    .alignItems(HorizontalAlign.Center)
    .onClick(()=>{
      this.close()
    })
  }
}