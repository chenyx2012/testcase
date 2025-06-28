import { DefaultFlattener } from '../flatten/DefaultFlattener';
import { Flattener } from '../flatten/Flattener';
import { Printer } from './Printer';

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

export class ConsolePrinter extends Printer {
  /**
   * The log flattener when print a log.
   */
  private flattener: Flattener;

  constructor(flattener?: Flattener) {
    super();
    if (flattener == null) {
      this.flattener = new DefaultFlattener();
    } else {
      this.flattener = flattener;
    }
  }

  println(logLevel: number, tag: string, msg: string) {
    let flattenedLog = this.flattener.flatten(0, logLevel, tag, msg);
    console.log(flattenedLog);
  }
}