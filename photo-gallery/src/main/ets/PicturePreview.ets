import { common } from '@kit.AbilityKit'
import { ComponentContent, PromptAction, promptAction } from '@kit.ArkUI';
import { PicturePreviewData } from './interface/PicturePreviewInterface';
import { PicturePreviewDataModel } from './model/PicturePreviewDataModel';
import { PictureCacheUtil } from './utils/PictureCacheUtil';
import { PicturePreviewView } from './view/PicturePreviewView';

/**
 * 视频预览器
 */
export class PicturePreview {
  private static contentNode: ComponentContent<Object>;
  private static promptAction: PromptAction;
  /**
   * 打开图片预览器
   * @returns 组件内容的实体
   */
  static async open(
    picturePreviewData: PicturePreviewData,
    transition: TransitionEffect = TransitionEffect.OPACITY.animation({duration: 100}).combine(
      TransitionEffect.opacity(0)
    )
  ): Promise<ComponentContent<Object>> {
    // 获取应用上下文
    const context = getContext() as common.UIAbilityContext;
    const windowStage = context.windowStage;
    const mainWindow = await windowStage.getMainWindow();
    const uiContext = mainWindow.getUIContext();
    PicturePreview.promptAction = uiContext.getPromptAction();

    // 初始化数据
    PicturePreviewDataModel.getInstance().init(picturePreviewData);

    // 设置打开的弹窗
    let contentNode = new ComponentContent(uiContext, wrapBuilder(PicturePreviewView), picturePreviewData);
    PicturePreview.contentNode = contentNode;
    // 打开弹窗，并设置弹窗遮罩颜色
    PicturePreview.promptAction.openCustomDialog(PicturePreview.contentNode, {
      maskColor: "#00ffffff",
      transition: transition
    })
    return contentNode;
  }

  /**
   * 关闭当前弹窗
   */
  static close() {
    PicturePreview.promptAction.closeCustomDialog(PicturePreview.contentNode)
    PicturePreviewDataModel.destroy()
  }
}


