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
import { CleanStrategy } from './CleanStrategy';

export class FileLastModifiedCleanStrategy extends CleanStrategy {
  maxTimeMillis: number;

  constructor(maxTimeMillis: number) {
    super();
    this.maxTimeMillis = maxTimeMillis;
  }

  shouldClean(filePath: string): boolean {
    let currentTime = new Date().getTime();
    let lastModified = fs.statSync(filePath).mtime * 1000;
    return (currentTime - lastModified > this.maxTimeMillis);
  }

  getClassName(): string {
    return "FileLastModifiedCleanStrategy";
  }

  getClassValue(): Object {
    return this.maxTimeMillis;
  }
}