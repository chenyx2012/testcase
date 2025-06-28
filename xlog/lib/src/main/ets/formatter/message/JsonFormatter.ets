import { Formatter } from '../Formatter';

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

export class JsonFormatter extends Formatter<string> {
  format(json: string): string {
    let formattedString = "";
    if (json && json.length != 0) {
      try {
        let jsonObj: Object = JSON.parse(json);
        if (json.startsWith("{")) {
          formattedString = JSON.stringify(jsonObj, null, 4);
        } else if (json.startsWith("[")) {
          formattedString = JSON.stringify(jsonObj, null, 2);
        } else {
          console.warn("JSON should start with { or [");
          return json;
        }
      } catch (error) {
        console.warn(error);
        return json;
      }
      return formattedString;
    }
    console.warn("JSON empty.");
    return "";
  }
}