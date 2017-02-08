//
//  ProjectCheckTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectCheckTableViewCell.h"

@implementation ProjectCheckTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDocumentTypeArr:(NSMutableArray *)documentTypeArr
{
    _documentTypeArr = documentTypeArr;
    
    if (_documentTypeArr.count == 1) {
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
    }else if (_documentTypeArr.count == 2){
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
        _label2.text = [_documentTypeArr[1] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[1] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView2.image = [UIImage imageNamed:@"checkState"];
        }
    }else if (_documentTypeArr.count == 3){
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
        _label2.text = [_documentTypeArr[1] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[1] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView2.image = [UIImage imageNamed:@"checkState"];
        }
        _label3.text = [_documentTypeArr[2] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[2] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView3.image = [UIImage imageNamed:@"checkState"];
        }
    }else if (_documentTypeArr.count == 4){
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
        _label2.text = [_documentTypeArr[1] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[1] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView2.image = [UIImage imageNamed:@"checkState"];
        }
        _label3.text = [_documentTypeArr[2] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[2] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView3.image = [UIImage imageNamed:@"checkState"];
        }
        _label4.text = [_documentTypeArr[3] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[3] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView4.image = [UIImage imageNamed:@"checkState"];
        }
    }else if (_documentTypeArr.count == 5){
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
        _label2.text = [_documentTypeArr[1] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[1] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView2.image = [UIImage imageNamed:@"checkState"];
        }
        _label3.text = [_documentTypeArr[2] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[2] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView3.image = [UIImage imageNamed:@"checkState"];
        }
        _label4.text = [_documentTypeArr[3] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[3] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView4.image = [UIImage imageNamed:@"checkState"];
        }
        _label5.text = [_documentTypeArr[4] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[4] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView5.image = [UIImage imageNamed:@"checkState"];
        }
    }else if (_documentTypeArr.count == 6){
        _label1.text = [_documentTypeArr[0] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[0] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView1.image = [UIImage imageNamed:@"checkState"];
        }
        _label2.text = [_documentTypeArr[1] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[1] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView2.image = [UIImage imageNamed:@"checkState"];
        }
        _label3.text = [_documentTypeArr[2] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[2] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView3.image = [UIImage imageNamed:@"checkState"];
        }
        _label4.text = [_documentTypeArr[3] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[3] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView4.image = [UIImage imageNamed:@"checkState"];
        }
        _label5.text = [_documentTypeArr[4] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[4] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView5.image = [UIImage imageNamed:@"checkState"];
        }
        _label6.text = [_documentTypeArr[5] objectForKey:@"DocumentName"];
        if ([[_documentTypeArr[5] objectForKey:@"StatusId"] integerValue] == 1) {
            _imageView6.image = [UIImage imageNamed:@"checkState"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
