//
//  SecretReadController.m
//  SecretRead
//
//  Created by 静 on 2018/12/10.
//  Copyright © 2018年 静. All rights reserved.
//

#import "SecretReadController.h"

@interface SecretReadController ()<NSTableViewDelegate,NSTableViewDataSource>
@property(nonatomic,strong) NSString * bookContent;
@property(nonatomic,strong) NSMutableArray * bookList;
@property(nonatomic,strong) NSMutableArray * chapterList;
@property(nonatomic,strong) NSMutableArray * bookPathList;
@property(nonatomic,strong) NSMutableArray * chapterContentArr;
@property(nonatomic,strong) NSString * bookPath;
@property(nonatomic,strong) NSFileManager * fileManage;
@end

@implementation SecretReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [NSApplication sharedApplication].keyWindow.title = @"asdasd";
    
    
    [self createBookPath];
    [self reloadBookList];
    
    
    

}

/**
 创建文件目录
 */
-(void)createBookPath{
    self.fileManage = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    self.bookPath = [path stringByAppendingPathComponent:@"books"];
    if (![self.fileManage fileExistsAtPath:self.bookPath]) {
        [self.fileManage createDirectoryAtPath:self.bookPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 刷新文件list
 */
-(void)reloadBookList{
    [self.bookList removeAllObjects];
    //目录迭代器
    NSDirectoryEnumerator *direnum = [self.fileManage enumeratorAtPath:self.bookPath];
    //新建数组，存放各个文件路径
    //遍历目录迭代器，获取各个文件路径
    NSString *filename;
    while (filename = [direnum nextObject]) {
        if ([[filename pathExtension] isEqualTo:@"txt"]) {//筛选出文件后缀名是txt的文件
            SecretBookModel * model = [SecretBookModel new];
            model.bookName= filename;
            model.bookPath =[self.bookPath stringByAppendingPathComponent:filename];
            
            [self.bookList addObject:model];
        }
    }
    
    [self.bookListTable reloadData];
    
}

- (NSMutableArray *)bookList{
    if (!_bookList) {
        _bookList = [NSMutableArray array];
    }
    return _bookList;
}

- (NSMutableArray *)bookPathList{
    if (!_bookPathList) {
        _bookPathList = [NSMutableArray array];
    }
    return _bookPathList;
}

- (NSMutableArray *)chapterList{
    if (!_chapterList) {
        _chapterList = [NSMutableArray array];
    }
    return _chapterList;
}

- (NSMutableArray *)chapterContentArr{
    if (!_chapterContentArr) {
        _chapterContentArr = [NSMutableArray array];
    }
    return _chapterContentArr;
}

#pragma mark --tableDelegate--


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (tableView == self.bookListTable) {
        return self.bookList.count;
    }else{
        return self.chapterList.count;
    }
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (tableView == self.bookListTable) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"customCellView" owner:self];
        // cellView.imageView.image = [NSImage imageNamed:@""]; //设置图片
        SecretBookModel * model =self.bookList[row];
        cellView.textField.stringValue = model.bookName;        //设置文字
        return cellView;
    }else{
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"chapterCellView" owner:self];
        // cellView.imageView.image = [NSImage imageNamed:@""]; //设置图片
        
        cellView.textField.stringValue = self.chapterList[row];        //设置文字
        return cellView;
    }
    
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 17;
}

-(void)tableViewSelectionDidChange:(nonnull NSNotification *)notification{
    NSTableView *tableView = notification.object;
    if (tableView == self.bookListTable) {
        SecretBookModel *model = self.bookList[tableView.selectedRow];
        self.bookContent = [DCFileTool transcodingWithPath:model.bookPath];
        self.chapterList =  [DCFileTool getBookListWithText:self.bookContent];
        self.chapterContentArr = [DCFileTool getChapterArrWithString:self.bookContent];
        [self.chapterListTable reloadData];
    }else{
        
        self.previewTextView.string = self.chapterContentArr[tableView.selectedRow];
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
}

/**
 添加图书
 */
- (IBAction)chooseFileBtnClick:(id)sender {
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    NSArray *array = [NSArray arrayWithObject:@"txt"];
    [panel setAllowedFileTypes:array];
    [panel setAllowsMultipleSelection:NO];  //是否允许多选file
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSMutableArray* filePaths = [[NSMutableArray alloc] init];
            for (NSURL* elemnet in [panel URLs]) {
                
//                self.book = [DCFileTool transcodingWithPath:elemnet.absoluteString];
                [filePaths addObject:[elemnet path]];
                // 从路径中获得完整的文件名（带后缀）
                NSString * exestr = [elemnet lastPathComponent];
                NSLog(@"%@",exestr);
                // 获得文件名（不带后缀）
                NSString* bookName = [exestr stringByDeletingPathExtension];
                [self finshChooseFile:[elemnet path] bookName:exestr];
            }
            
            NSLog(@"filePaths : %@",filePaths);
        }
        
    }];
    
}

/**
 完成选择，进行存储拷贝

 @param path 要拷贝的文件路径
 @param bookName 图书名称，带后缀
 */
-(void)finshChooseFile:(NSString*)path bookName:(NSString*)bookName{
    

    
    NSString *addPath = [self.bookPath stringByAppendingPathComponent:bookName];
    if (![self.fileManage fileExistsAtPath:addPath]) {
            BOOL isSuccess = [self.fileManage copyItemAtPath:path toPath:addPath error:nil];
            [self showAlert:isSuccess?@"导入成功":@"导入失败"];
            
        [self reloadBookList];
    }else{
        [self showAlert:@"已存在同名文件！"];
    }


    
}

/**
 提示框

 @param content 提示文字
 */
-(void)showAlert:(NSString *)content{
    NSAlert *alert = [[NSAlert alloc]init];
    //        alert.icon = [NSImage imageNamed:@"baba.png"];[alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    alert.messageText = @"提示";
    alert.informativeText = content;
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {        if (returnCode == NSAlertFirstButtonReturn ) {            NSLog(@"this is OK Button tap");
        
    }else if (returnCode == NSAlertSecondButtonReturn){            NSLog(@"this is Cancel Button tap");
        
    }
        
    }];
}

@end
