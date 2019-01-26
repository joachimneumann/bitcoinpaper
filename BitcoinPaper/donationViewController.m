//
//  donationViewController.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 01/04/14.
//  Copyright (c) 2014 Joachim Neumann. All rights reserved.
//

#import "donationViewController.h"

@interface donationViewController ()

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation donationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [donationScrollView setScrollEnabled: YES];
    [donationScrollView setContentSize: CGSizeMake(320, 410)];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [donationScrollView addGestureRecognizer:singleTapGestureRecognizer];
    [self addQRCodeToImageView: qrImageView];
}


- (void)viewDidLayoutSubviews
{
    CGRect frame;
    frame = l1.frame;
    frame.origin.y = 5;
    [l1 setFrame: frame];

    frame = qrImageView.frame;
    frame.origin.y = 90;
    [qrImageView setFrame: frame];
    
    frame = l3.frame;
    frame.origin.y = 270;
    [l3 setFrame: frame];
}


// old, lost private key NSString* btcAddress = @"1FHhBBTLkebrAAUfC4Exk5sBKg7yxAU6LV";
NSString* btcAddress = @"1KM2jTgFkrpvY43wBQsLu31i4aUq9HnMrw";

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    [[UIPasteboard generalPasteboard] setString: btcAddress];
}

- (IBAction)buttonPressed:(id)sender {
    [[UIPasteboard generalPasteboard] setString: btcAddress];
}

- (void)addQRCodeToImageView:(UIImageView *)imgView {
    NSData *qrData = [btcAddress dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:qrData forKey:@"inputMessage"];
    CIImage *unscaledImage = qrFilter.outputImage;
    
    // transition CIImage to CGImage and enlarge it
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:unscaledImage fromRect:[unscaledImage extent]];
    UIGraphicsBeginImageContext(CGSizeMake((NSInteger)imgView.frame.size.width, (NSInteger)imgView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *upscaledQR = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    imgView.image = [self flipImageVertically:upscaledQR];
}

- (UIImage *)flipImageVertically:(UIImage *)originalImage {
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];
    UIGraphicsBeginImageContext(tempImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, tempImageView.frame.size.height);
    CGContextConcatCTM(context, flipVertical);
    [[tempImageView layer] renderInContext:context];
    UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return flipedImage;
}


@end
