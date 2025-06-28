# juniversalchardet

## 简介

> juniversalchardet 是一个用于检测文本文件的字符编码。它能够自动识别多种字符编码，包括常见的 UTF-8、UTF-16、ISO-8859 等，以及一些亚洲语言的特定编码。这个库可以帮助开发者在处理文本数据时准确地识别字符编码，从而避免乱码和解码错误。juniversalchardet 提供了简单易用的 API，可以轻松地集成到项目中，并且具有良好的性能和准确度。

![动画](./动画.gif)

## 下载安装

```
  ohpm install @ohos/juniversalchardet
```
OpenHarmony ohpm 环境配置等更多内容，请参考如何安装 [OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

### 文本编码检测

提供两种方法检测

- 方法一 通过文件路径检测编码
  UniversalDetector.detectCharset(path);

  ```ts
  // 传入文件路径参数
  let filePath = getPath() + file;
  UniversalDetector.detectCharset(filePath)
    .then((encoing) => {
      // encoding 编码名称 eg：UTF-8
    })
    .catch((err) => {
      // 异常信息
    });
  ```

- 方法二 通过数据检测编码
  UniversalDetector.handleData(buf, offset, length);

  ```ts
   detect(data: ArrayBuffer): string {
       //创建检测对象
       let detector: UniversalDetector = new UniversalDetector();
       // 传入检测数据并实时判断编码格式
       detector.handleData(data, 0, data.byteLength);
       // 标记检测数据 读取结束
       detector.dataEnd();
       // 获取检测结果
      let detected: string = detector.getDetectedCharset();
       // 释放资源
       detector.reset();

       return detected;
    }
  ```

## 接口说明

`let detector: UniversalDetector = new UniversalDetector();`

1. 向检测器输入数据 `detector.handleData()`
2. 从 InputStream 获取内容的符号集 `UniversalDetector.detectCharset()`
3. 读取结束 `detector.dataEnd()`
4. 检测到的编码 `detector.getDetectedCharset()`
5. 重置 `detector.reset()`

单元测试用例详情见[TEST.md](https://gitee.com/openharmony-sig/juniversalchardet/blob/master/TEST.md)

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806,SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.1 Canary(4.1.3.317)，OpenHarmony SDK: API11 Release(4.1.0.36)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2(3.1.0.400)，OpenHarmony SDK: API9 Release(3.2.11.9)

## 目录结构

```
|---- juniversalchardet
|     |---- entry  # 示例代码文件夹
|     |---- library  # juniversalchardet库 源码文件夹
|          |----src
|               |----main
|                   |----ets
|                      |----prober # 检测器文件
|                          |----constextanalysis # 语境分析
|                          |----distributionanalysis # 分布分析
|                          |----sequence # 序列模型
|                          |----statemachine # 业务处理
|          |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-sig/juniversalchardet/issues) 给组件，当然，也非常欢迎发 [PR](https://gitee.com/openharmony-sig/juniversalchardet/pulls) 共建。

## 开源协议

本项目基于 [MPL-1.1 License](https://gitee.com/openharmony-sig/juniversalchardet/blob/master/LICENSE) ,请自由地享受和参与开源。
