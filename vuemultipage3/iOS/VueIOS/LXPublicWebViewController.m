//
//  LXPublicWebViewController.m
//  OfficeManagement
//
//  Created by sjw on 2019/11/7.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import "LXPublicWebViewController.h"
#import "WKWebView+JavaScriptBridge.h"

//// WKWebView 内存不释放的问题解决
//@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
//
//    //WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
//    @property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
//
//    - (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
//
//@end
//
//@implementation WeakWebViewScriptMessageDelegate
//
//    - (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
//        self = [super init];
//        if (self) {
//            _scriptDelegate = scriptDelegate;
//        }
//        return self;
//    }
//
//    #pragma mark - WKScriptMessageHandler
//        //遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//        //通过接收JS传出消息的name进行捕捉的回调方法
//    - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//
//        if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
//            [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
//        }
//    }
//
//@end


@interface LXPublicWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

//网页加载进度视图
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation LXPublicWebViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (self.isWatchTitleFlag) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isWatchTitleFlag = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
//    //添加监测网页加载进度的观察者
//    [self.webView addObserver:self
//                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
//                      options:0
//                      context:nil];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    if (self.isWatchTitleFlag) {
        [self.webView addObserver:self
        forKeyPath:@"title"
           options:NSKeyValueObservingOptionNew
           context:nil];
    }
    
    [self loadlHtml];
    
}

    //kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)loadlHtml {
    if ([self.strUrl hasPrefix:@"http://"] || [self.strUrl hasPrefix:@"https://"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120]];
    }
    else {
        NSString *path = self.strUrl;
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *strBaseURL = [[NSBundle mainBundle] bundlePath];
        if(self.strBaseUrl) {
            strBaseURL = self.strBaseUrl;
        }
        
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:strBaseURL]];
    }
}

#pragma mark - Get

- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *) webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        //应许访问本地文件（跨域支持）
        [preference setValue:@(YES) forKey:@"allowFileAccessFromFileURLs"];//关键代码
        config.preferences = preference;
        if (@available(iOS 10.0, *)) {
            [config setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        }
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"LXiOS";
        
//        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
//        //这个类主要用来做native与JavaScript的交互管理
//        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
//        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
//
//        config.userContentController = wkUController;
//
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        //以下代码适配文本大小
        [javascript appendString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"];
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        CGRect webFrame = self.view.bounds;
        webFrame.size.height = webFrame.size.height - (THE_DEVICE_HAVE_HEAD ? 88 : (44+20));
        _webView = [[WKWebView alloc] initWithFrame:webFrame configuration:config];// UI代理
        _webView.UIDelegate = self;
        [_webView setBackgroundColor:[UIColor whiteColor]];
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
//        //可返回的页面列表, 存储已打开过的网页
//        WKBackForwardList * backForwardList = [_webView backForwardList];
        //If you set LogginglevelAll ,Xcode command Line will show all JavaScript console.log.
        [WKWebView enableLogging:WVJBLogginglevelAll];
    }
    return _webView;
}

#pragma mark -- WKNavigationDelegate

/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
    
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
    
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
    
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
    
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
//
//    NSURLRequest * request = navigationAction.request;
//    NSMutableURLRequest * mutRequest = [request mutableCopy];
//    NSString * urlString = request.URL.absoluteString;
//    NSDictionary * dictHader = request.allHTTPHeaderFields;
//    NSString *headerField = @"Authorization";
//    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
//
//    if([[navigationAction.request valueForHTTPHeaderField:headerField] isEqualToString:headerValue]) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    } else {
//        NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] initWithURL:navigationAction.request.URL];
//        [newRequest setValue:headerValue forHTTPHeaderField:headerField];
//
//        decisionHandler(WKNavigationActionPolicyCancel);
//        [self.webView loadRequest:newRequest];
//    }
    
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"github://";
    if([urlStr hasPrefix:htmlHeadString]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
            [[UIApplication sharedApplication] openURL:url];
            
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    
}
    
// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
    
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
//    if ([GlobalData instance].userInfo && [GlobalData instance].userInfo.userId && [GlobalData instance].userInfo.userId.length > 0) {
//        //用户身份信息
//        NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:[GlobalData instance].userInfo.userId password:[GlobalData instance].userInfo.password persistence:NSURLCredentialPersistenceNone];
//        //为 challenge 的发送方提供 credential
//        [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
//        completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
//    }
}
    
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark -- WKUIDelegate
    
    /**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param completionHandler 警告框消失调用
     */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//#pragma mark - UIScrollViewDelegate 屏蔽放大，缩小
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return nil;
//}

@end
