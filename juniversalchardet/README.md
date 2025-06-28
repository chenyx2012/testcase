# juniversalchardet

## Introduction

juniversalchardet is a character encoding detector for text files. It can automatically recognize a variety of character encodings, including common ones such as UTF-8, UTF-16, ISO-8859, and specific encodings for some Asian languages. This library helps you accurately detect character encodings in text data, avoiding garbled text and decoding errors. It provides simple and easy-to-use APIs for seamless integration into projects, along with reliable performance and accuracy.

![Animation](./animation.gif)

## How to Install

```
  ohpm install @ohos/juniversalchardet
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

Two methods are provided for text encoding detection:

- Method 1: Detect the encoding by file path.<br>
  UniversalDetector.detectCharset(path);

  ```ts
  // Pass the file path parameter.
  let filePath = getPath() + file;
  UniversalDetector.detectCharset(filePath)
    .then((encoing) => {
      // encoding indicates the encoding name, for example, UTF-8.
    })
    .catch((err) => {
      // Error information
    });
  ```

- Method 2: Detect the encoding by data.<br>
  UniversalDetector.handleData(buf, offset, length);

  ```ts
   detect(data: ArrayBuffer): string {
       // Create a detector object.
       let detector: UniversalDetector = new UniversalDetector();
       // Pass the data for detection and determine the encoding format in real time.
       detector.handleData(data, 0, data.byteLength);
       // Mark the end of data detection.
       detector.dataEnd();
       // Obtain the detection result.
      let detected: string = detector.getDetectedCharset();
       // Release resources.
       detector.reset();

       return detected;
    }
  ```

## Available APIs

`let detector: UniversalDetector = new UniversalDetector();`

1. Input data to the detector: **detector.handleData()**
2. Obtain the character set of the content from **InputStream**: UniversalDetector.detectCharset()
3. Mark the end of data detection: **detector.dataEnd()**
4. Obtain the detection result: **detector.getDetectedCharset()**
5. Reset the detector: **detector.reset()**

For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-sig/juniversalchardet/blob/master/TEST.md).

## Constraints

This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API 12 Release (5.0.0.66)
- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), OpenHarmony SDK: API 9 Release (3.2.11.9)

## Directory Structure

```
|---- juniversalchardet
|     |---- entry                                    # Sample code
|     |---- library                                  # Library
|          |----src
|               |----main
|                   |----ets
|                      |----prober # Detector files
|                          |----constextanalysis     # Context analysis
|                          |----distributionanalysis # Distribution analysis
|                          |----sequence             # Sequence models
|                          |----statemachine         # Service processing
|          |---- index.ets                           # External APIs
|     |---- README.md                                # Readme
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-sig/juniversalchardet/issues) or a [PR](https://gitee.com/openharmony-sig/juniversalchardet/pulls).

## License

This project is licensed under [MPL 1.1 License](https://gitee.com/openharmony-sig/juniversalchardet/blob/master/LICENSE).
