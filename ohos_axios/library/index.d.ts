// TypeScript Version: 4.7
import http from '@ohos.net.http'
type AxiosHeaderValue = AxiosHeaders | string | string[] | number | boolean | null;

interface RawAxiosHeaders {
  [key: string]: AxiosHeaderValue;
}

type MethodsHeaders = Partial<{
  [Key in Method as Lowercase<Key>]: AxiosHeaders;
} & {common: AxiosHeaders}>;

type AxiosHeaderMatcher = (this: AxiosHeaders, value: string, name: string, headers: RawAxiosHeaders) => boolean;

export class AxiosHeaders {
  constructor(
      headers?: RawAxiosHeaders | AxiosHeaders
  );

  [key: string]: any;

  set(headerName?: string, value?: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  set(headers?: RawAxiosHeaders | AxiosHeaders, rewrite?: boolean): AxiosHeaders;

  get(headerName: string, parser: RegExp): RegExpExecArray | null;
  get(headerName: string, matcher?: true | AxiosHeaderMatcher): AxiosHeaderValue;

  has(header: string, matcher?: true | AxiosHeaderMatcher): boolean;

  delete(header: string | string[], matcher?: AxiosHeaderMatcher): boolean;

  clear(matcher?: AxiosHeaderMatcher): boolean;

  normalize(format: boolean): AxiosHeaders;

  concat(...targets: Array<AxiosHeaders | RawAxiosHeaders | string | undefined | null>): AxiosHeaders;

  toJSON(asStrings?: boolean): RawAxiosHeaders;

  static from(thing?: AxiosHeaders | RawAxiosHeaders | string): AxiosHeaders;

  static accessor(header: string | string[]): AxiosHeaders;

  static concat(...targets: Array<AxiosHeaders | RawAxiosHeaders | string | undefined | null>): AxiosHeaders;

  setContentType(value: ContentType, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getContentType(parser?: RegExp): RegExpExecArray | null;
  getContentType(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasContentType(matcher?: AxiosHeaderMatcher): boolean;

  setContentLength(value: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getContentLength(parser?: RegExp): RegExpExecArray | null;
  getContentLength(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasContentLength(matcher?: AxiosHeaderMatcher): boolean;

  setAccept(value: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getAccept(parser?: RegExp): RegExpExecArray | null;
  getAccept(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasAccept(matcher?: AxiosHeaderMatcher): boolean;

  setUserAgent(value: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getUserAgent(parser?: RegExp): RegExpExecArray | null;
  getUserAgent(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasUserAgent(matcher?: AxiosHeaderMatcher): boolean;

  setContentEncoding(value: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getContentEncoding(parser?: RegExp): RegExpExecArray | null;
  getContentEncoding(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasContentEncoding(matcher?: AxiosHeaderMatcher): boolean;

  setAuthorization(value: AxiosHeaderValue, rewrite?: boolean | AxiosHeaderMatcher): AxiosHeaders;
  getAuthorization(parser?: RegExp): RegExpExecArray | null;
  getAuthorization(matcher?: AxiosHeaderMatcher): AxiosHeaderValue;
  hasAuthorization(matcher?: AxiosHeaderMatcher): boolean;

  [Symbol.iterator](): IterableIterator<[string, AxiosHeaderValue]>;
}

type CommonRequestHeadersList = 'Accept' | 'Content-Length' | 'User-Agent' | 'Content-Encoding' | 'Authorization';

type ContentType = AxiosHeaderValue | 'text/html' | 'text/plain' | 'multipart/form-data' | 'application/json' | 'application/x-www-form-urlencoded' | 'application/octet-stream';

export type RawAxiosRequestHeaders = Partial<RawAxiosHeaders & {
  [Key in CommonRequestHeadersList]: AxiosHeaderValue;
} & {
  'Content-Type': ContentType
}>;

export type AxiosRequestHeaders = RawAxiosRequestHeaders & AxiosHeaders;

type CommonResponseHeadersList = 'Server' | 'Content-Type' | 'Content-Length' | 'Cache-Control'| 'Content-Encoding';

type RawCommonResponseHeaders = {
  [Key in CommonResponseHeadersList]: AxiosHeaderValue;
} & {
  "set-cookie": string[];
};

export type RawAxiosResponseHeaders = Partial<RawAxiosHeaders & RawCommonResponseHeaders>;

export type AxiosResponseHeaders = RawAxiosResponseHeaders & AxiosHeaders;

export interface AxiosRequestTransformer {
  (this: InternalAxiosRequestConfig, data: any, headers: AxiosRequestHeaders): any;
}

export interface AxiosResponseTransformer {
  (this: InternalAxiosRequestConfig, data: any, headers: AxiosResponseHeaders, status?: number): any;
}

export interface AxiosAdapter {
  (config: InternalAxiosRequestConfig): AxiosPromise;
}

export interface AxiosBasicCredentials {
  username: string;
  password: string;
}

export interface AxiosProxyConfig {
  host: string;
  port: number;
  exclusionList: Array<string>;
}

export enum HttpStatusCode {
  Continue = 100,
  SwitchingProtocols = 101,
  Processing = 102,
  EarlyHints = 103,
  Ok = 200,
  Created = 201,
  Accepted = 202,
  NonAuthoritativeInformation = 203,
  NoContent = 204,
  ResetContent = 205,
  PartialContent = 206,
  MultiStatus = 207,
  AlreadyReported = 208,
  ImUsed = 226,
  MultipleChoices = 300,
  MovedPermanently = 301,
  Found = 302,
  SeeOther = 303,
  NotModified = 304,
  UseProxy = 305,
  Unused = 306,
  TemporaryRedirect = 307,
  PermanentRedirect = 308,
  BadRequest = 400,
  Unauthorized = 401,
  PaymentRequired = 402,
  Forbidden = 403,
  NotFound = 404,
  MethodNotAllowed = 405,
  NotAcceptable = 406,
  ProxyAuthenticationRequired = 407,
  RequestTimeout = 408,
  Conflict = 409,
  Gone = 410,
  LengthRequired = 411,
  PreconditionFailed = 412,
  PayloadTooLarge = 413,
  UriTooLong = 414,
  UnsupportedMediaType = 415,
  RangeNotSatisfiable = 416,
  ExpectationFailed = 417,
  ImATeapot = 418,
  MisdirectedRequest = 421,
  UnprocessableEntity = 422,
  Locked = 423,
  FailedDependency = 424,
  TooEarly = 425,
  UpgradeRequired = 426,
  PreconditionRequired = 428,
  TooManyRequests = 429,
  RequestHeaderFieldsTooLarge = 431,
  UnavailableForLegalReasons = 451,
  InternalServerError = 500,
  NotImplemented = 501,
  BadGateway = 502,
  ServiceUnavailable = 503,
  GatewayTimeout = 504,
  HttpVersionNotSupported = 505,
  VariantAlsoNegotiates = 506,
  InsufficientStorage = 507,
  LoopDetected = 508,
  NotExtended = 510,
  NetworkAuthenticationRequired = 511,
}

export type Method =
    | 'get' | 'GET'
    | 'delete' | 'DELETE'
    | 'head' | 'HEAD'
    | 'options' | 'OPTIONS'
    | 'post' | 'POST'
    | 'put' | 'PUT'
    | 'patch' | 'PATCH'
    | 'purge' | 'PURGE'
    | 'link' | 'LINK'
    | 'unlink' | 'UNLINK';


export type ResponseType =
  | 'string' | 'STRING'
  | 'object' | 'OBJECT'
  | 'array_buffer' | 'ARRAY_BUFFER'


export type responseEncoding =
    | 'ascii' | 'ASCII'
    | 'ansi' | 'ANSI'
    | 'binary' | 'BINARY'
    | 'base64' | 'BASE64'
    | 'base64url' | 'BASE64URL'
    | 'hex' | 'HEX'
    | 'latin1' | 'LATIN1'
    | 'ucs-2' | 'UCS-2'
    | 'ucs2' | 'UCS2'
    | 'utf-8' | 'UTF-8'
    | 'utf8' | 'UTF8'
    | 'utf16le' | 'UTF16LE';

export type CertType =
  | 'pem' | 'PEM'
  | 'der' | 'DER'
  | 'p12' | 'P12'

export interface ClientCert {
  certPath: string;
  certType?: CertType;
  keyPath?: string;
  keyPasswd?: string;
}

export interface TransitionalOptions {
  silentJSONParsing?: boolean;
  forcedJSONParsing?: boolean;
  clarifyTimeoutError?: boolean;
}

export interface GenericAbortSignal {
  readonly aborted: boolean;
  onabort?: ((...args: any) => any) | null;
  addEventListener?: (...args: any) => any;
  removeEventListener?: (...args: any) => any;
}

export interface FormDataVisitorHelpers {
  defaultVisitor: SerializerVisitor;
  convertValue: (value: any) => any;
  isVisitable: (value: any) => boolean;
}

export interface SerializerVisitor {
  (
      this: GenericFormData,
      value: any,
      key: string | number,
      path: null | Array<string | number>,
      helpers: FormDataVisitorHelpers
  ): boolean;
}

export interface SerializerOptions {
  visitor?: SerializerVisitor;
  dots?: boolean;
  metaTokens?: boolean;
  indexes?: boolean | null;
}

// tslint:disable-next-line
export interface FormSerializerOptions extends SerializerOptions {
}

export interface ParamEncoder {
  (value: any, defaultEncoder: (value: any) => any): any;
}

export interface CustomParamsSerializer {
  (params: Record<string, any>, options?: ParamsSerializerOptions): string;
}

export interface ParamsSerializerOptions extends SerializerOptions {
  encode?: ParamEncoder;
  serialize?: CustomParamsSerializer;
}

type MaxUploadRate = number;

type MaxDownloadRate = number;

type BrowserProgressEvent = any;

export interface AxiosProgressEvent {
  loaded: number;
  total?: number;
  progress?: number;
  bytes: number;
  rate?: number;
  estimated?: number;
  upload?: boolean;
  download?: boolean;
  event?: BrowserProgressEvent;
}

type Milliseconds = number;

type AxiosAdapterName = 'xhr' | 'http' | string;

type AxiosAdapterConfig = AxiosAdapter | AxiosAdapterName;

export interface AxiosRequestConfig<D = any> {
  url?: string;
  method?: Method | string;
  baseURL?: string;
  transformRequest?: AxiosRequestTransformer | AxiosRequestTransformer[];
  transformResponse?: AxiosResponseTransformer | AxiosResponseTransformer[];
  headers?: (RawAxiosRequestHeaders & MethodsHeaders) | AxiosHeaders;
  params?: any;
  paramsSerializer?: ParamsSerializerOptions;
  data?: D;
  timeout?: Milliseconds;
  readTimeout?: Milliseconds;
  timeoutErrorMessage?: string;
  connectTimeout?: Milliseconds;
  // withCredentials?: boolean;
  adapter?: AxiosAdapterConfig | AxiosAdapterConfig[];
  // auth?: AxiosBasicCredentials;
  responseType?: ResponseType;
  responseEncoding?: responseEncoding | string;
  // xsrfCookieName?: string;
  // xsrfHeaderName?: string;
  onUploadProgress?: (progressEvent: AxiosProgressEvent) => void;
  onDownloadProgress?: (progressEvent: AxiosProgressEvent) => void;
  maxContentLength?: number;
  validateStatus?: ((status: number) => boolean) | null;
  maxBodyLength?: number;
  // maxRedirects?: number;
  // maxRate?: number | [MaxUploadRate, MaxDownloadRate];
  // beforeRedirect?: (options: Record<string, any>, responseDetails: {headers: Record<string, string>}) => void;
  // socketPath?: string | null;
  // httpAgent?: any;
  // httpsAgent?: any;
  proxy?: AxiosProxyConfig | boolean;
  // cancelToken?: CancelToken;
  // decompress?: boolean;
  // transitional?: TransitionalOptions;
  // signal?: GenericAbortSignal;
  // insecureHTTPParser?: boolean;
  context?: any;
  filePath?: string;
  formSerializer?: FormSerializerOptions;
  priority?: number;
  caPath?: string;
  clientCert?: ClientCert;
  // The following six attributes take effect only in Axios for HttpClient, see https://gitee.com/openharmony-tpc/httpclient/blob/master/README.md for details
  sslCertificateManager?: X509TrustManager;
  client?: any;
  dns?: Dns;
  eventListener?: any;
  async?: boolean;
  cache?: any;
  remoteValidation?: RemoteValidation;
}

type RemoteValidation = 'system' | 'skip';

interface X509TrustManager {
  checkClientTrusted(data: certFramework.X509Cert): void;

  checkServerTrusted(data: certFramework.X509Cert): void;
}

interface Dns {
  lookup(hostname: String): Promise<Array<connection.NetAddress>>;
}

// Alias
export type RawAxiosRequestConfig<D = any> = AxiosRequestConfig<D>;

export interface InternalAxiosRequestConfig<D = any> extends AxiosRequestConfig<D> {
  headers: AxiosRequestHeaders;
}

export interface HeadersDefaults {
  common: RawAxiosRequestHeaders;
  delete: RawAxiosRequestHeaders;
  get: RawAxiosRequestHeaders;
  head: RawAxiosRequestHeaders;
  post: RawAxiosRequestHeaders;
  put: RawAxiosRequestHeaders;
  patch: RawAxiosRequestHeaders;
  options?: RawAxiosRequestHeaders;
  purge?: RawAxiosRequestHeaders;
  link?: RawAxiosRequestHeaders;
  unlink?: RawAxiosRequestHeaders;
}

export interface AxiosDefaults<D = any> extends Omit<AxiosRequestConfig<D>, 'headers'> {
  headers: HeadersDefaults;
}

export interface CreateAxiosDefaults<D = any> extends Omit<AxiosRequestConfig<D>, 'headers'> {
  headers?: RawAxiosRequestHeaders | AxiosHeaders | Partial<HeadersDefaults>;
}

export interface AxiosResponse<T = any, D = any> {
  data: T;
  status: number;
  statusText: string;
  headers: RawAxiosResponseHeaders | AxiosResponseHeaders;
  config: InternalAxiosRequestConfig<D>;
  request?: any;
  performanceTiming?: http.PerformanceTiming;
}

export class AxiosError<T = unknown, D = any> extends Error {
  constructor(
      message?: string,
      code?: string,
      config?: InternalAxiosRequestConfig<D>,
      request?: any,
      response?: AxiosResponse<T, D>
  );

  config?: InternalAxiosRequestConfig<D>;
  code?: string;
  request?: any;
  response?: AxiosResponse<T, D>;
  isAxiosError: boolean;
  status?: number;
  toJSON: () => object;
  cause?: Error;
  static from<T = unknown, D = any>(
    error: Error | unknown,
    code?: string,
    config?: InternalAxiosRequestConfig<D>,
    request?: any,
    response?: AxiosResponse<T, D>,
    customProps?: object,
): AxiosError<T, D>;
  static readonly ERR_FR_TOO_MANY_REDIRECTS = "ERR_FR_TOO_MANY_REDIRECTS";
  static readonly ERR_BAD_OPTION_VALUE = "ERR_BAD_OPTION_VALUE";
  static readonly ERR_BAD_OPTION = "ERR_BAD_OPTION";
  static readonly ERR_NETWORK = "ERR_NETWORK";
  static readonly ERR_DEPRECATED = "ERR_DEPRECATED";
  static readonly ERR_BAD_RESPONSE = "ERR_BAD_RESPONSE";
  static readonly ERR_BAD_REQUEST = "ERR_BAD_REQUEST";
  static readonly ERR_NOT_SUPPORT = "ERR_NOT_SUPPORT";
  static readonly ERR_INVALID_URL = "ERR_INVALID_URL";
  static readonly ERR_CANCELED = "ERR_CANCELED";
  static readonly ECONNABORTED = "ECONNABORTED";
  static readonly ETIMEDOUT = "ETIMEDOUT";
}

export class CanceledError<T> extends AxiosError<T> {
}

export type AxiosPromise<T = any> = Promise<AxiosResponse<T>>;

export interface CancelStatic {
  new (message?: string): Cancel;
}

export interface Cancel {
  message: string | undefined;
}

export interface Canceler {
  (message?: string, config?: AxiosRequestConfig, request?: any): void;
}

export interface CancelTokenStatic {
  new (executor: (cancel: Canceler) => void): CancelToken;
  source(): CancelTokenSource;
}

export interface CancelToken {
  promise: Promise<Cancel>;
  reason?: Cancel;
  throwIfRequested(): void;
}

export interface CancelTokenSource {
  token: CancelToken;
  cancel: Canceler;
}

export interface AxiosInterceptorOptions {
  synchronous?: boolean;
  runWhen?: (config: InternalAxiosRequestConfig) => boolean;
}

export interface AxiosInterceptorManager<V> {
  use(onFulfilled?: ((value: V) => V | Promise<V>) | null, onRejected?: ((error: any) => any) | null, options?: AxiosInterceptorOptions): number;
  eject(id: number): void;
  clear(): void;
}

export class Axios {
  constructor(config?: AxiosRequestConfig);
  defaults: AxiosDefaults;
  interceptors: {
    request: AxiosInterceptorManager<InternalAxiosRequestConfig>;
    response: AxiosInterceptorManager<AxiosResponse>;
  };
  getUri(config?: AxiosRequestConfig): string;
  request<T = any, R = AxiosResponse<T>, D = any>(config: AxiosRequestConfig<D>): Promise<R>;
  get<T = any, R = AxiosResponse<T>, D = any>(url: string, config?: AxiosRequestConfig<D>): Promise<R>;
  delete<T = any, R = AxiosResponse<T>, D = any>(url: string, config?: AxiosRequestConfig<D>): Promise<R>;
  head<T = any, R = AxiosResponse<T>, D = any>(url: string, config?: AxiosRequestConfig<D>): Promise<R>;
  options<T = any, R = AxiosResponse<T>, D = any>(url: string, config?: AxiosRequestConfig<D>): Promise<R>;
  post<T = any, R = AxiosResponse<T>, D = any>(url: string, data?: D, config?: AxiosRequestConfig<D>): Promise<R>;
  put<T = any, R = AxiosResponse<T>, D = any>(url: string, data?: D, config?: AxiosRequestConfig<D>): Promise<R>;
  postForm<T = any, R = AxiosResponse<T>, D = any>(url: string, data?: D, config?: AxiosRequestConfig<D>): Promise<R>;
  putForm<T = any, R = AxiosResponse<T>, D = any>(url: string, data?: D, config?: AxiosRequestConfig<D>): Promise<R>;
  patchForm<T = any, R = AxiosResponse<T>, D = any>(url: string, data?: D, config?: AxiosRequestConfig<D>): Promise<R>;
}

export interface AxiosInstance extends Axios {
  <T = any, R = AxiosResponse<T>, D = any>(config: AxiosRequestConfig<D>): Promise<R>;
  <T = any, R = AxiosResponse<T>, D = any>(url: string, config?: AxiosRequestConfig<D>): Promise<R>;

  defaults: Omit<AxiosDefaults, 'headers'> & {
    headers: HeadersDefaults & {
      [key: string]: AxiosHeaderValue
    }
  };
}

export interface GenericFormData {
  append(name: string, value: any, options?: any): any;
}

export interface GenericHTMLFormElement {
  name: string;
  method: string;
  submit(): void;
}

export function toFormData(sourceObj: object, targetFormData?: GenericFormData, options?: FormSerializerOptions): GenericFormData;

export function formToJSON(form: GenericFormData|GenericHTMLFormElement): object;

export function isAxiosError<T = any, D = any>(payload: any): payload is AxiosError<T, D>;

export function spread<T, R>(callback: (...args: T[]) => R): (array: T[]) => R;

export function isCancel(value: any): value is Cancel;

export function all<T>(values: Array<T | Promise<T>>): Promise<T[]>;

export interface AxiosStatic extends AxiosInstance {
  create(config?: CreateAxiosDefaults): AxiosInstance;
  Cancel: CancelStatic;
  CancelToken: CancelTokenStatic;
  Axios: typeof Axios;
  AxiosError: typeof AxiosError;
  HttpStatusCode: typeof HttpStatusCode;
  readonly VERSION: string;
  isCancel: typeof isCancel;
  all: typeof all;
  spread: typeof spread;
  isAxiosError: typeof isAxiosError;
  toFormData: typeof toFormData;
  formToJSON: typeof formToJSON;
  CanceledError: typeof CanceledError;
  AxiosHeaders: typeof AxiosHeaders;
  FormData: typeof FormData;
}
export interface Type {
  filename?: string;
  type?: string;
}

export class FormData {
  append(name:string, value:any, option?: string | Type): void;
  get(name:string):any;
  has(name:string):boolean;
  delete(name:string):boolean;
  set(name:string, value:any, option?:any): void;
  forEach(callback:(value:any, key?:string, option?: any)=>void): void;
}
declare const axios: AxiosStatic;

export default axios;
