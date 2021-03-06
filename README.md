***Essentials*** is a curated list of things I wish I knew about Objective-C, Xcode, and Cocoa Touch when I started programming iOS apps. The first few months of my iOS developer career were marked by spending entire days debugging annoying crashes or odd behavior that almost always turned out to be *one-liners* to fix. I became quite good at scouring the web for the solution to my problem, and do my best to [contribute back to the Stack Overflow community](http://stackoverflow.com/users/3132984/mike) when I can.

My goal for this project is to accumulate all of the interesting shortcuts, tips, solutions to problems easy or hard, and anything else I feel is worth sharing and archiving, for both myself and the iOS developer community at large to have as a reference. I willing be adding new information here seemingly at random, as interesting or useful bits of information come to mind, and this will likely be a forever *work in progress*.

# Table of Contents

* [Xcode](#xcode)
  * [View UI Hierarchy](#view-ui-hierarchy)

* [Foundation](#foundation)
  * [NSObject](#nsobject)
    * [Object Initialization Shortcuts](#object-initialization-shortcuts)  
    * [Custom Debug Descriptions](#custom-debug-descriptions)
 
* [UIKit](#uikit)
  * [UIView](#uiview)
    * [Rounded View With Shadow](#rounded-view-with-shadow)
  * [UIImageView](#uiimageview)
    * [UITapGestureRecognizer not working?](#uitapgesturerecognizer-not-working)

* [Core Graphics](#core-graphics)
  * [CGRect Shortcuts](#cgrect-shortcuts)


# Xcode

## View UI Hierarchy

This is one of my personal favorite Xcode features, that has saved my butt probably hours of debugging time. While running your app in the simulator, select the `Debug Navigator` tab on the left-hand menu, click the sideways-hamburger-looking icon (I still have no idea what that icon is), and select `View UI Hierarchy`:

![ui-hierarchy](Screenshots/ui-hierarchy.png)

After a short delay, this will give you a ***SWEET*** live interactive view of the view you're looking at in the simulator, giving you the ability to debug any weird UI layout issues you may be having:

![ui-hierarchy](Screenshots/ui-hierarchy.gif)

# Foundation
  
## NSObject

### Object Initialization Shortcuts

I'm baffled that in so much of the code I see these days that's been written *recently*, people are still using the older initialization conventions for various classes:

    NSObject *object = [[NSObject alloc] init];
    NSNumber *number = [[NSNumber alloc] initWithInteger:1];
    NSNumber *boolNumber = [[NSNumber alloc] initWithBool:NO];
    NSArray *array = [[NSArray alloc] initWithObjects:object, number, boolNumber, nil];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:object, @"key", nil];
    
For christ's sake, there's a better way!

    NSObject *object = [NSObject new];
    NSNumber *number = @1; // or if you have a primitive var, wrap it in parens: @(foo)
    NSNumber *boolNumber = @YES;
    NSArray *array = @[object, number, boolNumber];
    NSDictionary *dictionary = @{@"key": object};
  
### Custom Debug Descriptions

Ever get deep into debugging some obscure issue with your custom `NSObject` subclasses, sitting at a breakpoint, excited that you think you've finally tracked down the bug, you print out the variable in the console and get this:

    (lldb) po person
    <MyPersonObject: 0x7fb5c8c35c90>

Or perhaps you have an array of people and need to figure out which one has the bad data?

    (lldb) po people
    <__NSArrayI 0x7f83fa50f0a0>(
    <MyPersonObject: 0x7f83fa424810>,
    <MyPersonObject: 0x7f83fa424910>,
    <MyPersonObject: 0x7f83fa424930>
    )
    
Well that's not very useful, is it? I'll tell you, it was a happy day when I discovered that you can override what Xcode outputs to the console when you use the `po` command while debugging, simply by implementing `debugDescription` in your subclass:

    - (NSString *)debugDescription {
        return [NSString stringWithFormat:@"name: %@, favorite color: %@, age: %ld", self.name, self.favoriteColor, (long)self.age];
    }

Xcode will now output useful debugging information nice and neatly for you:

    (lldb) po person
    name: Michael, favorite color: red, age: 26

    (lldb) po people
    <__NSArrayI 0x7ffa599017a0>(
       name: Michael, favorite color: red, age: 26,
       name: Suzie, favorite color: orange, age: 4,
       name: Meghan, favorite color: purple, age: 23,
       name: Karen, favorite color: (null), age: -2
    )
  
# UIKit
  
## UIView
  
### Rounded view with shadow

It seems like in most of the apps I work on these days include a number of [UIView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/) designs that have both radiused corners, as well as a drop shadow. For example, let's say I'm designing a sleek new profile page, and want to feature my user's avatar with a nice circular shape, that should be pretty simple, right? I'll just set the `cornerRadius` and customize the shadow properties on my view's `layer`, throw it in my view controller, and we should be all set.

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
    self.imageView.layer.cornerRadius = kAvatarSize / 2.0;
    self.imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.9;
    self.imageView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    [self.view addSubview:self.imageView];

![fail1](Screenshots/1.png)

Well the shadow looks OK, but square avatars were *so 2011*. Looks like I forgot to tell the layer to `masksToBounds` - let's throw that in there and we should be ready to see this pretty rounded avatar with a nice drop shadow effect for my new profile page!

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = kAvatarSize / 2.0;
    self.imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.9;
    self.imageView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    [self.view addSubview:self.imageView];

![fail2](Screenshots/2.png)

Great, now we.... wait, where'd the shadow go? It's always about this point I realize I've forgotten ***for the nth time*** that the problem with the above code is that in order to get your view to be rounded, you need to either set the view's `clipsToBounds` or your view's layer's `masksToBounds` properties to `YES`, but that effectively clips/masks your shadow.

The solution to our problem is a slightly annoying one, but easily done - create **two** views, one that will display the shadow, and one that will show your content appropriately rounded:

    self.shadowView = [UIView new];
    self.shadowView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.shadowView.layer.shadowOpacity = 0.9;
    self.shadowView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    [self.view addSubview:self.shadowView];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = kAvatarSize / 2.0;
    [self.shadowView addSubview:self.imageView];

![fail2](Screenshots/3.png)

>I was interested to know what the difference between `view.clipsToBounds` and `view.layer.masksToBounds` was, as they seemed to achieve the exact same thing. I stumbled across [this answer](http://stackoverflow.com/a/1177978/3132984) to exactly that question. Turns out, they *basically are the same thing*. Under the covers, `UIView`'s `clipsToBounds` calls `CALayer`'s `masksToBounds`.

## UIImageView

### UITapGestureRecognizer not working?

I end up spending a few minutes every few months scratching my head over why my `UIImageView` that I added a `UITapGestureRecognizer` to wasn't *working*. In almost all cases, it's because I forgot that Apple pulled a switcheroo on us, and decided that for `UIImageView` only:

> image view objects are configured to disregard user events by default.

According to the [documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIImageView_Class/#//apple_ref/occ/instp/UIImageView/userInteractionEnabled) for `UIImageView`, more specifically the `userInteractionEnabled` property:

> This property is inherited from the UIView parent class. This class changes the default value of this property to NO.

Make sure you explicity enable user interaction on your image views if you plan to allow it.

    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doYourThing)]];
    
# Core Graphics
  
## CGRect Shortcuts

I create all of my UI layouts programmatically, which can get quite verbose with more complex interfaces. Consider a `UIView` that you need to access and/or calculate information about its frame. I used to have a whole bunch of the following in my code:

    CGFloat xOrigin = view.frame.origin.x;
    CGFloat yOrigin = view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    CGFloat maxX = view.frame.origin.x + view.frame.size.width;
    CGFloat maxY = view.frame.origin.y + view.frame.size.height;
    
I've since discovered a few really nice shortcuts defined in the [CGGeometry docs](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CGGeometry/#//apple_ref/c/func/CGRectGetMinX), that have made my life easier and my code much more clean and concise.

    CGFloat xOrigin = CGRectGetMinX(view.frame);
    CGFloat yOrigin = CGRectGetMinY(view.frame);
    CGFloat width = CGRectGetWidth(view.frame);
    CGFloat height = CGRectGetHeight(view.frame);
    CGFloat maxX = CGRectGetMaxX(view.frame);
    CGFloat maxY = CGRectGetMaxY(view.frame);
