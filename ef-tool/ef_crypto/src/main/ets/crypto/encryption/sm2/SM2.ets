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

import { CryptoKey, CryptoUtil } from '../../util/CryptoUtil';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { StrAndUintUtil } from '../../util/StrAndUintUtil';

/**
 * @Author csx
 * @DateTime 2024/3/18 10:33:03
 * @TODO SM2
 */
export class SM2 {
  /**
   * 生成SM2的非对称密钥
   * @returns SM2密钥{publicKey:公钥,privateKey:私钥}
   */
  static async generateSM2Key(): Promise<CryptoKey> {
    return CryptoUtil.generateCryptoKey('SM2_256');
  }


  /**
   * 加密
   * @param encodeStr  待加密的字符串
   * @param pubKey  SM2公钥
   */
  static async encode(str: string, pubKey: string): Promise<string> {
    return CryptoUtil.encodeAsym(str, pubKey, 'SM2_256', 'SM2_256|SM3', 256);
  }

  /**
   * 解密
   * @param decodeStr  待解密的字符串
   * @param priKey    SM2私钥
   */
  static async decode(str: string, priKey: string): Promise<string> {
    return CryptoUtil.decodeAsym(str, priKey, 'SM2_256', 'SM2_256|SM3', 256);
  }

  /**
   * 签名
   * @param str  需要签名的字符串
   * @param priKey  私钥
   * @returns string> 签名对象
   */
  static async sign(str: string, priKey: string): Promise<string> {
    return CryptoUtil.sign(str, priKey, 'SM2_256', 'SM2_256|SM3', 256);
  }

  /**
   * 验签
   * @param signStr  已签名的字符串
   * @param verifyStr  需要验签的字符串
   * @param pubKey  SM2公钥
   * @returns 验签结果,其中Msg为验签结果
   */
  static async verify(signStr: string, verifyStr: string, pubKey: string): Promise<string> {
    return CryptoUtil.verify(signStr, verifyStr, pubKey, 'SM2_256', 'SM2_256|SM3', 256);
  }

  /**
   * 将服务器端生成的16进制的长度为130位的04开头的C1C3C2格式的SM2公钥转换为前端所需的ASN.1格式公钥字符串
   * @param pubKey   04开头的16进制的130位的公钥字符串
   * @returns 转换后的公钥字符串
   */
  static async convertSM2PubKey(pubKey: string): Promise<string> {
    if (pubKey.length != 130) {
      return '服务器端SM2公钥长度不正确~';
    }
    //截取x参数
    let px = pubKey.substring(2, 66);
    //截取y参数
    let py = pubKey.substring(66);
    //转16进制放入对应的位置 04+x+y
    let pk: cryptoFramework.Point = {
      x: BigInt("0x" + px),
      y: BigInt("0x" + py)
    }
    //构建SM2公钥参数对象
    let keyPair: cryptoFramework.ECCPubKeySpec = {
      params: cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_sm2'),
      pk: pk,
      algName: 'SM2',
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC
    }
    //创建密钥生成器
    let keyPairGenerator = await cryptoFramework.createAsyKeyGeneratorBySpec(keyPair);
    //生成uint8Array格式密钥
    let unit8PubKey = await keyPairGenerator.generatePubKey();
    //转换成鸿蒙所需公钥字符串
    return StrAndUintUtil.unitArray2String(unit8PubKey.getEncoded().data);
  }

  /**
   * 将服务器端生成的16进制的长度为64位的C1C3C2格式的SM2私钥转换为前端所需的ASN.1格式SM2私钥字符串
   * @param priKey   16进制的64位的私钥字符串
   * @returns 转换后的私钥字符串
   */
  static async convertSM2PriKey(priKey: string): Promise<string> {
    if (priKey.length != 64) {
      return '服务器端SM2私钥长度不正确~';
    }
    //构建SM2私钥参数对象
    let keyPair: cryptoFramework.ECCPriKeySpec = {
      params: cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_sm2'),
      algName: 'SM2',
      sk: BigInt('0x' + priKey),
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC
    }
    //创建密钥生成器
    let keyPairGenerator = await cryptoFramework.createAsyKeyGeneratorBySpec(keyPair);
    //生成uint8Array格式密钥
    let unit8PriKey = await keyPairGenerator.generatePriKey();
    //转换成鸿蒙所需私钥字符串
    return StrAndUintUtil.unitArray2String(unit8PriKey.getEncoded().data);
  }
}