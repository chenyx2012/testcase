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
import PkgInt from './PkgInt';
import SMModel   from './SMModel';

class Big5SMModel extends SMModel {
  ////////////////////////////////////////////////////////////////
  // constants
  ////////////////////////////////////////////////////////////////
  public static BIG5_CLASS_FACTOR:number = 5;

  ////////////////////////////////////////////////////////////////
  // methods
  ////////////////////////////////////////////////////////////////
  public constructor() {
    super(new PkgInt(PkgInt.INDEX_SHIFT_4BITS, PkgInt.SHIFT_MASK_4BITS, PkgInt.BIT_SHIFT_4BITS, PkgInt.UNIT_MASK_4BITS, Big5SMModel.big5ClassTable),
          Big5SMModel.BIG5_CLASS_FACTOR,
          new PkgInt(PkgInt.INDEX_SHIFT_4BITS, PkgInt.SHIFT_MASK_4BITS, PkgInt.BIT_SHIFT_4BITS, PkgInt.UNIT_MASK_4BITS, Big5SMModel.big5StateTable),
          Big5SMModel.big5CharLenTable,
          Constants.CHARSET_BIG5
    );
  }

  ////////////////////////////////////////////////////////////////
  // constants continued
  ////////////////////////////////////////////////////////////////
  private static big5ClassTable:number[] = [
    // PkgInt.pack4bits(0,1,1,1,1,1,1,1),  // 00 - 07
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 00 - 07    //allow 0x00 as legal value
    PkgInt.pack4bits(1,1,1,1,1,1,0,0),  // 08 - 0f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 10 - 17
    PkgInt.pack4bits(1,1,1,0,1,1,1,1),  // 18 - 1f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 20 - 27
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 28 - 2f
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 30 - 37
    PkgInt.pack4bits(1,1,1,1,1,1,1,1),  // 38 - 3f
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 40 - 47
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 48 - 4f
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 50 - 57
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 58 - 5f
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 60 - 67
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 68 - 6f
    PkgInt.pack4bits(2,2,2,2,2,2,2,2),  // 70 - 77
    PkgInt.pack4bits(2,2,2,2,2,2,2,1),  // 78 - 7f
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 80 - 87
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 88 - 8f
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 90 - 97
    PkgInt.pack4bits(4,4,4,4,4,4,4,4),  // 98 - 9f
    PkgInt.pack4bits(4,3,3,3,3,3,3,3),  // a0 - a7
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // a8 - af
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // b0 - b7
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // b8 - bf
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // c0 - c7
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // c8 - cf
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // d0 - d7
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // d8 - df
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // e0 - e7
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // e8 - ef
    PkgInt.pack4bits(3,3,3,3,3,3,3,3),  // f0 - f7
    PkgInt.pack4bits(3,3,3,3,3,3,3,0)   // f8 - ff
  ];

  private static big5StateTable:number[] = [
    PkgInt.pack4bits(SMModel.ERROR, SMModel.START, SMModel.START, 3, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR, SMModel.ERROR),//00-07
    PkgInt.pack4bits(SMModel.ERROR, SMModel.ERROR, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ITSME, SMModel.ERROR),//08-0f
    PkgInt.pack4bits(SMModel.ERROR, SMModel.START, SMModel.START, SMModel.START, SMModel.START, SMModel.START, SMModel.START, SMModel.START) //10-17
  ];

  private static big5CharLenTable:number[] = [
    0, 1, 1, 2, 0
  ];
}

export default Big5SMModel;