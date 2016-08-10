//
//  KeyBoardScrollView.m
//  KeyBoardTesting
//
//  Created by Ashiwani on 11/24/14.
//  Copyright (c) 2014 Chromeinfotech. All rights reserved.
//

#import "KeyBoardScrollView.h"
static  UIEdgeInsets inset;

static const CGFloat kCalculatedContentPadding = 0;

@implementation KeyBoardScrollView
{
    UIEdgeInsets _initialInset;
}

#pragma mark - Setup/Teardown

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _initialInset = self.contentInset;
    
   self.contentSize = [self calculatedContentSizeFromSubviewFrames];
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

//set the content size of scroll view
- (void)contentSizeToFit {
    self.contentSize = [self calculatedContentSizeFromSubviewFrames];
}

/*
 Description:for keyboard down touch any where in scroll view
 Return-type:
 Argument:
 */
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self KeyboardAvoidingFindFirstResponder:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

/*
 Description:keyboard will show
 Return-type:
 Argument:
 */
- (void)keyboardWillShow:(NSNotification*)notification {
    
    inset = self.contentInset;
    UIView *firstResponder = [self KeyboardAvoidingFindFirstResponder:self];
    
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    UIEdgeInsets newInset = self.contentInset;
    newInset.bottom = keyboardRect.size.height - MAX((CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds)), 0) + 15;
    self.contentInset = newInset;

//    if ( [firstResponder isKindOfClass:[UITextView class]]) {
    //in case of textview go to more up give appropriate height example firstResponder.bounds.size.height = 50
    CGRect  fieldRect = [firstResponder convertRect:CGRectMake(0, 0, firstResponder.bounds.size.width,firstResponder.bounds.size.height) toView:self];
        [self scrollRectToVisible:fieldRect animated:NO];
//    }
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    UIEdgeInsets contentInsets = _initialInset;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

- (UIView*)KeyboardAvoidingFindFirstResponder:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self KeyboardAvoidingFindFirstResponder:childView];
        if ( result ) return result;
    }
    return nil;
}

-(CGSize)calculatedContentSizeFromSubviewFrames {
    
    BOOL wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    BOOL wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    CGRect rect = CGRectZero;
    for ( UIView *view in self.subviews ) {
        rect = CGRectUnion(rect, view.frame);
    }
   rect.size.height += kCalculatedContentPadding;
    
    self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator;
      return rect.size;
}

@end
