//
//  AuthorizationViewController.h
//  innotechtest
//
//  Created by Gorf on 8/23/17.
//  Copyright © 2017 Gorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationViewController : UIViewController
{
    __weak IBOutlet UITextField *txtPhoneNumber;
    __weak IBOutlet UITextField *txtCode;
    __weak IBOutlet UIButton *btnGetCode;
    __weak IBOutlet UIButton *btnApply;
    __weak IBOutlet UILabel *lblPhoneHint;
    
}
- (IBAction)btnQuestionClick:(id)sender;
- (IBAction)btnGetCodeClick:(id)sender;
- (IBAction)btnApplyClick:(id)sender;
- (IBAction)btnHideKeyboardClick:(UIButton *)sender;

@end
