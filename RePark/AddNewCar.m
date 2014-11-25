//
//  AddNewCar.m
//  RePark
//
//  Created by Elad Damari on 11/20/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "AddNewCar.h"
#import "AFNetworking.h"
#import "PXAlertView+Customization.h"
#import "UIViewController+MJPopupViewController.h"

@interface AddNewCar ()

{
    
    AppDelegate     *appDelegate;
    
    UIPickerView    *carPropsPicker;
    
    NSString        *chosenProperty;
    
    bool            isDefault;
    
    int flag, mainCounter, typeCounter, colorCounter, sizeCounter;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UITextField *addCarNumberField;

@property (weak, nonatomic) IBOutlet       UILabel *chooseCarTypeLabel;

@property (weak, nonatomic) IBOutlet       UILabel *chooseCarColorLabel;

@property (weak, nonatomic) IBOutlet       UILabel *chooseCarSizeLabel;

@property (weak, nonatomic) IBOutlet       UILabel *isDefaultLabel;



@property (strong, nonatomic) IBOutlet    UIButton *addCarImageLabel;

@property (strong, nonatomic) IBOutlet    UIButton *chooseFromPickerLabel;


@property (strong, nonatomic)              NSArray *carColors;

@property (strong, nonatomic)              NSArray *carTypes;

@property (strong, nonatomic)              NSArray *carSizes;

@property (strong, nonatomic)             NSString *carNumber;;


- (IBAction)chooseCarColorButton:(id)sender;

- (IBAction)chooseCarTypeButton:(id)sender;

- (IBAction)chooseCaeSizeButton:(id)sender;

- (IBAction)addCarImageButton:(id)sender;

- (IBAction)useAsDefaultButton:(id)sender;

- (IBAction)cancelButton:(id)sender;

- (IBAction)okButton:(id)sender;

- (IBAction)chooseFromPickerButton:(id)sender;



@end



@implementation AddNewCar

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self initializeWindowObjects];
    
    [self setViewsOnScreen];
    
    
   
}


- (IBAction)chooseCarTypeButton:(id)sender

{
    
    chosenProperty = @"";
    
    flag = 1;
    
    [carPropsPicker reloadAllComponents];
    
    [self.view addSubview:carPropsPicker];
    
    _chooseFromPickerLabel.hidden = NO;
    
    _addCarImageLabel.hidden = YES;
    
    
}


- (IBAction)chooseCarColorButton:(id)sender

{
    
    chosenProperty = @"";
    
    flag = 2;
    
    [carPropsPicker reloadAllComponents];
    
    [self.view addSubview:carPropsPicker];
    
    _chooseFromPickerLabel.hidden = NO;
    
    _addCarImageLabel.hidden = YES;
    
}



- (IBAction)chooseCaeSizeButton:(id)sender

{
    
    chosenProperty = @"";
    
    flag = 3;
    
    [carPropsPicker reloadAllComponents];
    
    [self.view addSubview:carPropsPicker];
    
    _chooseFromPickerLabel.hidden = NO;
    
    _addCarImageLabel.hidden = YES;
    
}

- (IBAction)addCarImageButton:(id)sender

{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"שים לב !"
                                                 message:@"האם תרצלה לצלם תמונה חדשה? \n או לבחור מתוך אלבום התמונות שלך?"
                                             cancelTitle:@"צלם תמונה חדשה"
                                             otherTitles:@[@"בחר מתוך האלבום"]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      [self takePhoto];
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      [self selectPhoto];
                                                  }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
    
}

- (IBAction)useAsDefaultButton:(id)sender

{
    
    NSLog(@"\n make car as default ... ");
    
    if (isDefault)
    {
         _isDefaultLabel.text = @"";
    }
    else
    {
         _isDefaultLabel.text = @"V";
    }

    
}

- (IBAction)cancelButton:(id)sender

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}




- (IBAction)okButton:(id)sender

{
    if ([self checkParametrs])
    {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:[NSString stringWithFormat:@"%@",
                               [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]]
                       forKey:kAccessToken];
        
        [parameters setObject:kAddCar forKey:kService];
        
        [parameters setObject:_carNumber forKey:kCarNumber];
        
        [parameters setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.dataBase objectForKey:kCarTypeID] indexOfObject:_chooseCarTypeLabel.text]]
                       forKey:@"typeID"];
        
        [parameters setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.dataBase objectForKey:kCarColorID] indexOfObject:_chooseCarColorLabel.text]]
                       forKey:@"colorID"];
        
        [parameters setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.dataBase objectForKey:kSizeID] indexOfObject:_chooseCarSizeLabel.text]]
                       forKey:@"sizeID"];
        
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);
        
        NSLog(@" parameters: %@", parameters.descriptionInStringsFileFormat);
        
        
        
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                                  initWithBaseURL:[NSURL URLWithString:kServerAdrress]];
        
        AFHTTPRequestOperation *op =[manager POST:@""
                                       parameters:parameters
                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         //do not put image inside parameters dictionary as I did, but append it!
                                         [formData appendPartWithFileData:imageData
                                                                     name:@"carImage"
                                                                 fileName:@"photo.jpg"
                                                                 mimeType:@"image/jpeg"];
                                     }
                                     
                                          success:^(AFHTTPRequestOperation *operation, id responseObject)
                                     {
                                         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                         
                                         PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                                                     message:@"רכבך יתווסף מיד לרשימת הרכבים שלך."
                                                                                 cancelTitle:@"אישור"
                                                                                  completion:^(BOOL cancelled, NSInteger buttonIndex)
                                                              {
                                                                  
                                                              }];
                                         [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
                                         
                                         
                                         [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                     }
                                     
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                     {
                                         NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                         
                                         PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                                                     message:@"אירעה שגיאה במהלך ניסיון הוספת הרכב. אנא נסה שוב מאוחר יותר."
                                                                                 cancelTitle:@"אישור"
                                                                                  completion:^(BOOL cancelled, NSInteger buttonIndex)
                                                              {
                                                                  
                                                              }];
                                         [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
                                         
                                         
                                     }];
        
        [op start];
    }

    
    
}


- (BOOL) checkParametrs
{
    
    mainCounter = typeCounter + colorCounter + sizeCounter;
    
    if (mainCounter < 3 || [_addCarNumberField.text isEqualToString:@""])
    {
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"אירעה שגיאה"
                                                    message:@"אנא הזן את כל הפרטים הנחוצים להוספת רכב. "
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
                             {
                                 
                             }];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

    }
    else if (mainCounter >=3)
    {
        return YES;
    }

    return NO;
}


- (IBAction)chooseFromPickerButton:(id)sender

{
    
    if (flag == 1)
        
    {
        if ([chosenProperty isEqualToString:@""] || chosenProperty == nil)
        {
            _chooseCarTypeLabel.text = @"יצרן";
            
            typeCounter = 0;
        }
        else
        {
            _chooseCarTypeLabel.text = chosenProperty;
            
            typeCounter = 1;
        }

    }
    
    else if (flag == 2)
        
    {
        
        if ([chosenProperty isEqualToString:@""] || chosenProperty == nil)
        {
            _chooseCarColorLabel.text = @"צבע";
            
            colorCounter = 0;
        }
        else
        {
            _chooseCarColorLabel.text = chosenProperty;
            
            colorCounter = 1;
        }
        
    }
    
    else if (flag == 3)
        
    {
        
        if ([chosenProperty isEqualToString:@""] || chosenProperty == nil)
        {
            _chooseCarSizeLabel.text = @"גודל";
            
            sizeCounter = 0;
        }
        else
        {
            _chooseCarSizeLabel.text = chosenProperty;
            
            sizeCounter = 1;
        }
        
    }
    
    
    _addCarImageLabel.hidden = NO;
    
    _chooseFromPickerLabel.hidden = YES;
    
    [carPropsPicker removeFromSuperview];

}


#pragma mark - Handle Field Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.view endEditing:YES];
    
}


- (IBAction)hideMyKeyboard:(id)sender

{

    // close keyboard...
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    if ([nf numberFromString:textField.text] && textField.text.length == 7)
    {
        _carNumber = textField.text;
        
        NSString *I   = [textField.text substringWithRange:NSMakeRange(0,2)];
        NSString *II  = [textField.text substringWithRange:NSMakeRange(2,3)];
        NSString *III = [textField.text substringWithRange:NSMakeRange(5,2)];
        
        textField.text = [NSString stringWithFormat:@"%@-%@-%@", I, II, III];
    }
    
    else
    {
        
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"אירעה שגיאה !"
                                                    message:@"אנא הזן מספר רכב תקין."
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
        {
                                                 
            textField.text = @"";
        
        }];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

    }
   

}

#pragma mark - UI Picker View Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (flag == 1)
    {
        return [_carTypes  count];
    }
    else if (flag == 2)
    {
        return [_carColors count];

    }
    else if (flag == 3)
    {
        return [_carSizes  count];
        
    }
    
    return 1;
}

#pragma mark - UI Picker View Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title;
    
    if (flag == 1)
    {
        title = [_carTypes  objectAtIndex:row];
        return title;
    }
    else if (flag == 2)
    {
        title = [_carColors objectAtIndex:row];
        return title;
    }
    else if (flag == 3)
    {
        title = [_carSizes  objectAtIndex:row];
        return title;
    }
    
    return nil;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (flag == 1)
    {
        chosenProperty = [_carTypes  objectAtIndex:row];
    }
    else if (flag == 2)
    {
        chosenProperty = [_carColors objectAtIndex:row];
    }
    else if (flag == 3)
    {
        chosenProperty = [_carSizes  objectAtIndex:row];
    }
}


- (void) initializeWindowObjects

{
    
    if (_dictionary)
    {
        
        typeCounter  = [[_dictionary objectForKey:@"typeCounter"]  intValue];
        
        colorCounter = [[_dictionary objectForKey:@"colorCounter"] intValue];
        
        sizeCounter  = [[_dictionary objectForKey:@"sizeCounter"]  intValue];
        
    }
    
    appDelegate    = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _carColors     = [[NSArray alloc] initWithArray:[appDelegate.dataBase objectForKey:kCarColorID]];
    
    _carTypes      = [[NSArray alloc] initWithArray:[appDelegate.dataBase objectForKey:kCarTypeID]];
    
    _carSizes      = [[NSArray alloc] initWithArray:[appDelegate.dataBase objectForKey:kSizeID]];
    
    _carNumber      = [[NSString alloc] init];
    
    
    carPropsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 135, 240, 160)];
    
    carPropsPicker.delegate = self;

    isDefault = NO;
    
    mainCounter = 0;
    
    flag = 0;


}


- (void) setViewsOnScreen

{
    
    if (_dictionary)
        
    {
         _carNumber    = [_dictionary objectForKey:kCarNumber];
        
        if (_carNumber.length == 7)
        {
            NSString *I   = [_carNumber substringWithRange:NSMakeRange(0,2)];
            NSString *II  = [_carNumber substringWithRange:NSMakeRange(2,3)];
            NSString *III = [_carNumber substringWithRange:NSMakeRange(5,2)];
            _addCarNumberField.text   = [NSString stringWithFormat:@"%@-%@-%@", I, II, III];
        }
        
        else
        {
            _addCarNumberField.text   = @"";
        }
        
        _chooseCarTypeLabel.text  = [_dictionary objectForKey:kCarTypeID];
        
        _chooseCarColorLabel.text = [_dictionary objectForKey:kCarColorID];
        
        _chooseCarSizeLabel.text  = [_dictionary objectForKey:kSizeID];
        
        _imageView.image =          [_dictionary objectForKey:@"image"];
    }
    
    carPropsPicker.backgroundColor = [UIColor whiteColor];
    
    _chooseFromPickerLabel.hidden = YES;
    
    
}




#pragma mark - open camera roll Methods

- (void)takePhoto
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void) selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:_carNumber                forKey:kCarNumber];
    [dic setObject:_chooseCarTypeLabel.text  forKey:kCarTypeID];
    [dic setObject:_chooseCarColorLabel.text forKey:kCarColorID];
    [dic setObject:_chooseCarSizeLabel.text  forKey:kSizeID];
    
    [dic setObject:[NSString stringWithFormat:@"%d", typeCounter]  forKey:@"typeCounter"];
    [dic setObject:[NSString stringWithFormat:@"%d", colorCounter] forKey:@"colorCounter"];
    [dic setObject:[NSString stringWithFormat:@"%d", sizeCounter]  forKey:@"sizeCounter"];
    
    [dic setObject:selectedImage             forKey:@"image"];
    
    [self.delegate popUp:self withData:dic];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}






@end
