import fs from '@ohos.file.fs';
import { BackupStrategy } from '../../printer/file/backup/BackupStrategy';

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

export class BackupUtil {
  static backup(loggingFilePath: string, backupStrategy: BackupStrategy) {
    let index = loggingFilePath.lastIndexOf("/");
    let logFileDir = loggingFilePath.substring(0, index);
    let logFileName = loggingFilePath.substring(index + 1, loggingFilePath.length);
    let maxBackupIndex = backupStrategy.getMaxBackupIndex();
    let nextBackupFile: string;
    let backupFilePath: string;
    if (maxBackupIndex > 0) {
      backupFilePath = `${logFileDir}/${backupStrategy.getBackupFileName(logFileName, maxBackupIndex)}`;
      if (fs.accessSync(backupFilePath)) {
        fs.unlinkSync(backupFilePath);
      }
      for (let i = maxBackupIndex - 1; i > 0; i--) {
        backupFilePath = `${logFileDir}/${backupStrategy.getBackupFileName(logFileName, i)}`;
        if (fs.accessSync(backupFilePath)) {
          nextBackupFile = `${logFileDir}/${backupStrategy.getBackupFileName(logFileName, i + 1)}`;
          fs.renameSync(backupFilePath, nextBackupFile);
        }
      }
      nextBackupFile = `${logFileDir}/${backupStrategy.getBackupFileName(logFileName, 1)}`;
      fs.renameSync(loggingFilePath, nextBackupFile);
    } else if (maxBackupIndex == 0) {
      for (let i = 1; i < 256; i++) {
        nextBackupFile = `${logFileDir}/${backupStrategy.getBackupFileName(logFileName, i)}`;
        try {
          if (!fs.accessSync(nextBackupFile)) {
            fs.renameSync(loggingFilePath, nextBackupFile);
            break;
          }
        } catch (err) {
          console.info("XLog test err" + err);
        }
      }
    } else {
      // Illegal maxBackIndex, could not come here.
    }
  }

  static verifyBackupStrategy(backupStrategy: BackupStrategy) {
    let maxBackupIndex = backupStrategy.getMaxBackupIndex();
    if (maxBackupIndex < 0) {
      throw new Error("Max backup index should not be less than 0");
    } else if (maxBackupIndex == 256) {
      throw new Error("Max backup index too big: " + maxBackupIndex);
    }
  }
}