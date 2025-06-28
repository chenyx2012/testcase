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
import { DateUtils } from '../../../internal/DateUtils';

import { FileNameGenerator } from './FileNameGenerator';

export class DateFileNameGenerator extends FileNameGenerator {

  isFileNameChangeable(): boolean {
    return true;
  }

  generateFileName(logLevel: number, timestamp: number): string {
    return DateUtils.dateFormat(timestamp, "yyyy-MM-dd");
  }

  getClassName(): string {
    return "DateFileNameGenerator";
  }

  getClassValue(): Object {
    return "";
  }
}