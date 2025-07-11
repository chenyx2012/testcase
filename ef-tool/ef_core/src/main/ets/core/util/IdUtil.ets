/**
 Copyright 2024 csx - @yunkss/ef_core

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

/**
 * @Author csx
 * @DateTime 2023/12/29 20:07
 * @TODO IdUtil   主键ID工具类
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_core
 */
export class IdUtil {
  /**
   * 简化的UUID，去掉了横线
   *
   */
  static simpleUUID(): string {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  /**
   * 获取随机36位UUID，带-
   *
   */
  static fastUUID(): string {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    const uuid = new Array<string>(36);
    let rand = 0;

    for (let i = 0; i < 36; i++) {
      if (i === 8 || i === 13 || i === 18 || i === 23) {
        uuid[i] = '-';
      } else if (i === 14) {
        uuid[i] = '4';
      } else {
        if (rand <= 0x02) {
          rand = 0x2000000 + (Math.random() * 0x1000000) | 0;
        }
        const r = rand & 0xf;
        rand = rand >> 4;
        uuid[i] = chars[(i === 19) ? (r & 0x3) | 0x8 : r];
      }
    }

    return uuid.join('');
  }


  /**
   * 获取随机32位UUID，带-
   *
   */
  static fastSimpleUUID(): string {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    const uuid = new Array<string>(32);
    let rand = 0;
    let index = 0;

    for (let i = 0; i < 32; i++) {
      if (i === 8 || i === 12 || i === 16 || i === 20) {
        uuid[i] = '-';
      } else {
        if (rand <= 0x02) {
          rand = 0x2000000 + (Math.random() * 0x1000000) | 0;
        }
        const r = rand & 0xf;
        rand = rand >> 4;
        uuid[i] = chars[(i === 12) ? (r & 0x3) | 0x8 : r];
      }
    }

    return uuid.join('');
  }


  /**
   * 生成36位UUID带有-
   */
  static randomUUID(): string {
    const chars = '0123456789abcdef';
    const uuid = new Array<string>(36);

    for (let i = 0; i < 36; i++) {
      if (i === 8 || i === 13 || i === 18 || i === 23) {
        uuid[i] = '-';
      } else if (i === 14) {
        uuid[i] = '4';
      } else {
        const randomValue = Math.random() * 16 | 0;
        let idx = (i === 19) ? (randomValue & 0x3) | 0x8 : randomValue;
        uuid[i] = chars.charAt(idx);
      }
    }
    return uuid.join('');
  }
}