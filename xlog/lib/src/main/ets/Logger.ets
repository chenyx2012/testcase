import { LogLevel } from './LogLevel';
import { LogItem } from './LogItem';
import { Interceptor } from './interceptor/Interceptor';
import { XLog } from './XLog';
import { BorderFormatter } from './formatter/message/BorderFormatter';
import { StackTraceFormatter } from './formatter/StackTraceFormatter';
import { ThreadFormatter } from './formatter/ThreadFormatter';
import { ThrowableFormatter } from './formatter/ThrowableFormatter';
import { XmlFormatter } from './formatter/message/XmlFormatter';
import { JsonFormatter } from './formatter/message/JsonFormatter';
import { Printer } from './printer/Printer';
import { LogConfiguration } from './LogConfiguration';
import { PrinterSet } from './printer/PrinterSet';

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

export class Logger {
  private logConfiguration?: LogConfiguration;
  private printer?: Printer;

  constructor(logConfiguration: LogConfiguration, printer: Printer);

  constructor(builder: Logger.Builder);

  constructor(...args: Object[]) {

    if (args.length == 2) {
      this.logConfiguration = args[0] as LogConfiguration;
      this.printer = args[1] as Printer;
      return;
    }
    let builder: Logger.Builder;
    if (args.length == 1) {
      builder = args[0] as Logger.Builder;
    } else {
      return;
    }

    let logConfigBuilder: LogConfiguration.Builder = new LogConfiguration.Builder(XLog.getLogConfiguration());

    if (builder.mLogLevel != 0) {
      logConfigBuilder.setLogLevel(builder.mLogLevel);
    }

    if (builder.mTag != null) {
      logConfigBuilder.setTag(builder.mTag);
    }

    if (builder.threadSet) {
      if (builder.withThread) {
        logConfigBuilder.enableThreadInfo();
      } else {
        logConfigBuilder.disableThreadInfo();
      }
    }
    if (builder.stackTraceSet) {
      if (builder.withStackTrace) {
        // logConfigBuilder.enableStackTrace(builder.stackTraceOrigin, builder.stackTraceDepth);
      } else {
        logConfigBuilder.disableStackTrace();
      }
    }
    if (builder.borderSet) {
      if (builder.withBorder) {
        logConfigBuilder.enableBorder();
      } else {
        logConfigBuilder.disableBorder();
      }
    }

    if (builder.jsonFormatter != null) {
      logConfigBuilder.setJsonFormatter(builder.jsonFormatter);
    }
    if (builder.xmlFormatter != null) {
      logConfigBuilder.setXmlFormatter(builder.xmlFormatter);
    }
    if (builder.throwableFormatter != null) {
      logConfigBuilder.setThrowableFormatter(builder.throwableFormatter);
    }
    if (builder.threadFormatter != null) {
      logConfigBuilder.setThreadFormatter(builder.threadFormatter);
    }
    if (builder.stackTraceFormatter != null) {
      logConfigBuilder.setStackTraceFormatter(builder.stackTraceFormatter);
    }
    if (builder.borderFormatter != null) {
      logConfigBuilder.setBorderFormatter(builder.borderFormatter);
    }
    /*if (builder.objectFormatters != null) {
      logConfigBuilder.objectFormatters(builder.objectFormatters);
    }*/
    if (builder.interceptors != null) {
      logConfigBuilder.setInterceptors(builder.interceptors);
    }
    this.logConfiguration = logConfigBuilder.build();

    if (builder.printer != null) {
      this.printer = builder.printer;
    } else {
      this.printer = XLog.getSPrinter();
    }
  }

  changeLogLevel(logLevel: number) {
    if (this.logConfiguration != undefined) {
      this.logConfiguration.logLevel = logLevel;
    }
  }

  d(msg: string) {
    this.println(LogLevel.DEBUG, msg);
  }

  i(msg: string) {
    this.println(LogLevel.INFO, msg);
  }

  v(msg: string) {
    this.println(LogLevel.VERBOSE, msg);
  }

  w(msg: string) {
    this.println(LogLevel.WARN, msg);
  }

  e(msg: string) {
    this.println(LogLevel.ERROR, msg);
  }

  log(logLevel: number, msg: string) {
    this.println(logLevel, msg);
  }

  json(json: string) {
    if (LogLevel.DEBUG < this.logConfiguration!.logLevel) {
      return;
    }
    this.printlnInternal(LogLevel.DEBUG, this.logConfiguration!.jsonFormatter!.format(json));
  }

  xml(xml: string) {
    if (LogLevel.DEBUG < this.logConfiguration!.logLevel) {
      return;
    }
    this.printlnInternal(LogLevel.DEBUG, this.logConfiguration!.xmlFormatter!.format(xml));
  }

  println(logLevel: number, msg: string) {
    if (this.logConfiguration == undefined || logLevel < this.logConfiguration.logLevel) {
      return;
    }
    this.printlnInternal(logLevel, msg != null ? msg : "");
  }

  private printlnInternal(logLevel: number, msg: string) {
    if (this.logConfiguration == undefined) {
      return
    }
    let tag = this.logConfiguration.tag;
    /*var thread = this.logConfiguration.withThread
      ? this.logConfiguration.threadFormatter.format(Thread.currentThread())
      : null;
    var stackTrace = this.logConfiguration.withStackTrace
      ? this.logConfiguration.stackTraceFormatter.format(
    StackTraceUtil.getCroppedRealStackTrack(new Throwable().getStackTrace(),
    this.logConfiguration.stackTraceOrigin,
    this.logConfiguration.stackTraceDepth))
      : null;*/

    let thread: string | undefined;
    let stackTrace: string | undefined;

    if (this.logConfiguration.interceptors != null) {
      let log: LogItem | null = new LogItem(logLevel, tag, msg, thread, stackTrace);
      this.logConfiguration.interceptors.forEach((interceptor: Interceptor) => {
        log = interceptor.intercept(log!);
        if (log == null) {
          // Log is eaten, don't print this log.
          return;
        }
        // Check if the log still healthy.
        if (log.tag == "" || log.msg == "") {
          console.warn("Interceptor " + interceptor
            + " should not remove the tag or message of a log,"
            + " if you don't want to print this log,"
            + " just return a null when intercept.");
          return;
        }
      });

      logLevel = log.level;
      tag = log.tag;
      thread = log.threadInfo;
      stackTrace = log.stackTraceInfo;
      msg = log.msg;
    }

    if (this.printer != null) {
      this.printer.println(logLevel, tag, this.logConfiguration?.withBorder == true ?
      this.logConfiguration.borderFormatter!.format([msg])
        : ((thread != null ? (thread + "\n") : ""))
          + (stackTrace != null ? (stackTrace + "\n") : "")
          + msg);
    }
  }
}

export namespace Logger {
  export class Builder {
    /**
     * 日志级别，低于该级别的日志将不被打印。
     */
    mLogLevel: number = 0;
    /**
     * 日志的标记字符串。
     */
    mTag: string = "";
    /**
     * 是否记录线程信息。
     */
    withThread: boolean = false;
    /**
     * 启用/禁用线程信息。
     */
    threadSet: boolean = false;
    /**
     * 是否记录堆栈跟踪日志。
     */
    withStackTrace: boolean = false;
    /**
     * 当记录堆栈跟踪日志时，不应该记录的堆栈跟踪元素的起源，例如“com.elvishew”这样的包名,
     * 例如"com.yourdomain.logWrapper"这样的类名。
     */
    stackTraceOrigin?: string;
    /**
     * 当记录堆栈跟踪日志时，记录的堆栈跟踪元素的数量。
     * 如果没有限制则为0。
     */
    stackTraceDepth: number = 0;
    /**
     * 启用/禁用堆栈跟踪
     */
    stackTraceSet: boolean = false;
    /**
     * 是否使用边框。
     */
    withBorder: boolean = false;
    /**
     * 启用/禁用边框.
     */
    borderSet: boolean = false;
    /**
     * JSON字符串格式化.
     */
    jsonFormatter?: JsonFormatter;
    /**
     * XML字符串格式化.
     */
    xmlFormatter?: XmlFormatter;
    /**
     * 抛出异常格式化.
     */
    throwableFormatter?: ThrowableFormatter;
    /**
     * 线程信息格式化。
     */
    threadFormatter?: ThreadFormatter;
    /**
     * 堆栈跟踪格式化。
     */
    stackTraceFormatter?: StackTraceFormatter;
    /**
     * 边框格式化。
     */
    borderFormatter?: BorderFormatter;
    /**
     * The object formatters, used when {@link Logger} logging an object.
     */
    //private Map<Class<?>, ObjectFormatter<?>> objectFormatters;

    /**
     * 日志拦截。
     */
    interceptors: Interceptor[] = [];
    /**
     * The printer used to print the log when {@link Logger} log.
     */
    printer: Printer = new PrinterSet([]);

    constructor() {
      XLog.assertInitialization();
    }

    public logLevel(logLevel: number): Builder {
      this.mLogLevel = logLevel;
      return this;
    }

    public tag(tag: string): Builder {
      this.mTag = tag;
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

    public setPrinters(printers: Printer): Builder {
      if (printers == null) {
        this.printer = new PrinterSet([]);
      } else {
        this.printer = printers;
      }
      return this;
    }

    public build(): Logger {
      return new Logger(this);
    }
  }
}