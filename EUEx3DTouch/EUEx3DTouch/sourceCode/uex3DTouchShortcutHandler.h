//
//  uex3DTouchShortcutHandler.h
//  EUEx3DTouch
//
//  Created by CeriNo on 15/11/5.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface uex3DTouchShortcutHandler : NSObject




+(instancetype)sharedHandler;

-(void)handleAppDidFinishLaunchingEventWithOptions:(NSDictionary *)launchOptions;
-(void)handleAppDidBecomeActiveEvent;
-(void)handleAppPerformActionForShortcutItemEventWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem;
-(void)handleRootPageDidFinishLoadingEvent;
@end


