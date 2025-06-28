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

export abstract class FileNameGenerator {
  /**
   * 生成的文件名是否会更改。
   *
   * @return true if the file name is changeable
   */
  abstract isFileNameChangeable(): boolean;

  /**
   * 为指定的日志级别和时间戳生成文件名。
   *
   * @param logLevel  the level of the log
   * @param timestamp the timestamp when the logging happen
   * @return the generated file name
   */
  abstract generateFileName(logLevel: number, timestamp: number): string;

  abstract getClassName(): string;
  abstract getClassValue(): Object;
}