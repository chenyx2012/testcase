/**
 Copyright 2024 csx - @yunkss/ef_crypto_dto

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

import { DynamicUtil } from '../util/DynamicUtil';
import { OutDTO } from '@yunkss/ef_core';

/**
 * @Author csx
 * @DateTime 2024/3/20 20:21
 * @TODO ECDH  动态协商共享密钥
 */
export class ECDH {
  /**
   * ecdh动态协商密钥,要求密钥长度为256位的非对称密钥
   * @param pubKey  符合256位的非对称密钥的公钥字符串或Uint8Array字节流  【一般为外部传入】
   * @param priKey  符合256位的非对称密钥的私钥字符串或Uint8Array字节流  【一般为本项目】
   * @returns ECC256共享密钥
   */
  static async ecdh(pubKey: string | Uint8Array, priKey: string | Uint8Array): Promise<OutDTO<string>> {
    return DynamicUtil.dynamicKey(pubKey, priKey, 'ECC256', 256);
  }
}