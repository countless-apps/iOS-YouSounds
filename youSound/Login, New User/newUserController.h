//
//  newUserController.h
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "TPKeyboardAvoidingScrollView.h"

#define iPhone5ExHeight ((((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f)))?88:0)

@interface newUserController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end
