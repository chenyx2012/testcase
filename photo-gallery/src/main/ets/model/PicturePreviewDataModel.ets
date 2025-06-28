import { FunctionData,
  IconData,
  PicturePreviewData,
  PicturePreviewListener,
  StyleData, ToolBuild } from "../interface/PicturePreviewInterface";

/**
 * 图片预览数据单例
 */
export class PicturePreviewDataModel {
  private static instance: PicturePreviewDataModel | undefined;
  private constructor() {
  }
  public static getInstance(): PicturePreviewDataModel {
    if (!PicturePreviewDataModel.instance) {
      PicturePreviewDataModel.instance = new PicturePreviewDataModel();
    }
    return PicturePreviewDataModel.instance;
  }

  // 继续移动的时间
  public static continueTime: number = 500;
  // 继续移动多少秒移动一帧
  public static continueMoveTime: number = 5;
  // 多少ms记录一次运动轨迹
  public static continueTimeInterval: number = 10;

  // 功能参数
  functionData: FunctionData = {
    indicator: true,
    backIcon: $r('app.media.photo_gallery_public_arrow_left'),
    saveAlbum: true,
    isClickClose: true,
    isNavigationImage: true,
    continueTime: 500,
    isBack: true
  };
  // 样式参数
  styleData: StyleData = {
    bgColor: "#000",
    isMaskGradient: true,
    isTransition: true,
    isIndicatorColorVariation: true,
    isZoom: true,
    saveLocation: FlexAlign.End,
    maxScale: 5
  };
  // 自定义功能
  toolBuild: ToolBuild = {};
  // 监听函数
  listener: PicturePreviewListener = {
    onChange: (index: number, data: IconData) => {
      // console.info("PicturePreview onChange index:" + index + " data:" + JSON.stringify(data));
    },
    onAnimationStart: (index: number, iconData: IconData, targetIndex: number | undefined, targetIconData: IconData | undefined) => {
      // console.info("PicturePreview onAnimationStart index:" + index + " targetIndex:" + targetIndex + " iconData:" + JSON.stringify(iconData) + " targetIconData:" + JSON.stringify(targetIconData));
    },
    onAnimationEnd: (index: number, iconData: IconData) => {
      // console.info("PicturePreview onAnimationEnd index:" + index + " iconData:" + JSON.stringify(iconData));
    },
    onLongPress: (index: number, iconData: IconData) => {
      // console.info("PicturePreview onLongPress index:" + index + " iconData:" + JSON.stringify(iconData));
      return false;
    },
    onDoubleTap: (index: number, iconData: IconData) => {
      // console.info("PicturePreview onDoubleTap index:" + index + " iconData:" + JSON.stringify(iconData));
      return false;
    },
    onClick: (index: number, iconData: IconData) => {
      // console.info("PicturePreview onClick index:" + index + " iconData:" + JSON.stringify(iconData));
      return false;
    }
  };

  /**
   * 初始化数据
   * @param picturePreviewData
   */
  public init(picturePreviewData: PicturePreviewData) {
    this.initFunctionData(picturePreviewData.functionData)
    this.initStyleData(picturePreviewData.styleData)
    this.initToolBuild(picturePreviewData.toolBuild)
    this.initListener(picturePreviewData.listener)
  }

  /**
   * 销毁数据
   */
  public static destroy() {
    PicturePreviewDataModel.instance = undefined;
  }

  /**
   * 初始化功能参数
   * @param picturePreviewData
   */
  private initFunctionData(fnData: FunctionData | undefined) {
    if (fnData) {
      if (fnData.indicator != undefined) {
        this.functionData.indicator = fnData.indicator;
      }
      if (fnData.backIcon != undefined) {
        this.functionData.backIcon = fnData.backIcon;
      }
      if (fnData.saveAlbum != undefined) {
        this.functionData.saveAlbum = fnData.saveAlbum;
      }
      if (fnData.isClickClose != undefined) {
        this.functionData.isClickClose = fnData.isClickClose;
      }
      if (fnData.isNavigationImage != undefined) {
        this.functionData.isNavigationImage = fnData.isNavigationImage;
      }
      if (fnData.continueTime != undefined) {
        this.functionData.continueTime = fnData.continueTime;
      }
      if (fnData.isBack != undefined) {
        this.functionData.isBack = fnData.isBack;
      }
    }
  }
  /**
   * 初始化样式参数
   * @param picturePreviewData
   */
  private initStyleData(stData: StyleData | undefined) {
    if (stData) {
      if (stData.bgColor != undefined) {
        this.styleData.bgColor = stData.bgColor
      }
      if (stData.isMaskGradient != undefined) {
        this.styleData.isMaskGradient = stData.isMaskGradient
      }
      if (stData.isTransition != undefined) {
        this.styleData.isTransition = stData.isTransition
      }
      if (stData.isIndicatorColorVariation != undefined) {
        this.styleData.isIndicatorColorVariation = stData.isIndicatorColorVariation
      }
      if (stData.isZoom != undefined) {
        this.styleData.isZoom = stData.isZoom
      }
      if (stData.saveLocation != undefined) {
        this.styleData.saveLocation = stData.saveLocation
      }
      if (stData.maxScale != undefined) {
        this.styleData.maxScale = stData.maxScale
      }
    }
  }
  /**
   * 初始化自定义功能
   * @param picturePreviewData
   */
  private initToolBuild(toolBuild: ToolBuild | undefined) {
    if (toolBuild) {
      if (toolBuild.saveDialog) {
        this.toolBuild.saveDialog = toolBuild.saveDialog;
      }
      if (toolBuild.tools) {
        this.toolBuild.tools = toolBuild.tools;
      }
      if (toolBuild.loading) {
        this.toolBuild.loading = toolBuild.loading;
      }
    }
  }
  /**
   * 初始化监听函数
   * @param picturePreviewData
   */
  private initListener(listener: PicturePreviewListener | undefined) {
    if (listener) {
      if (listener.onChange) {
        this.listener.onChange = listener.onChange;
      }
      if (listener.onLongPress) {
        this.listener.onLongPress = listener.onLongPress;
      }
      if (listener.onDoubleTap) {
        this.listener.onDoubleTap = listener.onDoubleTap;
      }
      if (listener.onClick) {
        this.listener.onClick = listener.onClick;
      }
    }
  }
}