## ohos_mqtt单元测试用例

该测试用例基于OpenHarmony系统下，进行单元测试

### 单元测试用例覆盖情况

| 接口名                                                                                     | 是否通过 | 备注  |
|-----------------------------------------------------------------------------------------|------|-----|
| createMqtt(options: MqttAsyncClientOptions): MqttAsyncClient                            | pass |     |
| connect(options: MqttConnectOptions, callback: AsyncCallback<MqttResponse>): void       | pass |     |
| publish(options: MqttPublishOptions, callback: AsyncCallback<MqttResponse>): void       | pass |     |
| subscribe(options: MqttSubscribeOptions, callback: AsyncCallback<MqttResponse>): void   | pass |     |
| unsubscribe(options: MqttSubscribeOptions, callback: AsyncCallback<MqttResponse>): void | pass |     |
| messageArrived(callback: AsyncCallback<MqttMessage>): void                              | pass |     |
| disconnect(callback: AsyncCallback<MqttResponse>): void                                 | pass |     |
| isConnected(): boolean                                                                  | pass |     |
| reconnect(): boolean;                                                                   | pass |     |
| destroy(): void                                                                         | pass |     |

