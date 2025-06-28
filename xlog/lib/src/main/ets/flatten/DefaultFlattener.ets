import { LogLevel } from '../LogLevel';
import { Flattener } from './Flattener';
import { DateUtils } from '../internal/DateUtils';

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

export class DefaultFlattener extends Flattener {
  flatten(timeMillis: number, logLevel: number, tag: string, msg: string): string {
    if (timeMillis == 0) {
      return `[${tag}](${LogLevel.getLevelName(logLevel)}) ${msg}`;
    } else {
      return `${DateUtils.dateFormat(timeMillis)} [${tag}](${LogLevel.getLevelName(logLevel)}) ${msg}`;
    }
  }

  getClassName(): string {
    return "DefaultFlattener";
  }
}