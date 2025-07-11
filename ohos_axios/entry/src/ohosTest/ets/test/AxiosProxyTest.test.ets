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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import axios,{ AxiosError, AxiosResponse} from '@ohos/axios';
import { LOG, DEMO_CONFIG as XTS_CONFIG } from '../../../main/ets/common/Common';
import { isSuccess } from '../utils/utils';

export default function AxiosProxyTest() {
  describe('AxiosProxyTest', () => {
    const TAG = LOG.TAG;
    const DOMAIN = LOG.DOMAIN;
    const proxyHttps = XTS_CONFIG.proxyHttps;
    const proxyHttp = XTS_CONFIG.proxyHttp;
    const host = XTS_CONFIG.host;

    it('proxy', 0, async (done: Function) => {
      let startTime = new Date().getTime()
        axios({
          url: proxyHttps,
          method: 'get',
          proxy:{
            host: host,
            port: 8005,
            exclusionList: []
          }
        }).then((res: AxiosResponse) => {
          let endTime = new Date().getTime();
          let averageTime = (endTime - startTime) * 1000;
          hilog.info(DOMAIN, TAG, " proxy averageTime: " + averageTime + ' μs');
          expect(isSuccess(res)).assertTrue();
          done();
        }).catch(() => {
          expect().assertFail();
          done();
        })
    })

    it('proxy_http', 1, async (done: Function) => {
      let startTime = new Date().getTime()
      axios({
        url: proxyHttp,
        method: 'get',
        proxy:{
          host: host,
          port: 8005,
          exclusionList: []
        }
      }).then((res: AxiosResponse) => {
        let endTime = new Date().getTime();
        let averageTime = (endTime - startTime) * 1000;
        hilog.info(DOMAIN, TAG, " proxy_http averageTime: " + averageTime + ' μs');
        expect(isSuccess(res)).assertTrue();
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    })
  })
}