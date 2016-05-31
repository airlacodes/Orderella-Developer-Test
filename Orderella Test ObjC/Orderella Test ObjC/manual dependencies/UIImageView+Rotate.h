//
// Created by Alex Hajdu on 5/27/13.
// Copyright (c) 2013 Mr.Fox and friends. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

/*source: https://gist.github.com/alexhajdu/5658543 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImageView (Rotate)
- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount;
- (void)pauseAnimations;
- (void)resumeAnimations;
- (void)stopAllAnimations;
@end