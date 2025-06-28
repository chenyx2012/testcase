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

import { XLog, LogConfiguration, OhPrinter, FilePrinter, FileSizeBackupStrategy,
    DateFileNameGenerator, FileLastModifiedCleanStrategy, LevelFileNameGenerator } from '@ohos/xlog';

export class TestLog {
    static init(filesDir: string) {
        let config = new LogConfiguration.Builder()
            .setTag("XLog")
            .build();
        let printer = new FilePrinter.Builder(`${filesDir}/log`)
            .setCleanStrategy(new FileLastModifiedCleanStrategy(24 * 60 * 60 * 1000)) //24h
            .setFileNameGenerator(new DateFileNameGenerator())
            .setBackupStrategy(new FileSizeBackupStrategy(10 * 1024 * 1024)) // 10MB
            .build();
        XLog.init(config, [printer, new OhPrinter()]);
        XLog.i("xlog init");
    }

    static i(msg: string) {
        XLog.i(msg);
    }

    static d(msg: string) {
        XLog.d(msg);
    }

    static w(msg: string) {
        XLog.w(msg);
    }

    static e(msg: string) {
        XLog.e(msg);
    }
}