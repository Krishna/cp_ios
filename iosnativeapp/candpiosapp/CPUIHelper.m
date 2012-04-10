//
//  CPUIHelper.m
//  candpiosapp
//
//  Created by Stephen Birarda on 2/17/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "CPUIHelper.h"
#define navbarShadowTag 991

#define M_PI   3.14159265358979323846264338327950288
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation CPUIHelper

#pragma mark - UI Elements

+(void)addShadowToView:(UIView *)view
                 color:(UIColor *)color
                offset:(CGSize)offset
                radius:(double)radius
               opacity:(double)opacity
{
    view.layer.shadowColor = [color CGColor];
    view.layer.shadowOffset = offset;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = opacity;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

// apparently it is a bad idea to subclass UIButton
// this method will give you a UIButton with C&P styling

// NOTE: frame.size.height will always be overriden to be 43pts 
// as the height cannot be resized because it will muck with the 
// gradient. Grayson has said that CPButtons he designs will always
// be of that height
+ (UIButton *)CPButtonWithText:(NSString *)buttonText color:(CPButtonColor)buttonColor frame:(CGRect)buttonFrame
{
    // get a button with the passed frame
    UIButton *cpButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    [cpButton setTitle:buttonText forState:UIControlStateNormal];
    
    return [self makeButtonCPButton:cpButton withCPButtonColor:buttonColor];
}

// method to turn an existing button into a CPButton with a particular color
// note that this changes the button height to be 43pts as the image we're using
// for the background forces the button to be of this height
// CPButtons designed by Grayson will always be of this height
+ (UIButton *)makeButtonCPButton:(UIButton *)button withCPButtonColor:(CPButtonColor)buttonColor
{
    // forcing change of button height to 43pts
    CGRect buttonFrame = button.frame;
    buttonFrame.size.height = 43;
    button.frame = buttonFrame;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // set the background color using the imageForColorString method
    [button setBackgroundImage:[self imageForCPColor:buttonColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.titleLabel.layer.shadowOpacity = 0.5;
    button.titleLabel.layer.shadowRadius = 0.0; 
    
    return button;
}

// used by the method above to return a UIImage for the button background
+ (UIImage *)imageForCPColor:(CPButtonColor)buttonColor
{
    switch (buttonColor) {
        case CPButtonTurquoise:
            return [[UIImage imageNamed:@"button-turquoise.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
        case CPButtonGrey:
            return [[UIImage imageNamed:@"button-grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
        default:
            return nil;
    }
}

#pragma mark - Color schemes

+ (UIColor *)colorForCPColor:(CPColor)cpColor
{
    switch (cpColor) {
        case CPColorGreen:
            return [UIColor colorWithRed:0.259f green:0.549f blue:0.588f alpha:1.0f];
        case CPColorGrey:
            return [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.0f];
        default:
            return nil;
    }
}

# pragma mark - League Gothic Helper

+ (void)changeFontForLabel:(UILabel *)label toLeagueGothicOfSize:(CGFloat)size
{
    UIFont *gothic = [UIFont fontWithName:@"LeagueGothic" size:size];
    label.font = gothic;
}

+ (void)changeFontForTextField:(UITextField *)textField toLeagueGothicOfSize:(CGFloat)size
{
    UIFont *gothic = [UIFont fontWithName:@"LeagueGothic" size:size];
    textField.font = gothic;
}

#pragma mark - UIImage rotate

+ (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

#pragma mark - 360 Rotation

// note the the above method couldn't be used for this because it does nothing if the angle
// you give it is 360 degrees

+ (void)spinView:(UIView *)view 
        duration:(NSTimeInterval)duration 
     repeatCount:(float)repeatCount 
       clockwise:(BOOL)clockwise
  timingFunction:(CAMediaTimingFunction *)timingFunction
{
    CABasicAnimation *rotate360;
    rotate360 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate360.fromValue = [NSNumber numberWithFloat:0];
    
    CGFloat endVal = (360*M_PI)/180;
    if (!clockwise) {
        endVal = -1 * endVal;
    }
    
    rotate360.toValue = [NSNumber numberWithFloat:endVal];
    rotate360.duration = duration;
    rotate360.cumulative = YES;
    rotate360.timingFunction = timingFunction;
    rotate360.repeatCount = repeatCount;
    
    
    [view.layer addAnimation:rotate360 forKey:@"360"];
}     

#pragma mark - App-wide images

// returns a UIImage with our default profile pic
// might need to be changed a to larger version if used somewhere that frame is larger than 256x256
+ (UIImage *)defaultProfileImage
{
    return [UIImage imageNamed:@"default-avatar-256"];
}


@end
