//
//  XPBLoginViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBLoginViewController.h"
#import "XPBRegistViewController.h"
#import "LCTextFieldCell.h"

#define RegisterTextTag 110

@interface XPBLoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation XPBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setFoot];
    [self.view addSubview:self.tableView];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setData];
}

-(void)setData{

    YYCache *cache = [YYCache cacheWithName:CacheKey];
    BPUserModel *userModel = (BPUserModel *)[cache objectForKey:UserID];
    if ([userModel.userName isNotNil])
    {
        DTextField *userText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
        DTextField *pwdText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
        userText.text = userModel.userName;
        NSString *password = userModel.password;
        NSData *data = [[NSData alloc] initWithBase64EncodedString:password options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *passwordStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        pwdText.text =  passwordStr;
        NSLog(@"%@,%@",userModel.userName,passwordStr);

    }
}

- (void)setFoot {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    
    UIButton *LoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, SCREENWIDTH - 30, 44)];
    LoginBtn.layer.masksToBounds = YES;
    LoginBtn.layer.cornerRadius = 5;
    [LoginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    LoginBtn.backgroundColor = GlobalOrangeColor;
    [LoginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:LoginBtn];
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 94, SCREENWIDTH - 30, 44)];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 5;
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registBtn.backgroundColor = GlobalOrangeColor;
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:registBtn];
    
    self.tableView.tableFooterView = foot;
}

- (void)loginAction {
    DTextField *userText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *pwdText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    
    
    if (![userText.text isNotNil]) {
        userText.promptText = @"请输入用户名";
        return;
    }
    else if (![pwdText.text isNotNil]) {
        pwdText.promptText = @"请输入密码";
        return;
    }
    
//    [MBProgressHUD showMessage:@"正在登录" toView:self.view];
    
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
            [MBProgressHUD showSuccess:@"登录成功"];
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
            [cache setObject:userModel forKey:UserID];
            if(self.popVC){
                userModel.isLoginOtherView = YES;
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccessed" object:nil];
        }else{
           [MBProgressHUD showError:@"登录失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"登录失败"];
    }];
 
}

- (void)registAction{
   
    XPBRegistViewController *registVC = [XPBRegistViewController new];
    registVC.popVC =self.popVC;
    [self.navigationController pushViewController:registVC animated:YES];
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
                     @{@"title":@"密码",@"image":@"Login_password"}];
    }
    return _dataArr;
}




@end
