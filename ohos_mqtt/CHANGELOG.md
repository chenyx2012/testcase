## 2.0.23-rc.0
1.Modify the userName and password properties in MqttConnectOptions to make them optional.
2.Modify the default value of the persistenceType property in MqttClientOptions to 1

## 2.0.22
1.Publish fails and returns an add errorcode
2.The connect timeout add some logs
3.Remove the upper limit of the payload length of the string type received by the c++ layer
4.Support mqtt V5 properties
5.Fix the issue of send message crash

## 2.0.22-rc.0
1.Fixed the issue where calling "destroy" during "connect" caused a crash

## 2.0.21
1.Increase the reference count to manage memory

## 2.0.20
1.Fixed an issue where MessageArrived topic was empty
2.Repair the cppcrash caused by reconnection
3.A cppcrash occurred while fixing a subscription

## 2.0.19
1.Change the repository URL from Gitee to Gitcode

## 2.0.18
1.Update version Paho.mqtt.c to 1.3.14
2.Fix the problem of network disconnection and crash

## 2.0.17
1.Fix the crash issues of On Connect Success and On Connect Fail

## 2.0.16
1.Fixed the dependency issue of MQTT in version 2.0.15 where the openssl version was not upgraded

## 2.0.15
1.MQTT multi instance implementation
2.fix bug from mqttAsync_ null pointer - Fallback MqttConnect function

## 2.0.14
1.Fix stability issues such as appFreeze and crashes
2.Switch openssl version 3.4.0

## 2.0.13
1.Fix mqttAsynchronous null pointer issue

## 2.0.13-rc.1
1.修复订阅失败，无反馈给ArkTs层问题

## 2.0.13-rc.0
1.修改日志打印级别

## 2.0.12
1.修复connect接口低概率未收到回调问题

## 2.0.11
1.设置sslOptions.trustStore默认值为系统ca证书

2.修复connectLost接口appFreeze问题

## 2.0.10

1.新增订阅与取消订阅多主题接口
  - subscribeMany(options: MqttSubscribeOptions[], callback: AsyncCallback<MqttResponse>): void;
  - subscribeMany(options: MqttSubscribeOptions[]): Promise<MqttResponse>;
  - unsubscribeMany(options: MqttSubscribeOptions[], callback: AsyncCallback<MqttResponse>): void;
  - unsubscribeMany(options: MqttSubscribeOptions[]): Promise<MqttResponse>;
## 2.0.9
1.更新版本号至2.0.9

## 2.0.9-rc.0

1.新增变量payloadBinary,支持二进制数据。注意：发送数据同时设置payload和payloadBinary时，会优先使用payloadBinary,忽略payload。

## 2.0.8

1.新增sslVersion参数--设置TLS的版本

## 2.0.8-rc.0

1.修复2.0.7版本不支持x86问题

## 2.0.7

1.处理payload乱码问题--修改MessageArrived函数解析payload方式

## 2.0.6

1.适配x86架构

## 2.0.6-rc.0

1.修复Socket_getReadySocket signal SIGSEGV --切换paho.mqtt.c版本为1.3.13

## 2.0.5

1.修复不兼容API9问题

## 2.0.5-rc.0
1.修复不兼容API9问题

## 2.0.4
1.适配arkTs语法

2.修复CVE-2023-3446漏洞：openssl版本由OpenSSL_1_1_1u更换为OpenSSL_1_1_1w

3.切换paho.mqtt.c版本为1.3.10

## 2.0.3
1.修复短时间多次调用publish接口概率性卡死问题

## 2.0.2
1.添加connect、publish、subscribe、unsubscribe、disconnect的promise接口

2.reconnect、isconnected、destroy接口回调修改为promise

3.删除payloadLen参数

4.切换paho.mqtt.c版本为1.3.12

5.导出参数类型： MqttQos, MqttPersistenceType, MqttClientOptions, MqttConnectOptions, MqttSubscribeOptions, MqttPublishOptions, MqttResponse, MqttMessage, MqttClient

## 2.0.1
1.移除submodule openssl以及openssl适配代码

2.删除paho.mqtt.c源码，修改paho.mqtt.c引入方式,从源码引入改为submodule引入

## 2.0.0
1.适配DevEco Studio:3.1 Beta2(3.1.0.400), SDK:API9 Release(3.2.11.9)
2.包管理工具由npm切换成ohpm

## 0.1.2
1.添加ssl协议能力

## 0.1.1
1.适配DevEco Studio 3.1 Beta1版本

## 0.1.0

1.支持创建客户端参数、建立连接参数、订阅参数、发布参数、响应参数、接收消息响应参数、创建客户端、建立连接 订阅主题、取消订阅、发布消息、接收消息、断开连接、重新连接、连接断开的回调、判断是否连接、销毁客户端释放内存等功能。
