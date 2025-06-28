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

export class LogItem {
  level: number;
  msg: string;
  tag: string;
  threadInfo?: string;
  stackTraceInfo?: string;

  constructor(level: number, tag: string, msg: string,
              threadInfo?: string, stackTraceInfo?: string) {
    this.level = level;
    this.tag = tag;
    this.threadInfo = threadInfo;
    this.stackTraceInfo = stackTraceInfo;
    this.msg = msg;
  }
}