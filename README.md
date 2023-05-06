

## 简介
这个是热修复包辅助工具，主要支持一下功能：

- Object-C代码到热修复脚本的转换
- 热修复包的生成

## 预览
![功能预览](https://raw.githubusercontent.com/shijianmei/PatchGenerater/main/patchTool.gif)


## 使用

- 下载源码
```
git clone https://github.com/shijianmei/PatchGenerater
```
- 配置秘钥：
秘钥需要和App解析保持一致
```
let aes128Key = "123456";
let aes128Iv = "abcdef"

```
## 不支持

1. 预编译相关
2. 编译器内置函数以及属性__attribute__等
3. a[x], {x,y,z}, a->x
4. id a = ( identifier )object; 类型转换. 但支持id a = (identifier *)object;

目前还不支持Swift语法

