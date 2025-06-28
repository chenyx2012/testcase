import { Formatter } from '../Formatter';

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

export class BorderFormatter extends Formatter<string[]> {
  private VERTICAL_BORDER_CHAR = '║';
  private TOP_HORIZONTAL_BORDER =
    "╔═════════════════════════════════════════════════" +
      "══════════════════════════════════════════════════";
  private DIVIDER_HORIZONTAL_BORDER =
    "╟─────────────────────────────────────────────────" +
      "──────────────────────────────────────────────────";
  private BOTTOM_HORIZONTAL_BORDER =
    "╚═════════════════════════════════════════════════" +
      "══════════════════════════════════════════════════";

  format(segments: string[]): string {
    if (segments == null || segments.length == 0) {
      return "";
    }
    let nonNullSegments: Array<string> = new Array(segments.length);
    let nonNullCount = 0;
    for (let segment of segments) {
      if (segment && segment.length > 0) {
        nonNullSegments[nonNullCount++] = segment;
      }
    }
    if (nonNullCount == 0) {
      return "";
    }
    let msgBuilder = "";
    msgBuilder += this.TOP_HORIZONTAL_BORDER + "\n";
    for (let i = 0; i < nonNullCount; i++) {
      msgBuilder += this.appendVerticalBorder(nonNullSegments[i]);
      if (i != nonNullCount - 1) {
        msgBuilder += "\n" + this.DIVIDER_HORIZONTAL_BORDER + "\n";
      } else {
        msgBuilder += "\n" + this.BOTTOM_HORIZONTAL_BORDER;
      }
    }
    return msgBuilder;
  }

  private appendVerticalBorder(msg: string): string {
    let borderedMsgBuilder = "";
    let lines = msg.split("\n");
    for (let i = 0; i < lines.length; i++) {
      if (i != 0) {
        borderedMsgBuilder += "\n";
      }
      let line = lines[i];
      borderedMsgBuilder += this.VERTICAL_BORDER_CHAR + line;
    }
    return borderedMsgBuilder;
  }
}