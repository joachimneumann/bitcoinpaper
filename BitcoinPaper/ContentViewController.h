//
//  ContentViewController.h
//  BitcoinPaper
//
//  Created by Joachim Neumann on 04/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publication.h"

@interface ContentViewController : UIViewController
@property (nonatomic, retain) Publication* publication;
@property (strong, nonatomic) IBOutlet UIView *resultNavigationView;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (nonatomic, assign) CGPoint searchPos;

- (void)lessButtonPressed:(id)sender;
- (void)moreButtonPressed:(id)sender;
- (CGPoint)myPositionOfElementWithId:(NSString *)elementID;
@end
