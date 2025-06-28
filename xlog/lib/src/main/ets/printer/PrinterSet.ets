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

export class PrinterSet extends Printer {
  private printers: Printer[] = [];

  constructor(printers: Printer[]) {
    super();
    this.printers = printers;
  }

  println(logLevel: number, tag: string, msg: string): void {
    this.printers.forEach(printer => {
      printer.println(logLevel, tag, msg);
    });
  }
}