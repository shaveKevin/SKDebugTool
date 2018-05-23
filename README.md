# SKDebugTool
iOS开发中网络请求,内存，fps查看，基于JxbDebugTool进行改造
## 开发中用cocoapod集成方式

```
pod 'SKDebugTool' ,:configurations => ['Debug']

```
## 使用方式：

```
#import <SKDebugTool/SKDebugTool.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ........

#if DEBUG
    [[SKDebugTool shareInstance] setMainColor:[UIColor redColor]];
    [[SKDebugTool shareInstance] enableDebugMode];
#endif
........
}
```
使用过程中出现问题请及时issue
后续会继续为此工具更新添加新功能
项目原地址：
https://github.com/JxbSir/JxbDebugTool
