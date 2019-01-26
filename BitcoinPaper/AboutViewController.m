//
//  AboutViewController.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 05/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [aboutScrollview setScrollEnabled: YES];
    [aboutScrollview setContentSize: CGSizeMake(320, 410)];
}


- (void)viewDidLayoutSubviews
{
    CGRect textFrame;
    textFrame = copyrightTextview.frame;
    textFrame.origin.y = 0;
    [copyrightTextview setFrame: textFrame];
    
    float y = textFrame.origin.y + textFrame.size.height;
    CGRect buttonFrame;
    buttonFrame = button1.frame;
    buttonFrame.origin.y = y+20;
    [button1 setFrame:buttonFrame];
}
@end


//    copyrightTextview.center = aboutScrollview.center;
//    CGRect bounds = copyrightTextview.bounds;
//    bounds.origin.y = 20;
//    [copyrightTextview setBounds: bounds];
//    CGPoint aboutCenter = aboutScrollview.center;
//    CGPoint textCenter = copyrightTextview.center;
//    textCenter.x = aboutCenter.x;
//    [copyrightTextview setCenter: textCenter];
//    textBounds.origin.y = 0;
//    [copyrightTextview setBounds:textBounds];
