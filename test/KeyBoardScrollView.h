//
//  KeyBoardScrollView.h
//  KeyBoardTesting
//
//  Created by Ashiwani on 11/24/14.
//  Copyright (c) 2014 Chromeinfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBoardScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>

//used to set the content size set call in view didload only
-(void)contentSizeToFit;

@end