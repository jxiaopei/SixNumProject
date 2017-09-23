//
//  XPBAddPhoneNumViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAddPhoneNumViewController.h"
#import "LCTextFieldCell.h"

#define RegisterTextTag 110

@interface XPBAddPhoneNumViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation XPBAddPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self setFoot];
    [self.view addSubview:self.tableView];
}

- (void)setFoot {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    
    UIButton *addPhoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREENWIDTH - 60, 44)];
    addPhoneBtn.layer.masksToBounds = YES;
    addPhoneBtn.layer.cornerRadius = 22;
    [addPhoneBtn setTitle:@"绑定手机" forState:UIControlStateNormal];
    addPhoneBtn.backgroundColor = GlobalOrangeColor;
    [addPhoneBtn addTarget:self action:@selector(addPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    addPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [foot addSubview:addPhoneBtn];
    
    self.tableView.tableFooterView = foot;
}

-(void)addPhoneAction:(UIButton *)sender{
    
    DTextField *phoneText = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    
    if (![phoneText.text isNotNil]) {
        
        phoneText.promptText = @"请输入您的手机号码";
        return;
    }
    
    NSLog(@"%@",BaseUrl(AddPhoneNum));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AddPhoneNum,
                           @"paramData":@{@"mission_id" :@"13",
                                          @"user_account" : [BPUserModel shareModel].userAccount,
                                          @"user_phone" : phoneText.text,
                                          @"user_id" : [BPUserModel shareModel].uid}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(AddPhoneNum) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"操作失败"];
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
        _dataArr = @[@{@"title":@"手机号",@"image":@"Login_phone"},
                     ];
    }
    return _dataArr;
}

@end
