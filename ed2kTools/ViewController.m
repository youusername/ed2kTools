//
//  ViewController.m
//  ed2kTools
//
//  Created by Mac on 15/10/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

@implementation ViewController{
    NSMutableArray*TFHppleArray;
    NSMutableArray*ed2kArray;
    TFHpple *xpathparser;
    __weak IBOutlet NSTableView *EtableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TFHppleArray = [[NSMutableArray alloc]init];
    ed2kArray = [[NSMutableArray alloc]init];
    xpathparser=[[TFHpple alloc]init];
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear{
//    
//    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
//    NSString *plainText = [[pasteboard readObjectsForClasses:@[[NSString class]] options:nil] firstObject];
//    if(self.getURLField.stringValue.length==0||self.getURLField.stringValue.length<400||plainText!=nil){
//    self.getURLField.stringValue=plainText;
//    }
}
- (IBAction)copyAllEd2k:(id)sender {
    NSString*str=[[NSString alloc]init];
    for (NSDictionary*dic in ed2kArray) {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"\n%@",dic[@"ed2k"]]];
    }
    [self setPasteboard:str];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
//    if (!(row >= 0 && row < [ed2kArray count])) {
//        return nil;
//    }
//    NSDictionary *p=[ed2kArray objectAtIndex:row];
//    return [p objectForKey:[tableColumn identifier]];

    return [[ed2kArray objectAtIndex:row] objectForKey:[tableColumn identifier]];
}
-(void)setPasteboard:(NSString*)text{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    
    [self writeToPasteboard:pasteboard withString:text];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return YES;
}
- (void)writeToPasteboard:(NSPasteboard *)pb withString:string{
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]
               owner:self];
    [pb setString:string forType:NSStringPboardType];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [ed2kArray count];
}
- (IBAction)GoAction:(id)sender {
//    http://cn163.net/archives/140
//    http://cn163.net/archives/138
    [ed2kArray removeAllObjects];
    [TFHppleArray removeAllObjects];
    NSData*htmlData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.getURLField.stringValue]];
    if (htmlData.length<100) {

        return;
    }
//    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:htmlData];
    [xpathparser setValue:htmlData forKey:@"data"];
    NSString*ed2k;
    NSArray*liS=[xpathparser searchWithXPathQuery:@"//a[@href]"];
    NSString* strClear;
    NSString *user;
    NSRange range;
    for (TFHppleElement*tf in liS) {
        if (tf.raw.length>200) {
            
            if ([[tf.raw componentsSeparatedByString:@"ed2k://"] count]>=2) {
                user = @"ed2k://.*.\\|\\/";
                range = [tf.raw rangeOfString:user options:NSRegularExpressionSearch];
                strClear=[NSString stringWithFormat:@"%@",[tf.raw substringWithRange:range]];
                NSArray*strClearArray=[strClear componentsSeparatedByString:@"|/"];
                if (strClearArray.count<2) {
                    ed2k=[tf.raw substringWithRange:range];
                }else{
                    ed2k=[NSString stringWithFormat:@"%@|/",strClearArray[0]];
                }
                if (range.location != NSNotFound) {
                    [self searchEd2kName:ed2k];
                    [ed2kArray addObject:@{@"ed2k": ed2k} ];
                }
            }else if ([[tf.raw componentsSeparatedByString:@"magnet:?"] count]>=2){
                
                    user = @"magnet:?[^\"]+";
                    range = [tf.raw rangeOfString:user options:NSRegularExpressionSearch];
                
                    strClear = [NSString stringWithFormat:@"%@",[tf.raw substringWithRange:range]];
                
                if (range.location != NSNotFound) {
                    
                    [ed2kArray addObject:@{@"ed2k": strClear} ];
                }
            }
        }
    }
    
    [EtableView reloadData];
}

-(NSString*)searchEd2kName:(NSString*)ed2k{
    
    NSArray*strClearArray=[ed2k componentsSeparatedByString:@"|"];
    return [strClearArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
