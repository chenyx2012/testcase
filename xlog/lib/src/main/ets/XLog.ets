import { DefaultsFactory } from './internal/DefaultsFactory';
import { Interceptor } from './interceptor/Interceptor';
import { BorderFormatter } from './formatter/message/BorderFormatter';
import { StackTraceFormatter } from './formatter/StackTraceFormatter';
import { ThreadFormatter } from './formatter/ThreadFormatter';
import { ThrowableFormatter } from './formatter/ThrowableFormatter';
import { XmlFormatter } from './formatter/message/XmlFormatter';
import { JsonFormatter } from './formatter/message/JsonFormatter';
import { Printer } from './printer/Printer';
import { Logger } from './Logger';
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

export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  logger?: Logger;
  logConfiguration?: LogConfiguration;
  printer?: Printer;
  isInitialized?: boolean;

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }
}

export class XLog {
  static init(logConfiguration?: LogConfiguration, printers?: Printer[]) {
    if (logConfiguration == null) {
      XLog.setLogConfiguration(new LogConfiguration.Builder().build());
    } else {
      XLog.setLogConfiguration(logConfiguration);
    }
    if (printers == null) {
      XLog.setSPrinter(new PrinterSet(DefaultsFactory.createPrinter()));
    } else {
      XLog.setSPrinter(new PrinterSet(printers));
    }

    XLog.setIsInitialized(true);
    XLog.setLogger(new Logger(XLog.getLogConfiguration(), XLog.getSPrinter()));
  }

  static assertInitialization() {
    if (!XLog.getIsInitialized()) {
      //throw new IllegalStateException("Do you forget to initialize XLog?");
      throw new Error("Do you forget to initialize XLog?");
    }
  }

  private static setLogger(logger: Logger) {
    GlobalContext.getContext().logger = logger;
  }

  private static getLogger(): Logger | undefined {
    if (GlobalContext.getContext().logger != undefined) {
      return GlobalContext.getContext().logger as Logger;
    }
    return undefined;
  }

  private static setLogConfiguration(logConfiguration: LogConfiguration) {
    GlobalContext.getContext().logConfiguration = logConfiguration;
  }

  static getLogConfiguration(): LogConfiguration {
    if (GlobalContext.getContext().logConfiguration != undefined) {
      return GlobalContext.getContext().logConfiguration as LogConfiguration;
    }
    let logConfigBuilder: LogConfiguration.Builder = new LogConfiguration.Builder(XLog.getLogConfiguration());
    return logConfigBuilder.build();
  }

  private static setSPrinter(printers: Printer) {
    GlobalContext.getContext().printer = printers;
  }

  static getSPrinter(): Printer {
    if (GlobalContext.getContext().printer != undefined) {
      return GlobalContext.getContext().printer as Printer;
    }
    return new PrinterSet([]);
  }

  private static setIsInitialized(isInitialized: boolean) {
    GlobalContext.getContext().isInitialized = isInitialized;
  }

  private static getIsInitialized(): boolean {
    if (GlobalContext.getContext().isInitialized != undefined) {
      return GlobalContext.getContext().isInitialized as boolean;
    }
    return false;
  }

  static changeLogLevel(logLevel: number) {
    XLog.getLogger()?.changeLogLevel(logLevel);
  }

  static logLevel(logLevel: number): Logger.Builder {
    return new Logger.Builder().logLevel(logLevel);
  }

  static tag(tag: string): Logger.Builder {
    return new Logger.Builder().tag(tag);
  }

  static enableThreadInfo(): Logger.Builder {
    return new Logger.Builder().enableThreadInfo();
  }

  static disableThreadInfo(): Logger.Builder {
    return new Logger.Builder().disableThreadInfo();
  }

  static enableStackTrace(depth: number, stackTraceOrigin?: string): Logger.Builder {
    return new Logger.Builder().enableStackTrace(depth, stackTraceOrigin);
  }

  static disableStackTrace(): Logger.Builder {
    return new Logger.Builder().disableStackTrace();
  }

  static enableBorder(): Logger.Builder {
    return new Logger.Builder().enableBorder();
  }

  static disableBorder(): Logger.Builder {
    return new Logger.Builder().disableBorder();
  }

  static setJsonFormatter(jsonFormatter: JsonFormatter): Logger.Builder {
    return new Logger.Builder().setJsonFormatter(jsonFormatter);
  }

  static setXmlFormatter(xmlFormatter: XmlFormatter): Logger.Builder {
    return new Logger.Builder().setXmlFormatter(xmlFormatter);
  }

  static setThrowableFormatter(throwableFormatter: ThrowableFormatter): Logger.Builder {
    return new Logger.Builder().setThrowableFormatter(throwableFormatter);
  }

  static setThreadFormatter(threadFormatter: ThreadFormatter): Logger.Builder {
    return new Logger.Builder().setThreadFormatter(threadFormatter);
  }

  static setStackTraceFormatter(stackTraceFormatter: StackTraceFormatter): Logger.Builder {
    return new Logger.Builder().setStackTraceFormatter(stackTraceFormatter);
  }

  static setBorderFormatter(borderFormatter: BorderFormatter): Logger.Builder {
    return new Logger.Builder().setBorderFormatter(borderFormatter);
  }

  static addInterceptor(interceptor: Interceptor): Logger.Builder {
    return new Logger.Builder().addInterceptor(interceptor);
  }

  static setPrinters(printers: Printer): Logger.Builder {
    return new Logger.Builder().setPrinters(printers);
  }

  static d(msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.d(msg);
  }

  static i(msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.i(msg);
  }

  static v(msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.v(msg);
  }

  static w(msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.w(msg);
  }

  static e(msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.e(msg);
  }

  static log(logLevel: number, msg: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.log(logLevel, msg);
  }

  static json(json: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.json(json);
  }

  static xml(xml: string) {
    XLog.assertInitialization();
    XLog.getLogger()?.xml(xml);
  }
}