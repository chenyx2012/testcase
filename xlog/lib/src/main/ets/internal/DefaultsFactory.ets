import { DefaultFlattener } from '../flatten/DefaultFlattener';
import { OhPrinter } from '../printer/OhPrinter';
import { Printer } from '../printer/Printer';
import { Flattener } from '../flatten/Flattener';
import { BorderFormatter } from '../formatter/message/BorderFormatter';
import { StackTraceFormatter } from '../formatter/StackTraceFormatter';
import { ThreadFormatter } from '../formatter/ThreadFormatter';
import { ThrowableFormatter } from '../formatter/ThrowableFormatter';
import { XmlFormatter } from '../formatter/message/XmlFormatter';
import { JsonFormatter } from '../formatter/message/JsonFormatter';
import { FileNameGenerator } from '../printer/file/naming/FileNameGenerator';
import { ChangelessFileNameGenerator } from '../printer/file/naming/ChangelessFileNameGenerator';
import { BackupStrategy } from '../printer/file/backup/BackupStrategy';
import { FileSizeBackupStrategy } from '../printer/file/backup/FileSizeBackupStrategy';
import { CleanStrategy } from '../printer/file/clean/CleanStrategy';
import { NeverCleanStrategy } from '../printer/file/clean/NeverCleanStrategy';
import { Writer } from '../printer/file/writer/Writer';
import { SimpleWriter } from '../printer/file/writer/SimpleWriter';

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

export class DefaultsFactory {
  static DEFAULT_DOMAIN: number = 0x0000;
  static DEFAULT_LOG_TAG: string = "XLog";
  private static DEFAULT_LOG_FILE_NAME: string = "log";

  private static DEFAULT_LOG_FILE_MAX_SIZE: number = 1024 * 1024; // 1M bytes;

  static createJsonFormatter(): JsonFormatter {
    return new JsonFormatter();
  }

  static createXmlFormatter(): XmlFormatter {
    return new XmlFormatter();
  }

  static createThrowableFormatter(): ThrowableFormatter {
    return new ThrowableFormatter();
  }

  static createThreadFormatter(): ThreadFormatter {
    return new ThreadFormatter();
  }

  static createStackTraceFormatter(): StackTraceFormatter {
    return new StackTraceFormatter();
  }

  static createBorderFormatter(): BorderFormatter {
    return new BorderFormatter();
  }

  static createFlattener(): Flattener {
    return new DefaultFlattener();
  }

  static createPrinter(): Printer[] {
    let printers: Printer[] = [];
    printers.push(new OhPrinter());
    return printers;
  }

  static createFileNameGenerator(): FileNameGenerator {
    return new ChangelessFileNameGenerator(DefaultsFactory.DEFAULT_LOG_FILE_NAME);
  }

  static createBackupStrategy(): BackupStrategy {
    return new FileSizeBackupStrategy(DefaultsFactory.DEFAULT_LOG_FILE_MAX_SIZE);
  }

  static createCleanStrategy(): CleanStrategy {
    return new NeverCleanStrategy();
  }

  static createWriter(): Writer {
    return new SimpleWriter();
  }
}