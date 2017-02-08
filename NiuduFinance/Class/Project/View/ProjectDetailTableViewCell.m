//
//  ProjectDetailTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailTableViewCell.h"

//间距
#define  marginW 10

@interface ProjectDetailTableViewCell()

@property (nonatomic,strong) UIView *redView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,weak) UILabel *contentLabel; //显示文本的label

//定义一个contentLabel文本高度的属性
@property (nonatomic,assign) CGFloat contentLabelH;

@end

@implementation ProjectDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //1.添加子控件
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{

    //1.添加redView
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:view];
    self.redView  = view;
    
    //2 添加标题
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //3. 添加文字内容
    UILabel *contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    //设置约束
    __weak __typeof(&*self)weakSelf = self;
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(4);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.top.equalTo(weakSelf.mas_top).offset(15);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(200);
        make.left.equalTo(weakSelf.redView.mas_right).offset(5);
        make.top.bottom.equalTo(weakSelf.redView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.titleLabel.mas_left);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        
        
    }];
    
}
- (void)setProjectModel:(ProjectDetailModel *)projectModel
{
    _projectModel = projectModel;
    self.titleLabel.text = projectModel.title;
    if (IsStrEmpty(projectModel.content)) {
        self.contentLabel.text = @"无";
    }else{
    self.contentLabel.text = projectModel.content;
    
    if (_ishowHtml) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_projectModel.content
                                                                                 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.contentLabel.attributedText = attrStr;
 
    }
       
    }
}

- (void)setIshowHtml:(BOOL)ishowHtml
{

    _ishowHtml = ishowHtml;
}

-(CGFloat)rowHeightWithCellModel:(ProjectDetailModel *)model
{
    _projectModel = model;
    __weak __typeof(&*self)weakSelf = self;
    
    //设置标签的高度
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_projectModel.content
                                                                             dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.contentLabel.attributedText = attrStr;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        // weakSelf.contentLabelH  这个会调用下面的懒加载方法
        make.height.mas_equalTo(weakSelf.contentLabelH);
    }];
    
    // 2. 更新约束
    [self layoutIfNeeded];
    
    //3.  视图的最大 Y 值
    CGFloat h= CGRectGetMaxY(self.contentLabel.frame);
    
    return h+marginW; //最大的高度+10
    
}

/*
 *  懒加载的方法返回contentLabel的高度  (只会调用一次)
 */
-(CGFloat)contentLabelH
{
    if(!_contentLabelH){
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.projectModel.content
                                                                                 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
//        self.projectModel.content.attributedText = attrStr;
        
        UILabel *label = [UILabel new];
        label.text = self.projectModel.content;
        label.attributedText = attrStr;
        
        CGFloat h=[label.text boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width)-2*marginW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        _contentLabelH=h+1;  //内容距离底部下划线10的距离
    }
    return _contentLabelH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
