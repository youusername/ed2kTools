//
//  AppDelegate.m
//  ed2kTools
//
//  Created by Mac on 15/10/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    //    if (!flag){//是否有可见窗口
    //主窗口显示
    //        [NSApp activateIgnoringOtherApps:NO];
    [self.RootWindow makeKeyAndOrderFront:self];
    
    
    //    }
    
    
    return YES;
}
@end
