/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { GlobalContext, MimeTypeDetector } from '@ohos/mail'

export default class EntryAbility extends UIAbility {
    onCreate(want, launchParam) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    }

    onDestroy() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    }

    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

        windowStage.loadContent('pages/Index', (err, data) => {
            if (err.code) {
                hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });

        GlobalContext.getContext().setValue("filesPath", this.context.filesDir);
        GlobalContext.getContext().setValue("context", this.context);
        GlobalContext.getContext().setValue("debug", true);

        MimeTypeDetector.init((data) => {
            GlobalContext.getContext().setValue("cacheContent", data);
        })


        GlobalContext.getContext().setValue("supportMail", ["QQ", "sina.com", "sina.cn",
            "126", "126vip", "163",
            "Yeah", "Sohu", "139",
            "189", "Wo", "Tom",
            "ALiYun", "FoxMail", "Outlook",
            "Hotmail", "yahoo", "live"]);


        GlobalContext.getContext().setValue("smtpHost", ["smtp.qq.com", "smtp.sina.com", "smtp.sina.cn",
            "smtp.126.com", "smtp.vip.126.com", "smtp.163.com",
            "smtp.yeah.net", "smtp.sohu.com", "smtp.139.com",
            "smtp.189.cn", "smtp.wo.cn", "smtp.tom.com",
            "smtp.aliyun.com", "smtp.qq.com", "smtp.office365.com",
            "smtp.office365.com", "smtp.mail.yahoo.com", "smtp-mail.outlook.com"]);


        GlobalContext.getContext().setValue("popHost", ["pop.qq.com", "pop.sina.com", "pop.sina.cn",
            "pop.126.com", "pop.vip.126.com", "pop.163.com",
            "pop.yeah.net", "pop.sohu.com", "pop.139.com",
            "pop.189.cn", "pop.wo.cn", "pop.tom.com",
            "pop3.aliyun.com", "pop.qq.com", "outlook.office365.com",
            "outlook.office365.com", "pop.mail.yahoo.com", "pop-mail.outlook.com"]);


        GlobalContext.getContext().setValue("imapHost", ["imap.qq.com", "imap.sina.com", "imap.sina.cn",
            "imap.126.com", "imap.vip.126.com", "imap.163.com",
            "imap.yeah.net", "imap.sohu.com", "imap.139.com",
            "imap.189.cn", "imap.wo.cn", "imap.tom.com",
            "imap.aliyun.com", "imap.qq.com", "outlook.office365.com",
            "outlook.office365.com", "imap.mail.yahoo.com", "imap-mail.outlook.com"]);



        GlobalContext.getContext().setValue("caList", [["qq.root.crt", "qq.crt"], ["sina.com.root.crt", "sina.com.crt"], ["sina.cn.root.crt", "sina.cn.crt"],
            ["126.root.crt", "126.crt"], ["126.vip.root.crt", "126.vip.crt"], ["163.root.crt", "163.crt"],
            ["yeah.root.crt", "yeah.crt"], ["sohu.root.crt", "sohu.crt"], ["139.root.crt", "139.crt"],
            ["189.root.crt", "189.crt"], ["wo.root.crt", "wo.crt"], ["tom.root.crt", "tom.crt"],
            ["aliyun.root.crt", "aliyun.crt"], ["qq.root.crt", "qq.crt"], ["outlook.root.crt", "outlook.crt"],
            ["hotmail.root.crt", "hotmail.crt"], ["yahoo.root.crt", "yahoo.crt"], ["live.root.crt", "live.crt"]]);
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }

    onForeground() {
        // Ability has brought to foreground
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    }

    onBackground() {
        // Ability has back to background
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    }
}
