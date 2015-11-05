//
//  EUEx3DTouch.m
//  EUEx3DTouch
//
//  Created by CeriNo on 15/11/4.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUEx3DTouch.h"
#import "JSON.h"
#import "uex3DTouchShortcutHandler.h"




@interface EUEx3DTouch()

@end

@implementation EUEx3DTouch

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{


    [[uex3DTouchShortcutHandler sharedHandler] handleAppDidFinishLaunchingEventWithOptions:launchOptions];
    return YES;
}
+ (void)applicationDidBecomeActive:(UIApplication *)application {
    [[uex3DTouchShortcutHandler sharedHandler] handleAppDidBecomeActiveEvent];
    /*
    if(self.shortcutHandler && self.isFirstPageDidLoad){
        
        self.shortcutHandler();
        self.shortcutHandler=nil;
    }
     */
}

+(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [[uex3DTouchShortcutHandler sharedHandler] handleAppPerformActionForShortcutItemEventWithShortcutItem:shortcutItem];
}

+(void)rootPageDidFinishLoading{
    [[uex3DTouchShortcutHandler sharedHandler] handleRootPageDidFinishLoadingEvent];
}

-(void)setDynamicShortcutItems:(NSMutableArray *)inArguments{
    if([inArguments count] < 1){
        return;
    }
    id info = [inArguments[0] JSONValue];
    if(!info || ![info isKindOfClass:[NSArray class]]){
        return;
    }
    NSMutableArray<UIApplicationShortcutItem *> *shortcuts=[NSMutableArray array];
    for(int i=0;i<[info count];i++){
        UIApplicationShortcutItem *item=[self parseShortcutItem:info[i]];
        if(item){
            [shortcuts addObject:item];
        }
    }
    [[UIApplication sharedApplication] setShortcutItems:shortcuts];
    
}
-(UIApplicationShortcutItem *)parseShortcutItem:(NSDictionary *)shortcutInfo{
    if(!shortcutInfo || ![shortcutInfo isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    if(![shortcutInfo objectForKey:@"type"] || ![shortcutInfo objectForKey:@"title"]){
        return nil;
    }
    UIMutableApplicationShortcutItem *item =[[UIMutableApplicationShortcutItem alloc]initWithType:[shortcutInfo objectForKey:@"type"]
                                                                                   localizedTitle:[shortcutInfo objectForKey:@"title"]];
    UIApplicationShortcutIcon *icon=nil;
    NSArray *iconArray=@[@"UIApplicationShortcutIconTypeCompose",
                         @"UIApplicationShortcutIconTypePlay",
                         @"UIApplicationShortcutIconTypePause",
                         @"UIApplicationShortcutIconTypeAdd",
                         @"UIApplicationShortcutIconTypeLocation",
                         @"UIApplicationShortcutIconTypeSearch",
                         @"UIApplicationShortcutIconTypeShare",
                         @"UIApplicationShortcutIconTypeProhibit",
                         @"UIApplicationShortcutIconTypeContact",
                         @"UIApplicationShortcutIconTypeHome",
                         @"UIApplicationShortcutIconTypeMarkLocation",
                         @"UIApplicationShortcutIconTypeFavorite",
                         @"UIApplicationShortcutIconTypeLove",
                         @"UIApplicationShortcutIconTypeCloud",
                         @"UIApplicationShortcutIconTypeInvitation",
                         @"UIApplicationShortcutIconTypeConfirmation",
                         @"UIApplicationShortcutIconTypeMail",
                         @"UIApplicationShortcutIconTypeMessage",
                         @"UIApplicationShortcutIconTypeDate",
                         @"UIApplicationShortcutIconTypeTime",
                         @"UIApplicationShortcutIconTypeCapturePhoto",
                         @"UIApplicationShortcutIconTypeCaptureVideo",
                         @"UIApplicationShortcutIconTypeTask",
                         @"UIApplicationShortcutIconTypeTaskCompleted",
                         @"UIApplicationShortcutIconTypeAlarm",
                         @"UIApplicationShortcutIconTypeBookmark",
                         @"UIApplicationShortcutIconTypeShuffle",
                         @"UIApplicationShortcutIconTypeAudio",
                         @"UIApplicationShortcutIconTypeUpdate"];

    
    if([shortcutInfo objectForKey:@"iconType"] && [iconArray containsObject:[shortcutInfo objectForKey:@"iconType"]]){
        icon=[UIApplicationShortcutIcon iconWithType:[iconArray indexOfObject:[shortcutInfo objectForKey:@"iconType"]]];
    }
    if([shortcutInfo objectForKey:@"iconFile"] && [shortcutInfo[@"iconFile"] isKindOfClass:[NSString class]]){
        icon=[UIApplicationShortcutIcon iconWithTemplateImageName:shortcutInfo[@"iconFile"]];
    }
    if(icon){
        [item setIcon:icon];
    }
    if([shortcutInfo objectForKey:@"info"] && [shortcutInfo[@"info"] isKindOfClass:[NSDictionary class]]){
        [item setUserInfo:shortcutInfo[@"info"]];
    }
    if([shortcutInfo objectForKey:@"subtitle"] && [shortcutInfo[@"subtitle"] isKindOfClass:[NSString class]]){
        [item setLocalizedSubtitle:shortcutInfo[@"subtitle"]];
    }
    return item;
}

@end
