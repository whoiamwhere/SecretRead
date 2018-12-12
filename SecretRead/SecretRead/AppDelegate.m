//
//  AppDelegate.m
//  SecretRead
//
//  Created by 静 on 2018/12/10.
//  Copyright © 2018年 静. All rights reserved.
//

#import "AppDelegate.h"
#import "SecretReadController.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;


@property (nonatomic,strong) IBOutlet SecretReadController *viewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.viewController  = [[SecretReadController alloc]initWithNibName:@"SecretReadController" bundle:nil];
    
//    self.window.styleMask = self.window.styleMask | NSWindowStyleMaskFullSizeContentView;
    
    
    [self.window.contentView addSubview:self.viewController.view];
    self.viewController.view.frame = self.window.contentView.bounds;
    
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
