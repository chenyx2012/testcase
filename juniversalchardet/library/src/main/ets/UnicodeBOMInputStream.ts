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

class UnicodeBOMInputStream {
    /**
     * Type safe enumeration class that describes the different types of Unicode
     * BOMs.
     */
    static BOM = class {
        bytes: ArrayBuffer = new ArrayBuffer(1024);
        description: string;
        static array0 = new Int8Array([0xEF, 0xBB, 0xBF]);
        static array1 = new Int8Array([0xFF, 0xFE]);
        static array2 = new Int8Array([0xFE, 0xFF]);
        static array3 = new Int8Array([0xFF, 0xFE, 0x00, 0x00]);
        static array4 = new Int8Array([0x00, 0x00, 0xFE, 0xFF]);

        /**
         * NONE.
         */
        public static NONE: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(new ArrayBuffer(null), "NONE");

        /**
         * UTF-8 BOM (EF BB BF).
         */
        public static UTF_8: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(UnicodeBOMInputStream.BOM.array0, "UTF-8");

        /**
         * UTF-16, little-endian (FF FE).
         */
        public static UTF_16_LE: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(UnicodeBOMInputStream.BOM.array1, "UTF-16 little-endian");

        /**
         * UTF-16, big-endian (FE FF).
         */
        public static UTF_16_BE: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(UnicodeBOMInputStream.BOM.array2, "UTF-16 big-endian");

        /**
         * UTF-32, little-endian (FF FE 00 00).
         */
        public static UTF_32_LE: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(UnicodeBOMInputStream.BOM.array3,
            "UTF-32 little-endian");

        /**
         * UTF-32, big-endian (00 00 FE FF).
         */
        public static UTF_32_BE: InstanceType<typeof UnicodeBOMInputStream.BOM> = new UnicodeBOMInputStream.BOM(UnicodeBOMInputStream.BOM.array4,
            "UTF-32 big-endian");

        /**
         * Returns a <code>String</code> representation of this <code>BOM</code>
         * value.
         */
        public toString(): String {
            return this.description;
        }

        /**
         * Returns the bytes corresponding to this <code>BOM</code> value.
         * @return the bytes corresponding to this <code>BOM</code> value.
         */
        public getBytes(): ArrayBuffer {
            let length: number = this.bytes.byteLength;
            let result: ArrayBuffer = new ArrayBuffer(length);
            // make a defensive copy
            result = this.bytes;
            return result;
        }

        public constructor(bom: ArrayBuffer, description: string) {
            if (bom == null) {
                throw new Error('invalid BOM: null is not allowed');
            }
            if (description == null) {
                throw new Error('invalid description: null is not allowed');
            }
            if (description.length != 0) {
                throw new Error('invalid description: empty string is not allowed');
            }
            this.bytes = bom;
            this.description = description;
        }
    } // BOM

    private bom: InstanceType<typeof UnicodeBOMInputStream.BOM>;
    private skipped: boolean = false;
    protected pos: number;
    private buf: ArrayBuffer;

    /**
     * Constructs a new <code>UnicodeBOMInputStream</code> that wraps the
     * specified <code>InputStream</code>. By default skip BOM bytes
     *
     * @param inputStream an <code>InputStream</code>.
     *
     * @throws NullPointerException when <code>inputStream</code> is
     * <code>null</code>.
     * @throws IOException on reading from the specified <code>InputStream</code>
     * when trying to detect the Unicode BOM.
     */

    //  public constructor(inputStream: ArrayBuffer) {
    //    this(inputStream, true);
    //  }


    /**
     * Constructs a new <code>UnicodeBOMInputStream</code> that wraps the
     * specified <code>InputStream</code>.
     *
     * @param inputStream an <code>InputStream</code>.
     * @param skipIfFound to automatically skip BOM bytes if found
     *
     * @throws NullPointerException when <code>inputStream</code> is
     * <code>null</code>.
     * @throws IOException on reading from the specified <code>InputStream</code>
     * when trying to detect the Unicode BOM.
     */
    public constructor(stream: any, skipIfFound: boolean) {
        if (stream == null) {
            throw new Error(
                "invalid input stream: null is not allowed");
        }
        let bom: ArrayBuffer = new ArrayBuffer(4);
        this.pos = 4;
        let read = stream.readSync(bom)
        const intArray = new Int8Array(bom);

        switch (read) {
            case 4:
                if ((intArray[0] == 0xFF) && (intArray[1] == 0xFE)
                && (intArray[2] == 0x00) && (intArray[3] == 0x00)) {
                    this.bom = UnicodeBOMInputStream.BOM.UTF_32_LE;
                    break;
                } else if ((intArray[0] == 0x00) && (intArray[1] == 0x00)
                && (intArray[2] == 0xFE) && (intArray[3] == 0xFF)) {
                    this.bom = UnicodeBOMInputStream.BOM.UTF_32_BE;
                    break;
                }

            case 3:
                if ((intArray[0] == 0xEF) && (intArray[1] == 0xBB)
                && (intArray[2] == 0xBF)) {
                    this.bom = UnicodeBOMInputStream.BOM.UTF_8;
                    break;
                }

            case 2:
                if ((intArray[0] == 0xFF) && (intArray[1] == 0xFE)) {
                    this.bom = UnicodeBOMInputStream.BOM.UTF_16_LE;
                    break;
                } else if ((intArray[0] == 0xFE) && (intArray[1] == 0xFF)) {
                    this.bom = UnicodeBOMInputStream.BOM.UTF_16_BE;
                    break;
                }

            default:
                this.bom = UnicodeBOMInputStream.BOM.NONE;
                break;
        }

        if (read > 0) {
            if (read > this.pos) {
                throw new Error("Push back buffer is full");
            }
            this.pos -= read;
            let temp = new Int8Array(this.buf.slice(0, this.pos));
            temp.set(intArray.slice(0, read), this.pos);
            this.buf = temp.buffer;
        }
        if (skipIfFound) {
            this.skipBOM(stream);
        }
    }

    /**
     * Returns the <code>BOM</code> that was detected in the wrapped
     * <code>InputStream</code> object.
     *
     * @return a <code>BOM</code> value.
     */
    public getBOM(): InstanceType<typeof UnicodeBOMInputStream.BOM> {
        // BOM type is immutable.
        return this.bom;
    }

    /**
     * Skips the <code>BOM</code> that was found in the wrapped
     * <code>InputStream</code> object.
     *
     * @return this <code>UnicodeBOMInputStream</code>.
     *
     * @throws IOException when trying to skip the BOM from the wrapped
     * <code>InputStream</code> object.
     */
    public skipBOM(stream: any): UnicodeBOMInputStream {
        if (!this.skipped) {
            let bytesToSkip: number = this.bom.bytes.byteLength;
            let bytesSkipped: number = this.skipPushBack(stream, bytesToSkip);
            let buf: ArrayBuffer = new ArrayBuffer(4);
            for (let i: number = bytesSkipped; i < bytesToSkip; i++) {
                stream.readSync(buf)
            }
            this.skipped = true;
        }
        return this;
    }

    private skipPushBack(stream: any, n: number): number {
        if (n <= 0) {
            return 0;
        }
        let pskip: number = this.buf.byteLength - this.pos;
        if (pskip > 0) {
            if (n < pskip) {
                pskip = n;
            }
            this.pos += pskip;
            n -= pskip;
        }
        if (n > 0) {
            pskip += this.skipIS(stream, n);
        }
        return pskip;
    }

    private skipIS(stream: any, n: number): number {
        let remaining: number = n;
        let nr: number;
        if (n <= 0) {
            return 0;
        }
        if (remaining > 2048) {
            remaining = 2048;
        }
        let size: number = remaining;
        let skipBuffer: ArrayBuffer = new ArrayBuffer(size);
        while (remaining > 0) {
            if (remaining > size) {
                remaining = size;
            }
            remaining = stream.readSync(skipBuffer, { offset: 0, length: remaining })
            if (nr < 0) {
                break;
            }
            remaining -= nr;
        }
        return n - remaining;
    }
}

export default UnicodeBOMInputStream
