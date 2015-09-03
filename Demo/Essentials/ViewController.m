//
//  ViewController.m
//  Essentials
//
//  Created by Mike on 9/1/15.
//  Copyright © 2015 Mike Amaral. All rights reserved.
//

#import "ViewController.h"
#import "MyPersonObject.h"

static CGFloat const kPadding = 30.0;
static CGFloat const kAvatarSize = 150.0;

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createRoundedImageViewWithShadow];
    [self addGestureRecognizerToImageView];
    [self createSomeObjects];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.shadowView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (kAvatarSize / 2.0), kPadding, kAvatarSize, kAvatarSize);
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

- (void)addGestureRecognizerToImageView {
    // If we don't override the default NO value (NO is only the default for UIImageView - WHY APPLE?!)
    // our gesture recognizer won't work.
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
}


#pragma mark - Tap gesture recognizer

- (void)handleTap {
    [[[UIAlertView alloc] initWithTitle:@"Testing" message:@"123" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}


#pragma mark - Object creation shortcuts

- (void)createSomeObjects {
    // Old and busted
    NSObject *object = [[NSObject alloc] init];
    NSNumber *number = [[NSNumber alloc] initWithInteger:1];
    NSNumber *boolNumber = [[NSNumber alloc] initWithBool:NO];
    NSArray *array = [[NSArray alloc] initWithObjects:object, number, boolNumber, nil];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:object, @"key1", number, @"key2", nil];

    // New hotness
    object = [NSObject new];
    number = @1;
    boolNumber = @YES;
    array = @[object, number, boolNumber];
    dictionary = @{@"key": object};

    MyPersonObject *personA = [MyPersonObject new];
    personA.name = @"Michael";
    personA.favoriteColor = @"red";
    personA.age = 26;

    MyPersonObject *personB = [MyPersonObject new];
    personB.name = @"Suzie";
    personB.favoriteColor = @"orange";
    personB.age = 4;

    MyPersonObject *personC = [MyPersonObject new];
    personC.name = @"Meghan";
    personC.favoriteColor = @"purple";
    personC.age = 23;

    MyPersonObject *personD = [MyPersonObject new];
    personD.name = @"Karen";
    personD.favoriteColor = nil;
    personD.age = -2;

    NSArray *people = @[personA, personB, personC, personD];

    NSLog(@"%@", people.debugDescription);
}


#pragma mark - CGRect shortcuts

- (void)createSomeFrames {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 100, 75)];

    // Old and busted
    CGFloat xOrigin = view.frame.origin.x;
    CGFloat yOrigin = view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    CGFloat maxX = view.frame.origin.x + view.frame.size.width;
    CGFloat maxY = view.frame.origin.y + view.frame.size.height;

    // New hotness
    xOrigin = CGRectGetMinX(view.frame);
    yOrigin = CGRectGetMinY(view.frame);
    width = CGRectGetWidth(view.frame);
    height = CGRectGetHeight(view.frame);
    maxX = CGRectGetMaxX(view.frame);
    maxY = CGRectGetMaxY(view.frame);
}

@end
