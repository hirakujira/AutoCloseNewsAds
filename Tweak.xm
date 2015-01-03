#include <objc/runtime.h>
#import <UIKit/UIKit.h>
#include <substrate.h>

NSDictionary* cleanList = @{@"udn.com"              :@"cboxClose",
                            @"m.udn.com"            :@"cboxClose",
                            @"m.appledaily.com.tw"  :@"closeID",
                            @"www.chinatimes.com"   :@"madclose"};

%hook UIWebView
-(void)webView:(UIWebView *)webview didFinishLoadForFrame:(id)frame
{
    NSString* currentURL = self.request.URL.absoluteString;
    // NSLog(@"currentURL shit:%@",currentURL);
    for (NSString* key in cleanList) {
        if ([currentURL hasPrefix:[NSString stringWithFormat:@"http://%@",key]]) {
            [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setInterval(function(){document.getElementById('%@').click()},1000)",[cleanList objectForKey:key]]];
            // NSLog(@"Cleaning %@ Ads",key);
        }
    }
    if ([currentURL hasPrefix:@"http://www.ptt.cc/ask/over18"]) {
        [webview stringByEvaluatingJavaScriptFromString:@"setInterval(function(){document.getElementsByName('yes')[0].click()},1000)"];
        // NSLog(@"Skip PTT Over18");
    }
    %orig;
}
%end

%ctor {
    %init;
}   