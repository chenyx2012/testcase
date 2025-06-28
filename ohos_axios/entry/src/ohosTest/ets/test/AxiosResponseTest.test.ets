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
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import axios from '@ohos/axios';
import { AxiosRequestConfig, AxiosResponse } from '@ohos/axios';
import { NormalResultModel, IdModel } from '../../../main/ets/types/types';
import { LOG, DEMO_CONFIG as XTS_CONFIG } from '../../../main/ets/common/Common';

export default function AxiosResponseTest() {
  let config: AxiosRequestConfig;

  describe('AxiosResponseTest', () => {
    const HTTP_COUNT = 2; //循环测试：测试http接口性能
    const TAG = LOG.TAG;
    const DOMAIN = LOG.DOMAIN;
    const baseUrl = XTS_CONFIG.baseUrl;
    const postUrl = XTS_CONFIG.postUrl;
    beforeAll(() => {
      config = {
        url: postUrl,
        method: 'post',
        baseURL:  baseUrl,
        headers: {
          "Content-Type": "application/json"
        },
        data: {
          id: 590
        },
        timeout: 5000,
      }
    })

    it('responseType_ARRAY_BUFFER', 1, async (done: Function) => {
      let startTime = new Date().getTime();
      let options: AxiosRequestConfig = JSON.parse(JSON.stringify(config));
      options.responseType = 'ARRAY_BUFFER';
      let res: AxiosResponse = await axios<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>(options);

      let endTime = new Date().getTime();
      let averageTime = (endTime - startTime) / HTTP_COUNT;
      hilog.info(DOMAIN, TAG, " responseType_ARRAY_BUFFER averageTime: " + averageTime + ' μs');
      hilog.info(DOMAIN, TAG, " responseType_ARRAY_BUFFER averageTime: " + JSON.stringify(res.status));
      expect(res && res.data && (res.data instanceof ArrayBuffer))
        .assertTrue();
      expect(res && res.data && (typeof (res.data) === 'object') && !(res.data instanceof ArrayBuffer))
        .assertFalse();
      expect(res && res.data && (typeof (res.data) === 'string'))
        .assertFalse();
      done();
    })

    it('responseType_string', 2, async (done: Function) => {
      let startTime = new Date().getTime();
      let options: AxiosRequestConfig = JSON.parse(JSON.stringify(config));
      options.responseType = 'STRING';
      axios<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>(options).then((res: AxiosResponse<NormalResultModel>) => {
        let endTime = new Date().getTime();
        let averageTime = (endTime - startTime) / HTTP_COUNT;
        hilog.info(DOMAIN, TAG, " responseType_string averageTime: " + averageTime + ' μs');
        hilog.info(DOMAIN, TAG, " responseType_string averageTime: " + JSON.stringify(res.status));
        expect(res && res.data && (res.data instanceof ArrayBuffer))
          .assertFalse();
        expect(res && res.data && (typeof (res.data) === 'object') && !(res.data instanceof ArrayBuffer))
          .assertFalse();
        expect(res && res.data && (typeof (res.data) === 'string'))
          .assertTrue();
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    })


    it('responseType_OBJECT', 3, async (done: Function) => {
      let startTime = new Date().getTime();
      let options: AxiosRequestConfig = JSON.parse(JSON.stringify(config));
      options.responseType = 'OBJECT';
      axios<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>(options).then((res: AxiosResponse<NormalResultModel>) => {
        let endTime = new Date().getTime();
        let averageTime = (endTime - startTime) / HTTP_COUNT;
        hilog.info(DOMAIN, TAG, " responseType_OBJECT averageTime: " + averageTime + ' μs');
        hilog.info(DOMAIN, TAG, " responseType_OBJECT averageTime: " + JSON.stringify(res.status));
        expect(res.data instanceof ArrayBuffer)
          .assertFalse();
        expect(res && res.data && (typeof (res.data) === 'object') && !(res.data instanceof ArrayBuffer))
          .assertTrue();
        expect(res && res.data && (typeof (res.data) === 'string'))
          .assertFalse();
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    })

    // 返回值里含有PerformanceTiming
    it('response_PerformanceTiming', 4, async (done: Function) => {
      let options: AxiosRequestConfig = JSON.parse(JSON.stringify(config));
      options.responseType = 'OBJECT';
      axios<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>(options).then((res: AxiosResponse<NormalResultModel>) => {
        hilog.info(DOMAIN, TAG, " responseType_OBJECT averageTime: " + JSON.stringify(res.status));
        expect(res && (typeof (res.performanceTiming) === 'object'))
          .assertTrue();
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    })
  })

}
