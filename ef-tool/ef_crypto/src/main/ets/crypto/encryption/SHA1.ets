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

/**
 * @Author csx
 * @DateTime 2024/3/20 21:43
 * @TODO SHA1  工具类 源码来自官方库  https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fchecksum
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_crypto
 */
export class SHA1 {
  hexcase = 0;
  /* hex output format. 0 - lowercase; 1 - uppercase */
  chrsz = 8;

  /* bits per input character. 8 - ASCII; 16 - Unicode */


  /**
   * 散列哈希算法
   * @param value
   * @returns
   */
  static hash(value: string): string {
    let hash = new SHA1();
    return hash.hex_sha1(value);
  }

  hex_sha1(s: string): string {
    return this.binb2hex(this.core_sha1(this.AlignSHA1(s)));
  }

  core_sha1(blockArray: number[]) {

    let x: number[] = blockArray; // append padding
    let w: number[] = Array(80);

    let a: number = 1732584193;

    let b: number = -271733879;

    let c: number = -1732584194;

    let d: number = 271733878;

    let e: number = -1009589776;

    for (let i = 0; i < x.length; i += 16) // 每次处理512位 16*32
    {

      let olda: number = a;

      let oldb: number = b;

      let oldc: number = c;

      let oldd: number = d;

      let olde: number = e;

      for (let j = 0; j < 80; j++) // 对每个512位进行80步操作
      {

        if (j < 16) {
          w[j] = x[i + j];
        } else {
          w[j] = this.rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
        }

        let t = this.safe_add(this.safe_add(this.rol(a, 5), this.sha1_ft(j, b, c, d)),
          this.safe_add(this.safe_add(e, w[j]), this.sha1_kt(j)));

        e = d;

        d = c;

        c = this.rol(b, 30);

        b = a;

        a = t;

      }

      a = this.safe_add(a, olda);

      b = this.safe_add(b, oldb);

      c = this.safe_add(c, oldc);

      d = this.safe_add(d, oldd);

      e = this.safe_add(e, olde);

    }

    return new Array(a, b, c, d, e);

  }

  /*
     *
     * Perform the appropriate triplet combination function for the current
     * iteration
     *
     * 返回对应F函数的值
     *
     */
  sha1_ft(t: number, b: number, c: number, d: number) {

    if (t < 20) {
      return (b & c) | ((~b) & d);
    }

    if (t < 40) {
      return b ^ c ^ d;
    }

    if (t < 60) {
      return (b & c) | (b & d) | (c & d);
    }

    return b ^ c ^ d; // t<80
  }

  /*
     *
     * Determine the appropriate additive constant for the current iteration
     *
     * 返回对应的Kt值
     *
     */
  sha1_kt(t: number) {

    return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 : (t < 60) ? -1894007588 : -899497514;

  }

  /*
     *
     * Add integers, wrapping at 2^32. This uses 16-bit operations internally
     *
     * to work around bugs in some JS interpreters.
     *
     * 将32位数拆成高16位和低16位分别进行相加，从而实现 MOD 2^32 的加法
     *
     */
  // safe_add(x: number, y: number) {
  //
  //   let lsw = (x & 0xFFFF) + (y & 0xFFFF);
  //
  //   let msw = (x > 16) + (y > 16) + (lsw > 16);
  //
  //   return (msw << 16) | (lsw & 0xFFFF);
  //
  // }
  safe_add(x: number, y: number): number {
    let lsw = (x & 0xFFFF) + (y & 0xFFFF); // 计算低16位的和
    let msw = (x >>> 16) + (y >>> 16); // 计算高16位的和
    if (lsw > 0xFFFF) { // 如果低16位和溢出
      msw += 1; // 高16位加1
    }
    return (msw << 16) | (lsw & 0xFFFF); // 组合新高16位和低16位
  }

  /*
     *
     * Bitwise rotate a 32-bit number to the left.
     *
     * 32位二进制数循环左移
     *
     */
  rol(num: number, cnt: number) {

    return (num << cnt) | (num >> (32 - cnt));

  }

  /*
     *
     * The standard SHA1 needs the input string to fit into a block
     *
     * This function align the input string to meet the requirement
     *
     */
  // AlignSHA1(str: string): number[] {
  //
  //   let nblk: number = ((str.length + 8) > 6) + 1,
  //     blks: number[] = new Array(nblk * 16);
  //
  //   for (let i = 0; i < nblk * 16; i++) {
  //     blks[i] = 0;
  //   }
  //
  //   for (let i = 0; i < str.length; i++) {
  //
  //     blks[i > 2] |= str.charCodeAt(i) << (24 - (i & 3) * 8);
  //
  //     blks[i > 2] |= 0x80 << (24 - (i & 3) * 8);
  //
  //     blks[nblk * 16 - 1] = str.length * 8;
  //   }
  //
  //   return blks;
  //
  // }

  AlignSHA1(str: string): number[] {
    // 计算需要的块数
    let nblk = Math.ceil((str.length + 8) / 64) + 1;
    let blks: number[] = new Array(nblk * 16).fill(0);

    // 填充原始数据
    for (let i = 0; i < str.length; i++) {
      blks[i >> 2] |= str.charCodeAt(i) << (24 - (i % 4) * 8);
    }

    // 填充1字节 (0x80)
    blks[str.length >> 2] |= 0x80 << (24 - (str.length % 4) * 8);

    // 填充长度信息
    blks[nblk * 16 - 1] = str.length * 8;

    return blks;
  }

  /*
     *
     * Convert an array of big-endian words to a hex string.
     *
     */
  // binb2hex(binarray: number[]): string {
  //
  //   let hex_tab: string = this.hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  //
  //   let str = "";
  //
  //   for (let i = 0; i < binarray.length * 4; i++) {
  //     str += hex_tab.charAt((binarray[i > 2] > ((3 - i % 4) * 8 + 4)) & 0xF) +
  //     hex_tab.charAt((binarray[i > 2] > ((3 - i % 4) * 8)) & 0xF);
  //   }
  //
  //   return str;
  //
  // }
  binb2hex(binarray: number[]): string {
    let hex_tab: string = this.hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
    let str = "";

    for (let i = 0; i < binarray.length; i++) {
      // 取出当前字节
      const byte = binarray[i];
      // 获取高四位和低四位的十六进制字符
      const hex1 = (byte >> 4) & 0x0F;
      const hex2 = byte & 0x0F;
      // 追加到结果字符串
      str += hex_tab.charAt(hex1) + hex_tab.charAt(hex2);
    }

    return str;
  }
}