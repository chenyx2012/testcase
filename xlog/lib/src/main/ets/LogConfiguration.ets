import { DefaultsFactory } from './internal/DefaultsFactory';
import { LogLevel } from './LogLevel';
import { Printer } from './printer/Printer';
import { Interceptor } from './interceptor/Interceptor';
import { BorderFormatter } from './formatter/message/BorderFormatter';
import { StackTraceFormatter } from './formatter/StackTraceFormatter';
import { ThreadFormatter } from './formatter/ThreadFormatter';
import { ThrowableFormatter } from './formatter/ThrowableFormatter';
import { XmlFormatter } from './formatter/message/XmlFormatter';
import { JsonFormatter } from './formatter/message/JsonFormatter';

/**
 * Copyright (c) 2023 Wathinst <wxz@xkzhineng.com>
 * XLog is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 * http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

export class LogConfiguration {
  logLevel: number;
  tag: string;
  withThread: boolean;
  withStackTrace: boolean;
  threadSet: boolean = false;
  stackTraceOrigin?: string;
  stackTraceDepth: number;
  stackTraceSet: boolean = false;
  withBorder: boolean;
  borderSet: boolean = false;
  jsonFormatter?: JsonFormatter;
  xmlFormatter?: XmlFormatter;
  throwableFormatter?: ThrowableFormatter;
  threadFormatter?: ThreadFormatter;
  stackTraceFormatter?: StackTraceFormatter;
  borderFormatter?: BorderFormatter;
  //  private final Map<Class<?>, ObjectFormatter<?>> objectFormatters;
  interceptors: Interceptor[];

  constructor(builder: LogConfiguration.Builder) {
    this.logLevel = builder.logLevel;

    this.tag = builder.tag;

    this.withThread = builder.withThread;
    this.withStackTrace = builder.withStackTrace;
    this.stackTraceOrigin = builder.stackTraceOrigin;
    this.stackTraceDepth = builder.stackTraceDepth;
    this.withBorder = builder.withBorder;

    this.jsonFormatter = builder.jsonFormatter;
    this.xmlFormatter = builder.xmlFormatter;
    this.throwableFormatter = builder.throwableFormatter;
    this.threadFormatter = builder.threadFormatter;
    this.stackTraceFormatter = builder.stackTraceFormatter;
    this.borderFormatter = builder.borderFormatter;

//    this.objectFormatters = builder.objectFormatters;
    this.interceptors = builder.interceptors;
  }
}

export namespace LogConfiguration {
  export class Builder {
    private DEFAULT_LOG_LEVEL: number = LogLevel.ALl;
    private DEFAULT_TAG: string = DefaultsFactory.DEFAULT_LOG_TAG;

    logLevel: number = this.DEFAULT_LOG_LEVEL;
    tag: string = this.DEFAULT_TAG;
    withThread: boolean = false;
    withStackTrace: boolean = false;
    threadSet: boolean = false;
    stackTraceOrigin?: string = "";
    stackTraceDepth: number = 1;
    stackTraceSet: boolean = false;
    withBorder: boolean = false;
    borderSet: boolean = false;
    jsonFormatter?: JsonFormatter;
    xmlFormatter?: XmlFormatter;
    throwableFormatter?: ThrowableFormatter;
    threadFormatter?: ThreadFormatter;
    stackTraceFormatter?: StackTraceFormatter;
    borderFormatter?: BorderFormatter;

    interceptors: Interceptor[] = [];
    printer: Printer[] = [];

    constructor(logConfiguration?: LogConfiguration) {
      if (logConfiguration == null) {
        return;
      }

      this.logLevel = logConfiguration.logLevel;
      this.tag = logConfiguration.tag;

      this.withThread = logConfiguration.withThread;
      this.withStackTrace = logConfiguration.withStackTrace;
      this.stackTraceOrigin = logConfiguration.stackTraceOrigin;
      this.stackTraceDepth = logConfiguration.stackTraceDepth;
      this.withBorder = logConfiguration.withBorder;

      this.jsonFormatter = logConfiguration.jsonFormatter;
      this.xmlFormatter = logConfiguration.xmlFormatter;
      this.throwableFormatter = logConfiguration.throwableFormatter;
      this.threadFormatter = logConfiguration.threadFormatter;
      this.stackTraceFormatter = logConfiguration.stackTraceFormatter;
      this.borderFormatter = logConfiguration.borderFormatter;

      /*if (logConfiguration.objectFormatters != null) {
        objectFormatters = new HashMap<>(logConfiguration.objectFormatters);
      }*/
      if (logConfiguration.interceptors != null) {
        this.interceptors = logConfiguration.interceptors;
      }
    }

    public setLogLevel(logLevel: number): Builder {
      this.logLevel = logLevel;
      return this;
    }

    public setTag(tag: string): Builder {
      this.tag = tag;
      return this;
    }

    public enableThreadInfo(): Builder {
      this.withThread = true;
      this.threadSet = true;
      return this;
    }

    public disableThreadInfo(): Builder {
      this.withThread = false;
      this.threadSet = true;
      return this;
    }

    public enableStackTrace(depth: number, stackTraceOrigin?: string): Builder {
      this.withStackTrace = true;
      this.stackTraceOrigin = stackTraceOrigin;
      this.stackTraceDepth = depth;
      this.stackTraceSet = true;
      return this;
    }

    public disableStackTrace(): Builder {
      this.withStackTrace = false;
      this.stackTraceOrigin = undefined;
      this.stackTraceDepth = 0;
      this.stackTraceSet = true;
      return this;
    }

    public enableBorder(): Builder {
      this.withBorder = true;
      this.borderSet = true;
      return this;
    }

    public disableBorder(): Builder {
      this.withBorder = false;
      this.borderSet = true;
      return this;
    }

    public setJsonFormatter(jsonFormatter: JsonFormatter): Builder {
      this.jsonFormatter = jsonFormatter;
      return this;
    }

    public setXmlFormatter(xmlFormatter: XmlFormatter): Builder {
      this.xmlFormatter = xmlFormatter;
      return this;
    }

    public setThrowableFormatter(throwableFormatter: ThrowableFormatter): Builder {
      this.throwableFormatter = throwableFormatter;
      return this;
    }

    public setThreadFormatter(threadFormatter: ThreadFormatter): Builder {
      this.threadFormatter = threadFormatter;
      return this;
    }

    public setStackTraceFormatter(stackTraceFormatter: StackTraceFormatter): Builder {
      this.stackTraceFormatter = stackTraceFormatter;
      return this;
    }

    public setBorderFormatter(borderFormatter: BorderFormatter): Builder {
      this.borderFormatter = borderFormatter;
      return this;
    }

    public addInterceptor(interceptor: Interceptor): Builder {
      if (this.interceptors == null) {
        this.interceptors = [];
      }
      this.interceptors.push(interceptor);
      return this;
    }

    public setInterceptors(interceptors: Interceptor[]): Builder {
      this.interceptors = interceptors;
      return this;
    }

    public printers(printers: Printer[]): Builder {
      if (printers == null) {
        this.printer = [];
      } else {
        this.printer = printers;
      }
      return this;
    }

    public build(): LogConfiguration {
      this.initEmptyFieldsWithDefaultValues();
      return new LogConfiguration(this);
    }

    private initEmptyFieldsWithDefaultValues() {
      if (this.jsonFormatter == null) {
        this.jsonFormatter = DefaultsFactory.createJsonFormatter();
      }
      if (this.xmlFormatter == null) {
        this.xmlFormatter = DefaultsFactory.createXmlFormatter();
      }
      if (this.throwableFormatter == null) {
        this.throwableFormatter = DefaultsFactory.createThrowableFormatter();
      }
      if (this.threadFormatter == null) {
        this.threadFormatter = DefaultsFactory.createThreadFormatter();
      }
      if (this.stackTraceFormatter == null) {
        this.stackTraceFormatter = DefaultsFactory.createStackTraceFormatter();
      }
      if (this.borderFormatter == null) {
        this.borderFormatter = DefaultsFactory.createBorderFormatter();
      }
    }
  }
}