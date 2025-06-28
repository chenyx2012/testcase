import { DefaultsFactory } from '../internal/DefaultsFactory';
import { LogLevel } from '../LogLevel';
import hilog from '@ohos.hilog';
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

export class OhPrinter extends Printer {
  /**
   * Generally, android has a default length limit of 4096 for single log, but
   * some device(like HUAWEI) has its own shorter limit, so we just use 4000
   * and wish it could run well in all devices.
   */
  static DEFAULT_MAX_CHUNK_SIZE = 4000;
  /**
   * Whether the log should be separated by line separator automatically.
   */
  private autoSeparate: boolean;
  private maxChunkSize: number;

  constructor(autoSeparate: boolean = false, maxChunkSize: number = OhPrinter.DEFAULT_MAX_CHUNK_SIZE) {
    super();
    this.autoSeparate = autoSeparate;
    this.maxChunkSize = maxChunkSize;
  }

  println(logLevel: number, tag: string, msg: string) {
    let msgLength = msg.length;
    let start = 0;
    let end = 0;
    while (start < msgLength) {
      if (msg.charAt(start) == '\n') {
        start++;
        continue;
      }
      end = Math.min(start + this.maxChunkSize, msgLength);
      if (this.autoSeparate) {
        let newLine = msg.indexOf('\n', start);
        end = newLine != -1 ? Math.min(end, newLine) : end;
      } else {
        end = this.adjustEnd(msg, start, end);
      }
      this.printlnItem(logLevel, tag, msg.substring(start, end));

      start = end;
    }
  }

  private adjustEnd(msg: string, start: number, originEnd: number): number {
    if (originEnd == msg.length) {
      return originEnd;
    }
    if (msg.charAt(originEnd) == '\n') {
      // Already prior to '\n'.
      return originEnd;
    }
    // Search back for '\n'.
    let last = originEnd - 1;
    while (start < last) {
      if (msg.charAt(last) == '\n') {
        return last;
      }
      last--;
    }
    return originEnd;
  }

  printlnItem(logLevel: number, tag: string, msg: string) {
    switch (logLevel) {
      case LogLevel.VERBOSE:
        hilog.info(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        break;
      case LogLevel.DEBUG:
        hilog.debug(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        break;
      case LogLevel.INFO:
        hilog.info(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        break;
      case LogLevel.WARN:
        hilog.warn(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        break;
      case LogLevel.ERROR:
        hilog.error(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        break;
      default:
        if (logLevel < LogLevel.VERBOSE) {
          hilog.info(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        } else {
          hilog.error(DefaultsFactory.DEFAULT_DOMAIN, tag, '%{public}s', msg);
        }
        break;
    }
  }
}