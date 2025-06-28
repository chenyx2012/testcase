## juniversalchardet 单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/albfernandez/juniversalchardet/tree/main/src/test/java/org/mozilla/universalchardet) 进行单元测试

### 单元测试用例覆盖情况

| 接口名                           | 是否通过 |备注|
|-------------------------------|---|---|
| detectCharset()               |pass|
| EncodingDetectorInputStream() |pass|
| EncodingDetectorOutputStream() |pass|
| readWithOneParameter()        |pass|
| close()                       |pass|
| writeWithTreeParameter()      |pass|
| getDetectedCharset()          |pass|
| UniversalDetector()           |pass|
| handleDataParent()            |pass|
| dataEnd()                     |pass|
| reset()                       |pass|
| PkgInt()                      |pass|
| PkgInt().unpack()             |pass|
| PkgInt().pack4bits()             |pass|