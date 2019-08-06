//
//  GameViewController.h
//  cengine-ios
//
//  Created by Harry Lundstrom on 23/07/15.
//  Copyright (c) 2015 Palestone Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface RTBViewController : GLKViewController <UIAlertViewDelegate>

+ (RTBViewController *)sharedInstance;

@end
