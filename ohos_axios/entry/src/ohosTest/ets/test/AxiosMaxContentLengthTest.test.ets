/*
 * The MIT License (MIT)
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import axios, { AxiosError, AxiosHeaders } from '@ohos/axios';
import { AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { NormalResultModel, IdModel } from '../../../main/ets/types/types';
import hilog from '@ohos.hilog';
import { LOG, DEMO_CONFIG as XTS_CONFIG } from '../../../main/ets/common/Common';
import { isSuccess } from '../utils/utils';

export default function AxiosMaxContentLengthTest() {

  describe('AxiosMaxContentLengthTest', () => {
    const HTTP_COUNT = 2;
    const TAG = LOG.TAG;
    const DOMAIN = LOG.DOMAIN;
    const maxContentLength = -1;
    const maxContentLengthLarge = 6 * 1024 * 1024;
    const maxContentLengthLess = 10;
    const baseUrl = XTS_CONFIG.baseUrl;
    const getUrl = XTS_CONFIG.getUrl;

    //get method
    it('get', 0, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.get<NormalResultModel, AxiosResponse<NormalResultModel>, null>(getUrl, {
          maxContentLength: maxContentLength
        }).then((res: AxiosResponse<NormalResultModel>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " get method averageTime: " + averageTime + ' μs');
            expect(isSuccess(res)).assertTrue();
            done();
          }
        }).catch(() => {
          expect().assertFail();
          done();
        })
      }
      configUrlTest(0);
    })

    // 返回字节数小于config.maxContentLength
    it('get_langerThanResponseLimit', 0, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.get<NormalResultModel, AxiosResponse<NormalResultModel>, null>(getUrl, {
          maxContentLength: maxContentLengthLarge
        }).then((res: AxiosResponse<NormalResultModel>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " get method averageTime: " + averageTime + ' μs');
            expect(isSuccess(res)).assertTrue();
            done();
          }
        }).catch(() => {
          expect().assertFail();
          done();
        })
      }
      configUrlTest(0);
    })

    // 返回字节数大于config.maxContentLength
    it('get_lessThanResponseLimit', 0, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.get<NormalResultModel, AxiosResponse<NormalResultModel>, null>(getUrl, {
          maxContentLength: maxContentLengthLess
        }).then((res: AxiosResponse<NormalResultModel>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " get method averageTime: " + averageTime + ' μs');
            expect(isSuccess(res)).assertTrue();
            done();
          }
        }).catch((err:AxiosError) => {
          expect(err.message).assertEqual('maxContentLength size of 10 exceeded');
          done();
        })
      }
      configUrlTest(0);
    })
  })
}
