/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 */

/**
 * 时间工具类
 */
export default class TimeUtil {
  public static currentTimeStamp(): string {
    let date = new Date();
    return TimeUtil.timeFormat(date, "{h}:{i}:{s}");
  }

  public static timeFormat(time: Date, format: string): string {
    const format_: string = format || "{y}-{m}-{d} {h}:{i}:{s}";
    const timeObj: Time = {
      y: time.getFullYear(),
      m: time.getMonth() + 1,
      d: time.getDate(),
      h: time.getHours(),
      i: time.getMinutes(),
      s: time.getSeconds()
    };
    let regex: RegExp = new RegExp("{(y|m|d|h|i|s)+}", "g")
    const timeString: string = format_.replace(regex, (result: string, key: string) => {
      let value: number = 0
      if (key === "h") {
        value = timeObj.h;
      } else if (key === "i") {
        value = timeObj.i
      } else {
        value = timeObj.s
      }
      if (result.length > 0 && value < 10) {
        return "0" + value;
      }
      return value.toString() || '0';
    })
    return timeString;
  }
}

class Time {
  y: number = 0
  m: number = 0
  d: number = 0
  h: number = 0
  i: number = 0
  s: number = 0
}