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

export class LogLevel {
  static ALl: number = 0;
  static VERBOSE: number = 2;
  static DEBUG: number = 3;
  static INFO: number = 4;
  static WARN: number = 5;
  static ERROR: number = 6;

  static getLevelName(logLevel: number): string {
    let levelName: string;
    switch (logLevel) {
      case LogLevel.VERBOSE:
        levelName = "VERBOSE";
        break;
      case LogLevel.DEBUG:
        levelName = "DEBUG";
        break;
      case LogLevel.INFO:
        levelName = "INFO";
        break;
      case LogLevel.WARN:
        levelName = "WARN";
        break;
      case LogLevel.ERROR:
        levelName = "ERROR";
        break;
      default:
        if (logLevel < LogLevel.VERBOSE) {
          levelName = "VERBOSE-" + (LogLevel.VERBOSE - logLevel);
        } else {
          levelName = "ERROR+" + (logLevel - LogLevel.ERROR);
        }
        break;
    }
    return levelName;
  }

  static getShortLevelName(logLevel: number): string {
    let levelName: string;
    switch (logLevel) {
      case LogLevel.VERBOSE:
        levelName = "V";
        break;
      case LogLevel.DEBUG:
        levelName = "D";
        break;
      case LogLevel.INFO:
        levelName = "I";
        break;
      case LogLevel.WARN:
        levelName = "W";
        break;
      case LogLevel.ERROR:
        levelName = "E";
        break;
      default:
        if (logLevel < LogLevel.VERBOSE) {
          levelName = "V-" + (LogLevel.VERBOSE - logLevel);
        } else {
          levelName = "E+" + (logLevel - LogLevel.ERROR);
        }
        break;
    }
    return levelName;
  }
}