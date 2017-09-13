//
//  XPBRegistViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBRegistViewController.h"
#import "LCTextFieldCell.h"

#define RegisterTextTag 110

@interface XPBRegistViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation XPBRegistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setFoot];
    [self.view addSubview:self.tableView];
    
}

- (void)setFoot {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, SCREENWIDTH - 30, 44)];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 5;
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registBtn.backgroundColor = GlobalOrangeColor;
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:registBtn];
    self.tableView.tableFooterView = foot;
}

- (void)registAction {
    DTextField *userText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *nickText  = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    DTextField *phoneText = (DTextField *)[self.view viewWithTag:RegisterTextTag + 2];
    DTextField *pwdText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 3];
    DTextField *verText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 4];
    
    if (![userText.text isNotNil]) {
        userText.promptText = @"请输入用户名";
        return;
    }
    else if (![phoneText.text isNotNil]) {

        phoneText.text = @"";
    }
    else if (![pwdText.text isNotNil]) {
        pwdText.promptText = @"请输入密码";
        return;
    }else if (![verText.text isNotNil]) {
        verText.promptText = @"请确认密码";
        return;
    }else if (![nickText.text isNotNil]) {
 
        nickText.text = @"";
    }else if (verText.text.length < 6) {
        verText.promptText = @"密码长度不得少于六位";
        return;
    }
    
    if (![pwdText.text isEqualToString:verText.text]) {
        verText.promptText = @"密码不一致";
        return;
    }
    
//    [MBProgressHUD showMessage:@"正在注册" toView:self.view];
    
    NSLog(@"%@",BaseUrl(UserRegist));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":UserRegist,
                           @"paramData":@{@"name":nickText.text,
                                       @"user_name":userText.text,
                                       @"user_cipher":pwdText.text,
                                       @"user_phone":phoneText.text
                                       }
                           };

    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(UserRegist) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"注册成功"];
            //注册成功直接登录
            NSLog(@"%@",BaseUrl(UserLogin));
            NSDictionary *loginDict = @{
                                        @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                        @"uri":UserLogin,
                                        @"paramData":@{@"user_name":userText.text,
                                                       @"user_cipher":pwdText.text
                                                       }
                                        };
            
            [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(UserLogin) parameters:loginDict success:^(id responseObject) {
            
                if([responseObject[@"code"] isEqualToString:@"0000"])
                {
                    
                    BPUserModel *userModel = [BPUserModel shareModel];
                    userModel.userName = responseObject[@"data"][@"user_name"];;
                    userModel.userAccount = responseObject[@"data"][@"user_account"];
                    userModel.phoneNumber = responseObject[@"data"][@"user_phone"];
                    userModel.currentToken = responseObject[@"data"][@"token"];
                    userModel.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_id"]];
                    userModel.isLogin = YES;
                    NSData *data = [pwdText.text dataUsingEncoding:NSUTF8StringEncoding];
                    NSString *baseString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    userModel.password = baseString;
                    YYCache *cache = [YYCache cacheWithName:CacheKey];
                    [cache setObject:userModel forKey:userModel.uid];
                    if(self.popVC)
                    {
                        userModel.isLoginOtherView = YES;
                        [self.navigationController popToViewController:self.popVC animated:YES];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccessed" object:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } fail:^(NSError *error) {
              [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if([responseObject[@"code"] isEqualToString:@"230002"]){
            [MBProgressHUD showError:@"该用户已经存在,请直接登录"];
        }else{
            [MBProgressHUD showError:@"注册失败"];
        }
        
    } fail:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view];
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCTextFieldCell"];
    cell.textField.tag = RegisterTextTag + indexPath.row;
    cell.textField.delegate = self;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = GlobalLightGreyColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[LCTextFieldCell class] forCellReuseIdentifier:@"LCTextFieldCell"];
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"用户名",@"image":@"Login_account"},
                     @{@"title":@"昵称(选填)",@"image":@"Login_account"},
                     @{@"title":@"手机号(选填)",@"image":@"Login_account"},
                     @{@"title":@"密码",@"image":@"Login_password"},
                     @{@"title":@"确认密码",@"image":@"Login_password"}];
    }
    return _dataArr;
}

@end
