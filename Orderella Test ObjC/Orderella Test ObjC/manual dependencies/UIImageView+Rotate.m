//
// Created by Alex Hajdu on 5/27/13.
// Copyright (c) 2013 Mr.Fox and friends. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

/*source: https://gist.github.com/alexhajdu/5658543 */ 
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Rotate.h"

@implementation UIImageView (Rotate)

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount
{

	CABasicAnimation *fullRotation;
	fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	fullRotation.fromValue = [NSNumber numberWithFloat:0];
	fullRotation.toValue = [NSNumber numberWithFloat:((360 * M_PI) / 180)];
	fullRotation.duration = duration;
	if (repeatCount == 0)
		fullRotation.repeatCount = MAXFLOAT;
	else
		fullRotation.repeatCount = repeatCount;

	[self.layer addAnimation:fullRotation forKey:@"360"];
}

- (void)stopAllAnimations
{

	[self.layer removeAllAnimations];
};

- (void)pauseAnimations
{

	[self pauseLayer:self.layer];
}

- (void)resumeAnimations
{

	[self resumeLayer:self.layer];
}

- (void)pauseLayer:(CALayer *)layer
{

	CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
	layer.speed = 0.0;
	layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{

	CFTimeInterval pausedTime = [layer timeOffset];
	layer.speed = 1.0;
	layer.timeOffset = 0.0;
	layer.beginTime = 0.0;
	CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	layer.beginTime = timeSincePause;
}

@end