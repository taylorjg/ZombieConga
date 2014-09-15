//
//  MathUtils.h
//  ZombieConga
//
//  Created by Jonathan Taylor on 13/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGPoint CGRectGetMidPoint(const CGRect rect);
extern CGPoint CGSizeGetMidPoint(const CGSize size);
extern CGPoint CGPointAdd(const CGPoint pt1, const CGPoint pt2);
extern CGPoint CGPointSubtract(const CGPoint pt1, const CGPoint pt2);
extern CGPoint CGPointMultiplyScalar(const CGPoint pt, const CGFloat s);
extern CGFloat CGPointLength(const CGPoint pt);
extern CGPoint CGPointNormalise(const CGPoint pt);
extern CGFloat CGPointToAngle(const CGPoint pt);
extern CGPoint CGPointFromSize(const CGSize size);
extern CGFloat ScalarSign(const CGFloat a);
extern CGFloat ScalarSign(const CGFloat a);
extern CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b);
extern CGFloat ScalarRandomRange(const CGFloat min, const CGFloat max);
