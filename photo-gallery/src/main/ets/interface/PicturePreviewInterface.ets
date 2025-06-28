
/**
 * 图片预览器的参数
 */
export interface PicturePreviewData{
  /**
   * 图片参数
   */
  iconDatas: IconData[];
  /**
   * 当前所在索引
   */
  index: number;
  /**
   * 功能开关参数
   */
  functionData?: FunctionData;
  /**
   * 样式参数
   */
  styleData?: StyleData;
  /**
   * 自定义功能参数
   */
  toolBuild?: ToolBuild;
  /**
   * 监听函数
   */
  listener?: PicturePreviewListener;
}

/**
 * 图片参数
 */
@Observed
export class IconData{
  /**
   * 图片名称
   */
  name?: string;
  /**
   * 图片后缀
   */
  suffix?: string;
  /**
   * 图片本地地址
   */
  path?: string;
  /**
   * 图片网络地址
   */
  url?: string;
}

/**
 * 功能参数
 */
export interface FunctionData {
  /**
   * 开启指示器 默认为true
   */
  indicator?: boolean;
  /**
   * 返回图标
   */
  backIcon?: ResourceStr;
  /**
   * 关闭长按保存功能 默认为true 开启后长按会触发保存相册弹窗
   */
  saveAlbum?: boolean;
  /**
   * 是否开启双击关闭功能 默认为true
   */
  isClickClose?: boolean;
  /**
   * 是否开启导航缩略图
   */
  isNavigationImage?: boolean;
  /**
   * 滚动后继续移动的时间
   */
  continueTime?: number;
  /**
   * 返回按钮是否显示
   */
  isBack?: boolean;
}

/**
 * 样式参数
 */
export interface StyleData {
  /**
   * 背景颜色
   */
  bgColor?: ResourceColor;
  /**
   * 上下滑动遮罩颜色是否渐变
   */
  isMaskGradient?: boolean;
  /**
   * 是否开启一镜到底转场
   */
  isTransition?: boolean;
  /**
   * 指示器颜色是否根据图片颜色变化而变化
   */
  isIndicatorColorVariation?: boolean
  /**
   * 是否允许缩放
   */
  isZoom?: boolean
  /**
   * 保存弹窗所在位置
   */
  saveLocation?: FlexAlign
  /**
   * 最大缩放倍数
   */
  maxScale?: number
}

/**
 * 自定义功能
 */
export interface ToolBuild {
  /**
   * 保存弹框
   * @param iconData 图片数据
   * @param close 用来关闭当前弹窗的回调
   */
  saveDialog?: (iconData: IconData, close: ()=>void) => void;
  /**
   * 工具栏
   * @param iconData 当前图片数据
   */
  tools?: (iconData: IconData) => void;
  /**
   * 自定义loading
   */
  loading?: (iconData: IconData) => void;
}

/**
 * 监听函数
 */
export interface PicturePreviewListener {
  /**
   * 监听图片切换
   * @param index 切换后的索引, data 切换后的图片数据
   */
  onChange?: (index: number, data: IconData) => void;
  /**
   * 监听图片切换动画开始
   * @param index 当前索引,
   * @param targetIndex 切换到的索引
   * @param iconData 切换前的图片数据
   */
  onAnimationStart? : (index: number, iconData: IconData, targetIndex: number | undefined, targetIconData: IconData | undefined) => void;
  /**
   * 监听图片切换动画结束
   * @param index 切换后的索引,
   * @param iconData 切换后的图片数据
   */
  onAnimationEnd? : (index: number, iconData: IconData) => void;
  /**
   * 监听图片长按
   * @param index 长按的索引, iconData 长按的图片数据
   * @returns 是否拦截长按事件
   */
  onLongPress?: (index: number, iconData: IconData) => boolean | void;
  /**
   * 监听图片双击
   * @param index 双击的索引, iconData 双击的图片数据
   * @returns 是否拦截双击事件
   */
  onDoubleTap?: (index: number, iconData: IconData) => boolean | void;
  /**
   * 监听图片点击
   * @param iconData 点击的图片数据
   * @returns 是否拦截点击事件
   */
  onClick?: (index: number, iconData: IconData) => boolean | void;
}