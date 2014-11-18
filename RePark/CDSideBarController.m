//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"

@implementation CDSideBarController
{
    int flag1;
    int flag2;
    int flag3;
    int flag4;
}

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;

#pragma mark - 
#pragma mark Init

- (CDSideBarController*)initWithImages:(NSArray*)images
{
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(0, 0, 50, 50);
    [_menuButton setImage:[UIImage imageNamed:@"parkingicon.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor redColor];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    NSLog(@"images count is: %lu", (unsigned long)images.count);
    
    int index = 0;
    for (UIImage *image in [images copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 60 + (60 * index), 50, 50);
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
    _menuButton.frame = CGRectMake(position.x, position.y, _menuButton.frame.size.width, _menuButton.frame.size.height);
    [view addSubview:_menuButton];
    
    NSLog(@"opend");
    
    //////////////////////////////////////////////////////////////////////
    //**************************** move from here ?! *********************
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
//    [view addGestureRecognizer:singleTap];
    
    
    //////////////////////////////////////////////////////////////////////
    for (UIButton *button in _buttonList)
    {
        [_backgroundMenuView addSubview:button];
    }

    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    //_backgroundMenuView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    _backgroundMenuView.backgroundColor = [UIColor lightGrayColor];
    _backgroundMenuView.alpha = 0.5f;
    [view addSubview:_backgroundMenuView];
}

#pragma mark - 
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    
    NSLog(@"dissmis with selection");
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    NSLog(@"dissmisssssss");

    if (_isOpen)
    {
        _isOpen = !_isOpen;
       [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
        NSLog(@" menu open");
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
        [_backgroundMenuView.superview addGestureRecognizer:singleTap];
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    // button clicked - use in home controller
    //if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        //[self.delegate menuButtonClicked:button.tag];
    
    // dissmis view ...
    //[self dismissMenuWithSelection:button];
    
    
    
    if (button.tag == 0 && flag1 == 0)
    {
        [button setImage:[UIImage imageNamed:@"menuChatOn.png"] forState:UIControlStateNormal];
        flag1 =1;
    }
    else if (button.tag == 0 && flag1 == 1)
    {
        [button setImage:[UIImage imageNamed:@"menuChat.png"] forState:UIControlStateNormal];
        flag1 =0;
    }
    
    
    
    
    else if (button.tag == 1 && flag2 == 0)
    {
        [button setImage:[UIImage imageNamed:@"menuUsersOn.png"] forState:UIControlStateNormal];
        flag2 =1;
    }
    else if (button.tag == 1 && flag2 == 1)
    {
        [button setImage:[UIImage imageNamed:@"menuUsers.png"] forState:UIControlStateNormal];
        flag2 =0;
    }
    
    
    
    
    else if (button.tag == 2 && flag3 == 0)
    {
        [button setImage:[UIImage imageNamed:@"menuMapOn.png"] forState:UIControlStateNormal];
        flag3 =1;
    }
    else if (button.tag == 2 && flag3 == 1)
    {
        [button setImage:[UIImage imageNamed:@"menuMap.png"] forState:UIControlStateNormal];
        flag3 =0;
    }
    
    
    
    
    else if (button.tag == 3 && flag4 == 0)
    {
        [button setImage:[UIImage imageNamed:@"menuCloseOn.png"] forState:UIControlStateNormal];
        flag4 =1;
    }
    else if (button.tag == 3 && flag4 == 1)
    {
        [button setImage:[UIImage imageNamed:@"menuClose.png"] forState:UIControlStateNormal];
        flag4 =0;
    }
    
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    for (UIGestureRecognizer *recognizer in _backgroundMenuView.superview.gestureRecognizers)
    {
        [_backgroundMenuView.superview removeGestureRecognizer:recognizer];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    
    
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _menuButton.alpha = 0.0f;
            _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
