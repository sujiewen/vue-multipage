//
//  WKWebView+JavaScriptBridge.h
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    //Only printf JSON In Xcode Command line
    WVJBLogginglevelJSONOnly = 1 << 0,
    //All String  printf In Xcode Command line
    WVJBLogginglevelAll = 1 << 1,
}WVJBLogginglevel;

typedef NSDictionary WVJBMessage;
typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@interface WKWebView (JavaScriptBridge)<WKScriptMessageHandler>
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;
@property (strong, nonatomic) WVJBHandler messageHandler;

- (void)registerHandler:(NSString *) handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString *) handlerName;
- (void)callHandler:(NSString *) handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;

+ (void)enableLogging:(WVJBLogginglevel)logginglevel;

@end

NS_ASSUME_NONNULL_END

