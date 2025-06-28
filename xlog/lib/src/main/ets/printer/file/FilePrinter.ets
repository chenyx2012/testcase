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

import { Writer } from './writer/Writer';
import { BackupStrategy } from './backup/BackupStrategy';
import { CleanStrategy } from './clean/CleanStrategy';
import { FileNameGenerator } from './naming/FileNameGenerator';
import { Flattener } from '../../flatten/Flattener';
import { Printer } from '../Printer';
import worker, { MessageEvents } from '@ohos.worker';
import { LogAddMessage, LogInitMessage, LogMessage } from './MessageType';
import { DefaultsFactory } from '../../internal/DefaultsFactory';
import { BackupUtil } from '../../internal/file/BackupUtil';

export class FilePrinter extends Printer {
  // USE_WORKER: boolean = true;
  builder: FilePrinter.Builder
  workerInstance?: worker.ThreadWorker;

  constructor(builder: FilePrinter.Builder) {
    super();
    this.builder = builder;

    if (this.builder.useWorker) {
      try {
        this.workerInstance = new worker.ThreadWorker(this.builder.workerPath);
        this.workerInstance.onmessage = (e: MessageEvents): void => {
          let data = e.data as LogMessage;
          let type = data.type;
        }
        this.workerInstance.onexit = (code) => {
          console.info("XLog: workerInstance onexit")
        }
        // this.workerInstance.onmessage = function(e){
        //   let data = e.data as LogMessage;
        //   let type = data.type;
        // }.bind(this);

        // this.workerInstance.onexit = function () {
        //   console.info("XLog: workerInstance onexit")
        // }

        let data = new LogInitMessage(this.builder);
        this.workerInstance.postMessage(data);
      } catch (err) {
        console.error("XLog start worker err: " + err)
      }
    }
  }

  println(logLevel: number, tag: string, msg: string) {
    if (this.workerInstance != null) {
      let data = new LogAddMessage(logLevel, tag, msg);
      this.workerInstance.postMessage(data);
    }
  }
}

export namespace FilePrinter {
  export class Builder {
    folderPath: string;
    workerPath: string = "entry/ets/workers/XLogWorker.ets";
    useWorker: boolean = true;
    fileNameGenerator?: FileNameGenerator;
    backupStrategy?: BackupStrategy;
    cleanStrategy?: CleanStrategy;
    flattener?: Flattener;
    writer?: Writer;

    constructor(folderPath: string, useWorker?: boolean, workerPath?: string) {
      this.folderPath = folderPath;
      if (useWorker != undefined) {
        this.useWorker = useWorker;
      }
      if (workerPath != undefined) {
        this.workerPath = workerPath;
      }
    }

    setFileNameGenerator(fileNameGenerator: FileNameGenerator): Builder {
      this.fileNameGenerator = fileNameGenerator;
      return this;
    }

    setBackupStrategy(backupStrategy: BackupStrategy): Builder {
      this.backupStrategy = backupStrategy;
      BackupUtil.verifyBackupStrategy(this.backupStrategy);
      return this;
    }

    setCleanStrategy(cleanStrategy: CleanStrategy): Builder {
      this.cleanStrategy = cleanStrategy;
      return this;
    }

    setFlattener(flattener: Flattener): Builder {
      this.flattener = flattener;
      return this;
    }

    setWriter(writer: Writer): Builder {
      this.writer = writer;
      return this;
    }

    build(): FilePrinter {
      this.fillEmptyFields();
      return new FilePrinter(this);
    }

    private fillEmptyFields() {
      if (this.fileNameGenerator == undefined) {
        this.fileNameGenerator = DefaultsFactory.createFileNameGenerator();
      }
      if (this.backupStrategy == undefined) {
        this.backupStrategy = DefaultsFactory.createBackupStrategy();
      }
      if (this.cleanStrategy == undefined) {
        this.cleanStrategy = DefaultsFactory.createCleanStrategy();
      }
      if (this.flattener == undefined) {
        this.flattener = DefaultsFactory.createFlattener();
      }
      if (this.writer == undefined) {
        this.writer = DefaultsFactory.createWriter();
      }
    }
  }
}