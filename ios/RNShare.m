#import <MessageUI/MessageUI.h>
#import "RNShare.h"
// import RCTConvert
#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#elif __has_include("RCTConvert.h")
#import "RCTConvert.h"
#else
#import "React/RCTConvert.h"   // Required when used as a Pod in a Swift project
#endif
// import RCTLog
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import "React/RCTLog.h"   // Required when used as a Pod in a Swift project
#endif
// import RCTUtils
#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#elif __has_include("RCTUtils.h")
#import "RCTUtils.h"
#else
#import "React/RCTUtils.h"   // Required when used as a Pod in a Swift project
#endif
// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include("RCTBridge.h")
#import "RCTBridge.h"
#else
#import "React/RCTBridge.h"   // Required when used as a Pod in a Swift project
#endif
// import RCTBridge
#if __has_include(<React/RCTUIManager.h>)
#import <React/RCTUIManager.h>
#elif __has_include("RCTUIManager.h")
#import "RCTUIManager.h"
#else
#import "React/RCTUIManager.h"   // Required when used as a Pod in a Swift project
#endif
#import "GenericShare.h"
#import "WhatsAppShare.h"
#import "GooglePlusShare.h"
#import "EmailShare.h"
#import "WXApiObject.h"
#import "WXApi.h"

@implementation RNShare
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(shareSingle:(NSDictionary *)options
                  failureCallback:(RCTResponseErrorBlock)failureCallback
                  successCallback:(RCTResponseSenderBlock)successCallback)
{

    NSString *social = [RCTConvert NSString:options[@"social"]];
    if (social) {
        NSLog(social);
        if([social isEqualToString:@"facebook"]) {
            NSLog(@"TRY OPEN FACEBOOK");
            GenericShare *shareCtl = [[GenericShare alloc] init];
            [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback serviceType: SLServiceTypeFacebook];
        } else if([social isEqualToString:@"twitter"]) {
            NSLog(@"TRY OPEN Twitter");
            GenericShare *shareCtl = [[GenericShare alloc] init];
            [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback serviceType: SLServiceTypeTwitter];
        } else if([social isEqualToString:@"googleplus"]) {
            NSLog(@"TRY OPEN google plus");
            GooglePlusShare *shareCtl = [[GooglePlusShare alloc] init];
            [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback];
        } else if([social isEqualToString:@"whatsapp"]) {
            NSLog(@"TRY OPEN whatsapp");

            WhatsAppShare *shareCtl = [[WhatsAppShare alloc] init];
            [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback];
        } else if([social isEqualToString:@"email"]) {
            NSLog(@"TRY OPEN email");
            EmailShare *shareCtl = [[EmailShare alloc] init];
            [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback];
        } else if([social isEqualToString:@"wechat"]) {
          NSURL *url = [NSURL URLWithString:aData[RCTWXShareImageUrl]];
          NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];
          NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
          UIImage *image = [UIImage imageWithData: imageData];
          WXImageObject *imageObject = [WXImageObject object];
          imageObject.imageData = UIImagePNGRepresentation(image);

          WXMediaMessage *message = [WXMediaMessage message];
          message.title = [options objectForKey:@"title"];
          message.description = [options objectForKey:@"message"];
          [message setThumbImage:image];
          //message.mediaObject = mediaObject;

          WXWebpageObject *webpageObject = [WXWebpageObject object];
          webpageObject.webpageUrl = @"https://itunes.apple.com/us/app/air-translator-translation-any-time-anywhere/id1119155198?mt=8";
          message.mediaObject = webpageObject;

          SendMessageToWXReq* req = [SendMessageToWXReq new];
          req.bText = NO;
          req.scene = WXSceneSession;
          req.message = message;

          BOOL success = [WXApi sendReq:req];

          if (success) {
            successCallback(@[]);
          } else {
            NSString *errorMessage = @"Not installed";
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)};
            NSError *error = [NSError errorWithDomain:@"com.rnshare" code:1 userInfo:userInfo];
            return failureCallback(error);
          }
        }
    } else {
        RCTLogError(@"key 'social' missing in options");
        return;
    }
}

@end
