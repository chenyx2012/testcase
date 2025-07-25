/**
 Copyright 2024 csx - @yunkss/ef_ui

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


import { LoadingDialog } from '@kit.ArkUI'
import { UiConst } from '@yunkss/ef_core';

/**
 * @Author csx
 * @DateTime 2024/3/25 15:54:03
 * @TODO LoadingUtil 全局加载工具类
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_ui
 */
@Component
export struct LoadingUtil {
  @Prop @Watch("change") options: LoadOptions = new LoadOptions();
  /**
   * 自定义loading
   */
  private dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: this.options.content
    }),
    autoCancel: false,
    alignment: this.options.alignment != undefined ? this.options.alignment : DialogAlignment.Center,
    offset: this.options.offset != undefined ? this.options.offset :
      this.options.alignment == DialogAlignment.Bottom || this.options.alignment == DialogAlignment.BottomEnd ||
        this.options.alignment == DialogAlignment.BottomStart ? {
        dx: 0,
        dy: -20
      } : this.options.alignment == DialogAlignment.Top || this.options.alignment == DialogAlignment.TopStart ||
        this.options.alignment == DialogAlignment.TopEnd ? {
        dx: 0,
        dy: 50
      } : { dx: 0, dy: 0 },
    customStyle: true,
    gridCount: 10,
    maskRect: {
      x: 0,
      y: 0,
      width: '100%',
      height: '100%'
    },
    openAnimation: { duration: 500, tempo: 0.7, curve: Curve.EaseInOut },
    closeAnimation: { duration: 500, tempo: 0.7, curve: Curve.FastOutLinearIn },
    showInSubWindow: this.options.showInSubWindow != undefined ? this.options.showInSubWindow : false,
    isModal: true
  })

  change() {
    if (!this.options.content) {
      this.options.content = '正在拼命加载中,请稍后...';
    }
    if (this.options.alignment == undefined) {
      this.options.alignment = DialogAlignment.Center;
    }
    if (this.options.show) {
      this.show();
    } else {
      this.close()
    }
  }

  /**
   * 打开全局加载模态框
   */
  show() {
    this.dialogControllerProgress.open();
  }

  /**
   * 关闭全局加载模态框
   */
  close() {
    this.dialogControllerProgress.close();
  }

  build() {
    Row()
  }
}

/**
 * 加载框参数
 */
class LoadOptions {
  /**
   * 弹窗在竖直方向上的对齐方式
   */
  public alignment?: DialogAlignment;
  /**
   * 弹窗相对alignment所在位置的偏移量
   */
  public offset?: Offset;
  /**
   * 是否显示在主窗口之外
   */
  public showInSubWindow?: boolean;
  /**
   * 加载内容
   */
  public content?: ResourceStr;
  /**
   * 是否显示
   */
  public show?: boolean;
}