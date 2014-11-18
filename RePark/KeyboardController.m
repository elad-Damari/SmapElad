//
//  KeyboardController.m
//  KeyboardDemo
//
//  Created by Nadav Kershner on 11/10/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "KeyboardController.h"

@implementation KeyboardController

#pragma mark - IBAction methods

- (IBAction)screenTapped:(id)sender{

    [self removeKeyborad:sender];
    
}

#pragma mark - Private methods

- (void)removeKeyborad:(UIView *)view{

    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    for (UIView *subview in subviews) {
        
        //if the view is textFiled or textView - remove keyboard
        if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
            
            [subview resignFirstResponder];
        
            }
        
        //do the same on every view
        [self removeKeyborad:subview];
        
    }

}

@end
