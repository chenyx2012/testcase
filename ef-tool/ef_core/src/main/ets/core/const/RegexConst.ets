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
 * @DateTime 2023/12/29 21:56
 * @TODO RegexConst  正则所需常量池
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_core
 */
export class RegexConst {
  /**
   * 英文字母 、数字和下划线
   */
  static GENERAL: string = "^\\w+$";
  /**
   * 数字
   */
  static NUMBERS: string = "^\\d+$";
  /**
   * 字母
   */
  static WORD: string = "^[a-zA-Z]+$";
  /**
   * 单个中文汉字<br>
   * 参照维基百科汉字Unicode范围(https://zh.wikipedia.org/wiki/%E6%B1%89%E5%AD%97 页面右侧)
   */
  static CHINESE: string =
    "[\u2E80-\u2EFF\u2F00-\u2FDF\u31C0-\u31EF\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF\uD840\uDC00-\uD869\uDEDF\uD869\uDF00-\uD86D\uDF3F\uD86D\uDF40-\uD86E\uDC1F\uD86E\uDC20-\uD873\uDEAF\uD87E\uDC00-\uD87E\uDE1F]";
  /**
   * 中文汉字
   */
  static CHINESES: string = RegexConst.CHINESE + "+";
  /**
   * 分组
   */
  static GROUP_VAR: string = "^\\$(\\d+)$";
  /**
   * IP v4<br>
   * 采用分组方式便于解析地址的每一个段
   */
  //static IPV4 = "\\b((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\b";
  static IPV4: string =
    "^(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)$";
  /**
   * IP v6
   */
  static IPV6: string =
    "^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]+|::(ffff(:0{1,4})?:)?((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\\.){3}(25[0-5]|(2[0-4]|1?[0-9])?[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\\.){3}(25[0-5]|(2[0-4]|1?[0-9])?[0-9]))$";
  /**
   * 货币
   */
  static MONEY: string = "^(\\d+(?:\\.\\d+)?)$";
  /**
   * 邮件，符合RFC 5322规范，正则来自：http://emailregex.com/
   */
  static EMAIL: string =
    "^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)])$";
  /**
   * 移动电话
   */
  static MOBILE: string = "^(?:0|86|\\+86)?1[3-9]\\d{9}$";
  /**
   * 中国香港移动电话
   * eg: 中国香港： +852 5100 4810， 三位区域码+10位数字, 中国香港手机号码8位数
   * eg: 中国大陆： +86  180 4953 1399，2位区域码标示+13位数字
   * 中国大陆 +86 Mainland China
   * 中国香港 +852 Hong Kong
   * 中国澳门 +853 Macao
   * 中国台湾 +886 Taiwan
   */
  static MOBILE_HK: string = "^(?:0|852|\\+852)?\\d{8}$";
  /**
   * 中国台湾移动电话
   * eg: 中国台湾： +886 09 60 000000， 三位区域码+号码以数字09开头 + 8位数字, 中国台湾手机号码10位数
   * 中国台湾 +886 Taiwan 国际域名缩写：TW
   */
  static MOBILE_TW: string = "^(?:0|886|\\+886)?(?:|-)09\\d{8}$";
  /**
   * 中国澳门移动电话
   * eg: 中国台湾： +853 68 00000， 三位区域码 +号码以数字6开头 + 7位数字, 中国台湾手机号码8位数
   * 中国澳门 +853 Macao 国际域名缩写：MO
   */
  static MOBILE_MO: string = "^(?:0|853|\\+853)?(?:|-)6\\d{7}$";
  /**
   * 座机号码<br>
   * pr#387@Gitee
   */
  static TEL: string = "^(010|02\\d|0[3-9]\\d{2})-?(\\d{6,8})$";
  /**
   * 座机号码+400+800电话
   *
   * @see <a href="https://baike.baidu.com/item/800">800</a>
   */
  static TEL_400_800: string = "^0\\d{2,3}[\\- ]?[1-9]\\d{6,7}|[48]00[\\- ]?[1-9]\\d{6}$";
  /**
   * 18位身份证号码
   */
  static CITIZEN_ID: string = "^[1-9]\\d{5}[1-2]\\d{3}((0\\d)|(1[0-2]))(([012]\\d)|3[0-1])\\d{3}(\\d|X|x)$";
  /**
   * 邮编，兼容港澳台
   */
  static ZIP_CODE: string =
    "^(0[1-7]|1[0-356]|2[0-7]|3[0-6]|4[0-7]|5[0-7]|6[0-7]|7[0-5]|8[0-9]|9[0-8])\\d{4}|99907[78]$";
  /**
   * 生日
   */
  static BIRTHDAY: string = "^(\\d{2,4})([/\\-.年]?)(\\d{1,2})([/\\-.月]?)(\\d{1,2})日?$";
  /**
   * URI<br>
   * 定义见：https://www.ietf.org/rfc/rfc3986.html#appendix-B
   */
  static URI: string = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$";
  /**
   * URL
   */
  static URL: string = "^[a-zA-Z]+://[\\w-+&@#/%?=~_|!:,.;]*[\\w-+&@#/%=~_|]$";
  /**
   * Http URL（来自：http://urlregex.com/）<br>
   * 此正则同时支持FTP、File等协议的URL
   */
  static URL_HTTP: string = "^(https?|ftp|file)://[\\w-+&@#/%?=~_|!:,.;]*[\\w-+&@#/%=~_|]$";
  /**
   * 中文字、英文字母、数字和下划线
   */
  static GENERAL_WITH_CHINESE: string = "^[\u4E00-\u9FFF\\w]+$";
  /**
   * UUID
   */
  static UUID: string = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
  /**
   * 不带横线的UUID
   */
  static UUID_SIMPLE: string = "^[0-9a-fA-F]{32}$";
  /**
   * MAC地址正则
   */
  static MAC_ADDRESS: string = "^((?:[a-fA-F0-9]{1,2}[:-]){5}[a-fA-F0-9]{1,2})|0x(\\d{12}).+ETHER$";
  /**
   * 16进制字符串
   */
  static HEX: string = "^[a-fA-F0-9]+$";
  /**
   * 时间正则
   */
  static TIME: string = "^\\d{1,2}:\\d{1,2}(:\\d{1,2})?$";
  /**
   * 中国车牌号码（兼容新能源车牌）
   */
  static PLATE_NUMBER: string =
    "^(([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z](([0-9]{5}[ABCDEFGHJK])|([ABCDEFGHJK]([A-HJ-NP-Z0-9])[0-9]{4})))|" +
      "([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]\\d{3}\\d{1,3}[领])|" +
      "([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳使领]))$";
  /**
   * 社会统一信用代码
   * <pre>
   * 第一部分：登记管理部门代码1位 (数字或大写英文字母)
   * 第二部分：机构类别代码1位 (数字或大写英文字母)
   * 第三部分：登记管理机关行政区划码6位 (数字)
   * 第四部分：主体标识码（组织机构代码）9位 (数字或大写英文字母)
   * 第五部分：校验码1位 (数字或大写英文字母)
   * </pre>
   */
  static CREDIT_CODE: string = "^[0-9A-HJ-NPQRTUWXY]{2}\\d{6}[0-9A-HJ-NPQRTUWXY]{10}$";
  /**
   * 车架号
   * 别名：车辆识别代号 车辆识别码
   * 十七位码、车架号
   * 车辆的唯一标示
   */
  static CAR_VIN: string = "^[A-HJ-NPR-Z0-9]{8}[0-9X][A-HJ-NPR-Z0-9]{2}\\d{6}$";
  /**
   * 驾驶证  别名：驾驶证档案编号、行驶证编号
   * 12位数字字符串
   * 仅限：中国驾驶证档案编号
   */
  static CAR_DRIVING_LICENCE: string = "^[0-9]{12}$";
  /**
   * 中文姓名
   */
  static CHINESE_NAME: string = "^[\u2E80-\u9FFF·]{2,60}$";
}