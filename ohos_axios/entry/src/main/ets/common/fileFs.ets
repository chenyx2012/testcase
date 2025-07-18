/*
 * The MIT License (MIT)
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */

import fs from '@ohos.file.fs';
import hilog from '@ohos.hilog';
import request from '@ohos.request';

const TAG = '[tpc].[axios]';
const DOMAIN = 0x0001

/**
 * write files
 * @param path: file path
 * @param name: filename
 * @param content: file content
 */
const writeFile = (path:string, name:string, content:string | ArrayBuffer):void => {
    if (!fs.accessSync(path)) {
        fs.mkdirSync(path);
    }
    let file = fs.openSync(`${path}/${name}`, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, content);
    fs.fsyncSync(file.fd);
    fs.closeSync(file);
}

/**
 * Clean up temporary directory files
 * @param cacheDir: temporary directory
 * @param options: request configuration
 */
const deleteFile = (cacheDir:string, options:request.UploadConfig):void => {
    const axios_temp = 'axios_temp'
    let path_temp = `${cacheDir}/${axios_temp}/`;
    try {
        if (options) {
            //Delete specified file
            options && options.files.forEach(item => {
                item.uri && fs.unlink(item.uri.replace(`internal://cache/${axios_temp}/`, path_temp));
            })
        } else {
            // Delete files that exceed 12 hours
            let filenames = fs.listFileSync(path_temp);
            let now = Date.now();
            for (let i = 0; i < filenames.length; i++) {
                let path = path_temp + filenames[i];
                let stat = fs.statSync(path);
                if (now - stat.atime * 1000 >= 1 * 60 * 60 * 1000) {
                    fs.unlink(path);
                }
            }
        }
    }
    catch (err) {
        hilog.error(DOMAIN, TAG, `delete file failed with error message message: ${err.message}, code: ${err.code}`);
    }
}

/**
 * read file content
 * @param fullPath: full file path
 */
const readFile = (fullPath:string):ArrayBuffer=>{
    let file = fs.openSync(fullPath, 0o2);
    let stat = fs.lstatSync(fullPath);
    let buf = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buf);
    fs.fsyncSync(file.fd);
    fs.closeSync(file.fd);
    return buf
}


/**
 * copy file to sandbox
 * @param rawfilePath
 * @param sanboxFilePath
 * @param context
 * @returns
 */
const copyToSandBox = (rawfilePath: string, sandboxFilePath: string, context: Context) => {
    try {
        let cacheDir: string = context.cacheDir;
        let file: Uint8Array = context.resourceManager.getRawFileContentSync(rawfilePath);
        if (file != null) {
            writeFile(cacheDir, sandboxFilePath, file.buffer);
        }
        return `${ cacheDir }/${ sandboxFilePath }`;
    }
    catch (err) {
        hilog.error(DOMAIN, TAG, `delete file failed with error message message: ${err.message}, code: ${err.code}`);
        return ""
    }
}

export { writeFile, deleteFile, readFile, copyToSandBox }





