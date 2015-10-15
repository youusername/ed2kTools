//
//  ViewController.h
//  ed2kTools
//
//  Created by Mac on 15/10/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTextField *getURLField;

@end

