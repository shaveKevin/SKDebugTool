# SKDebugTool
iOS开发中网络请求,内存，fps查看以及沙盒文件实时查看可airdrop发送至电脑
## 集成方式
### 使用cocoapods集成
```
pod 'SKDebugTool' ,:configurations => ['Debug']

```
## 使用方式：

```
#import <SKDebugTool/SKDebugTool.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ........

#if DEBUG

    [SKDebugTool shareInstance].specialHeaders = @[@"requet specialHeaders"]; // optional
    // eg: rquest url is  https:localhostL:18080?requestParame=xxxxxxx?xxxxxxx
    // so you can add header to  specialHeaders just like  [SKDebugTool shareInstance].specialHeaders = @[@"requestHeaders"];
    [[SKDebugTool shareInstance] enableDebugMode];
#endif
........
}
```
使用过程中出现问题请及时issue
后续会继续为此工具更新添加新功能

项目原地址：

https://github.com/JxbSir/JxbDebugTool

https://github.com/music4kid/AirSandbox

## 后续需要添加的功能有：

 ### 接口的过滤功能
 ### 接口的搜索功能
 ### 闪退的定位以及闪退日志的记录
 
## 待优化：
* 悬浮球拖拽在旋转VC的时候 位置错误
* 如果目标项目中隐藏了navigationbar，导致工具的navigationbar出不来
