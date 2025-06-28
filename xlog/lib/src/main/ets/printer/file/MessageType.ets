import { FilePrinter } from './FilePrinter';

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

export enum MessageType {
  CLOSE,
  INIT,
  ADD
}

export class LogMessage {
  public type: MessageType;

  constructor(_type: MessageType) {
    this.type = _type;
  }
}

export class LogInitMessage extends LogMessage {
  //public descriptor: resourceManager.RawFileDescriptor;
  //builder: FilePrinter.Builder
  folderPath: string;
  writerClass: string;
  namingClass: string;
  namingValue: Object;
  backupClass: string;
  backupValue: Object;
  cleanClass: string;
  cleanValue: Object;
  flattenerClass: string;

  constructor(_builder: FilePrinter.Builder) {
    super(MessageType.INIT);
    //this.builder = _builder;
    this.folderPath = _builder.folderPath;
    this.writerClass = _builder.writer == undefined ? "" : _builder.writer.getClassName();
    this.namingClass = _builder.fileNameGenerator == undefined ? "" : _builder.fileNameGenerator.getClassName();
    this.namingValue = _builder.fileNameGenerator == undefined ? "" : _builder.fileNameGenerator.getClassValue();
    this.backupClass = _builder.backupStrategy == undefined ? "" : _builder.backupStrategy.getClassName();
    this.backupValue = _builder.backupStrategy == undefined ? "" : _builder.backupStrategy.getClassValue();
    this.cleanClass = _builder.cleanStrategy == undefined ? "" : _builder.cleanStrategy.getClassName();
    this.cleanValue = _builder.cleanStrategy == undefined ? "" : _builder.cleanStrategy.getClassValue();
    this.flattenerClass = _builder.flattener == undefined ? "" : _builder.flattener.getClassName();
  }
}

export class LogAddMessage extends LogMessage {
  logLevel: number;
  tag: string;
  msg: string;

  constructor(_logLevel: number, _tag: string, _msg: string) {
    super(MessageType.ADD);
    this.logLevel = _logLevel;
    this.tag = _tag;
    this.msg = _msg;
  }
}
