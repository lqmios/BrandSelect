//
//  ViewController.m
//  BrandSelect
//
//  Created by lqm on 16/9/7.
//  Copyright © 2016年 LQM. All rights reserved.
//

#import "ViewController.h"
#import "PLCollectionViewWaterfallLayout.h"
#import "BrandCollectionViewCell.h"
#import "HeaderView.h"
#import "BrandTableViewCell.h"
#import "ChineseToPinyin.h"


static NSString *SCellID = @"SCellID";
static NSString *TCellID = @"TCellID";
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PLCollectionViewDelegateWaterfallLayout,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTabelView;

@property(nonatomic,strong)UICollectionView *myCollectionView;

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray  *allKeysArray;
@property(nonatomic,strong)NSMutableDictionary *mCarDic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  _dataSource = [NSMutableArray arrayWithObjects:@"阿斯顿·马丁",@"福特",@"Jeep",@"奥迪",@"丰田",@"北京现代",@"别克",@"大众",@"QQ",@"玛莎拉蒂",@"红旗",@"奇瑞",@"宝马",@"雪弗兰",@"SUV",@"拖拉机",@"自行车",@"电动车",@"C",@"E",@"Y",@"柳州", nil];
    
    [self.view addSubview:self.myCollectionView];
    _myTabelView.dataSource = self;
    _myTabelView.delegate = self;
    _myTabelView.rowHeight = 50;
    /*========*/
    _myTabelView.sectionIndexColor = [UIColor grayColor];
    _myTabelView.sectionIndexBackgroundColor = [UIColor clearColor];

     /*========*/
    
    [_myTabelView registerNib:[UINib nibWithNibName:@"BrandTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TCellID];
    _myTabelView.showsVerticalScrollIndicator = NO;

    //去掉多余的cell
    _myTabelView.tableFooterView=[[UIView alloc]init];

    //初始化数据源字典
    _mCarDic = [[NSMutableDictionary alloc]init];
    _allKeysArray = [[NSMutableArray alloc]init];
    
    
    [self prepareCarListDatasourceWithArray:_dataSource andToDictionary:_mCarDic];

}
- (UICollectionView *)myCollectionView
{
    if (!_myCollectionView) {
        PLCollectionViewWaterfallLayout *layout = [[PLCollectionViewWaterfallLayout alloc] init];
        layout.minimumRowSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        //返回行数
        layout.rowCount = 2;
        layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 0.0f);
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+30,  CGRectGetWidth(self.view.bounds), 150) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        //隐藏水平滚动条
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"BrandCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SCellID];
    }
    return _myCollectionView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark =UICollectionViewDataSource,UICollectionViewDelegate=

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCellID forIndexPath:indexPath];
    cell.headImageView.backgroundColor = [UIColor greenColor];
    cell.brandLabel.text = _dataSource[indexPath.row];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30,30);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了collection view");
}

#pragma mark =UITableViewDataSource,UITableViewDelegate=
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_mCarDic allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cityArray = [_mCarDic objectForKey:[_allKeysArray objectAtIndex:section]];
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TCellID forIndexPath:indexPath];
    
     NSArray *cityArray = [_mCarDic objectForKey:[_allKeysArray objectAtIndex:indexPath.section]];
    
    cell.titleLable.text = cityArray[indexPath.row];
    cell.headView.backgroundColor = [UIColor greenColor];
    //取消cell点击闪一下的状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"点击了tableView");
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (_allKeysArray.count>0) {
        
        HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [headerView setTitleString:[_allKeysArray objectAtIndex:section]];
        
        return headerView;
        
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (_allKeysArray.count>0) {
        return 30;
    }
    
    return 0;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (_allKeysArray.count>0)
    {
        
        return _allKeysArray;
    }
    return nil;
}






#pragma mark-排序车名首字母排序
-(void)prepareCarListDatasourceWithArray:(NSArray *)array andToDictionary:(NSMutableDictionary *)dic
{
    for (NSString *car in array)
    {
        NSString *carPinYin = [ChineseToPinyin pinyinFromChiniseString:car];
        NSString *firstLetter = [carPinYin substringWithRange:NSMakeRange(0, 1)];
        if (![dic objectForKey:firstLetter]) {
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:firstLetter];
        }
        if ([[dic objectForKey:firstLetter] containsObject:car]) {
            return;
            
        }
        [[dic objectForKey:firstLetter] addObject:car];
    }
    [_allKeysArray addObjectsFromArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [_myTabelView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















