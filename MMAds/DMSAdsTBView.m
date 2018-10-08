//
//  DMSAdsTBView.m
//  MMAds
//
//  Created by L.D. Deurman on 29/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

#import "DMSAdsTBView.h"




@implementation DMSAdsTBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"appEventsHandler"];
        
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
}

@end
