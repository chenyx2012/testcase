/**
his program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 1, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 */

import { TestLog } from '../utils/TestLog'
import fs from '@ohos.file.fs';
import { MyNavBar } from './MyNavBar';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = ''
  @State logArr: LogFile[] = []

  build() {
    Column() {
      MyNavBar({ title: '日志详情', isBack: false, isTitleCenter: true })
      Scroll() {
        Column() {
          Button("添加info日志").onClick(_ => {
            TestLog.i("test add info log");
            for (let i = 0; i < 5; i++) {
              TestLog.i("xlog add info item " + i);
            }
          }).margin(8)
          Button("添加error日志").onClick(() => {
            TestLog.e("test add error log");
            for (let i = 0; i < 5; i++) {
              TestLog.e("xlog add error item " + i);
            }
          }).margin(8)
          Button("查询日志").onClick(() => {
            this.logArr.splice(0, this.logArr.length)
            fs.listFile(`${getContext().filesDir}/log`).then(files => {
              files.forEach(file => {
                let path = `${getContext().filesDir}/log/${file}`;
                let size = fs.statSync(path).size;
                this.logArr.push(new LogFile(file, path, size));
              });
            });
          }).margin(8)
          ForEach(this.logArr, (item: LogFile) => {
            Row() {
              Text(item.name)
              Blank()
              Text(item.size + "")
            }.padding(8).width('100%').onClick(() => {
              router.pushUrl({ url: "pages/LogDetail",
                params: { logFilePath: item.path }
              });
            })
          }, (item: LogFile) => item.name)
        }
      }.layoutWeight(1).align(Alignment.Top).edgeEffect(EdgeEffect.Spring)
    }.width('100%').height('100%')
  }
}

export class LogFile {
  name: string;
  path: string;
  size: number;

  constructor(name: string, path: string, size: number) {
    this.name = name;
    this.path = path;
    this.size = size;
  }
}