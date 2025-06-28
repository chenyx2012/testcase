# XLog
[Android XLog](https://github.com/elvishew/xLog)

基于OpenHarmony/HarmonyOS使用ArkTS重写的XLog日志框架库，
具备轻量、美观强大、可扩展的特性。

## 快速开始

安装

```shell
ohpm install @ohos-port/xlog
```

导入

```typescript
import { XLog } from '@ohos/xlog';
```

初始化

```typescript
XLog.init();
```

打印日志

```typescript
XLog.i("你好 xlog");
```

## 配置

`xLog` 具有高度可扩展性，几乎任何一个组件都是可配置的。

```typescript
let config = new LogConfiguration.Builder()
    .setTag("XLog")
    .build();
let printer = new FilePrinter.Builder(`${filesDir}/log`)
  .setCleanStrategy(new FileLastModifiedCleanStrategy(24 * 60 * 60 * 1000)) //24h
  .setFileNameGenerator(new DateFileNameGenerator())
  .setBackupStrategy(new FileSizeBackupStrategy(10 * 1024 * 1024)) // 10MB
  .build();
XLog.init(config, [printer, new OhPrinter()]);
```

## 注册worker
- 创建一个worker类如[XLogWorker.ets](#注册worker)
```typescript
import worker from '@ohos.worker';
import { logHandler, logErrorHandler } from '@ohos/xlog/XLogBaseWorker'

worker.workerPort.onmessage = logHandler;
worker.workerPort.onerror = logErrorHandler;
```
- 在build-profile.json5中声明worker
``` json
  "buildOption": {
    "sourceOption": {
      "workers": [
        "./src/main/ets/workers/XLogWorker.ets"
      ]
    }
  }
```

## 参与贡献

主要写参与贡献的人以及个人主页链接

[@wathinst](https://gitee.com/wathinst) [@michael-eddy](https://gitee.com/michael-eddy) [@Mrxxy](https://gitee.com/Mr_xxy)