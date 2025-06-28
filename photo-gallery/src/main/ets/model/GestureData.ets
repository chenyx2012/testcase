import { display } from '@kit.ArkUI';
import { FunctionData } from '../interface/PicturePreviewInterface';
import { PicturePreview } from '../PicturePreview';
import { PicturePreviewDataModel } from './PicturePreviewDataModel';

export class PhotoGesture {
  // 缩放比例
  scale: number = 1;
  // 上一次最后的缩放比例
  lastScale: number = 1;
  // 偏移量
  offsetX: number = 0;
  // 偏移量
  offsetY: number = 0;
  // 上一次最后的偏移量
  centerOffsetX: number = 0;
  // 上一次最后的偏移量
  centerOffsetY: number = 0;
  // 图片宽度
  imageWidth: number = 0;
  // 图片高度
  imageHeight: number = 0;
  // 最大缩放倍数
  maxScale: number;
  // 第一次点击有效时间
  firstTime: number = 0;
  // 按下时间
  pressTime: number = 0;
  // 抬起时间
  upTime: number = 0;
  // 按下位置 X
  pressX: number = 0;
  // 按下位置 Y
  pressY: number = 0;
  // 抬起位置 X
  upX: number = 0;
  // 抬起位置 Y
  upY: number = 0;
  // 有效点击次数
  clickNum: number = 0;
  // 点击事件计时器
  timeIndex: number = 0;
  // 是否展示平移控制图片
  isPanImage: boolean = false;
  // 上一次记录偏移量Y
  previousRecordOffsetX: number = 0;
  // 上一次记录偏移量Y
  previousRecordOffsetY: number = 0;
  // 当前记录偏移量Y
  currentRecordOffsetX: number = 0;
  // 当前记录偏移量Y
  currentRecordOffsetY: number = 0;
  // 记录偏移量的计时ID
  recordId: number = 0;
  // 继续移动计时Id
  continueMoveId: number = 0;
  // 是否正在继续移动
  isContinueMove: boolean = false;
  private functionData: FunctionData = PicturePreviewDataModel.getInstance().functionData;

  constructor(maxScale: number) {
    this.maxScale = maxScale;
  }

  // 捏合手势
  onPinchGestureActionUpdate(event: GestureEvent) {
    animateTo({ duration: 50 }, () => {
      if (event.scale > 1) {
        this.scale = this.lastScale + (event.scale - 1);
      } else {
        // 缩小
        this.scale = this.lastScale - (1 - event.scale) * this.scale
      }
      this.scale = this.scale < 1 ? 1 : this.scale;
      this.scale = this.scale > this.maxScale ? this.maxScale : this.scale;
    })

    this.controlMargins()
  }

  onPinchGestureActionEnd() {
    this.setIsPanImage(this.scale)
    this.lastScale = this.scale;
  }

  // 平移手势
  onPanGestureActionStart() {
    this.finishContinueMove()
    this.recordOffset();
  }

  onPanGestureActionUpdate(event: GestureEvent) {
    this.offsetX = this.centerOffsetX + event.offsetX;
    this.offsetY = this.centerOffsetY + event.offsetY;
    this.controlMargins()
  }

  onPanGestureActionEnd() {
    this.centerOffsetX = this.offsetX;
    this.centerOffsetY = this.offsetY;
    this.finishRecordOffset();
  }

  // 记录偏移量
  recordOffset() {
    this.recordId = setInterval(() => {
      // 记录上一次偏移量
      this.previousRecordOffsetX = this.currentRecordOffsetX === 0 ? this.offsetX : this.currentRecordOffsetX;
      this.previousRecordOffsetY = this.currentRecordOffsetY === 0 ? this.offsetY : this.currentRecordOffsetY;

      // 记录这一次
      this.currentRecordOffsetX = this.offsetX;
      this.currentRecordOffsetY = this.offsetY;
      console.log(`TangYuYi Test previousRecordOffsetX: ${this.previousRecordOffsetX} , previousRecordOffsetY: ${this.previousRecordOffsetY}`)
      console.log(`TangYuYi Test currentRecordOffsetX: ${this.currentRecordOffsetX} , currentRecordOffsetY: ${this.currentRecordOffsetY}`)
    }, PicturePreviewDataModel.continueTimeInterval)
  }

  // 结束记录偏移量
  finishRecordOffset() {
    clearInterval(this.recordId);
    this.continueMove();
  }

  // 根据之前的移动继续移动
  continueMove() {
    this.isContinueMove = true;
    // 计算每5ms偏移量；
    let x = 0;
    let y = 0;
    x = (this.currentRecordOffsetX - this.previousRecordOffsetX) / (PicturePreviewDataModel.continueTimeInterval / PicturePreviewDataModel.continueMoveTime);
    y = (this.currentRecordOffsetY - this.previousRecordOffsetY) / (PicturePreviewDataModel.continueTimeInterval / PicturePreviewDataModel.continueMoveTime);
    console.log(`TangYuYi Test x: ${x} , y: ${y}`)

    // 计算每5ms减少速度
    let time = PicturePreviewDataModel.getInstance().functionData.continueTime!; // 总时间
    let speedX = x / (time / PicturePreviewDataModel.continueMoveTime);
    let speedY = y / (time / PicturePreviewDataModel.continueMoveTime);

    let intervalTime = 0;
    this.continueMoveId = setInterval(() => {
      if (intervalTime > time) {
        this.finishContinueMove()
      }
      x -= speedX;
      y -= speedY;

      this.offsetX = this.offsetX + x;
      this.offsetY = this.offsetY + y;
      this.controlMargins()
      intervalTime += PicturePreviewDataModel.continueMoveTime;
    }, PicturePreviewDataModel.continueMoveTime)
  }

  // 结束继续移动
  finishContinueMove() {
    console.log('TangYuYi Test finishContinueMove')
    clearInterval(this.continueMoveId)
    this.centerOffsetX = this.offsetX;
    this.centerOffsetY = this.offsetY;

    this.previousRecordOffsetX = 0;
    this.previousRecordOffsetY = 0;
    this.currentRecordOffsetX = 0;
    this.currentRecordOffsetY = 0;

    this.isContinueMove = false;
  }

  // 双击事件
  onTapGestureAction() {
    if (this.scale > 1.5) {
      this.setIsPanImage(1)
      animateTo({ duration: 300 }, () => {
        this.scale = 1
        this.lastScale = 1
        this.offsetX = 0
        this.offsetY = 0
        this.centerOffsetX = 0
        this.centerOffsetY = 0
      })
    } else {
      this.setIsPanImage(2)
      this.scale = this.maxScale > 1.05 ? 1.05 : this.maxScale
      animateTo({ duration: 300 }, () => {
        this.scale = this.maxScale > 3 ? 3 : this.maxScale;
        this.lastScale = this.maxScale > 3 ? 3 : this.maxScale
      })
    }
  }

  // 控制边距
  controlMargins() {
    let phoneWidth: number = px2vp(display.getDefaultDisplaySync().width);
    let phoneHeight: number = px2vp(display.getDefaultDisplaySync().height);
    let phoneOffsetX: number = ((phoneWidth * this.scale) - phoneWidth) / 2;
    // 控制左边距
    if (this.offsetX > 0 && this.offsetX > phoneOffsetX) {
      this.offsetX = phoneOffsetX
    }
    // 控制右边距
    if (this.offsetX < 0 && this.offsetX < -phoneOffsetX) {
      this.offsetX = -phoneOffsetX
    }

    if (this.imageHeight * this.scale > phoneHeight) {
      // 控制上边距
      if (this.offsetY > 0 && this.offsetY > ((this.imageHeight * this.scale) - phoneHeight) / 2) {
        this.offsetY = ((this.imageHeight * this.scale) - phoneHeight) / 2
      }
      // 控制下边距
      if (this.offsetY < 0 && this.offsetY < -((this.imageHeight * this.scale) - phoneHeight) / 2) {
        this.offsetY = -((this.imageHeight * this.scale) - phoneHeight) / 2
      }
    } else {
      this.offsetY = 0;
    }
  }

  // 计算是双击还是单击，并执行相应的效果
  clickOrDoubleClick(event: TouchEvent, click: (type: number) => boolean, isZoom: boolean = true,) {
    if (this.isContinueMove) {
      this.finishContinueMove()
    }

    // 判断按下松开位置和两次的时间是否为1次有效点击
    clearTimeout(this.timeIndex);
    if (event.type === TouchType.Down && event.touches.length === 1) {
      this.pressTime = new Date().getTime();
      this.pressX = event.touches[0].windowX;
      this.pressY = event.touches[0].windowY;
    }
    if (event.type === TouchType.Up) {
      if (event.touches.length === 1) {
        this.upTime = new Date().getTime();
        this.upX = event.touches[0].windowX;
        this.upY = event.touches[0].windowY;
      }
      if (this.upTime - this.pressTime < 120 && Math.abs(this.pressX - this.upX) < 5 &&
        Math.abs(this.upY - this.pressY) < 5) {
        if (this.clickNum === 0) {
          this.clickNum = 1;
          this.firstTime = this.upTime;
          setTimeout(() => {
            this.clickNum = 0;
          }, 335)

          // 单击关闭页面
          this.timeIndex = setTimeout(() => {
            click(0)
          }, 350)
        } else if (this.clickNum === 1) {
          this.clickNum = 0;
          if (this.upTime - this.firstTime < 330) {
            if (isZoom) {
              // 双击缩放图片
              let is = click(1);
              if (!is) {
                this.onTapGestureAction();
              }
            }
          }
        }
      }
    }
  }

  // 设置是否展示平移控制图片
  private setIsPanImage(scale: number) {
    if (scale > 1) {
      this.isPanImage = true
    } else {
      this.isPanImage = false

      this.finishRecordOffset()
      this.finishContinueMove()
    }
    console.log(`TangYuYi Test setIsPanImage: ${this.isPanImage}`)
  }
}
