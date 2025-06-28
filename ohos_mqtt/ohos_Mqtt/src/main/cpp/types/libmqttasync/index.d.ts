/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the  Eclipse Public License -v 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.eclipse.org/legal/epl-2.0/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface AsyncCallback<T> {
  /**
   * Defines the callback data.
   * @since 6
   */
  (err: Error, data: T): void;
}

/**
 * This function creates an MQTT client ready for connection to the
 * specified server and using the specified persistent storage.
 * @param options a valid MqttAsyncClientOptions
 */
export function createMqttSync(options: MqttClientOptions): MqttClient;

/**
 * The quality of service (QoS) assigned to the message.
 * There are three levels of QoS:
 * 0: QoS0
 * Fire and forget - the message may not be delivered
 * 1: QoS1
 * At least once - the message will be delivered, but may be
 * delivered more than once in some circumstances.
 * 2: QoS2
 * Once and one only - the message will be delivered exactly once.
 */
export type MqttQos = 0 | 1 | 2;

/**
 * 0 = Use the default (file system-based) persistence mechanism. TODO: not support
 * 1 = default: Use in-memory persistence.
 * 2 = Use an application-specific persistence implementation. TODO: not support
 */
export type MqttPersistenceType = 0 | 1 | 2;

export interface MqttClientOptions {
  /**
   * A null-terminated string specifying the server to which the client will connect.
   * It takes the form protocol://host:port.protocol must be tcp, ssl, ws or wss.
   * For host, you can specify either an IP address or a host name.
   * For instance,tcp://localhost:1883
   */
  url: string;

  /**
   * The client identifier passed to the server when the client connects to it.
   * It is a null-terminated UTF-8 encoded string.
   */
  clientId: string;

  /** The type of persistence to be used by the client. */
  persistenceType?: MqttPersistenceType;

  /**
   * 0 = default: start with 3.1.1, and if that fails, fall back to 3.1
   * 3 = only try version 3.1
   * 4 = only try version 3.1.1
   * 5 = only try version 5
   */
  MQTTVersion?: number;
}

export interface MqttConnectOptions {
  /**
   * This is a boolean value. The cleansession setting controls the behaviour
   * of both the client and the server at connection and disconnection time.
   * The client and server both maintain session state information. This
   * information is used to ensure "at least once" and "exactly once"
   * delivery, and "exactly once" receipt of messages. Session state also
   * includes subscriptions created by an MQTT client. You can choose to
   * maintain or discard state information between sessions.
   */
  cleanSession?: boolean; // default is true.
  connectTimeout?: number; // default is 30s.
  keepAliveInterval?: number; // default is 60s.
  /**
   * An array of null-terminated strings specifying the servers to which the client will connect.
   * Each string takes the form protocol://host:port.protocol must be tcp, ssl, ws or wss.
   * For host, you can specify either an IP address or a host name.
   */
  serverURIs?: Array<string>;
  retryInterval?: number; // default is 0.
  sslOptions?: {
    // true: enable server certificate authentication, false: disable,default is true.
    enableServerCertAuth?: boolean;

    // false for no verifying the hostname, true for verifying the hostname, default is false.
    verify?: boolean;

    /**
     * From the OpenSSL documentation:
     * If CApath is not NULL, it points to a directory containing CA certificates in PEM format.
     */
    caPath?: string;

    /**
     * The file in PEM format containing the public digital certificates trusted by the client.
     * It must set local file path in your device and the file must can be accessed.
     */
    trustStore?: string;

    /** The file in PEM format containing the public certificate chain of the client.
     * It may also include the client's private key.
     * It must set local file path in your device and the file must can be accessed.
     */
    keyStore?: string;

    /** If not included in the sslKeyStore, this setting points to
     * the file in PEM format containing the client's private key.
     * It must set local file path in your device and the file must can be accessed.
     */
    privateKey?: string;

    /** The password to load the client's privateKey if encrypted. */
    privateKeyPassword?: string;

    /**
     * The list of cipher suites that the client will present to the server during the SSL handshake.
     * If this setting is ommitted, its default value will be "ALL", that is, all the cipher suites -excluding
     * those offering no encryption- will be considered.
     * for example, TLSv1.2,RSA;More details please see https://www.openssl.org/docs/man1.1.1/man1/ciphers.html.
     */
    enabledCipherSuites?: string;

    /** The SSL/TLS version to use. Specify one of MQTT_SSL_VERSION_DEFAULT (0),
     * MQTT_SSL_VERSION_TLS_1_0 (1), MQTT_SSL_VERSION_TLS_1_1 (2) or MQTT_SSL_VERSION_TLS_1_2 (3).
     * Only used if struct_version is >= 1.
     */
    sslVersion?: MQTT_SSL_VERSION;
  };
  willOptions?: {
    topicName: string;
    message: string;
    retained?: boolean;
    qos?: MqttQos;
  };

  /**
   * 0 = default: start with 3.1.1, and if that fails, fall back to 3.1
   * 3 = only try version 3.1
   * 4 = only try version 3.1.1
   * 5 = only try version 5
   */
  MQTTVersion?: number;
  /** automaticReconnect is currently not supported. */
  automaticReconnect?: boolean; // default is false.
  minRetryInterval?: number; // default is 1s.
  maxRetryInterval?: number; // default is 60s.
  /**
   * the username required by your broker
   */
  userName?: string;

  /**
   * the password required by your broker
   */
  password?: string;
}

export interface MqttSubscribeOptions {
  /** The topic associated with this message. */
  topic: string;

  /** The quality of service (QoS) assigned to the message. */
  qos: MqttQos;
}

export type UserPropertiesType = [string, string];
export type Properties = {
  contentType?:string;
  userProperties?: UserPropertiesType[];
  integerProperties?: number[];
  strProperties?: string[];
};

export interface MqttPublishOptions {
  /** The topic associated with this message. */
  topic: string;

  /** the payload of the MQTT message. */
  payload?: string;

  payloadBinary?: ArrayBuffer;

  /** The quality of service (QoS) assigned to the message. */
  qos: MqttQos;

  /** The properties for mqtt5. */
  properties?: Properties;

  /**
   * retained = true
   * For messages being published, a true setting indicates that the MQTT
   * server should retain a copy of the message. The message will then be
   * transmitted to new subscribers to a topic that matches the message topic.
   *
   * retained = false
   * For publishers, this indicates that this message should not be retained
   * by the MQTT server. For subscribers, a false setting indicates this is
   * a normal message, received as a result of it being published to the
   * server.
   */
  retained?: boolean;

  /**
   * The dup flag indicates whether or not this message is a duplicate.
   * It is only meaningful when receiving QoS1 messages. When true, the
   * client application should take appropriate action to deal with the
   * duplicate message.  This is an output parameter only.
   */
  dup?: boolean;

  /** The message identifier is reserved for internal use by the
   * MQTT client and server.  It is an output parameter only - writing
   * to it will serve no purpose.  It contains the MQTT message id of
   * an incoming publish message.
   */
  msgid?: number;
}

export interface MqttResponse {
  message: string;
  /** If the value 0 is returned, the operation is successful. */
  code: number;
  errorCode: number;
  /** The reasonCode for mqtt5. */
  reasonCode: number;
  /** The properties for mqtt5. */
  properties: Properties;
}

export interface MqttMessage {
  topic: string;
  payload: string;
  payloadBinary : ArrayBuffer;
  qos: MqttQos;
  retained: number;
  dup: number;
  msgid: number;
  properties: Properties;
}

export class MqttClient {
  constructor(options: MqttClientOptions);
  /**
   * This function attempts to connect a previously-created client
   * to an MQTT server using the specified options.
   * @param options a valid MqttConnectOptions
   * @param callback Returns the MqttResponse object.
   */
  connect(options: MqttConnectOptions, callback: AsyncCallback<MqttResponse>): void;

  connect(options: MqttConnectOptions): Promise<MqttResponse>;

  /**
   * This function frees the memory allocated to an MQTT client.
   * It should be called when the client is no longer required.
   */
  destroy(): Promise<boolean>;

  /**
   * This function attempts to disconnect the client from the MQTT server.
   * @param callback Returns the MqttResponse object.
   */
  disconnect(callback: AsyncCallback<MqttResponse>): void;

  disconnect(): Promise<MqttResponse>;

  /**
   * This is a callback function.
   * It is called by the client library when a new message that matches a client
   * subscription has been received from the server. This function is executed on
   * a separate thread to the one on which the client application is running.
   * @param callback Returns the MQTTAsync_message object.
   */
  messageArrived(callback: AsyncCallback<MqttMessage>): void;

  /**
   * This is a callback function.
   * It is called by the client library if the client loses its connection to the server.
   * The client application must take appropriate action, such as trying to reconnect
   * or reporting the problem. This function is executed on a separate thread to
   *  the one on which the client application is running.
   * @param callback Returns the MqttResponse object.
   */
  connectLost(callback: AsyncCallback<MqttResponse>): void;

  /**
   * This function attempts to publish a message to a given topic.
   * @param options a valid MqttPublishOptions.
   * @param callback Returns the MqttResponse object.
   */
  publish(options: MqttPublishOptions, callback: AsyncCallback<MqttResponse>): void;

  publish(options: MqttPublishOptions): Promise<MqttResponse>;

  /**
   * This function attempts to subscribe a client to a single topic, which may
   * contain wildcards.
   * @param options a valid MqttSubscribeOptions.
   * @param callback Returns the MqttResponse object.
   */
  subscribe(options: MqttSubscribeOptions, callback: AsyncCallback<MqttResponse>): void;

  subscribe(options: MqttSubscribeOptions): Promise<MqttResponse>;

  subscribeMany(options: MqttSubscribeOptions[], callback: AsyncCallback<MqttResponse>): void;

  subscribeMany(options: MqttSubscribeOptions[]): Promise<MqttResponse>;

  /**
   * This function attempts to remove an existing subscription made by the
   * specified client.
   * @param options a valid MqttSubscribeOptions.
   * @param callback Returns the MqttResponse object.
   */
  unsubscribe(options: MqttSubscribeOptions, callback: AsyncCallback<MqttResponse>): void;

  unsubscribe(options: MqttSubscribeOptions): Promise<MqttResponse>;

  unsubscribeMany(options: MqttSubscribeOptions[], callback: AsyncCallback<MqttResponse>): void;

  unsubscribeMany(options: MqttSubscribeOptions[]): Promise<MqttResponse>;

  /**
   * This function allows the client application to test whether or not a
   * client is currently connected to the MQTT server.
   * @return Boolean true if the client is connected, otherwise false.
   */
  isConnected(): Promise<boolean>;

  /**
   * Reconnects a client with the previously used connect options.
   * Connect must have previously been called for this to work.
   * @return Boolean true if the client is reconnected, otherwise false.
   */
  reconnect(): Promise<boolean>;

  /**
   * This function sets the level of trace information in hilog.
   * @param level MQTTASYNC_TRACE_LEVELS
   */
  setMqttTrace(level: MQTTASYNC_TRACE_LEVELS): void;
}

export enum MQTTASYNC_TRACE_LEVELS {
  MQTTASYNC_TRACE_MAXIMUM = 1,
  MQTTASYNC_TRACE_MEDIUM,
  MQTTASYNC_TRACE_MINIMUM,
  MQTTASYNC_TRACE_PROTOCOL,
  MQTTASYNC_TRACE_ERROR,
  MQTTASYNC_TRACE_SEVERE,
  MQTTASYNC_TRACE_FATAL
}

/** The SSL/TLS version to use. Specify one of MQTT_SSL_VERSION_DEFAULT (0),
 * MQTT_SSL_VERSION_TLS_1_0 (1), MQTT_SSL_VERSION_TLS_1_1 (2) or MQTT_SSL_VERSION_TLS_1_2 (3).
 * Only used if struct_version is >= 1.
 */
export enum MQTT_SSL_VERSION {
  MQTT_SSL_VERSION_DEFAULT = 0,
  MQTT_SSL_VERSION_TLS_1_0,
  MQTT_SSL_VERSION_TLS_1_1,
  MQTT_SSL_VERSION_TLS_1_2,
}