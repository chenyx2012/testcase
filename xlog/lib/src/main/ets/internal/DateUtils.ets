/**
 * Copyright (c) 2023 Wathinst <wxz@xkzhineng.com>
 * XLog is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 * http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */
class DateMap {
  y: number | string = "" //年份
  M: number | string = "" //月份
  d: number | string = "" //日
  h: number | string = "" //小时 12
  H: number | string = "" //小时 24
  m: number | string = "" //分
  s: number | string = "" //秒
  q: number | string = "" //季度
  f: number | string = "" //毫秒

  reg(k: string) : (number | string) {
    switch (k) {
      case "y": return this.y;
      case "M": return this.M;
      case "d": return this.d;
      case "h": return this.h;
      case "H": return this.H;
      case "m": return this.m;
      case "s": return this.s;
      case "q": return this.q;
      case "f": return this.f;
      default: return this.s;
    }
  }
}

export class DateUtils {
  static dateFormat(date?: string | number | undefined | Date, format?: string): string {
    //无参数
    if (date == undefined) {
      date = new Date();
    } else if (typeof (date) == "string") {
      let regex: RegExp = new RegExp('-');
      date = new Date(date.replace(regex, '/'));
    } else if (typeof (date) == "number") {
      date = new Date(date);
    } else {
      date = new Date();
    }

    if (format === undefined) {
      format = "yyyy-MM-dd HH:mm:ss.fff";
    }
    else { }
    //没有分隔符的特殊处理

    let map = new DateMap();
    map.y = date.getFullYear() + ""; //年份
    map.M = date.getMonth() + 1 + ""; //月份
    map.d = date.getDate() + ""; //日
    map.H = date.getHours(); //小时 24
    map.m = date.getMinutes() + ""; //分
    map.s = date.getSeconds() + "";  //秒
    map.q = Math.floor((date.getMonth() + 3) / 3) + "";  //季度
    map.f = date.getMilliseconds() + "";  //毫秒

    //小时 12
    if (map.H > 12) { map.h = (map.H as number - 12) + ""; }
    else { map.h = map.H + ""; }
    map.H = (map.H as number) + "";

    let reg = "yMdHhmsqf";
    let all = "", str = "";
    for (let i = 0, n = 0; i < reg.length; i++) {
      n = format.indexOf(reg[i]);
      if (n < 0) { continue; }
      all = "";
      for (; n < format.length; n++) {
        if (format[n] != reg[i]) {
          break;
        }
        all += reg[i];
      }
      if (all.length > 0) {
        let regStr = (map.reg(reg[i]) as string);
        if (all.length == regStr.length) {
          str = regStr;
        }
        else if (all.length > regStr.length) {
          if (reg[i] == "f") {
            str = regStr + DateUtils.charString("0", all.length - regStr.length);
          }
          else {
            str = DateUtils.charString("0", all.length - regStr.length) + regStr;
          }
        }
        else {
          switch (reg[i]) {
            case "y": str = regStr.substring(regStr.length - all.length); break;
            case "f": str = regStr.substring(0, all.length); break;
            default: str = regStr; break;
          }
        }
        format = format.replace(all, str);
      }
    }
    return format;
  }

  static charString(char: string, count: number): string {
    let str: string = "";
    while (count--) {
      str += char;
    }
    return str;
  }
}