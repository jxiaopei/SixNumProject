//
//  XPBAttributeReferenceColorCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAttributeReferenceColorCell.h"
#import "XPBAttributeReferenceCell.h"

@interface XPBAttributeReferenceColorCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation XPBAttributeReferenceColorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(10);
        }];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat margant = (SCREENWIDTH - 25 *10 -10)/9;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = margant;
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 30, SCREENWIDTH - 10, 65) collectionViewLayout:layout];
        _collectionView = collectView;
        [self addSubview:collectView];
        collectView.delegate = self;
        collectView.dataSource = self;
        [collectView registerClass:[XPBAttributeReferenceCell class] forCellWithReuseIdentifier:@"attributeReferenceCell"];
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(void)setDataSource:(NSMutableArray <XPBReferenceBallModel *>*)dataSource
{
    _dataSource = dataSource;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
    }];
    _nameLabel.text = _nameStr;
    [_collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBAttributeReferenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attributeReferenceCell" forIndexPath:indexPath];
    XPBReferenceBallModel *dataModel = _dataSource[indexPath.item];
    [cell.btn setTitle:dataModel.number forState:UIControlStateNormal];
    [cell.btn setBackgroundImage:[UIImage imageNamed:dataModel.color] forState:UIControlStateNormal];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}



- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(25,25);
}


@end
