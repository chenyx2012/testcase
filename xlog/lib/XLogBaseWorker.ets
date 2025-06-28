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
import worker, { ErrorEvent, MessageEvents } from '@ohos.worker';
import Queue from '@ohos.util.Queue';
import {
  MessageType,
  LogMessage,
  LogInitMessage,
  LogAddMessage
} from './src/main/ets/printer/file/MessageType';
import { LogItem } from './src/main/ets/LogItem';
import { FileNameGenerator } from './src/main/ets/printer/file/naming/FileNameGenerator';
import { BackupStrategy } from './src/main/ets/printer/file/backup/BackupStrategy';
import { CleanStrategy } from './src/main/ets/printer/file/clean/CleanStrategy';
import { Writer } from './src/main/ets/printer/file/writer/Writer';
import { Flattener } from './src/main/ets/flatten/Flattener';
import { SimpleWriter } from './src/main/ets/printer/file/writer/SimpleWriter';
import { NeverBackupStrategy } from './src/main/ets/printer/file/backup/NeverBackupStrategy';
import { FileSizeBackupStrategy } from './src/main/ets/printer/file/backup/FileSizeBackupStrategy';
import { NeverCleanStrategy } from './src/main/ets/printer/file/clean/NeverCleanStrategy';
import { FileLastModifiedCleanStrategy } from './src/main/ets/printer/file/clean/FileLastModifiedCleanStrategy';
import { ChangelessFileNameGenerator } from './src/main/ets/printer/file/naming/ChangelessFileNameGenerator';
import { LevelFileNameGenerator } from './src/main/ets/printer/file/naming/LevelFileNameGenerator';
import { DateFileNameGenerator } from './src/main/ets/printer/file/naming/DateFileNameGenerator';
import { DefaultFlattener } from './src/main/ets/flatten/DefaultFlattener';
import { BackupUtil } from './src/main/ets/internal/file/BackupUtil';

const TAG: string = '[XLog worker]'


let queue:Queue<LogItem> = new Queue();
let isInit = false;

let folderPath: string;
let fileNameGenerator: FileNameGenerator;
let backupStrategy: BackupStrategy;
let cleanStrategy: CleanStrategy;
let flattener: Flattener;
let writer: Writer;

// Send or Receive Format Data Such as: {type: yourResolveType, data: yourDataJson, error?: yourErrorInfo }
export function logHandler(e: MessageEvents) {
  // data:主线程发送的消息
  let data = e.data as LogMessage;
  let type = data.type;
  switch (type) {
    case MessageType.CLOSE: {
      // 关闭线程
      console.info(`${TAG} workerPort.onmessage close`);
      isInit = false;
      worker.workerPort.close();
      break
    }

    case MessageType.INIT: {
      let initData = data as LogInitMessage
      folderPath = initData.folderPath;
      fileNameGenerator = classNameToFileNameGenerator(initData.namingClass, initData.namingValue as string);
      backupStrategy = classNameToBackupStrategy(initData.backupClass, initData.backupValue as number);
      cleanStrategy = classNameToCleanStrategy(initData.cleanClass, initData.cleanValue as number);
      flattener = classNameToFlattener(initData.flattenerClass);
      writer = classNameToWriter(initData.writerClass);
      if (!isInit) {
        isInit = true;
      }
      break
    }

    case MessageType.ADD: {
      let logData = data as LogAddMessage
      let message = new LogItem(logData.logLevel, logData.tag, logData.msg);
      queue.add(message);
      if (isInit) {
        doHandle()
      }
      break
    }

    default: {
      console.error(`${TAG} workerPort.onmessage message type error`)
    }
  }
}

function classNameToWriter(name: string): Writer {
  return new SimpleWriter();
}

function classNameToBackupStrategy(name: string, value: number): BackupStrategy {
  switch (name) {
    case "FileSizeBackupStrategy":
      return new FileSizeBackupStrategy(value);
    default:
      return new NeverBackupStrategy();
  }
}

function classNameToCleanStrategy(name: string, value: number): CleanStrategy {
  switch (name) {
    case "FileLastModifiedCleanStrategy":
      return new FileLastModifiedCleanStrategy(value);
    default:
      return new NeverCleanStrategy();
  }
}

function classNameToFileNameGenerator(name: string, value: string): FileNameGenerator {
  switch (name) {
    case "DateFileNameGenerator":
      return new DateFileNameGenerator();
    case "LevelFileNameGenerator":
      return new LevelFileNameGenerator();
    default:
      return new ChangelessFileNameGenerator(value);
  }
}

function classNameToFlattener(name: string): Flattener {
  return new DefaultFlattener();
}

async function doHandle(): Promise<boolean> {
  let promise = new Promise<boolean>((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
    while (queue.length > 0) {
      let log = queue.pop() as LogItem;
      let currentTime = new Date().getTime();
      doPrintln(currentTime, log.level, log.tag, log.msg);
    }
    resolve(true);
  })
  return promise
}

function doPrintln(timeMillis: number, logLevel: number, tag: string, msg: string) {
  let lastFileName = writer.getOpenedFileName();
  let isWriterClosed = !writer.isOpened();
  if (lastFileName == null || lastFileName.length == 0 || isWriterClosed || fileNameGenerator.isFileNameChangeable()) {
    let newFileName = fileNameGenerator.generateFileName(logLevel, timeMillis);
    if (newFileName == null || newFileName.length == 0) {
      console.error(`${TAG} File name should not be empty, ignore log: ${msg}`);
      return;
    }
    if (newFileName != lastFileName || isWriterClosed) {
      writer.close();
      cleanLogFilesIfNecessary();
      if (!writer.open(`${folderPath}/${newFileName}`)) {
        console.error(`${TAG} File open failed`);
        return;
      }
      lastFileName = newFileName;
    }
  }

  let lastFilePath = writer.getOpenedFilePath();
  if (backupStrategy.shouldBackup(lastFilePath)) {
    // Backup the log file, and create a new log file.
    writer.close();
    BackupUtil.backup(lastFilePath, backupStrategy);
    if (!writer.open(`${folderPath}/${lastFileName}`)) {
      return;
    }
  }

  let flattenedLog = flattener.flatten(timeMillis, logLevel, tag, msg);
  writer.appendLog(flattenedLog);
}

function cleanLogFilesIfNecessary() {
  try {
    let files = fs.listFileSync(folderPath);
    files.forEach(fileName => {
      if (cleanStrategy.shouldClean(`${folderPath}/${fileName}`)) {
        fs.unlinkSync(`${folderPath}/${fileName}`);
      }
    });
  } catch (err) {}
}

// worker线程发生error的回调
export function logErrorHandler(e: ErrorEvent) {
  console.info(`${TAG} workerPort.onerror ${JSON.stringify(e)}`)
}







