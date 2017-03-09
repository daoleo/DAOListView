//
//  DAOListView.m
//  DemoRoom
//
//  Created by daoleo on 2017/2/25.
//  Copyright © 2017年 daoleo. All rights reserved.
//

#import "DAOListView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kListTabelViewMinMargin 10
#define kTrianglePadding 10

typedef NS_ENUM(NSInteger, TriangleDirection) {
    TriangleDirectionTopLeft,
    TriangleDirectionTopRight,
    TriangleDirectionBottomLeft,
    TriangleDirectionBottomRight
};
//typedef NS_ENUM(NSInteger, DAONavItemActionList) {
//    DAONavItemActionListNone,
//    DAONavItemActionListLeft = 1,
//    DAONavItemActionListRight
//};

@interface DAOListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGRect referFrame;
@property (nonatomic, copy) ListSelectBlock select;
@property (nonatomic, copy) ListCellConfigBlock cellConfig;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
//包含三角 和 tableView
@property (nonatomic, strong) UIView *listView;

@end

@implementation DAOListView
- (instancetype)initWithReferFrame:(CGRect)referFrame
                        titleArray:(NSArray *)titleArray
                          selected:(ListSelectBlock)select{
    self = [self initWithReferFrame:referFrame titleArray:titleArray cellCount:0 cellConfig:nil selected:select];
    
    
    return self;
}
- (instancetype)initWithReferFrame:(CGRect)referFrame
                         cellCount:(NSInteger)cellCount
                        cellConfig:(ListCellConfigBlock)cellConfig
                          selected:(ListSelectBlock)select{
    self = [self initWithReferFrame:referFrame titleArray:nil cellCount:cellCount cellConfig:cellConfig selected:select];
    return self;
}
- (instancetype)initWithReferFrame:(CGRect)referFrame
                        titleArray:(NSArray *)titleArray
                         cellCount:(NSInteger)cellCount
                        cellConfig:(ListCellConfigBlock)cellConfig
                          selected:(ListSelectBlock)select{
    self = [self init];
    if(self){
        self.select = select;
        self.titleArray = titleArray;
        self.cellCount = cellCount;
        if(self.titleArray)
            self.cellCount = self.titleArray.count;
        self.cellConfig = cellConfig;
        self.referFrame = referFrame;
        self.cellHeight = 40;
        if(self.titleArray)
            self.listViewWidth = 100;
        else
            self.listViewWidth = 150;
        self.visibleCellCount = self.cellCount;
        self.listViewBounces = NO;
        self.hidden = YES;
        self.listViewTriangleColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self setupBackGroundView];
        [self addSubview:self.listView];
    }
    return self;
}

//- (void)layoutSubviews{
////    self.visibleCellCount = [self validVisibleCellCount];
//    [super layoutSubviews];
//    NSLog(@"layoutSubviews");
//    if(CGAffineTransformEqualToTransform(self.listView.transform, CGAffineTransformMakeScale(1.0, 1.0))){
//        [self layoutListView];
//    }
////    if(self.listView.alpha > 0){
////        [self layoutListView];
////    }
//}
#pragma mark private method
//三角形出现的位置
- (TriangleDirection)triangleDirection{
    
    CGFloat cenX = self.referFrame.origin.x + self.referFrame.size.width/2.0;
    CGFloat cenY = self.referFrame.origin.y + self.referFrame.size.height/2.0;
    if(cenX <= self.center.x && cenY <= self.center.y){
        return TriangleDirectionTopLeft;
    }else if(cenX <= self.center.x && cenY >= self.center.y){
        return TriangleDirectionBottomLeft;
    }else if(cenX >= self.center.x && cenY <= self.center.y){
        return TriangleDirectionTopRight;
    }else if(cenX >= self.center.x && cenY >= self.center.y){
        return TriangleDirectionBottomRight;
    }
    
    return 0;
}
//设置背景
- (void)setupBackGroundView{
    if(!self.superview){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = window.bounds;
        [window addSubview:self];
    }
//    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0.3f;
//    [self addSubview:bgView];
}

- (void)layoutListView{
    
#warning  to do 变化后frame设置会发生各种错误
    self.listView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    CGRect listFrame = CGRectMake(self.referFrame.origin.x, self.referFrame.origin.y+self.referFrame.size.height, self.listViewWidth, self.cellHeight*self.visibleCellCount);
   
    TriangleDirection triangleDirection = [self triangleDirection];
    switch (triangleDirection) {
        case TriangleDirectionTopLeft:
        case TriangleDirectionTopRight:
            listFrame.origin.y = listFrame.origin.y+(kListTabelViewMinMargin);
            if(CGRectGetMaxY(listFrame)+kListTabelViewMinMargin > kScreenHeight){//是否超出屏幕
                listFrame.size.height = kScreenHeight-CGRectGetMinY(listFrame)-kListTabelViewMinMargin;
            }
            break;
        case TriangleDirectionBottomLeft:
        case TriangleDirectionBottomRight:
            listFrame.origin.y = self.referFrame.origin.y-(kListTabelViewMinMargin)-CGRectGetHeight(listFrame);
            if(CGRectGetMinY(listFrame) < kListTabelViewMinMargin){//
                listFrame.origin.y = kListTabelViewMinMargin;
            }
            break;
        default:
            break;
    }
    listFrame.origin.x = [self listViewXWithDirection:triangleDirection];
//    self.listView.bounds = CGRectMake(0, 0, CGRectGetWidth(listFrame), CGRectGetHeight(listFrame));
//    self.listView.center = CGPointMake(CGRectGetMaxX(listFrame)/2, CGRectGetMaxY(listFrame)/2);
//    listFrame = CGRectApplyAffineTransform(listFrame, CGAffineTransformMakeScale(1.0, 1.0));
    self.listView.frame = listFrame;
//    self.visibleCellCount = CGRectGetHeight(listFrame)/self.cellHeight;
    self.listTableView.frame = CGRectMake(CGRectGetMinX(self.listTableView.frame), CGRectGetMinY(self.listTableView.frame), CGRectGetWidth(self.listView.frame), CGRectGetHeight(self.listView.frame));
    
    self.listTableView.bounces = self.listViewBounces;
    
    [self upTriangleLayerForTriangleDirection:triangleDirection];
//     self.listView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}
- (CGFloat)listViewXWithDirection:(TriangleDirection)triangleDirection{
    if(triangleDirection == TriangleDirectionTopRight || triangleDirection == TriangleDirectionBottomRight){
        if((CGRectGetMaxX(self.referFrame)-self.listViewWidth-kListTabelViewMinMargin)<0){
            return kListTabelViewMinMargin;
        }else{
            return CGRectGetMaxX(self.referFrame)>kScreenWidth?(kScreenWidth-kListTabelViewMinMargin-self.listViewWidth):CGRectGetMaxX(self.referFrame)-self.listViewWidth-kListTabelViewMinMargin;
        }
    }else if(triangleDirection == TriangleDirectionTopLeft || triangleDirection == TriangleDirectionBottomLeft){
        if(self.referFrame.origin.x+self.listViewWidth+kListTabelViewMinMargin>kScreenWidth){
            return kScreenWidth-kListTabelViewMinMargin-self.listViewWidth;
        }else{
            return self.referFrame.origin.x>2*kListTabelViewMinMargin?self.referFrame.origin.x-kListTabelViewMinMargin:kListTabelViewMinMargin;
        }
    }
    return self.referFrame.origin.x-kTrianglePadding;
    
}
- (void)upTriangleLayerForTriangleDirection:(TriangleDirection)triangleDirection{
    CGFloat triangleX = CGRectGetMinX(self.referFrame)-CGRectGetMinX(self.listView.frame)+CGRectGetWidth(self.referFrame)/2;
    if(triangleX >= self.listViewWidth-kTrianglePadding){
        triangleX = self.listViewWidth-kTrianglePadding;
    }else if(triangleX <= kTrianglePadding){
        triangleX = kTrianglePadding;
    }
    CGFloat triangleY = kTrianglePadding/2.0*1.7;
    CGFloat paddingX = kTrianglePadding/2.0;
    CGFloat paddingY = 0;
    
    switch (triangleDirection) {
        case TriangleDirectionTopLeft:
        case TriangleDirectionTopRight:
            paddingY = paddingY;
            triangleY = -triangleY;
            break;
        case TriangleDirectionBottomLeft:
        case TriangleDirectionBottomRight:
            paddingY = CGRectGetHeight(self.listView.frame)-paddingY;
            triangleY = CGRectGetHeight(self.listView.frame)+triangleY;
            break;
        default:
            break;
    }
    CGPoint triangleTopP,triangleLeftP,triangleRightP;
    triangleTopP = CGPointMake(triangleX, triangleY);
    triangleLeftP = CGPointMake(triangleX - paddingX, paddingY);
    triangleRightP = CGPointMake(triangleX + paddingX, paddingY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:triangleTopP];
    [path addLineToPoint:triangleLeftP];
    [path addLineToPoint:triangleRightP];
    self.triangleLayer.fillColor = self.listViewTriangleColor.CGColor;
    self.triangleLayer.path = path.CGPath;
    [self setAnchorPoint:CGPointMake(triangleX/CGRectGetWidth(self.listView.frame), triangleY<0?0:1) forView:self.listView];
    
}
//设置AnchorPoint时，layer位置保持不变
- (void)setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorpoint;
    view.frame = oldFrame;
}

#pragma mark public show and dismiss method
- (void)showWithReferFrame:(CGRect)referFrame{
    self.referFrame = referFrame;
    [self show];
}
- (void)show{
    [self setupBackGroundView];
    [self layoutListView];
    self.hidden = NO;
    self.alpha = 1;
    self.listView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.listView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.listView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismissHasRemove:(BOOL)isRemove{
    [UIView animateWithDuration:0.5 animations:^{
        self.listView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.listView.alpha = 0;
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if(isRemove){
            [self removeFromSuperview];
        }
    }];
}
- (void)dismissAndRemove{
    [self dismissHasRemove:YES];
}
- (void)dismiss{
    [self dismissHasRemove:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}
#pragma mark UITableViewDelegate UITableViewSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.select)
        self.select(indexPath.row);
    [self dismiss];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ListTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = self.listViewTriangleColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    if(self.titleArray.count > indexPath.row)
        cell.textLabel.text = self.titleArray[indexPath.row];
    if(self.cellConfig)
        self.cellConfig(cell, indexPath.row);
    return cell;
}
#pragma mark getters
- (UIView *)listView{
    if(!_listView){
        _listView = [[UIView alloc] init];
        [_listView addSubview:self.listTableView];
        [_listView.layer addSublayer:self.triangleLayer];
    }
    return _listView;
}

- (CAShapeLayer *)triangleLayer{
    if(!_triangleLayer){
        _triangleLayer = [CAShapeLayer layer];
        _triangleLayer.fillColor = self.listViewTriangleColor.CGColor;
    }
    return _triangleLayer;
}
- (UITableView *)listTableView{
    if(!_listTableView){
        _listTableView = [[UITableView alloc] init];
        [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListTableCell"];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.rowHeight = self.cellHeight;
        _listTableView.layer.cornerRadius = 5.0f;
        _listTableView.clipsToBounds = YES;
        _listTableView.bounces = self.listViewBounces;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _listTableView;
}
@end
