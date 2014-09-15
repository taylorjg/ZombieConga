//
//  MathUtils.m
//  ZombieConga
//
//  Created by Jonathan Taylor on 13/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import "MathUtils.h"

CGPoint CGRectGetMidPoint(const CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect),
                       CGRectGetMidY(rect));
}

CGPoint CGSizeGetMidPoint(const CGSize size)
{
    return CGPointMake(size.width / 2,
                       size.height / 2);
}

CGPoint CGPointAdd(const CGPoint pt1, const CGPoint pt2)
{
    return CGPointMake(pt1.x + pt2.x,
                       pt1.y + pt2.y);
}

CGPoint CGPointSubtract(const CGPoint pt1, const CGPoint pt2)
{
    return CGPointMake(pt1.x - pt2.x,
                       pt1.y - pt2.y);
}

CGPoint CGPointMultiplyScalar(const CGPoint pt, const CGFloat s)
{
    return CGPointMake(pt.x * s,
                       pt.y * s);
}

CGFloat CGPointLength(const CGPoint pt)
{
    return sqrtf(pt.x * pt.x + pt.y * pt.y);
}

CGPoint CGPointNormalise(const CGPoint pt)
{
    CGFloat length = CGPointLength(pt);
    
    return CGPointMake(pt.x / length,
                       pt.y / length);
}

CGFloat CGPointToAngle(const CGPoint pt)
{
    return atan2f(pt.y, pt.x);
}

CGPoint CGPointFromSize(const CGSize size)
{
    return CGPointMake(size.width, size.height);
}

CGFloat ScalarSign(const CGFloat a)
{
    return a >= 0 ? 1 : -1;
}

CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b)
{
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    else {
        if (angle <= -M_PI) {
            angle += M_PI * 2;
        }
    }
    
    return angle;
}

CGFloat ScalarRandomRange(const CGFloat min, const CGFloat max)
{
    return floorf(((double)arc4random() / 0x100000000) * (max - min) + min);
}
