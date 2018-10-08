/*   Copyright 2013 APPNEXUS INC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "DMSAdsCustomEventBanner.h"

@interface DMSAdsCustomEventBanner ()

@property WKWebView *webView;

@end

@implementation DMSAdsCustomEventBanner

@synthesize delegate;

#pragma mark - GADCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest
{


    
    NSURL *url = [NSURL URLWithString:serverParameter];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    WKWebViewConfiguration *theConfiguration =
    [[WKWebViewConfiguration alloc] init];
    [theConfiguration.userContentController
     addScriptMessageHandler:self name:@"delegate"];
    
    
    CGSize size = adSize.size;
    if (serverLabel != NULL) {
        if ([serverLabel length] > 0) {
            size = CGSizeFromString(serverLabel);
            if (!(size.width > 1 && size.height > 1)) {
                size = adSize.size;
            }
        }
    }
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)
                                     configuration:theConfiguration];
    [self.webView loadRequest:request];
    
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    if ([message.name  isEqual: @"delegate"]) {
        NSString *status = (NSString*)message.body;
        
        if ([status  isEqual: @"loaded"]) {
            [delegate customEventBanner:self didReceiveAd: self.webView];
        }
        
        
        if ([status  isEqual: @"failed"]) {
            [delegate customEventBanner:self didFailAd: NULL];
        }
    }
    
   
}


@end
