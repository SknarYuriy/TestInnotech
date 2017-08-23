//
//  AuthorizationViewController.m
//  innotechtest
//
//  Created by Gorf on 8/23/17.
//  Copyright © 2017 Gorf. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "AFHTTPSessionManager.h"
#import "WebViewController.h"

@interface AuthorizationViewController () <UITextFieldDelegate>

@end

@implementation AuthorizationViewController
{
    int digitsCount;
}

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    [btnGetCode setEnabled:FALSE];
    [btnApply setEnabled:FALSE];
    [txtPhoneNumber setDelegate:self];
    [txtCode setDelegate:self];
    [txtCode setEnabled:FALSE];
    digitsCount = 13;
}


#pragma mark - UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtPhoneNumber)
    {
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([resultString stringByReplacingOccurrencesOfString:@" " withString:@""].length == digitsCount)
            [btnGetCode setEnabled:TRUE];
        else
            [btnGetCode setEnabled:FALSE];
    }
    if (textField == txtCode)
    {
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([resultString stringByReplacingOccurrencesOfString:@" " withString:@""].length == 4)
            [btnApply setEnabled:TRUE];
        else
            [btnApply setEnabled:FALSE];
    }
    
    return TRUE;
}


#pragma mark - Action Methods

- (IBAction)btnQuestionClick:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NULL
                                  message:NULL
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ukr = [UIAlertAction
                          actionWithTitle:@"Украина +38"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [txtPhoneNumber setText:@"+38"];
                              [lblPhoneHint setText:@"+38 0XX XXX XXXX"];
                              digitsCount = 13;
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }];

    UIAlertAction *rus = [UIAlertAction
                          actionWithTitle:@"Россия +7"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [txtPhoneNumber setText:@"+7"];
                              [lblPhoneHint setText:@"+7 XXX XXX XXXX"];
                              digitsCount = 12;
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }];

    UIAlertAction *usa = [UIAlertAction
                          actionWithTitle:@"США +1"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [txtPhoneNumber setText:@"+1"];
                              [lblPhoneHint setText:@"+1XXX XXX XXXX"];
                              digitsCount = 11;
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }];
    
    [alert addAction:ukr];
    [alert addAction:rus];
    [alert addAction:usa];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnGetCodeClick:(id)sender
{
    [self hideKeyboard];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NULL
                                  message:@"Сейчас система отправит на Ваш телефон смс-сообщение с кодом для авторизации"
                                  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *params = @{@"data": [txtPhoneNumber.text  stringByReplacingOccurrencesOfString:@" " withString:@""]};
        [manager POST:@"http://s3.logist.ua/testdata/data.php" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Ответ сервера"
                                          message:responseString
                                          preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [txtCode becomeFirstResponder];
                [txtCode setEnabled:TRUE];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Ошибка"
                                          message:error.localizedDescription
                                          preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnApplyClick:(id)sender
{
    [self hideKeyboard];
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:TRUE];
}

- (IBAction)btnHideKeyboardClick:(UIButton *)sender
{
    [self hideKeyboard];
}

#pragma mark - Other Methods
- (void)hideKeyboard
{
    [self.view endEditing:TRUE];
}
@end
