/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 1998
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Copyright (c) 2022 Huawei Device Co., Ltd.
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

import Constants from '../../Constants';
import PkgInt    from './PkgInt';
import SMModel   from './SMModel';

class UTF8SMModel extends SMModel {
  ////////////////////////////////////////////////////////////////
  // constants
  ////////////////////////////////////////////////////////////////
  public static UTF8_CLASS_FACTOR:number = 16;

  ////////////////////////////////////////////////////////////////
  // methods
  ////////////////////////////////////////////////////////////////
  public constructor() {
    super(new PkgInt(PkgInt.INDEX_SHIFT_4BITS, PkgInt.SHIFT_MASK_4BITS, PkgInt.BIT_SHIFT_4BITS, PkgInt.UNIT_MASK_4BITS, UTF8SMModel.utf8ClassTable),
          UTF8SMModel.UTF8_CLASS_FACTOR,
          new PkgInt(PkgInt.INDEX_SHIFT_4BITS, PkgInt.SHIFT_MASK_4BITS, PkgInt.BIT_SHIFT_4BITS, PkgInt.UNIT_MASK_4BITS, UTF8SMModel.utf8StateTable),
          UTF8SMModel.utf8CharLenTable,
          Constants.CHARSET_UTF_8
    );
  }

  ////////////////////////////////////////////////////////////////
  // constants continued
  ////////////////////////////////////////////////////////////////
  private static utf8ClassTable:number[] = [
    // PkgInt.pack4bits(0,1,1,1,1,1,1,1),  // 00 - 07
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 00 - 07  //allow 0x00 as a legal value
    PkgInt.pack4bits(1,1,1,1,1,1,0,0),  // 08 - 0f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 10 - 17
    PkgInt.pack4bits(1,1,1,0,1,1,1,1),  // 18 - 1f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 20 - 27
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 28 - 2f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 30 - 37
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 38 - 3f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 40 - 47
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 48 - 4f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 50 - 57
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 58 - 5f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 60 - 67
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 68 - 6f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 70 - 77
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 78 - 7f
    PkgInt.pack4bits(2,2,2,2,3,3,3,3),  // 80 - 87
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 88 - 8f
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 90 - 97
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 98 - 9f
    PkgInt.pack4bits(5,5,5,5,5,5,5,5),  // a0 - a7
    PkgInt.pack4bits(5,5,5,5,5,5,5,5),  // a8 - af
    PkgInt.pack4bits(5,5,5,5,5,5,5,5),  // b0 - b7
    PkgInt.pack4bits(5,5,5,5,5,5,5,5),  // b8 - bf
    PkgInt.pack4bits(0,0,6,6,6,6,6,6),  // c0 - c7
    PkgInt.pack4bits(6,6,6,6,6,6,6,6),  // c8 - cf
    PkgInt.pack4bits(6,6,6,6,6,6,6,6),  // d0 - d7
    PkgInt.pack4bits(6,6,6,6,6,6,6,6),  // d8 - df
    PkgInt.pack4bits(7,8,8,8,8,8,8,8),  // e0 - e7
    PkgInt.pack4bits(8,8,8,8,8,9,8,8),  // e8 - ef
    PkgInt.pack4bits(10,11,11,11,11,11,11,11),  // f0 - f7
    PkgInt.pack4bits(12,13,13,13,14,15,0,0)   // f8 - ff
  ];

  private static utf8StateTable:number[] = [
    PkgInt.pack4bits(SMModel.ERROR, SMModel.START, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, 12, 10),//00-07
    PkgInt.pack4bits(9, 11, 8, 7, 6, 5, 4, 3),//08-0f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//10-17
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//18-1f
    PkgInt.pack4bits(SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME),//20-27
    PkgInt.pack4bits(SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME),//28-2f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, 5, 5, 5, 5, SMModel.ERROR, SMModel.ERROR),//30-37
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//38-3f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, 5, 5, 5, SMModel.ERROR, SMModel.ERROR),//40-47
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//48-4f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, 7, 7, 7, 7, SMModel.ERROR, SMModel.ERROR),//50-57
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//58-5f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, 7, 7, SMModel.ERROR, SMModel.ERROR),//60-67
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//68-6f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, 9, 9, 9, 9, SMModel.ERROR, SMModel.ERROR),//70-77
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//78-7f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, 9, 9, SMModel.ERROR, SMModel.ERROR),//80-87  // Allow emoji
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//88-8f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, 12, 12, 12, 12, SMModel.ERROR, SMModel.ERROR),//90-97
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//98-9f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, 12, SMModel.ERROR, SMModel.ERROR),//a0-a7
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//a8-af
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, 12, 12, 12, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//b0-b7
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//b8-bf
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.START, SMModel.START, SMModel.START, SMModel.START, SMModel.ERROR, SMModel.ERROR),//c0-c7
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR) //c8-cf
  ];

  private static utf8CharLenTable:number[] = [
    0, 1, 0, 0, 0, 0, 2, 3,
    3, 3, 4, 4, 5, 5, 6, 6
  ];
}

export default UTF8SMModel;