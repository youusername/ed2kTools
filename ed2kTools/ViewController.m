//
//  ViewController.m
//  ed2kTools
//
//  Created by Mac on 15/10/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
//#import "AFOnoResponseSerializer.h"
//#import "Ono.h"
#import "ed2kClass.h"
@implementation ViewController{
    NSMutableArray*ed2kArray;
    TFHpple *xpathparser;
    __weak IBOutlet NSTableView *EtableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.manager                    = [AFHTTPRequestOperationManager manager];
//    self.manager.responseSerializer = [AFOnoResponseSerializer HTMLResponseSerializer];
    ed2kArray = [[NSMutableArray alloc]init];
    xpathparser=[[TFHpple alloc]init];
    //setAction单击选择事件
    [EtableView setAction:NSSelectorFromString(@"SelectorClick:")];
    //setDoubleAction双击选择事件
    [EtableView setDoubleAction:NSSelectorFromString(@"doubleClick:")];
    
    
//    self.getURLField.stringValue=@"http://tieba.baidu.com/p/2201917869";

}

- (void)SelectorClick:(id)sender

{
//    单击选择事件
    NSInteger rowNumber = [EtableView clickedRow];
    if (rowNumber==-1) {
        for (ed2kClass*ed2k in ed2kArray) {
            ed2k.box=ed2k.box==1?0:1;
        }
    }else{
        ed2kClass*ed2k=ed2kArray[rowNumber];
        ed2k.box=ed2k.box==1?0:1;
    }
    [EtableView reloadData];
    
    NSLog(@"Selector Clicked.%ld ",rowNumber);
    
}
- (void)doubleClick:(id)sender

{
//    双击选择事件
    NSInteger rowNumber = [EtableView clickedRow];
    
    NSLog(@"Double Clicked.%ld ",rowNumber);
    
}
-(void)viewWillAppear{
//    
//    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
//    NSString *plainText = [[pasteboard readObjectsForClasses:@[[NSString class]] options:nil] firstObject];
//    if(self.getURLField.stringValue.length==0||self.getURLField.stringValue.length<400||plainText!=nil){
//    self.getURLField.stringValue=plainText;
//    }
}
- (IBAction)copySelectorEd2k:(id)sender {
    NSString*str=[[NSString alloc]init];
    for (ed2kClass*ed2k in ed2kArray) {
        if (ed2k.box==1) {
            str=[str stringByAppendingString:[NSString stringWithFormat:@"\n%@",ed2k.ed2k]];
        }
    }
    [self setPasteboard:str];
}
- (IBAction)pushWibo:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://weibo.com/u/2689574923"]];
}
- (IBAction)copyAllEd2k:(id)sender {
    NSString*str=[[NSString alloc]init];
    for (ed2kClass*ed2k in ed2kArray) {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"\n%@",ed2k.ed2k]];
    }
    [self setPasteboard:str];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ed2kClass*ed2k;
    if([[tableColumn identifier] isEqualToString:@"number"]){
        return [NSString stringWithFormat:@"%ld",row+1];
    }
    else if ([[tableColumn identifier] isEqualToString:@"ed2k"]){
        ed2k=ed2kArray[row];
        return ed2k.Name;
    }
    else if ([[tableColumn identifier] isEqualToString:@"box"]){
        ed2k=ed2kArray[row];
        return [NSString stringWithFormat:@"%ld",ed2k.box];
    }
    else{
        return nil;
    }
}

-(void)setPasteboard:(NSString*)text{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    
    [self writeToPasteboard:pasteboard withString:text];
}
-(NSString*)FiltrationURL:(NSString*)url{
    url=[url stringByReplacingOccurrencesOfString:@" " withString:@""];
    url=[url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return url;
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
    
    
    if (self.getURLField.stringValue.length>5) {
        [ed2kArray removeAllObjects];
        [ed2kArray addObjectsFromArray:[self getEd2kSetUrl:[self FiltrationURL:self.getURLField.stringValue]]];
        [EtableView reloadData];
    }else if (self.getSearchField.stringValue.length>5){
//        [ed2kArray removeAllObjects];
//        [EtableView reloadData];
    }else{
        NSAlert *alert = [NSAlert alertWithMessageText:@"你确定你输入了搜索名字或地址吗?"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"如果你确定有输入但程序没有反应请联系我告知BUG!"];
        [alert beginSheetModalForWindow:self.view.window
                              modalDelegate:self didEndSelector:nil
                                contextInfo:nil];

    }
    
}
-(NSMutableArray*)getEd2kSetUrl:(NSString*)url{
    NSMutableArray*ListArray=[[NSMutableArray alloc]init];
    NSData*htmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    if (htmlData.length<100) {
        
        return [[NSMutableArray alloc]init];
    }
    //    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:htmlData];
    [xpathparser setValue:htmlData forKey:@"data"];
    NSString*ed2k;
    NSArray*liS=[xpathparser searchWithXPathQuery:@"//a[@href]"];
    NSString* strClear;
//    NSString *user;
    NSRange range;
    BOOL isAdd = NO;
    for (TFHppleElement*tf in liS) {
        if (tf.raw.length>200) {
            
            if ([[tf.raw componentsSeparatedByString:@"ed2k://"] count]>=2) {
//                查找ed2k链接
//                user = @"ed2k://.*.\\|\\/";
//                range = [tf.raw rangeOfString:user options:NSRegularExpressionSearch];
//                strClear=[NSString stringWithFormat:@"%@",[tf.raw substringWithRange:range]];
                strClear = [self TextrangeOfString:tf.raw setRegularExpressions:@"ed2k://.*.\\|\\/"];
                NSArray*strClearArray=[strClear componentsSeparatedByString:@"|/"];
                if (strClearArray.count<2) {
                    ed2k=[tf.raw substringWithRange:range];
                }else{
                    ed2k=[NSString stringWithFormat:@"%@|/",strClearArray[0]];
                }
                isAdd = YES;
                
            }else if ([[tf.raw componentsSeparatedByString:@"magnet:?"] count]>=2){
//                查找磁力链接
//                user = @"magnet:?[^\"]+";
//                range = [tf.raw rangeOfString:user options:NSRegularExpressionSearch];
//                strClear = [NSString stringWithFormat:@"%@",[tf.raw substringWithRange:range]];
//                ed2k = strClear;
                ed2k = [self TextrangeOfString:tf.raw setRegularExpressions:@"magnet:?[^\"]+"];
                isAdd = YES;
            }
            
            
            if (range.location != NSNotFound && isAdd) {
//                排除空数据
                ed2kClass*e=[[ed2kClass alloc]init];
                e.ed2k=ed2k;
                e.Name=[self searchEd2kName:ed2k];
                
                [ListArray addObject:e];
            }
            isAdd = NO;
        }
    }
    if (ListArray.count<=0) {
//        查找非标签内的ed2k
        [ListArray addObjectsFromArray:[self getNotLabeWeb:[xpathparser searchWithXPathQuery:@"/*"]]];
    }
    
    return ListArray;
}

-(NSMutableArray*)getNotLabeWeb:(NSArray*)array{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    for (TFHppleElement*tf in array) {
        NSArray*ed2kA=[tf.raw componentsSeparatedByString:@"|/"];
        for (NSString*isEd2k in ed2kA) {
            if ([self isEd2k:[NSString stringWithFormat:@"%@|/",isEd2k]]) {
                NSString*clearEd2k = [self clearEd2kSrt:[NSString stringWithFormat:@"%@|/",isEd2k]];
                ed2kClass*e=[[ed2kClass alloc]init];
                e.ed2k=[self clearEd2kSrt:clearEd2k];
                e.Name=[self searchEd2kName:[self clearEd2kSrt:clearEd2k]];
                [arr addObject:e];
                
            }
        }
    }
    
    
    return arr;
}
-(NSString*)clearEd2kSrt:(NSString*)ed2kstr{
//    清理ed2k前后的多余字符
    NSRange range = [ed2kstr rangeOfString:@"ed2k"];//匹配得到的下标
    NSRange range2 = [ed2kstr rangeOfString:@"|/"];//匹配得到的下标
//    NSString*clear1=[]
    return [[ed2kstr substringFromIndex:range.location] substringToIndex:range2.length+range2.location-range.location];
}
-(BOOL)isEd2k:(NSString*)str{
    NSRange range = [str rangeOfString:@"ed2k://.*.\\|\\/" options:NSRegularExpressionSearch];
    if (range.length>10) {
        return YES;
    }else{
        return NO;
    }
}
-(NSString*)TextrangeOfString:(NSString*)rangeStr setRegularExpressions:(NSString*)RegularExpressions{

    NSRange range = [rangeStr rangeOfString:RegularExpressions options:NSRegularExpressionSearch];
    
    return [NSString stringWithFormat:@"%@",[rangeStr substringWithRange:range]];
}

-(NSString*)searchEd2kName:(NSString*)ed2k{
//    查找ed2k文件名
    NSArray*strClearArray=[ed2k componentsSeparatedByString:@"|"];
    if (strClearArray.count<2) {
        return ed2k;
    }else{
        NSString*name=[strClearArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (name.length<2) {
//            防止
            return ed2k;
        }else{
            return name;
        }
    }
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
