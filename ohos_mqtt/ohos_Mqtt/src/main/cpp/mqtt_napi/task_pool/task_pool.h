/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __task_pool_h_
#define __task_pool_h_

#include <ffrt/queue.h>
#include <ffrt/task.h>
#include <iostream>
#include <utility>

namespace OHOS {
namespace PahoMqtt {

ffrt_function_header_t *FfrtCreateFunctionWrapper(ffrt_function_t func,
                                                  ffrt_function_t afterFunc, void *arg);
class TaskPool {
public:
    struct AsyncData {
        std::function<void()> func;
        ffrt_task_handle_t handle{nullptr};
    };

    const std::string moduleName = "Task Pool";
    static TaskPool &GetInstance();

    template<class F, class ...Args>
    ffrt_task_handle_t PushTask(ffrt_queue_priority_t priority, F &&f, Args &&...data)
    {
        ffrt_task_attr_t taskAttr;
        (void)ffrt_task_attr_init(&taskAttr);
        ffrt_task_attr_set_queue_priority(&taskAttr, priority);
        AsyncData *asyncData = new AsyncData;
        asyncData->func = std::bind(std::forward<F>(f), std::forward<Args>(data)...);
        auto funcHeader = FfrtCreateFunctionWrapper(ExecFunction, AfterExecFunction, asyncData);
        asyncData->handle = ffrt_queue_submit_h(queue_, funcHeader, &taskAttr);
        return asyncData->handle;
    }

    template<class F, class ...Args>
    ffrt_task_handle_t PushTask(F &&f, Args &&...data)
    {
        AsyncData *asyncData = new AsyncData;
        asyncData->func = std::bind(std::forward<F>(f), std::forward<Args>(data)...);
        auto funcHeader = FfrtCreateFunctionWrapper(ExecFunction, AfterExecFunction, asyncData);
        asyncData->handle = ffrt_queue_submit_h(serialQueue_, funcHeader, nullptr);
        return asyncData->handle;
    }
private:
    const std::string queueName_{"queue"};
    const std::string serialQueueName_{"serial queue"};
    static void ExecFunction(void *data);
    static void AfterExecFunction(void *data);
    TaskPool();
    ~TaskPool();
    static TaskPool instance_;
    const size_t MaxRunningLimits_ = 8;
    const size_t defaultMaxRunningTask_ = 4;
    size_t maxRunningTask_{defaultMaxRunningTask_};
    ffrt_queue_t queue_{nullptr};
    ffrt_queue_attr_t queueAttr_;
    ffrt_queue_t serialQueue_{nullptr};
};
}
}
#endif