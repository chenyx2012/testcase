/**
 Copyright 2024 csx - @yunkss/ef_json

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


import { JSONValue } from './JSONValue';
import { HashMap } from '@kit.ArkTS';
import { JSONArray } from './JSONArray';
import { JSONArrayList } from './JSONArrayList';
import { DateConst, DateUtil, StringBuilder, CommonConst as Const } from '@yunkss/ef_core';

/**
 * @Author csx
 * @DateTime 2024/4/25 19:25:04
 * @TODO JSONObject  定义json对象
 * @Use 详细使用方法以及文档详见ohpm官网,地址https://ohpm.openharmony.cn/#/cn/detail/@yunkss%2Fef_json
 */
export class JSONObject extends HashMap<string, JSONValue> {
  /**
   * json字符串转换为JSONObject对象
   * @param jsonStr json字符串
   * @returns JSONObject 对象
   */
  public static parse(jsonStr: string): JSONObject {
    let json = new JSONObject();
    //去除字符串中的换行符
    const replaceStr = jsonStr.replace(/\r\n/g, '\\r\\n').replace(/\r/g, '\\r').replace(/\n/g, '\\n');
    //转换成json对象
    let jVal: Record<string, JSONValue> = JSON.parse(replaceStr);
    //循环赋值
    Object.entries(jVal).forEach((item) => {
      if (item[1] instanceof JSONObject) {
        json.set(item[0], JSONObject.from(item[1]));
      } else if (item[1] instanceof Array) {
        json.set(item[0], JSONArray.from(item[1]));
      } else if (item[1] instanceof JSONArray) {
        json.set(item[0], JSONArray.from(item[1]));
      } else if (item[1] instanceof JSONArrayList) {
        json.set(item[0], JSONArrayList.from(item[1]));
      } else if (item[1] instanceof Date) {
        json.set(item[0], DateUtil.format(item[1], DateConst.YMD_HLINE_HMS));
      } else if (item[1] instanceof Object) {
        json.set(item[0], JSONObject.from(item[1]));
      } else {
        json.set(item[0], item[1]);
      }
    })
    return json;
  }

  /**
   * 递归解析字符串
   * @param nestedJson 待解析的json
   * @param convertDateStr  是否将日期字符串转换为日期对象
   * @returns 解析后的结果
   */
  private static parseNestedObject<U>(nestedJson: Record<string, JSONValue>, convertDateStr: boolean = true): U {
    let nestedData: Record<string, JSONValue> = {};
    for (let key of Object.entries(nestedJson)) {
      if (typeof nestedJson[key[0]] === 'object' && nestedJson[key[0]] !== null) {
        if (nestedJson[key[0]] instanceof Date && convertDateStr == true) {
          nestedData[key[0]] = new Date(nestedJson[key[0]] as string);
        } else if (Array.isArray(nestedJson[key[0]])) {
          nestedData[key[0]] =
            (nestedJson[key[0]] as Array<Record<string, JSONValue>>).map(item => JSONObject.parseNestedObject(item,
              convertDateStr));
        } else {
          nestedData[key[0]] =
            JSONObject.parseNestedObject(nestedJson[key[0]] as Record<string, JSONValue>, convertDateStr);
        }
      } else if (typeof nestedJson[key[0]] === 'string') {
        if (DateUtil.isDate(nestedJson[key[0]] as string) && convertDateStr == true) {
          nestedData[key[0]] = new Date(nestedJson[key[0]] as string);
        } else {
          nestedData[key[0]] = nestedJson[key[0]];
        }
      } else {
        nestedData[key[0]] = nestedJson[key[0]];
      }
    }
    return nestedData as U;
  }

  /**
   * json字符串转换为实体对象
   * @param jsonStr json字符串
   * @param convertDateStr 是否将日期字符串转换成日期对象 - 默认为true
   * @returns T 对象
   */
  public static parseObject<T>(jsonStr: string, convertDateStr: boolean = true): T {
    //处理如果带有转义符号的
    const replaceStr = jsonStr.replace(/\r\n/g, '\\r\\n').replace(/\r/g, '\\r').replace(/\n/g, '\\n');
    //转换
    let json: Record<string, JSONValue> = JSON.parse(replaceStr);
    let data: T = JSONObject.parseNestedObject<T>(json, convertDateStr);
    return data;
  }

  /**
   * Object对象换为json字符串
   * @param object object对象
   * @returns JSON字符串
   */
  public static toJSONString(object: Object): string {
    if (object instanceof Map) {
      let map = new HashMap<string, JSONValue>();
      (object as Map<string, JSONValue>).forEach((val, key) => {
        map.set(key, val);
      })
      //获取key迭代器
      let iter: IterableIterator<string> = map.keys();
      return new JSONObject().convertString(iter, map);
    }
    //转换成字符串
    let str = JSON.stringify(object);
    //转换成json对象
    let jVal: Record<string, JSONValue> = JSON.parse(str);
    //如果是数组直接转换返回
    if (Array.isArray(jVal)) {
      return JSONArray.toJSONString(jVal);
    }
    let map = new HashMap<string, JSONValue>();
    //转换成map
    Object.entries(jVal).forEach(item => {
      map.set(item[0], item[1]);
    })
    //获取key迭代器
    let iter: IterableIterator<string> = map.keys();
    return new JSONObject().convertString(iter, map);
  }

  /**
   * 实体对象转换为JSONObject对象
   * @param bean 实体对象
   * @returns JSONObject 对象
   */
  public static from<T>(bean: T): JSONObject {
    let json = new JSONObject();
    //转换成字符串
    let str = JSON.stringify(bean);
    //转换成json对象
    let jVal: Record<string, JSONValue> = JSON.parse(str);
    //循环赋值
    Object.entries(jVal).forEach((item) => {
      if (item[1] instanceof JSONObject) {
        json.set(item[0], JSONObject.from(item[1]));
      } else if (item[1] instanceof Array) {
        json.set(item[0], JSONArray.from(item[1]));
      } else if (item[1] instanceof JSONArray) {
        json.set(item[0], JSONArray.from(item[1]));
      } else if (item[1] instanceof JSONArrayList) {
        json.set(item[0], JSONArrayList.from(item[1]));
      } else if (item[1] instanceof Date) {
        json.set(item[0], DateUtil.format(item[1], DateConst.YMD_HLINE_HMS));
      } else if (item[1] instanceof Object) {
        json.set(item[0], JSONObject.from(item[1]));
      } else if (typeof item[1] === 'string') {
        if (DateUtil.isDate(item[1])) {
          json.set(item[0], DateUtil.formatDate(item[1], DateConst.YMD_HLINE_HMS));
        } else {
          json.set(item[0], item[1]);
        }
      } else {
        json.set(item[0], item[1]);
      }
    })
    return json;
  }

  /**
   * 迭代转换json
   * @param iter  迭代器
   * @returns json字符串
   */
  private convertString(iter: IterableIterator<string>, map?: HashMap<string, JSONValue>): string {
    //转换的字符串
    let sb: StringBuilder = new StringBuilder();
    //拼接左括号
    sb.append(Const.zkh);
    // 是否为第一个字符
    let isFirst: boolean = true;
    //迭代获取值转换成字符串
    for (const key of iter) {
      if (!isFirst) {
        //拼接逗号
        sb.append(Const.dh);
      }
      isFirst = false;
      //获取值
      let val: JSONValue = '';
      if (map && map.length > 0) {
        val = map.get(key);
      }
      //判断类型
      if (val instanceof JSONObject) {
        sb.append(Const.quot + key + Const.quot + Const.mh + (val as JSONObject).toString());
      } else if (val instanceof Array) {
        let jArr = new JSONArray();
        (val as Array<JSONValue>).forEach(item => {
          jArr.push(item);
        });
        sb.append(Const.quot + key + Const.quot + Const.mh + jArr.toString());
      } else if (val instanceof JSONArray) {
        sb.append(Const.quot + key + Const.quot + Const.mh + (val as JSONArray).toString());
      } else if (val instanceof JSONArrayList) {
        sb.append(Const.quot + key + Const.quot + Const.mh + (val as JSONArrayList).toString());
      } else if (val instanceof Date) {
        sb.append(Const.quot + key + Const.quot + Const.mh + Const.quot +
        DateUtil.format((val as Date), DateConst.YMD_HLINE_HMS) + Const.quot);
      } else if (val instanceof Object) {
        //转换成字符串
        let str = JSON.stringify(val);
        //转换成json对象
        let jVal: Record<string, JSONValue> = JSON.parse(str);
        //接收
        let jo = new JSONObject();
        //循环赋值
        Object.entries(jVal).forEach((item) => {
          jo.set(item[0], item[1]);
        })
        sb.append(Const.quot + key + Const.quot + Const.mh + jo.toString());
      } else if (typeof val === 'string') {
        // if (DateUtil.isDate(val)) {
        //   sb.append(Const.quot + key + Const.quot + Const.mh + Const.quot +
        //   DateUtil.formatDate(val, DateConst.YMD_HLINE_HMS) + Const.quot);
        // } else {
        //   sb.append(Const.quot + key + Const.quot + Const.mh + Const.quot + val + Const.quot);
        // }
        sb.append(Const.quot + key + Const.quot + Const.mh + Const.quot + val + Const.quot);
      } else if (typeof val === 'number' || typeof val === 'boolean') {
        sb.append(Const.quot + key + Const.quot + Const.mh + val);
      } else {
        sb.append(Const.quot + key + Const.quot + Const.mh + null);
      }
    }
    //拼接右括号
    sb.append(Const.ykh);
    return sb.toString();
  }

  /**
   * 将本对象转换成json字符串
   * @returns
   */
  public toString(): string {
    //获取key的迭代器
    let iter: IterableIterator<string> = this.keys();
    //转换数据
    return new JSONObject().convertString(iter, this);
  }
}