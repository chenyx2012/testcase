/* ***** BEGIN LICENSE BLOCK *****
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

or

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the " Software"), to deal in 
the Software without restriction, including without limitation the rights to use, copy, 
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) 
shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ***** END LICENSE BLOCK ***** */

import fs from '@ohos.file.fs';
import prompt from '@system.prompt';
import { UniversalDetector } from '@ohos/juniversalchardet';
import { EncodingDetectorInputStream } from '@ohos/juniversalchardet';
import { EncodingDetectorOutputStream } from '@ohos/juniversalchardet';
import { GlobalContext } from '../entryability/GlobalContext';

function getPath(): string {
  let context:Context = GlobalContext.getContext().getObject("context") as Context
  let filesDir: string = context.filesDir
  let path: string = filesDir + '/';
  console.warn(`---> api-9 path:${path}`)
  return path
}


const asciiFile: string = 'ascii.txt';
const utf8File: string = 'utf8.txt';
const utf8nFile: string = 'utf8n.txt';
const utf16leFile: string = 'utf16le.txt';
const shiftjisFile: string = 'shiftjis.txt';
const eucFile: string = 'euc.txt';
const iso2022jpFile: string = 'iso2022jp.txt';
const big5File: string = 'big5.txt';
const euctwFile: string = 'euctw.txt';
const euckrFile: string = 'euckr.txt';
const windows1255File: string = 'windows1255.txt';
const utf8nEmojiFile: string = 'utf8n-emoji.txt';
const gb2312SampleFile: string = 'gb2312-sample.txt';
const gbkSampleFile: string = 'gbk-sample.txt';
const tis620File: string = 'tis620.txt';
const bug8VariousFailedCharsetsFile: string = 'bug8-various-failed-charsets.dat';
const bug20ExampleLatinFile: string = 'bug20-example-latin.txt';
const gb18030File: string = 'gb18030.txt';
const iso88598File: string = 'iso88598.txt';

@Entry
@Component
struct Index {
  @State encoding: string = '';
  @State BasicFileEncodingDetection: String[] = [asciiFile, utf8File, utf8nFile, utf16leFile, shiftjisFile,
    eucFile, iso2022jpFile, big5File, euctwFile, euckrFile, windows1255File, utf8nEmojiFile]
  @State GB18030SamplesTest: String[] = [gb2312SampleFile, gbkSampleFile]
  @State GB18030SMFalsePositiveTest: String[] = ['[°4°0°T°C°C°0°C°T', 'Wykamol,£588.95,0.18,0.12,testingSpecialised Products for DIY and Professionals£12']
  @State TIS620BasicTest: String[] = [tis620File]
  @State Bug8VariousFailedCharsets: String[] = ['wPzDvCCwy7v2', 'W1Nhbm9va10gt7TKzbq70a3L0qHSw83o0rnA0snS5LfCzdWhpMPR6acg8fLz', 'zfjS19PKz+TX1Lavu9i4tDo=']
  @State ShortStringTests: String[] = ['aeaCàêäÇ', 'Château', 'abcd']
  @State TestDetectorFile: String[] = [bug8VariousFailedCharsetsFile, bug20ExampleLatinFile, gb18030File, iso88598File]
  @State BasicStreamEncodingDetection: String[] = [utf8File, utf8nFile, utf16leFile, shiftjisFile,
    eucFile, iso2022jpFile, big5File, euctwFile, euckrFile, windows1255File, utf8nEmojiFile]
  @State Bug20LatinDetectedAsMaccyrillic: String[] = ['ÄÜÖßäöü,Name1ÄÜÖßäöü,Name2ÄÜÖßäöü,Name3ÄÜÖßäöü,StreetÄÜÖßäöü,MÄÜÖßäöü,DE,80080,München,ContactÄÜÖßäöü,+49(0)ÄÜÖßäöü,ÄÜÖßäöü@gls-itservices.com,CommentÄÜÖßäöü,+49,(0)98,765,432,BlÄÜÖßäöü'];
  @State Bug33USASCIIToGenerous: String[] = ['testZipHeader']
  @State TestDetector: String[] = ['testDetector']
  // For the base64 encoding pieces.
  alphabet: string[] = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'
  ];
  values: number[] = new Array();

  build() {
    Scroll() {
      Column({ space: 5 }) {
        Text('BasicFileEncodingDetectionTest(12) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.BasicFileEncodingDetection, (file: string) => {
            GridItem() {
              Text(file)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(80)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + file;
                  UniversalDetector.detectCharset(filePath).then((encoing) => {
                    console.info('---> UniversalDetector.detectCharset:' + (this.encoding += encoing));
                    this.showResult();
                  }).catch((err: Error) => {
                    this.encoding = 'detect charset err:' + JSON.stringify(err)
                    this.showResult();
                  });
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(170)

        Text('GB18030SamplesTest(2) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.GB18030SamplesTest, (file: string) => {
            GridItem() {
              Text(file)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + file;
                  UniversalDetector.detectCharset(filePath).then((encoing) => {
                    console.info(this.encoding += encoing);
                    this.showResult();
                  });
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(40)

        Text('GB18030SMFalsePositiveTest(2) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.GB18030SMFalsePositiveTest, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(100)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  let fileName: string = 'GB18030SMFalsePositiveTest_' + (this.GB18030SMFalsePositiveTest.indexOf(data) + 1) + '.txt';
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + fileName;
                  let stream = fs.createStreamSync(filePath, "r+")
                  let buf = new ArrayBuffer(1024);
                  let nread: number = 0;
                  let read_total: number = 0;
                  while ((nread = stream.readSync(buf, { offset: read_total, length: buf.byteLength })) > 0) {
                    read_total += nread;
                  }
                  let temp = new Int8Array(buf);
                  buf = this.typedArrayToBuffer(temp.subarray(0, read_total));
                  this.encoding = 'Detected Encoding = ';
                  let encoing: string = this.detect(buf);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(100)

        Text('TIS620BasicTest(1) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.TIS620BasicTest, (file: string) => {
            GridItem() {
              Text(file)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + file;
                  UniversalDetector.detectCharset(filePath).then((encoing) => {
                    console.info(this.encoding += encoing);
                    this.showResult();
                  })
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(40)

        Text('Bug8VariousFailedCharsets(3) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.Bug8VariousFailedCharsets, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(120)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  for (let i = 0; i < 64; ++i) {
                    this.values[this.alphabet[i]] = i;
                  }
                  this.encoding = 'Detected Encoding = ';
                  let buf: ArrayBuffer = this.typedArrayToBuffer(this.decode(data));
                  let encoing: string = this.detect(buf);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(120)

        Text('ShortStringTests(3) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.ShortStringTests, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  let fileName: string = 'ShortStringTests_' + (this.ShortStringTests.indexOf(data) + 1) + '.txt';
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + fileName;
                  console.info('GetCacheDir Successful. Path: ' + filePath);
                  let stream = fs.createStreamSync(filePath, "r+")
                  stream.writeSync(data, {
                    offset: 0,
                    length: data.length,
                    encoding: 'utf-8'
                  })
                  console.info('Write Successful. Content: \'' + data + '\'');
                  let buf = new ArrayBuffer(1024);
                  let encoing: string = this.guessCharsetName(buf, filePath);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(40)

        Text('TestDetectorFile(4) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.TestDetectorFile, (file: string) => {
            GridItem() {
              Text(file)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(100)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + file;
                  UniversalDetector.detectCharset(filePath).then((encoing) => {
                    console.info(this.encoding += encoing);
                    this.showResult();
                  });
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(100)

        Text('BasicStreamEncodingDetectionTest(11) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.BasicStreamEncodingDetection, (file: string) => {
            GridItem() {
              Text(file)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(80)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + file;
                  let encoing: string = this.guessCharsetNameByBasicStream(filePath);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(170)

        Text('Bug20LatinDetectedAsMaccyrillicTest(1) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.Bug20LatinDetectedAsMaccyrillic, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(130)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  let fileName: string = 'Bug20LatinDetectedAsMaccyrillicTest_' + (this.Bug20LatinDetectedAsMaccyrillic.indexOf(data) + 1) + '.txt';
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + fileName;
                  let stream = fs.createStreamSync(filePath, "r+")
                  stream.writeSync(data, {
                    offset: 0,
                    length: data.length,
                    encoding: 'utf-8'
                  })
                  console.info('Write Successful. Content: \'' + data + '\'');
                  let buf = new ArrayBuffer(1024);
                  let encoing: string = this.guessCharsetName(buf, filePath);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(130)

        // zipHeader Test Result:
        Text('Bug33USASCIIToGenerous(1) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.Bug33USASCIIToGenerous, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  let fileName: string = 'Bug33USASCIIToGenerous_' + (this.Bug33USASCIIToGenerous.indexOf(data) + 1) + '.txt';
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + fileName;
                  let stream = fs.createStreamSync(filePath, "r+")
                  let zipHeader: number[] = new Array(0x50, 0x4b, 0x03, 0x04, 0x14, 0x00, 0x02, 0x00);
                  let tempIntArray = this.typedArrayToBuffer(new Int8Array(zipHeader));
                  let encoing: string = UniversalDetector.detectCharsetBranch(stream, tempIntArray);
                  console.info(this.encoding += encoing);
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(40)

        Text('TestDetector(1) Samples：')
          .fontSize(26)
          .padding(15)
          .textAlign(TextAlign.Start)
        Grid() {
          ForEach(this.TestDetector, (data: string) => {
            GridItem() {
              Text(data)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  let fileName: string = 'TestDetector_' + (this.TestDetector.indexOf(data) + 1) + '.txt';
                  this.encoding = 'Detected Encoding = ';
                  let filePath = getPath() + fileName;
                  let encoing: string = this.guessCharsetNameByTestDetector(filePath);
                  console.info(this.encoding += encoing);
                  if (encoing == null) {
                    this.encoding = 'No encoding detected.';
                  }
                  this.showResult();
                })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr')
        .columnsGap(10)
        .rowsGap(10)
        .onScrollIndex((first: number) => {
          console.info(first.toString())
        })
        .width('90%')
        .backgroundColor(0xFAEEE0)
        .height(40)

        Text(this.encoding)
          .fontSize(36)
          .padding(15)
          .visibility(Visibility.Hidden)
      }.width('100%').margin({ top: 5, bottom: 135 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(30)
    .onScroll((xOffset: number, yOffset: number) => {
      console.info(xOffset + ' ' + yOffset)
    })
    .onScrollEdge(() => {
      console.info('To the edge')
    })
    .onScrollEnd(() => {
      console.info('Scroll Stop')
    })
  }

  guessCharsetName(buf: ArrayBuffer, filePath: string): string {
    let detector: UniversalDetector = new UniversalDetector();
    let stream = fs.createStreamSync(filePath, "r+");
    let nread = 0;
    let read_total: number = 0;
    while ((nread = stream.readSync(buf, { offset: read_total, length: buf.byteLength })) > 0) {
      read_total += nread;
    }
    let temp = new Int8Array(buf);
    buf = this.typedArrayToBuffer(temp.subarray(0, read_total));
    detector.handleData(buf, 0, buf.byteLength);
    detector.dataEnd();
    return detector.getDetectedCharset();
  }

  detect(data: ArrayBuffer): string {
    let detector: UniversalDetector = new UniversalDetector();
    detector.handleData(data, 0, data.byteLength);
    detector.dataEnd();
    let detected: string = detector.getDetectedCharset();
    detector.reset();
    return detected;
  }

  guessCharsetNameByBasicStream(path: string): string {
    let edis: EncodingDetectorInputStream = new EncodingDetectorInputStream();
    let edos: EncodingDetectorOutputStream = new EncodingDetectorOutputStream();
    try {
      let stream = fs.createStreamSync(path, "r+")
      let buffer = new ArrayBuffer(1024);
      let read: number = 0;
      let read_total: number = 0;
      while ((read = edis.readWithOneParameter(stream, buffer, read_total)) > 0) {
        edos.writeWithTreeParameter(stream, buffer, read_total, read);
        read_total += read;
      }
    } finally {
      edos.close();
      edis.close();
    }

    let encodingRead: string = edis.getDetectedCharset();
    let encodingWrite: string = edos.getDetectedCharset();
    let encoing: string = '';
    if (encodingRead != null && encodingWrite != null && encodingRead.valueOf() == encodingWrite.valueOf()) {
      encoing = encodingRead;
    }
    return encoing;
  }

  guessCharsetNameByTestDetector(path: string): string {
    let stream = fs.createStreamSync(path, "r+")
    let buf = new ArrayBuffer(1024);
    let detector: UniversalDetector = new UniversalDetector();
    let nread: number;
    let read_total: number = 0;
    while ((nread = stream.readSync(buf, { offset: read_total, length: buf.byteLength })) > 0 && !detector.isDone()) {
      detector.handleData(buf, 0, nread);
      read_total += nread;
    }
    detector.dataEnd();
    let encoding: string = detector.getDetectedCharset();
    detector.reset();
    return encoding;
  }

  /**
   * @param {?} data
   * @return {?}
   */
  decode(data: string) {
    let size: number = data.length;
    if (size === 0) {
      return new Int8Array(new ArrayBuffer(0));
    }
    if (size % 4 !== 0) {
      throw new Error('Bad length: ' + size);
    }
    let reg: RegExp = new RegExp("^[a-zA-Z0-9+/]+={0,2}$")
    if (!data.match(reg)) {
      throw new Error('Invalid base64 encoded value');
    }
    // Every 4 base64 chars = 24 bits = 3 bytes. But, we also need to figure out
    // padding, if any.
    let bytes = 3 * (size / 4);
    let numPad = 0;
    if (data.charAt(size - 1) === '=') {
      numPad++;
      bytes--;
    }
    if (data.charAt(size - 2) === '=') {
      numPad++;
      bytes--;
    }
    let buffer = new Int8Array(new ArrayBuffer(bytes));
    let index = 0;
    let bufferIndex = 0;
    let quantum = 0;
    if (numPad > 0) {
      size -= 4; // handle the last one specially
    }
    /* tslint:disable:no-bitwise */
    while (index < size) {
      quantum = 0;
      for (let i = 0; i < 4; ++i) {
        quantum = (quantum << 6) | this.values[data.charAt(index + i)];
      }
      // quantum is now a 24-bit value.
      buffer[bufferIndex++] = (quantum >> 16) & 0xff;
      buffer[bufferIndex++] = (quantum >> 8) & 0xff;
      buffer[bufferIndex++] = quantum & 0xff;
      index += 4;
    }
    if (numPad > 0) {
      // if numPad == 1, there is one =, and we have 18 bits with 2 0s at end.
      // if numPad == 2, there is two ==, and we have 12 bits with 4 0s at end.
      // First, grab my quantum.
      quantum = 0;
      for (let i = 0; i < 4 - numPad; ++i) {
        quantum = (quantum << 6) | this.values[data.charAt(index + i)];
      }
      if (numPad === 1) {
        // quantum is 18 bits, but really represents two bytes.
        quantum = quantum >> 2;
        buffer[bufferIndex++] = (quantum >> 8) & 0xff;
        buffer[bufferIndex++] = quantum & 0xff;
      }
      else {
        // quantum is 12 bits, but really represents only one byte.
        quantum = quantum >> 4;
        buffer[bufferIndex++] = quantum & 0xff;
      }
    }
    /* tslint:enable:no-bitwise */
    return buffer;
  }

  showResult() {
    prompt.showToast({
      message: this.encoding,
      duration: 5000
    });
  }

  typedArrayToBuffer(array: Int8Array): ArrayBuffer {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
  }
}