//
//  ProjectIntroduceDetailViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectIntroduceDetailViewController.h"
#import "ProjectDetailTableViewCell.h"
#import "ProjectDetailModel.h"
#import "ProjectDetailImageTableViewCell.h"
#import "User.h"
#import "ProjectDetailImageCell.h"


#define ProjectDetailCellID @"ProjectDetailTableViewCell"
#define ProjectDetailImageCellId @"ProjectDetailImageCell"
@interface ProjectIntroduceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong)  NSDictionary *dict;

@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSArray *imgArr;

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) NSDictionary *projectDic;

@end

@implementation ProjectIntroduceDetailViewController
{
    BOOL isHaveImage;
    NSInteger lastIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    self.title = @"项目详情";
    [self setupView];
    lastIndex = -1;
    _imgArr = [NSArray array];
    
     _arr=[NSMutableArray array];
    _projectDic = [NSDictionary dictionary];
    
    isHaveImage = NO;
}


- (void)setDebtProjectDic:(NSDictionary *)debtProjectDic
{
    _debtProjectDic = debtProjectDic;
    
    
    [_arr addObject:[debtProjectDic objectForKey:@"Projectintroduce"]];
    [_arr addObject:[debtProjectDic objectForKey:@"Enterpriseintroduce"]];
    [_arr addObject:[debtProjectDic objectForKey:@"Paymentsource"]];
     [_arr addObject:[debtProjectDic objectForKey:@"Securityguarantee"]];
    
    
    [_arr addObject:[debtProjectDic objectForKey:@"Cooperationdescriptio"]];
    if (!IsStrEmpty([debtProjectDic objectForKey:@"RiskManagement"])) {
        [_arr addObject:[debtProjectDic objectForKey:@"RiskManagement"]];
    }
    
    _imgArr = [debtProjectDic objectForKey:@"Imgs"];
    
    if (IsStrEmpty([debtProjectDic objectForKey:@"RiskManagement"])) {
        _titleArr = @[@"项目介绍",@"借款人企业介绍",@"还款来源",@"安全保障",@"担保公司介绍"];
    }else{
        
        _titleArr = @[@"项目介绍",@"借款人企业介绍",@"还款来源",@"安全保障",@"担保公司介绍",@"风控措施"];
    }

    for (int i = 0; i< _arr.count; i++) {
        ProjectDetailModel *model = [ProjectDetailModel new];
        model.title = _titleArr[i];
        model.content = _arr[i];
        [self.modelArr addObject:model];
    }
    if (_imgArr.count == 0) {
        isHaveImage = NO;
    }else{
        isHaveImage = YES;
    }
    
}



- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
- (void)setProjectId:(int)projectId
{
    _projectId = projectId;
    
    [self getProjectDetailsData];
}
//   项目信息
- (void)getProjectDetailsData
{
    
    
    
    [self.httpUtil requestDic4MethodName:@"project/detail" parameters:@{@"ProjectId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
       
        if (status == 1 || status == 2) {
           
            _projectDic = dic;
            _imgArr = [dic objectForKey:@"ProjectImage"];
            
            [self setData:dic];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_tableview reloadData];
    }];
}
- (void)setData:(NSDictionary *)dic{
    
    [_arr addObject:[dic objectForKey:@"ProjectIntroduce"]];
    [_arr addObject:[dic objectForKey:@"EnterpriseIntroduce"]];
    [_arr addObject:[dic objectForKey:@"PaymentSource"]];
    [_arr addObject:[dic objectForKey:@"SecurityGuarantee"]];
    
    
//     [_arr addObject:[dic objectForKey:@"SecurityGuarantee"]];
     [_arr addObject:[dic objectForKey:@"CooperationDescription"]];
    if (!IsStrEmpty([dic objectForKey:@"RiskManagement"])) {
        [_arr addObject:[dic objectForKey:@"RiskManagement"]];
    }
    
    
    if (IsStrEmpty([dic objectForKey:@"RiskManagement"])) {
         _titleArr = @[@"项目介绍",@"借款人企业介绍",@"还款来源",@"安全保障",@"担保公司介绍"];
    }else{
        
        _titleArr = @[@"项目介绍",@"借款人企业介绍",@"还款来源",@"安全保障",@"担保公司介绍",@"风控措施"];
    }
    
//     _titleArr = @[@"项目介绍",@"借款人企业介绍",@"还款来源",@"安全保障",@"担保公司介绍",@"风控措施"];
    
        for (int i = 0; i< _arr.count; i++) {
            ProjectDetailModel *model = [ProjectDetailModel new];
            model.title = _titleArr[i];
            model.content = _arr[i];
            [self.modelArr addObject:model];
        }

        if (_imgArr.count == 0) {
            isHaveImage = NO;
        }else{
            isHaveImage = YES;
        }
}

- (void)setupView
{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.estimatedRowHeight=200; //预估行高 可以提高性能
    _tableview.rowHeight = 88;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    [self.view addSubview:_tableview];
    //注册表格单元
    [self.tableview registerClass:[ProjectDetailTableViewCell class] forCellReuseIdentifier:ProjectDetailCellID];
    
//    [self.tableview registerNib:[UINib nibWithNibName:ProjectDetailImageCellId bundle:nil] forCellReuseIdentifier:ProjectDetailImageCellId];
    
    [self.tableview registerClass:[ProjectDetailImageCell class] forCellReuseIdentifier:ProjectDetailImageCellId];;
}



/*
 返回多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isHaveImage) {
        lastIndex = self.arr.count;
        
        return self.arr.count + 1;
    }else{
        
        return self.arr.count;
    }
    
}

/*
 返回表格单元
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //取出模型
   
    if (indexPath.row == lastIndex) {
        ProjectDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ProjectDetailImageCellId];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.imgArray = _imgArr;
        return cell;
        
    }else{
        
        ProjectDetailModel *model = self.modelArr[indexPath.row];
        ProjectDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProjectDetailCellID];
        
        //传递模型给cell
        
        if (indexPath.row  == _arr.count-1 && !IsStrEmpty([_projectDic objectForKey:@"RiskManagement"])) {
            cell.ishowHtml = YES;
        }
        
        if (indexPath.row  == _arr.count-1 && !IsStrEmpty([_debtProjectDic objectForKey:@"RiskManagement"])) {
            cell.ishowHtml = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.projectModel = model;
        
        return cell;
    }
    
}

/*
 *  返回每一个表格单元的高度
 */

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == lastIndex) {
        if (_imgArr.count % 2 == 0) {
            return 200 * (_imgArr.count / 2);
        }
        return 200 * (_imgArr.count / 2 + 1);
    }else{
        ProjectDetailModel *model = self.modelArr[indexPath.row];
        
        return model.cellHeight + 30;
    }
    
}


@end
