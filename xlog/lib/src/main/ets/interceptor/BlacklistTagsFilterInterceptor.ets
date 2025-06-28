import { AbstractFilterInterceptor } from './AbstractFilterInterceptor';
import { LogItem } from '../LogItem';

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

export class BlacklistTagsFilterInterceptor extends AbstractFilterInterceptor {
  private blacklistTags: string[];

  constructor(blacklistTags: string[]) {
    super();
    this.blacklistTags = blacklistTags;
  }

  reject(log: LogItem): boolean {
    if (this.blacklistTags != null) {
      this.blacklistTags.forEach((enabledTag) => {
        if (log.tag === enabledTag) {
          return true;
        }
        return false;
      })
    }
    return false;
  }
}