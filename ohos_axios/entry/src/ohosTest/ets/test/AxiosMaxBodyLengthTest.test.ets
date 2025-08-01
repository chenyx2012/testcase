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

export default function AxiosMaxBodyLengthTest() {

  describe('AxiosMaxBodyLengthTest', () => {
    const HTTP_COUNT = 2;
    const TAG = LOG.TAG;
    const DOMAIN = LOG.DOMAIN;
    const maxBodyLength = 5;
    const baseUrl = XTS_CONFIG.baseUrl;
    const getUrl = XTS_CONFIG.getUrl;
    const postUrl = XTS_CONFIG.postUrl;
    const data: IdModel = {
      id: 590
    };

    // creat get method
    it('creat_get', 0, async (done: Function) => {
      let startTime = new Date().getTime();
      const instance = axios.create();
      let configUrlTest: (index: number) => void = async (index) => {
        instance.defaults.baseURL = baseUrl;
        instance.get<NormalResultModel, AxiosResponse<NormalResultModel>, null>(getUrl, {
          maxBodyLength: maxBodyLength
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

    // request get method
    it('request_get', 1, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.request<NormalResultModel, AxiosResponse<NormalResultModel>, null>({
          url: getUrl,
          method: 'get',
          maxBodyLength: maxBodyLength
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

    //get method
    it('get', 2, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.get<NormalResultModel, AxiosResponse<NormalResultModel>, null>(getUrl, {
          maxBodyLength: maxBodyLength
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

    // post method
    it('post', 3, async (done: Function) => {
      let startTime = new Date().getTime();
      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios.post<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>(postUrl, data, {
          maxBodyLength: maxBodyLength
        }).then((res: AxiosResponse<NormalResultModel>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " post method averageTime: " + averageTime + ' μs');
            expect(isSuccess(res)).assertTrue();
            done();
          }
        }).catch((err: Error) => {
          expect(err.message).assertEqual('Request body larger than maxBodyLength limit');
          done();
        })
      }
      configUrlTest(0);
    })

    // defaultSetting
    it('defaultSetting', 4, async (done: Function) => {
      axios.defaults.baseURL = baseUrl;
      axios.defaults.headers['customer-header'] = 'customer-value';
      axios.defaults.method = 'post';
      let configUrlTest: (index: number) => void = async (index) => {
        axios<NormalResultModel, AxiosResponse<NormalResultModel>, IdModel>({
          url: postUrl,
          data: data,
          maxBodyLength: maxBodyLength
        }).then((res: AxiosResponse<NormalResultModel>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " defaultSetting averageTime: " + averageTime + ' μs');
            expect(isSuccess(res)).assertTrue();
            done();
          }
        }).catch((err: Error) => {
          expect(err.message).assertEqual('Request body larger than maxBodyLength limit');
          done();
        })
      }
      let startTime = new Date().getTime();
      configUrlTest(0);
    })

    // interceptors
    it('interceptors', 5, async (done: Function) => {
      let startTime = new Date().getTime();
      const myRequestInterceptor = axios.interceptors.request.use((config: InternalAxiosRequestConfig<null>) => {
        expect(baseUrl === baseUrl).assertTrue();
        return config;
      }, (error: AxiosError) => {
        return Promise.reject(error);
      })
      // response interceptors
      const myResponseInterceptor = axios.interceptors.response.use((response: AxiosResponse) => {
        response.data = 'hello world';
        return response;
      }, (error: AxiosError) => {
        return Promise.reject(error);
      })

      let configUrlTest: (index: number) => void = async (index) => {
        axios.defaults.baseURL = baseUrl;
        axios<string, AxiosResponse<string>, null>({
          method: 'get',
          url: getUrl,
          maxBodyLength: maxBodyLength
        }).then((res: AxiosResponse<string>) => {
          if (index < HTTP_COUNT) {
            configUrlTest(index + 1);
          } else {
            let endTime = new Date().getTime();
            let averageTime = (endTime - startTime) * 1000 / HTTP_COUNT;
            hilog.info(DOMAIN, TAG, " interceptors averageTime: " + averageTime + ' μs');
            expect(res.status === 200 && res.data === 'hello world')
              .assertTrue();
            done();
            axios.interceptors.request.eject(myRequestInterceptor);
            axios.interceptors.response.eject(myResponseInterceptor);
          }
        }).catch((err: Error) => {
          expect(err.message).assertEqual('Request body larger than maxBodyLength limit');
          done();
        })
      }
      configUrlTest(0);
    })

  })
}
