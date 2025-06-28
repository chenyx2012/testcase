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
import { BackupStrategy } from './BackupStrategy';

export class NeverBackupStrategy extends BackupStrategy {

  shouldBackup(filePath: string): boolean {
    return false;
  }

  getMaxBackupIndex(): number {
    return 0;
  }

  getBackupFileName(fileName: string, backupIndex: number): string {
    return "";
  }

  getClassName(): string {
    return "NeverBackupStrategy";
  }

  getClassValue(): Object {
    return "";
  }
}