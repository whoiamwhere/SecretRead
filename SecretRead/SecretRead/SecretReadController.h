//
//  SecretReadController.h
//  SecretRead
//
//  Created by 静 on 2018/12/10.
//  Copyright © 2018年 静. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SecretReadController : NSViewController
@property (nonatomic,strong)IBOutlet NSTableView *bookListTable;
@property (nonatomic,strong)IBOutlet NSTableView *chapterListTable;
@property (nonatomic,strong)IBOutlet NSButton *chooseBtn;
- (IBAction)chooseFileBtnClick:(id)sender;

@property (nonatomic,strong)IBOutlet NSTextView *previewTextView;

@property (nonatomic,strong)IBOutlet NSButton *previousBtn;
- (IBAction)previousBtnClick:(id)sender;

@property (nonatomic,strong)IBOutlet NSButton *nextBtn;
- (IBAction)nextBtnClick:(id)sender;
@end
