//
//  CPCheckedLabel.h
//  candpiosapp
//
//  Created by Stojce Slavkovski on 12/23/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCheckedLabel : UILabel <UIGestureRecognizerDelegate>
@property(nonatomic) BOOL checked;
+(void)setGroup:(NSArray *)group;
@end
