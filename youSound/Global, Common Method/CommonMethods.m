//
//  CommonMethods.m
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

#import "CommonMethods.h"

@interface CommonMethods ()
{
    //initialize values
    int myTextFieldSemaphore;
}

@end

@implementation CommonMethods

+(CommonMethods *) sharedObj
{
    // Static variable of type ServerCalls -- Declaration
    static CommonMethods* objectOfCommonMethods = nil;
    
    // GCD despatch queue -- Alternate would be simple Alloc - Init with IF not nil check
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectOfCommonMethods = [[CommonMethods alloc] init]; // Allocating and initializing object
    });
    
    // Returning singleton object
    return objectOfCommonMethods;
}

#pragma mark - Validations

+ (BOOL) isValidTextFieldData :(NSDictionary *)dicValues
{
    //Check if TextField is Empty
    for (int i = 0; i < dicValues.count; i++)
    {
        NSString *strKey = [[dicValues allKeys] objectAtIndex:i];
        NSString *strValue = [dicValues objectForKey:strKey];
        if (![self isNonEmptyString:strValue])
        {
            NSString *str = @"Please enter all the required values";
            
            if ([strKey isEqualToString:@"vEmail"])
               str = @"Please enter email";
           else if ([strKey isEqualToString:@"vPassword"])
               str = @"Please enter Password";
           else if ([strKey isEqualToString:@"vFirstname"])
               str = @"Please enter Firstname";
         
            
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else{
           if(![self isProperEmail:[dicValues valueForKey:@"vEmail"]])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter proper email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    }
    return YES;
}

+ (BOOL)isNonEmptyString :(NSString *)strstring
{
    return ([[strstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) ? NO : YES;
}

+ (BOOL)isProperEmail:(NSString*)email
{
    NSString *emailRegex    = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - customized Bar Buttons

+ (UIButton *)customizeLeftBarButton :(UIImage *)image
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(8.0, 2.0, image.size.width, image.size.height)];
    [btnLeft setImage:image forState:UIControlStateNormal];
    return btnLeft;
}

+ (UIButton *)customizeLeftBarButtonNewStyle :(UIImage *)image
{
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(8.0, 2.0, image.size.width + 50, image.size.height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [img setImage:image];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5 + image.size.width, 0, 48, image.size.height)];
    lbl.text = @"Back";
    lbl.font = [UIFont systemFontOfSize:17.0f];
    lbl.textColor = [UIColor colorWithRed:122/255.0f green:62/255.0f blue:38/255.0f alpha:1.0f];
    [btnLeft addSubview:img];
    [btnLeft addSubview:lbl];
    
    return btnLeft;
}

+ (UIButton *)customizeRightBarButton :(UIImage *)image withText:(NSString *)str andLength :(int)len andFontSize:(int)size
{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(8.0, 2.0, image.size.width + len, image.size.height)];
    CGImageRef cgref1 = [image CGImage];
    CIImage *cim1 = [image CIImage];
    if(len > 0)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (len - 2), image.size.height)];
        lbl.text = str;
        lbl.font = [UIFont systemFontOfSize:size];
        lbl.textColor = [UIColor colorWithRed:122/255.0f green:62/255.0f blue:38/255.0f alpha:1.0f];
        [btnRight addSubview:lbl];
    }
    if (cim1 == nil && cgref1 == NULL)
        return btnRight;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(len, 0, image.size.width, image.size.height)];
    [img setImage:image];
    
    [btnRight addSubview:img];
    return btnRight;
}

+ (UIButton *)customizeRightBarButtonNewStyle :(UIImage *)image withText:(NSString *)str andLength :(int)len andFontSize:(int)size
{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(8.0, 2.0, image.size.width + len, image.size.height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [img setImage:image];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(image.size.width + 4, 0, len, image.size.height)];
    lbl.text = str;
    lbl.font = [UIFont systemFontOfSize:size];
    lbl.textColor = [UIColor colorWithRed:122/255.0f green:62/255.0f blue:38/255.0f alpha:1.0f];
    [btnRight addSubview:lbl];
    [btnRight addSubview:img];
    return btnRight;
}

#pragma mark - customized view background

+ (UIImage *)setBackgroundImage
{
    UIImage* imgBackground = [UIImage imageNamed:@"background.png"];
    return imgBackground;
}


#pragma mark - check if image is not null

+(BOOL)isImageNotNull : (UIImage *)image
{
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    
    if (cim == nil && cgref == NULL)
        return NO;
    else
        return YES;
}

#pragma mark - customizeSearchBar

+ (void)customizeSearchBar
{
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"iconsearch.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbg.png"] forState:UIControlStateNormal];
}

#pragma mark - prepare post data

+(NSMutableData *)preparePostData :(NSDictionary *)dictData
{
    NSMutableData *reqData = [[NSMutableData alloc] init];
    
    // set Bountry
    NSString *Boundary = [NSString stringWithFormat:@"%@",@"0xKhTmLbOuNdArY"];
    
    // create form data
    for (int i = 0; i < dictData.count; i++)
    {
        //Fetch Key and value
        NSString *strKey = [[dictData allKeys] objectAtIndex:i];
        NSString *strValue = [dictData valueForKey:strKey];
        
        //Set image
        if ([strKey isEqualToString:@"vImage"])
        {
            //image
            [reqData appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [reqData appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"image.png\"\r\n", strKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [reqData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NSData *data1 = UIImagePNGRepresentation([dictData objectForKey:strKey]);
            [reqData appendData:[dictData objectForKey:strKey]];
            [reqData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            //Set object
            [reqData appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [reqData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", strKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [reqData appendData:[[NSString stringWithFormat:@"%@", strValue]  dataUsingEncoding:NSUTF8StringEncoding]];
            [reqData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // close form data
    [reqData appendData:[[NSString stringWithFormat:@"--%@--\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return reqData;
}


#pragma mark - Rotate Image

+ (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
+(void)customPushAnimation : (UINavigationController *)navigationController
{}
+ (void)customizeNavigationbar :(UINavigationBar *)navBar
{}
+ (void)customizeNavigationbarWithLogo :(UINavigationBar *)navBar
{}
+(void)customPopAnimation : (UINavigationController *)navigationController
{}
+(NSString *)convertText:(NSString *)strText fromFormat:(NSString *)strFromformat toFormat:(NSString *)strToFormat
{
    return 0;
}
+(NSDate *)convertToDate:(NSString *)strText fromFormat:(NSString *)strFromformat{
    return 0;
}
+(NSString *)convertDate:(NSDate *)dtText inFormat:(NSString *)strFromformat toTextInFormat:(NSString *)strToFormat{
    return 0;
}
+ (UIImage *)imageWithColor:(UIColor *)color{
    return 0;
}
+(void)animateBtnLR :(UIButton *)btn1 label:(UILabel *)lbl1 BtnRL:(UIButton *)btn2 label:(UILabel *)lbl2{}
+(void)animateButton :(UIButton *)sender{}
@end


