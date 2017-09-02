//
//  XPBAttributeReferenceZodiaCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAttributeReferenceZodiaCell.h"
#import "XPBAttributeReferenceCell.h"
#import "XPBReferenceBallModel.h"

@interface XPBAttributeReferenceZodiaCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger cellType ; //0 家禽野兽 1 生肖

@end

@implementation XPBAttributeReferenceZodiaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        nameLabel.frame = CGRectMake(10, 10, 30, 20);
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"类型";
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat margant = (SCREENWIDTH - 25 *10 -20)/9;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = margant;
        CGFloat X = CGRectGetMaxX(nameLabel.frame) + 5;
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(X, 10, SCREENWIDTH - 40, 35) collectionViewLayout:layout];
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

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    _nameLabel.text = _nameStr;
   if([_nameStr isEqualToString:@"野兽"] || [_nameStr isEqualToString:@"家禽"]){
       _cellType = 0;
   }else{
       _cellType = 1;
   }
    [_collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBAttributeReferenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attributeReferenceCell" forIndexPath:indexPath];
    if(_cellType == 0){
      [cell.btn setTitle:_dataSource[indexPath.item] forState:UIControlStateNormal];
        [cell.btn setBackgroundImage:[UIImage imageNamed:@"红波"] forState:UIControlStateNormal];
    }else if (_cellType == 1){
        XPBReferenceBallModel *dataModel = [XPBReferenceBallModel mj_objectWithKeyValues: _dataSource[indexPath.item]];
        [cell.btn setTitle:dataModel.number forState:UIControlStateNormal];
        [cell.btn setBackgroundImage:[UIImage imageNamed:dataModel.color] forState:UIControlStateNormal];
    }
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
