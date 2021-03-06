//
//  ZZDJShadowCornerView.m
//  qnchuxing_driver
//
//  Created by 李志佳 on 2018/3/14.
//  Copyright © 2018年 校管家. All rights reserved.
//

#import "LShadowCornerView.h"
#import <objc/runtime.h>

typedef struct RGBD {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat d;
}CGRGBD;
CG_INLINE CGRGBD
CGRGBDMake(CGFloat r , CGFloat g , CGFloat b , CGFloat d)
{
    CGRGBD p;
    p.r = r;
    p.g = g;
    p.b = b;
    p.d = d;
    return p;
}

@interface UIColor(RGBD)

- (CGFloat)R;
- (CGFloat)G;
- (CGFloat)B;
- (CGFloat)D;

@end

@implementation UIColor(RGBD)

- (CGRGBD)rgbd
{
    size_t numOfComponents = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *componemts = CGColorGetComponents(self.CGColor);
    if(numOfComponents == 2)
    {
        return CGRGBDMake(componemts[0], componemts[0], componemts[0], componemts[1]);
    }
    if(numOfComponents == 4)
    {
        return CGRGBDMake(componemts[0], componemts[1], componemts[2], componemts[3]);
    }
    return CGRGBDMake(0, 0, 0, 0);
}

- (CGFloat)R
{
    CGRGBD rgbd = [self rgbd];
    return rgbd.r;
}

- (CGFloat)G
{
    CGRGBD rgbd = [self rgbd];
    return rgbd.g;
}

- (CGFloat)B
{
    CGRGBD rgbd = [self rgbd];
    return rgbd.b;
}

- (CGFloat)D
{
    CGRGBD rgbd = [self rgbd];
    return rgbd.d;
}
@end

@interface UIView()
@property(nonatomic,weak)UIView * sc_contentCornerView;
@property(nonatomic,assign)CGFloat sc_cornerRadius;//加这个修护了自定义圆角的bug，好像在外部给contentCornerView设置圆角，就无法显示内容

@end
@implementation UIView (ShadowCorner)

static const char sc_cornerRadiusKey = '\0';
- (void)setSc_cornerRadius:(CGFloat)sc_cornerRadius
{
    objc_setAssociatedObject(self, &sc_cornerRadiusKey, @(sc_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sc_cornerRadius
{
    return [objc_getAssociatedObject(self, &sc_cornerRadiusKey) floatValue];
}

static const char sc_shadowCornerKey = '\0';
- (void)setShadowCorner:(UIViewShadowCorner)shadowCorner
{
    objc_setAssociatedObject(self, &sc_shadowCornerKey, @(shadowCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewShadowCorner)shadowCorner
{
    return [objc_getAssociatedObject(self, &sc_shadowCornerKey) integerValue];
}

static const char sc_contentCornerViewKey = '\0';
- (void)setSc_contentCornerView:(UIView *)sc_contentCornerView
{
    objc_setAssociatedObject(self, &sc_contentCornerViewKey, sc_contentCornerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sc_contentCornerView
{
    return objc_getAssociatedObject(self, &sc_contentCornerViewKey);
}

- (void)sc_setShadowCorner
{
    UIViewShadowCorner shadowCorner = self.sc_contentCornerView.shadowCorner;
    if(shadowCorner > 0)
    {
        UIRectCorner rectCorner = 0;
        UIBezierPath * shadowPath = [UIBezierPath bezierPath];
        CGFloat vWidth = self.bounds.size.width;
        CGFloat vHeight = self.bounds.size.height;
        CGFloat shadowRadius = self.layer.shadowRadius * 2;
        
        CGPoint topLeftPoint = CGPointMake(shadowRadius, shadowRadius);
        CGPoint topRigthPoint = CGPointMake(vWidth -shadowRadius, +shadowRadius);
        CGPoint bottomRightPoint = CGPointMake(vWidth -shadowRadius, vHeight -shadowRadius);
        CGPoint bottomLeftPoint = CGPointMake(+shadowRadius, +shadowRadius);
        
        if(shadowCorner&ShadowTop)
        {
            topLeftPoint.y = 0;
            topRigthPoint.y = 0;
        }
        if(shadowCorner&ShadowRight)
        {
            topRigthPoint.x = vWidth;
            bottomRightPoint.x = vWidth;
        }
        if(shadowCorner&ShadowBottom)
        {
            bottomRightPoint.y = vHeight;
            bottomLeftPoint.y = vHeight;
        }
        if(shadowCorner&ShadowLeft)
        {
            bottomLeftPoint.x = 0;
            topLeftPoint.x = 0;
        }
        if(shadowCorner&CornerTopLeft)
        {
            rectCorner = rectCorner|UIRectCornerTopLeft;
        }
        if(shadowCorner&CornerTopRight)
        {
            rectCorner = rectCorner|UIRectCornerTopRight;
        }
        if(shadowCorner&CornerBottomRight)
        {
            rectCorner = rectCorner|UIRectCornerBottomRight;
        }
        if(shadowCorner&CornerBottomLeft)
        {
            rectCorner = rectCorner|UIRectCornerBottomLeft;
        }
        if(rectCorner > 0)
        {
            if(self.sc_cornerRadius == 0)
            {
                if(shadowCorner&CornerType2)
                {
                    self.sc_cornerRadius = 2.0;
                }
                if(shadowCorner&CornerType4)
                {
                    self.sc_cornerRadius = 4.0;
                }
                if(shadowCorner&CornerType6)
                {
                    self.sc_cornerRadius = 6.0;
                }
                if(shadowCorner&CornerType8)
                {
                    self.sc_cornerRadius = 8.0;
                }
                if(shadowCorner&CornerType10)
                {
                    self.sc_cornerRadius = 10.0;
                }
            }
            if(self.sc_cornerRadius > 0)
            {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sc_contentCornerView.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.sc_cornerRadius, self.sc_cornerRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = self.sc_contentCornerView.bounds;
                maskLayer.path = maskPath.CGPath;
                self.sc_contentCornerView.layer.mask = maskLayer;
                ((CAShapeLayer *)self.layer).path = maskPath.CGPath;
            }
        }
        [shadowPath moveToPoint:topLeftPoint];
        //添加直线
        [shadowPath addLineToPoint:topRigthPoint];
        [shadowPath addLineToPoint:bottomRightPoint];
        [shadowPath addLineToPoint:bottomLeftPoint];
        [shadowPath addLineToPoint:topLeftPoint];
        self.layer.shadowPath = shadowPath.CGPath;
    }
}
@end

@interface LShadowCornerView()
@end
@implementation LShadowCornerView

+ (UIView *) viewWithContentView:(UIView *)contentView
{
    if(contentView.hidden || contentView.alpha < 0.01 || (contentView.backgroundColor && contentView.backgroundColor.D < 0.01))
        return contentView;
    contentView.layer.masksToBounds = YES;
    contentView.clipsToBounds = YES;
    LShadowCornerView * shadowView = [[self alloc] init];
    shadowView.sc_cornerRadius = contentView.layer.cornerRadius;
    contentView.layer.cornerRadius = 0;
    [shadowView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    shadowView.sc_contentCornerView = contentView;
    shadowView.backgroundColor = RGBACOLOR(255, 255, 255, 1.0);
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    if(contentView.layer.shadowOpacity > 0)
    {
        shadowView.layer.shadowColor = contentView.layer.shadowColor;
        shadowView.layer.shadowOpacity = contentView.layer.shadowOpacity;
        shadowView.layer.shadowRadius = contentView.layer.shadowRadius;
    }
    else
    {
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowOpacity = 0.2;
        shadowView.layer.shadowRadius = 5.0;
    }
    return shadowView;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)init
{
    if(self = [super init])
    {
        ((CAShapeLayer *)self.layer).fillColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    ((CAShapeLayer *)self.layer).fillColor = backgroundColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.sc_contentCornerView)
        [self sc_setShadowCorner];
}
//-(void)mj_setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor AndBorderWidth:(CGFloat)borderWidth{
//    
//    CGSize viewSize = self.frame.size;
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = borderColor.CGColor;
//    shapeLayer.lineWidth = borderWidth;
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height) cornerRadius:radius];
//    shapeLayer.path = path.CGPath;
//    maskLayer.path = path.CGPath;
//    
//    [self.layer insertSublayer:shapeLayer atIndex:0];
//    [self.layer setMask:maskLayer];
//}
@end

