//
//  KeyboardController.h
//  KeyboardDemo
//
//  Created by Nadav Kershner on 11/10/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ModalController.h"

@interface KeyboardController : ModalController <UITextFieldDelegate, UITextViewDelegate>

- (void)removeKeyborad:(UIView *)view;

@end
