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

import fs from '@ohos.file.fs';
import { AbstractBackupStrategy } from './AbstractBackupStrategy';

export class FileSizeBackupStrategy extends AbstractBackupStrategy {

  maxSize: number;

  maxBackupIndex: number;

  constructor(maxSize: number, maxBackupIndex?: number) {
    super();
    this.maxSize = maxSize;
    this.maxBackupIndex = maxBackupIndex == null ? 0 : maxBackupIndex;
  }

  shouldBackup(filePath: string): boolean {
    let fileStat = fs.statSync(filePath);
    return fileStat.size > this.maxSize;
  }

  getMaxBackupIndex(): number {
    return this.maxBackupIndex;
  }

  getClassName(): string {
    return "FileSizeBackupStrategy";
  }

  getClassValue(): Object {
    return this.maxSize;
  }
}