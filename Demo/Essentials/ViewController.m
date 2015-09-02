//
//  ViewController.m
//  Essentials
//
//  Created by Mike on 9/1/15.
//  Copyright © 2015 Mike Amaral. All rights reserved.
//

#import "ViewController.h"

static CGFloat const kPadding = 30.0;
static CGFloat const kAvatarSize = 150.0;

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createRoundedImageViewWithShadow];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.shadowView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (kAvatarSize / 2.0), kPadding, kAvatarSize, kAvatarSize);
    self.imageView.frame = CGRectMake(0, 0, kAvatarSize, kAvatarSize);
}


#pragma mark - Rounded image view with shadow

- (void)createRoundedImageViewWithShadow {
    self.shadowView = [UIView new];
    self.shadowView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.shadowView.layer.shadowOpacity = 0.9;
    self.shadowView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    [self.view addSubview:self.shadowView];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = kAvatarSize / 2.0;
    [self.shadowView addSubview:self.imageView];
}

@end
