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
import { Writer } from './Writer';

export class SimpleWriter extends Writer {

  private logFileDir: string = "";

  private logFileName: string = "";

  private logStream?: fs.Stream = undefined;

  open(filePath: string): boolean {
    let index = filePath.lastIndexOf("/");
    this.logFileDir = filePath.substring(0, index);
    this.logFileName = filePath.substring(index + 1, filePath.length);
    try {
      if (!fs.accessSync(this.logFileDir)) {
        fs.mkdirSync(this.logFileDir);
      }
      this.logStream = fs.createStreamSync(`${this.logFileDir}/${this.logFileName}`,  "a+");
    } catch (err) {
      console.error("XLog error: " + err);
      return false;
    }
    return true;
  }

  isOpened(): boolean {
    return this.logStream != null;
  }

  getOpenedFilePath(): string {
    return `${this.logFileDir}/${this.logFileName}`;
  }

  getOpenedFileName(): string {
    return this.logFileName;
  }

  appendLog(log: string) {
    if (this.logStream != null) {
      this.logStream.writeSync(log + "\n");
      this.logStream.flushSync();
    }
  }

  close(): boolean {
    try {
      if (this.logStream != null) {
        this.logStream.closeSync();
      }
    } catch (err) {
      console.error("XLog error: " + err);
      return false;
    }
    this.logStream = undefined;
    this.logFileDir = "";
    this.logFileName = "";
    return true;
  }

  getClassName(): string {
    return "SimpleWriter";
  }
}