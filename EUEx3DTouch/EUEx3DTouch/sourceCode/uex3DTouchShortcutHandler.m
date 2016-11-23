//
//  uex3DTouchShortcutHandler.m
//  EUEx3DTouch
//
//  Created by CeriNo on 15/11/5.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "uex3DTouchShortcutHandler.h"
#import <AppCanKit/AppCanKit.h>
typedef void (^AppShortcutLoadingHandler)(void);
typedef NS_ENUM(NSInteger,uex3DTouchShortcutHandleStatus) {
    uex3DTouchHandleOnLaunchApp = 0,
    uex3DTouchHandleOnWakeFromBackground,
};


@interface uex3DTouchShortcutHandler()
@property (nonatomic,strong)AppShortcutLoadingHandler shortcutCallbackBlock;
@property (nonatomic,assign)uex3DTouchShortcutHandleStatus status;
@property (nonatomic,assign)BOOL rootPageDidFinishLoading;
@end

@implementation uex3DTouchShortcutHandler

#pragma mark - Singleton
+(instancetype)sharedHandler{
    static uex3DTouchShortcutHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler=[[uex3DTouchShortcutHandler alloc] init];
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.status = uex3DTouchHandleOnWakeFromBackground;
        self.rootPageDidFinishLoading = NO;
    }
    return self;
}


#pragma mark - handlers
-(void)handleRootPageDidFinishLoadingEvent{
    if(self.shortcutCallbackBlock){
        self.shortcutCallbackBlock();
        self.shortcutCallbackBlock = nil;
    }
    self.rootPageDidFinishLoading = YES;
}

-(void)handleAppPerformActionForShortcutItemEventWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem{
    [self setCallbackBlockWithShortcutItem:shortcutItem status:self.status];
    self.status = uex3DTouchHandleOnWakeFromBackground;
}

-(void)handleAppDidBecomeActiveEvent{
    if(self.shortcutCallbackBlock && self.rootPageDidFinishLoading){
        self.shortcutCallbackBlock();
        self.shortcutCallbackBlock = nil;
    }
}
-(void)handleAppDidFinishLaunchingEventWithOptions:(NSDictionary *)launchOptions{
    if([launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey]){
        self.status = uex3DTouchHandleOnLaunchApp;
    }
}

#pragma mark - Set Callback Block
-(void)setCallbackBlockWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem status:(uex3DTouchShortcutHandleStatus)status{
    NSMutableDictionary * shortcutInfo=[NSMutableDictionary dictionary];
    [shortcutInfo setValue:shortcutItem.type forKey:@"type"];
    [shortcutInfo setValue:@(status) forKey:@"status"];
    [shortcutInfo setValue:shortcutItem.userInfo forKey:@"info"];
    self.shortcutCallbackBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [AppCanRootWebViewEngine() callbackWithFunctionKeyPath:@"uex3DTouch.onLoadByShortcutClickEvent" arguments:ACArgsPack(shortcutInfo.ac_JSONFragment)];
        });
    };
    
}
@end
