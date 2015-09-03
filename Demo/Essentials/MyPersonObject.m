//
//  MyCustomObject.m
//  Essentials
//
//  Created by Mike on 9/2/15.
//  Copyright © 2015 Mike Amaral. All rights reserved.
//

#import "MyPersonObject.h"

@implementation MyPersonObject

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"name: %@, favorite color: %@, age: %ld", self.name, self.favoriteColor, (long)self.age];
}

@end
