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

import { FileNameGenerator } from './FileNameGenerator';

export class ChangelessFileNameGenerator extends FileNameGenerator {

  fileName: string;

  constructor(fileName: string) {
    super();
    this.fileName = fileName;
  }

  isFileNameChangeable(): boolean {
    return false;
  }

  generateFileName(logLevel: number, timestamp: number): string {
    return this.fileName;
  }

  getClassName(): string {
    return "ChangelessFileNameGenerator";
  }

  getClassValue(): Object {
    return this.fileName;
  }
}