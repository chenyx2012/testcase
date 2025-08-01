/**
 Copyright 2024 csx - @yunkss/ef_crypto

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

import crypto from '@ohos.security.cryptoFramework';
import { util } from '@kit.ArkTS';
import { StrAndUintUtil } from '../util/StrAndUintUtil';
import { RandomUtil } from '@yunkss/ef_core';
import { CryptoUtil } from '../util/CryptoUtil';


/**
 * @Author csx
 * @DateTime 2024/3/18 10:39:03
 * @TODO AES
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_crypto
 */
export class AES {
  /**
   * gcm对象
   */
  private static gcmParams = AES.genGcmParamsSpec();

  /**
   * 生成GCM所需数据
   * @returns
   */
  private static genGcmParamsSpec(): crypto.GcmParamsSpec {
    // let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 12 bytes
    // let dataIv = new Uint8Array(arr);
    let ivBlob: crypto.DataBlob = { data: RandomUtil.randomUnitBySize(12) };
    // arr = [0, 0, 0, 0, 0, 0, 0, 0]; // 8 bytes
    // let dataAad = new Uint8Array(arr);
    let aadBlob: crypto.DataBlob = { data: RandomUtil.randomUnitBySize(8) };
    // arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
    // let dataTag = new Uint8Array(arr);
    let tagBlob: crypto.DataBlob = {
      data: RandomUtil.randomUnitBySize(16)
    };
    // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
    let gcmParamsSpec: crypto.GcmParamsSpec = {
      iv: ivBlob,
      aad: aadBlob,
      authTag: tagBlob,
      algName: "GcmParamsSpec"
    };
    return gcmParamsSpec;
  }

  /**
   * 生成AES的对称密钥
   * @returns AES密钥
   */
  static async generateAESKey(): Promise<string> {
    return CryptoUtil.generateSymKey('AES256');
  }

  /**
   * 生成AES的对称密钥-128位
   * @returns AES密钥-128位
   */
  static async generateAESKey128(): Promise<string> {
    return CryptoUtil.generateSymKey('AES128');
  }


  /**
   * 加密-GCM模式
   * @param str  待加密的字符串
   * @param aesKey   AES密钥
   * @returns
   */
  static async encodeGCM(str: string, aesKey: string): Promise<string> {
    //转换key
    let symKey = await CryptoUtil.convertKeyFromStr(aesKey, 'AES256', 256);
    // 初始化加解密操作环境
    let mode = crypto.CryptoMode.ENCRYPT_MODE;
    //创建加密器
    let cipher = crypto.createCipher('AES256|GCM|PKCS7');
    //初始化加密
    await cipher.init(mode, symKey, AES.gcmParams);
    //封装加密所需数据
    let encode = new util.TextEncoder();
    let a = encode.encodeInto(str);
    //开始加密
    let updateOutput = await cipher.update({ data: encode.encodeInto(str) });
    //拼接
    let finalOutput = await cipher.doFinal(null);
    if (finalOutput != null) {
      AES.gcmParams.authTag = finalOutput;
    }
    //转换字符串
    return StrAndUintUtil.unitArray2String(updateOutput.data);
  }

  /**
   * 加密-CBC模式
   * @param str  待加密的字符串
   * @param aesKey   AES密钥
   * @param iv   iv偏移量字符串
   * @returns
   */
  static async encodeCBC(str: string, aesKey: string, iv: string): Promise<string> {
    return CryptoUtil.encodeCBC(str, aesKey, iv, 'AES256', 'AES256|CBC|PKCS7', 256);
  }

  /**
   * 加密-CBC模式-128位
   * @param str  待加密的字符串
   * @param aesKey   AES密钥
   * @param iv   iv偏移量字符串
   * @returns
   */
  static async encodeCBC128(str: string, aesKey: string, iv: string): Promise<string> {
    return CryptoUtil.encodeCBC(str, aesKey, iv, 'AES128', 'AES128|CBC|PKCS7', 128);
  }

  /**
   * 加密-ECB模式
   * @param str  待加密的字符串
   * @param aesKey   AES密钥
   * @returns
   */
  static async encodeECB(str: string, aesKey: string): Promise<string> {
    return CryptoUtil.encodeECB(str, aesKey, 'AES256', 'AES256|ECB|PKCS7', 256);
  }

  /**
   * 加密-ECB模式-128位
   * @param str  待加密的字符串
   * @param aesKey   AES密钥-128位
   * @returns
   */
  static async encodeECB128(str: string, aesKey: string): Promise<string> {
    return CryptoUtil.encodeECB(str, aesKey, 'AES128', 'AES128|ECB|PKCS7', 128);
  }


  /**
   * 解密-GCM模式
   * @param str  加密的字符串
   * @param aesKey  AES密钥
   */
  static async decodeGCM(str: string, aesKey: string): Promise<string> {
    //转换密钥
    let symKey = await CryptoUtil.convertKeyFromStr(aesKey, 'AES256', 256);
    // 初始化加解密操作环境:开始解密
    let mode = crypto.CryptoMode.DECRYPT_MODE;
    //创建解密器
    let cipher = crypto.createCipher('AES256|GCM|PKCS7');
    //初始化加密
    await cipher.init(mode, symKey, AES.gcmParams);
    //解密
    let updateOutput = await cipher.update({ data: StrAndUintUtil.stringToByteArray(str, 256) });
    //判断是否完成
    let finalOutput = await cipher.doFinal(null);
    let decode = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    return decode.decodeWithStream(updateOutput.data);
  }

  /**
   * 解密-CBC模式
   * @param str  加密的字符串
   * @param aesKey AES密钥
   * @param iv  iv偏移量字符串
   * @returns
   */
  static async decodeCBC(str: string, aesKey: string, iv: string): Promise<string> {
    return CryptoUtil.decodeCBC(str, aesKey, iv, 'AES256', 'AES256|CBC|PKCS7', 256);
  }

  /**
   * 解密-CBC模式-128位
   * @param str  加密的字符串
   * @param aesKey AES密钥
   * @param iv  iv偏移量字符串
   * @returns
   */
  static async decodeCBC128(str: string, aesKey: string, iv: string): Promise<string> {
    return CryptoUtil.decodeCBC(str, aesKey, iv, 'AES128', 'AES128|CBC|PKCS7', 128);
  }

  /**
   * 解密-ECB模式
   * @param str  加密的字符串
   * @param aesKey AES密钥
   * @returns
   */
  static async decodeECB(str: string, aesKey: string): Promise<string> {
    return CryptoUtil.decodeECB(str, aesKey, 'AES256', 'AES256|ECB|PKCS7', 256);
  }

  /**
   * 解密-ECB模式-128位
   * @param str  加密的字符串
   * @param aesKey AES密钥-128位
   * @returns
   */
  static async decodeECB128(str: string, aesKey: string): Promise<string> {
    return CryptoUtil.decodeECB(str, aesKey, 'AES128', 'AES128|ECB|PKCS7', 128);
  }
}