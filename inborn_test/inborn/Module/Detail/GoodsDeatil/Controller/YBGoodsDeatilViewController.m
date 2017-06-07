//
//  YBGoodsDeatilViewController.m
//  inborn
//
//  Created by 刘文强 on 2017/3/20.
//  Copyright © 2017年 inborn. All rights reserved.
//

#import "YBGoodsDeatilViewController.h"
#import "YBGoodsDeatilHeaderView.h"
#import "YBGoodsDeatilCollectionSectionView.h"
#import "YBGoodDeatilSeactionCell.h"
#import "YBGoodsDeatilPresentFromboomView.h"
#import "ZJBaseBarButtonItem.h"
#import "YBGoodsDeatilBoomBarView.h"
#import "ZJBaseNavigationController.h"
#import "YBGoodsDeatilNaviMoreView.h"
#import "YBGoodsDeatilService.h"
#import "YBGoodsDeatilModel.h"
#import "YBStringTool.h"
#import "YBLikeGoodListController.h"
#import "YBGoodListControllerFlowLayout.h"
#import "YBGoodListCell.h"
#import "ZJHomePageService.h"
#import "YBConfirmOrderViewController.h"
#import "YBFeedBackViewController.h"
#import "YBShareView.h"
#import "MQCustomerServiceManager.h"
#import "YBOrderDetailTableViewController.h"
#import "YBHelpCenterViewController.h"
#import "YBGoodsDeatilImageViewController.h"
#import "ZJBaseNavigationController.h"
#import "PBViewController.h"
#import "YXShareSDKManager.h"
#import "User_LocalData.h"
#import "YBLoginViewController.h"
#import "YBTimerManager.h"
#import "YBHomePageController.h"
#import "YBGoodsDeatilTableViewCell.h"
#import "YBGoodsDeatilImgeMoreItemView.h"
#import "UINavigationController+WXSTransition.h"
#import "YBPhotoBrowserViewController.h"
#import "YBAttributedStringLabel.h"
#import "SDPhotoBrowser.h"
/**
 seactionheader
 */
static NSString *GOODSDEATILCOLLECTIONVIEWSEACTIONVIEW = @"GOODSDEATILCOLLECTIONVIEWSEACTIONVIEW";

/**
 tableview
 */
static NSString *GOODSDEATILCELLINDIFITER = @"GOODSDEATILCELLINDIFITER";

/**
 *  商品cell重用标志
 */
static NSString * const YBGoodListControllerGoodCellReuseIdentifier                                     = @"YBGoodListControllerGoodCellReuseIdentifier";

static NSInteger MAXPAGE = 8;

/**
 弹出视图的view高度
 */
static CGFloat PRESENTVIEWFROMBOOMHEIGHT = 350;

@interface YBGoodsDeatilViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YBGoodListControllerFlowLayoutDelegate,PBViewControllerDataSource, PBViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,clickGoodsImageViewDelegate,SDPhotoBrowserDelegate>

@property(nonatomic,strong) YBGoodsDeatilHeaderView * headerView;
@property(nonatomic,strong) UITableView * tableView;

//@property(nonatomic,strong) UICollectionView * collectView;
//@property(nonatomic,strong) UICollectionViewFlowLayout * layout;
@property(nonatomic,strong) NSArray * seactionArr;
@property(nonatomic,strong) NSArray * seactioncontenArr;
//@property(nonatomic,assign) BOOL  isShowAllInforBool;

/**
 交易流程 弹出视图
 */
@property(nonatomic,strong) YBGoodsDeatilPresentFromboomView * presentformboomView;
@property(nonatomic,strong) ZJBaseView * presentformboomBackView;
@property(nonatomic,assign) CGFloat  headerviewHeight;
@property(nonatomic,strong) YBGoodsDeatilBoomBarView  *boomBarView;


/**
 自定义navi上的字控件
 */
@property(nonatomic,strong) ZJBaseView * MyNaviView;
@property(nonatomic,strong) YBDefaultButton * MyNaviViewColseBtn;
@property(nonatomic,strong) YBDefaultButton  * MyNaviViewShareBtn;
@property(nonatomic,strong) YBDefaultButton  * MyNaviViewMoreBtn;
@property(nonatomic,strong) YBDefaultLabel * MyNaviViewTitleLable;
//导航栏上的覆盖视图 及其字控件
@property(nonatomic,strong) ZJBaseView * MyNaviCoverView;
@property(nonatomic,strong) UIImageView * MyNaviCoverViewUserImageView;
@property(nonatomic,strong) YBDefaultLabel * MyNaviCoverViewUserNameLable;
@property(nonatomic,strong) YBAttributedStringLabel * MyNaviCoverViewPriceLable;

@property(nonatomic,strong) NSString * goodsId;
@property(nonatomic,strong) YBGoodsDeatilModel * dataModel;
@property(nonatomic,strong) YBGoodsDeatilGuessGodosModel * guessBaseModel;
@property(nonatomic,assign) NSInteger  currentPage;

/**
 猜你喜欢的collectionview
 */
@property(nonatomic,strong) UIView * guessCollectBackView;
@property(nonatomic,strong) UICollectionView * guessCollectView;
@property(nonatomic,strong) NSMutableArray  * goodListArray;

/*
 @brief _guesscollectview的高度
 */
@property (nonatomic, assign) CGFloat MAXHEIGHT;
/**
 离开的 时候 是否恢复导航栏
 */
@property(nonatomic,assign) BOOL  ishiddenNav;

@property(nonatomic,strong) NSMutableArray * imageUrlStringArray;

/**
 商品信息开关
 // */
@property(nonatomic,assign) BOOL  isShowAllInforBool;
@property(nonatomic,assign) BOOL  isShowAllLiuchengBool;
@property(nonatomic,assign) BOOL  isShowAllBaozhangBool;

@property(nonatomic,strong) UIImageView * liuchengView;
@property(nonatomic,strong) UIView * footerview;

@property(nonatomic,strong) YBGoodsDeatilImgeMoreItemView * MoreItemView;
@property(nonatomic,strong) UIImage * clickGoodsImage;
@property(nonatomic,strong) NSArray * goodsImageArr;
@end

@implementation YBGoodsDeatilViewController


#pragma mark - First.通知

#pragma mark - Second.赋值

- (void)clickItemMoreViewBtnWith:(NSString *)btnstr
{
    [self.MoreItemView dismissItemMoreView];
    
    if (![btnstr isEqualToString:@"咨询"]) {
        if (![User_LocalData getTokenId]||[User_LocalData getTokenId].length == 0) {
            loginTypeEnum type = generalLoginType;
            if ([[User_LocalData getUserData] isHaveRealphone]) {
                type = haveAcountLoginType;
            }
            YBLoginViewController *loginvc = [YBLoginViewController creatLoginViewControllerWithType:type extend:nil];
            ZJBaseNavigationController *nav = [[ZJBaseNavigationController alloc]initWithRootViewController:loginvc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
    
    /**
     自己的商品不能购买
     */
    if ([btnstr isEqualToString:@"定金购"] ||
        [btnstr isEqualToString:@"马上抢"]) {
        NSString *userid = [User_LocalData getUserData].userId;
        if ([self.dataModel.sellerId isEqualToString:[NSString stringWithFormat:@"%@",userid]]) {
            [[YBTopAlert sharedAlert] showAlertWithTitleStringKey:ZJSTRING(@"提示") tipsStringKey:@"不能购买自己的商品" type:YBTopAlertError eventCallBackBlock:^(id sender) {
            }];
            return;
        }
    }
    
    if ([btnstr isEqualToString:@"喜欢"] ||
        [btnstr isEqualToString:@"取消"]) {
        [self collectOrcancleCollect];
    }else if ([btnstr isEqualToString:@"咨询"]){
        [[MQCustomerServiceManager  share] showCustomerServiceWithViewController:self];
        [[MQCustomerServiceManager share] sendUrlMessage:[NSString stringWithFormat:@"商品名称：%@\n商品编号：%@\n商品地址：%@",
                                                          self.dataModel.goodsName,
                                                          self.dataModel.goodsId,
                                                          [NSString stringWithFormat:@"%@/detail/detail.html?params=%@",
                                                           BASE_M_URL,
                                                           self.dataModel.goodsId]]];
    }else if ([btnstr isEqualToString:@"定金购"]){
        YBConfirmOrderViewController *comfirVC = [YBConfirmOrderViewController confirmOrderViewControllerWithGoodId:_goodsId extend:@"1"];
        [self.navigationController pushViewController:comfirVC animated:YES];
    }else if ([btnstr isEqualToString:@"马上抢"]){
        YBConfirmOrderViewController *comfrivc = [YBConfirmOrderViewController confirmOrderViewControllerWithGoodId:_goodsId extend:nil];
        [self.navigationController pushViewController:comfrivc animated:YES];
    }
}

#pragma mark  *** 网路请求

- (void)loadGoodsDeatilData
{
    [[YBGoodsDeatilService share] getGoodsDeatilInfoWithgoodsId:_goodsId
                                                        Success:^(id objc, id requestInfo) {
                                                            self.dataModel = [YBGoodsDeatilModel modelWithDictionary:objc[@"data"]];
                                                            NSArray *imagearr = objc[@"data"][@"goodsImgs"];
                                                            for (NSDictionary * dict in imagearr) {
                                                                [self.imageUrlStringArray addObject:dict[@"imgUrl"]];
                                                            }
                                                            [self setModelToView];
                                                        } fail:^(id error, id requestInfo) {
                                                            
                                                        }];
}

/**
 猜你 喜欢
 */
- (void)loadGuessYouLikeGoodsData
{
    self.guessBaseModel = [[YBGoodsDeatilGuessGodosModel alloc]init];
    [[YBGoodsDeatilService share] guessLikeGoodsInGoodsDeatilWithgoodsId:_goodsId
                                                                 curPage:_currentPage
                                                                pageSize:MAXPAGE
                                                                 Success:^(id objc, id requestInfo) {
                                                                     [self handleRequestObj:objc[@"data"]];
                                                                     
                                                                 } fail:^(id error, id requestInfo) {
                                                                     [self.tableView.mj_footer endRefreshing];
                                                                 }];
}

/**
 猜你 喜欢 加载更多
 */
- (void)loadMoreGoodsListData
{
    if (_currentPage + 1 > self.guessBaseModel.pages) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    _currentPage ++ ;
    [[YBGoodsDeatilService share] guessLikeGoodsInGoodsDeatilWithgoodsId:_goodsId
                                                                 curPage:_currentPage
                                                                pageSize:MAXPAGE
                                                                 Success:^(id objc, id requestInfo) {
                                                                     [self handleRequestObj:objc[@"data"]];
                                                                     
                                                                 } fail:^(id error, id requestInfo) {
                                                                     [self.tableView.mj_footer endRefreshing];
                                                                 }];
}

- (void)handleRequestObj:(id)obj
{
    
    self.guessBaseModel = [YBGoodsDeatilGuessGodosModel modelWithDictionary:obj];
    
    /**
     *  商品数据
     */
    NSMutableArray *tempArrayGoods = [NSMutableArray array];
    if (_currentPage == 1) {
        self.goodListArray = [NSMutableArray array];
        for (NSDictionary *dict in self.guessBaseModel.pageData) {
            [tempArrayGoods addObject:[YBGoodListGoodModel modelWithDictionary: dict]];
        }
    }else{
        NSMutableArray *dataarr = [NSMutableArray array];
        for (NSDictionary *dict in self.guessBaseModel.pageData) {
            [dataarr addObject:[YBGoodListGoodModel modelWithDictionary:dict]];
        }
        tempArrayGoods = self.goodListArray;
        [tempArrayGoods addObjectsFromArray:dataarr];
    }
    
    self.goodListArray = tempArrayGoods;
    
    if (self.guessBaseModel.total <= MAXPAGE) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    if (self.goodListArray.count==0 ||
        self.goodListArray == nil) {
        self.tableView.tableFooterView.hidden = YES;
    }
    
    [self.guessCollectView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
    /**
     防止刷新滚动
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/**
 给view赋值
 */
- (void)setModelToView
{
    /**
     navicoverview上赋值
     */
    if ([_dataModel.MemberModel.headImage isEqualToString:@"mine_defaultphoto_icon"]) {
        self.MyNaviCoverViewUserImageView.image =   [[UIImage imageNamed:@"mine_defaultphoto_icon"] ex_drawCircleImage];
    }else{
        [self.MyNaviCoverViewUserImageView sd_setImageWithURL:[NSURL URLWithString:ZJIMAGEURLSTRING(ZJProjectImageUrlStringHeaderIcon, self.dataModel.MemberModel.headImage)] placeholderImage:[UIImage imageNamed:@"mine_defaultphoto_icon"]];
    }
    self.MyNaviCoverViewUserNameLable.text = self.dataModel.MemberModel.nickname;
    
//    self.MyNaviCoverViewPriceLable.text = [NSString stringWithFormat:@"¥%@",[[YBStringTool share] strmethodCommaWith:_dataModel.mallPrice]];
    if (self.dataModel.boombarType == willStartSellType) {
        self.MyNaviCoverViewPriceLable.text = [NSString stringWithFormat:@"¥--"];
    }else{
        NSString *pricestr = [[YBStringTool share] strmethodCommaWith:_dataModel.mallPrice];
        if (pricestr != nil && pricestr.length != 0) {
            [self.MyNaviCoverViewPriceLable setAttributedStringWithContentArray:@[@{@"color":ZJCOLOR.color_c6,
                                                                                    @"content":@"￥",
                                                                                    @"size":SYSTEM_REGULARFONT(12),
                                                                                    @"lineSpacing":@0},
                                                                                  @{@"color":ZJCOLOR.color_c6,
                                                                                    @"content":pricestr,
                                                                                    @"size":SYSTEM_MEDIUMFONT(18),
                                                                                    @"lineSpacing":@0}]];
        }
    }

   
    self.MyNaviCoverViewPriceLable.textAlignment = NSTextAlignmentRight;
    
    self.headerView.dataModel = self.dataModel;
    
    
    [self.tableView reloadData];
}


/**
 关注 和 取消关注
 */
- (void)collectOrcancleCollect
{
    if (self.dataModel.isCollect==1) {
        /**
         取消关注
         */
        [SVProgressHUD show];
        [[YBGoodsDeatilService share] cancleCollectGoodsInGoodsDeatilWithgoodsId:_goodsId
                                                                         Success:^(id objc, id requestInfo) {
                                                                             NSString *str = objc[@"data"];
                                                                             if (str != nil &&
                                                                                 [str isEqualToString:@"取消关注成功"]) {
                                                                                 [self.headerView collectGoodsOrCancleCollectGoodsWith:2];
                                                                                 self.dataModel.isCollect = 0;
                                                                             }
                                                                             
                                                                             [SVProgressHUD dismiss];
                                                                         } fail:^(id error, id requestInfo) {
                                                                             [SVProgressHUD dismiss];
                                                                         }];
    }else {
        
        /**
         添加关注
         */
        [SVProgressHUD show];
        [[YBGoodsDeatilService share] addCollectGoodsInGoodsDeatilWithgoodsId:_goodsId
                                                                      Success:^(id objc, id requestInfo) {
                                                                          YBLog(@"--tianjiaguanz%@--",objc);
                                                                          NSString *str = objc[@"data"];
                                                                          if (str != nil &&
                                                                              [str isEqualToString:@"关注成功"]) {
                                                                              [self.headerView collectGoodsOrCancleCollectGoodsWith:1];
                                                                              
                                                                              self.dataModel.isCollect = 1;
                                                                          }
                                                                          [SVProgressHUD dismiss];
                                                                      } fail:^(id error, id requestInfo) {
                                                                          [SVProgressHUD dismiss];
                                                                      }];
    }
}

/**
 点击分享，更多 导航兰上的事件
 tag:
 100    分享
 101    更多
 102    关闭
 */
- (void)clickNaviItemsWithTag:(UIButton *)sender
{
    if (sender.tag == 101) {
        
        [[YBGoodsDeatilNaviMoreView share] addMoreViewWithOrigin:CGPointMake(ADJUST_PERCENT_FLOAT(SCREEN_WIDTH-30),
                                                                             ADJUST_PERCENT_FLOAT(65))
                                                           Width:ADJUST_PERCENT_FLOAT(115)
                                                          Height:ADJUST_PERCENT_FLOAT(159)
                                                       Direction:WBArrowDirectionUp3
                                                          sourVC:self
                                                         dataArr:@[@"消息",@"首页",@"帮助",@"我要反馈"]
                                                        ImageArr:@[@"details_message_icon",@"details_home_icon",@"details_help_icon",@"details_feedback_icon"]
                                                      cellHeight:40
                                                  clickCellBlcok:^(NSInteger row) {
                                                      
                                                      [self clickPOPviewCellWith:row];
                                                  }];
        [[YBGoodsDeatilNaviMoreView share] popView];
        
    }else if (sender.tag == 100) {
        
        /**
         *  分享
         */
        [[YXShareSDKManager sharedManager] shareGoodWithImageURLString:self.dataModel.squareImage
                                                          andGoodNamed:self.dataModel.goodsName
                                                         andGoodDetail:self.dataModel.sellerDesc
                                                             andProdId:self.goodsId
                                                          andProdBidId:@""
                                                     andViewController:self];
        
        
    }else if (sender.tag == 102) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 点击popview中的cell
 */
- (void)clickPOPviewCellWith:(NSInteger)row
{
    if (row == 0) {
        
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        ZJBaseNavigationController *baseNavigationController = tabBarController.childViewControllers[3];
        tabBarController.selectedIndex = 3;
        [baseNavigationController dismissViewControllerAnimated:YES completion:nil];
        
        
    }else if (row == 1){
        
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        ZJBaseNavigationController *baseNavigationController = tabBarController.childViewControllers[0];
        tabBarController.selectedIndex = 0;
        [baseNavigationController dismissViewControllerAnimated:YES completion:nil];
        
    }else if (row == 2){
        
        YBHelpCenterViewController *helpvc = [[YBHelpCenterViewController alloc]init];
        [self.navigationController pushViewController:helpvc animated:YES];
        
    }else if (row == 3){
        YBFeedBackViewController *feedbackvc = [[YBFeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedbackvc animated:YES];
    }
}


/**
 点击弹出的背景图
 */
- (void)clickpresentbackview:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.25 animations:^{
        self.presentformboomView.ex_y = SCREEN_HEIGHT + ADJUST_PERCENT_FLOAT(PRESENTVIEWFROMBOOMHEIGHT);
        self.presentformboomBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.presentformboomView.itemBackview removeFromSuperview];
        [self.presentformboomBackView removeFromSuperview];
        [self.presentformboomView removeFromSuperview];
    }];
}

#pragma mark - Fourth.代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == _tableView) {
        CGFloat Myalph;
        if (offset>20) {
            Myalph = 1 - offset/100;
            
        }else{
            Myalph = 1;
        }
        [self changeMyNaviViewWithAlpha:Myalph];
    }
}

/**
 * 点击商品图的代理
 */
- (void)clickGoodsImageViewWith:(UIImageView *)selectImageView ImageViewIndex:(NSInteger)index goodsImageArr:(NSArray *)goodsImageArr
{
    _clickGoodsImage = selectImageView.image;
    _goodsImageArr = goodsImageArr;
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.sourceImagesContainerView = self.headerView; // 原图的父控件
//    browser.imageCount = self.imageUrlStringArray.count; // 图片总数
//    browser.currentImageIndex = index;
//    browser.delegate = self;
//    browser.isHiddenIndexLabelBool = YES;
//    [browser show];
    PBViewController *pbViewController = [PBViewController new];
//    pbViewController.blurBackground = NO;
    //    pbViewController.hideThumb = NO;
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = index;
    [self presentViewController:pbViewController animated:YES completion:^{
        
    }];
}

#pragma mark - PBViewControllerDataSource

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return self.imageUrlStringArray.count;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    
    NSString *imageUrl = self.imageUrlStringArray[index];
    imageUrl = [NSString stringWithFormat:@"%@",imageUrl];
    imageUrl = ZJIMAGEURLSTRING(ZJProjectImageURLStringLarge, imageUrl);
    
    [imageView sd_setImageWithURL:[NSURL URLWithString: imageUrl]
                 placeholderImage:nil
                        completed:^(UIImage * _Nullable image,
                                    NSError * _Nullable error,
                                    SDImageCacheType cacheType,
                                    NSURL * _Nullable imageURL) {
                        }];
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return _goodsImageArr[index];
    return nil;
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}


/**
 动态改变导航栏上的控件的alpha
 */
- (void)changeMyNaviViewWithAlpha:(CGFloat)alpha
{
    self.MyNaviView.alpha = alpha;
    self.MyNaviCoverView.alpha = 1-alpha;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBGoodListCell *cell                                            = [collectionView dequeueReusableCellWithReuseIdentifier:YBGoodListControllerGoodCellReuseIdentifier
                                                                                                                forIndexPath:indexPath];
    
    cell.goodModel                                                  = self.goodListArray[indexPath.item];
    return cell;
}

/*
 @brief 组头的方法
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        YBGoodsDeatilCollectionSectionView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GOODSDEATILCOLLECTIONVIEWSEACTIONVIEW forIndexPath:indexPath];
        [header setSeactionViewWithtitle:@"guess" isShowIcon:NO index:indexPath.section];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }else{
        return nil;
    }
}


#pragma mark <YBWaterflowLayoutDelegate>
/**
 组头高度
 
 @param waterflowLayout             waterflowLayout
 @param indexPath                   indexPath
 @return return                     value
 */
- (CGFloat)collectionViewLayout:(YBGoodListControllerFlowLayout *)waterflowLayout
heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath
{
    return ADJUST_PERCENT_FLOAT(50.f);
    
}

/**
 计算每个item的高度
 
 @param waterflowLayout             布局
 @param indexPath                   当前个数
 @param itemWidth                   宽度
 @return                            高度
 */
- (CGFloat)waterflowLayout:(YBGoodListControllerFlowLayout *)waterflowLayout
  heightForItemAtIndexPath:(NSIndexPath *)indexPath
                 itemWidth:(CGFloat)itemWidth
{
    /**
     *  计算每个item的高度，图片高度及文字高度
     */
    YBGoodListGoodModel *goodModel                      = self.goodListArray[indexPath.item];
    goodModel.itemWidth                                 = itemWidth;
    return goodModel.itemHeight == 0 ? 100 : goodModel.itemHeight;
}

/**
 获取最大的高度
 */
- (void)returenMaxHeight:(CGFloat)height
{
    _MAXHEIGHT = height ;
    _guessCollectView.height = height;
    self.footerview.height = height;
    
}

/**
 列间距
 
 @param waterflowLayout             布局
 @return                            列间距
 */
- (CGFloat)columnMarginInWaterflowLayout:(YBGoodListControllerFlowLayout *)waterflowLayout
{
    return 12;
}

/**
 行间距
 
 @param waterflowLayout             布局
 @return                            行间距
 */
- (CGFloat)rowMarginInWaterflowLayout:(YBGoodListControllerFlowLayout *)waterflowLayout
{
    return 12;
}

/**
 内边距
 
 @param waterflowLayout             布局
 @return                            内边距
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YBGoodListControllerFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(12,
                            12,
                            12,
                            12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBar.hidden = NO;
    self.ishiddenNav = YES;
    YBGoodListGoodModel *guessmodle = self.goodListArray[indexPath.row];
    YBGoodsDeatilImageViewController *goodsImageDeatilvc = [YBGoodsDeatilImageViewController creatGoodsDeatilImageViewControllerWithGoodsId:guessmodle.customId Extend:nil];
    ZJBaseNavigationController *nav = [[ZJBaseNavigationController alloc]initWithRootViewController:goodsImageDeatilvc];
    goodsImageDeatilvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Fifth.控制器生命周期
/**
 初始化
 */
+ (instancetype)creatGoodsDeatilViewControllergoodsId:(NSString *)goodsId
                                               Extend:(id)extend
{
    YBGoodsDeatilViewController *viewcontroller = [[YBGoodsDeatilViewController alloc]init];
    viewcontroller.goodsId                      = goodsId;
    return viewcontroller;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _currentPage = 1;
    [self loadGoodsDeatilData];
    [self loadGuessYouLikeGoodsData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!_ishiddenNav) {
        self.navigationController.navigationBar.hidden = NO;
    }
    [[YBTimerManager shareTimer] stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  ZJCOLOR.color_c12;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentPage = 1;
    
    [self setUI];
    [self setNaviView];
    
    //    [SYSTEM_NOTIFICATIONCENTER addObserver:self selector:@selector(pictureCarousrClick:) name:@"goodDetailViewControllerPictureCarouselClick" object:nil];
}


#pragma mark - Sixth.界面配置
- (void)setUI
{
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.tableFooterView = self.footerview;
    [self.footerview addSubview:self.guessCollectView];
    [self registerCollectView];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoodsListData)];
    
    WEAKSELF(self);
    [self.headerView headerViewGetheaderHeight:^(CGFloat height) {
        weakself.headerView.height = height;
        weakself.tableView.tableHeaderView.height = height;
        [self.tableView reloadData];
    } clickheaderViewBtn:^(UIButton* sender) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGPoint buttonCenter = CGPointMake(sender.bounds.origin.x ,
                                           sender.bounds.origin.y + sender.bounds.size.height/2);
        CGPoint btnorigin = [sender convertPoint:buttonCenter toView:window];
        
        DeatilBMoreItemType types = TwoType;
        if (self.dataModel.showStatus == 2) {
            types = FourType;
        }
        self.MoreItemView =  [YBGoodsDeatilImgeMoreItemView creatMoreItemViewWith:types
                                                                      currenOrgin:btnorigin
                                                                    collectStatus:self.dataModel.isCollect
                                                                     clickItemBtn:^(NSString *btnstr) {
                                                                         [self clickItemMoreViewBtnWith:btnstr];
                                                                     }];
        [self.MoreItemView showItemMoreView];
        
    }];
}

- (void)registerCollectView
{
    [_guessCollectView registerClass:[YBGoodListCell class]
          forCellWithReuseIdentifier:YBGoodListControllerGoodCellReuseIdentifier];
    [_guessCollectView registerClass:[YBGoodsDeatilCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GOODSDEATILCOLLECTIONVIEWSEACTIONVIEW];
}

- (void)setNaviView
{
    /**
     类似原生导航栏的控件
     */
    [self.view addSubview:self.MyNaviView];
    [_MyNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_offset(ADJUST_PERCENT_FLOAT(64));
    }];
    
    /**
     头像 价格，姓名的导航栏
     */
    [self.view addSubview:self.MyNaviCoverView];
    [self.MyNaviCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_offset(ADJUST_PERCENT_FLOAT(64));
    }];
    self.MyNaviCoverView.alpha = 0;
}

#pragma mark  *** tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 0;
    if (section == 1)
    {
        if (self.isShowAllInforBool) {
            return self.dataModel.goodsSpecList.count;
        }
        return 0;
    }
    if (section == 2) return  self.isShowAllLiuchengBool ? 1 : 0;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *seactionview = [[UIView alloc]init];
    seactionview.backgroundColor = [UIColor whiteColor];
    if (section == 0 ) {
        seactionview.backgroundColor = ZJCOLOR.color_c12;
        return seactionview;
    }
    seactionview.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickseactionViewTap:)];
    [seactionview addGestureRecognizer:tap];
    
    
    UIView *lineview =[[UIView alloc]init];
    lineview.backgroundColor = ZJCOLOR.color_c16;
    [seactionview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(seactionview);
        make.height.mas_offset(0.5);
        make.bottom.mas_equalTo(seactionview.mas_bottom).mas_offset(0);
    }];
    
    NSString *lablestr;
    if (section == 1) {
        lablestr = ZJSTRING(@"商品详情");
    }else if (section == 2){
        lablestr = ZJSTRING(@"交易流程");
    }else if (section == 3){
        lablestr = ZJSTRING(@"交易保障");
    }
    YBDefaultLabel *seationlable = [YBDefaultLabel labelWithFont:SYSTEM_REGULARFONT(14)
                                                            text:lablestr
                                                       textColor:ZJCOLOR.color_c4];
    [seactionview addSubview:seationlable];
    [seationlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(100), ADJUST_PERCENT_FLOAT(20)));
        make.left.mas_equalTo(seactionview.mas_left).mas_offset(ADJUST_PERCENT_FLOAT(12));
        make.centerY.mas_equalTo(seactionview.centerY);
    }];
    
    UIButton *switchBtn = [[UIButton alloc]init];
    [switchBtn addTarget:self action:@selector(clickSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_spread", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
    [seactionview addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(22), ADJUST_PERCENT_FLOAT(22)));
        make.right.mas_equalTo(seactionview.mas_right).mas_offset(ADJUST_PERCENT_FLOAT(-12));
        make.centerY.mas_equalTo(seationlable.centerY);
    }];
    if (section == 1) {
        switchBtn.tag = 100;
        if (self.isShowAllInforBool) {
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_fold", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }else{
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_spread", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }
        
    }else if (section == 2){
        switchBtn.tag = 200;
        if (self.isShowAllLiuchengBool) {
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_fold", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }else{
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_spread", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }
    }else if(section == 3){
        switchBtn.tag = 300;
        if (self.isShowAllBaozhangBool) {
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_fold", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }else{
            [switchBtn setImage:ZJIMAGE(IMAGEFILEPATH_DETAIL, @"details_spread", ZJProjectLoadImageDefault).firstObject forState:UIControlStateNormal];
        }
    }
    return seactionview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)  return ADJUST_PERCENT_FLOAT(10);
    return ADJUST_PERCENT_FLOAT(46);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) return ADJUST_PERCENT_FLOAT(46);
    if(indexPath.section == 2) return ADJUST_PERCENT_FLOAT(425);
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        YBGoodsDeatilTableViewCell *cell = [[YBGoodsDeatilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                            reuseIdentifier:GOODSDEATILCELLINDIFITER];
        YBGoodsSpecListModel *speclistModel = self.dataModel.goodsSpecList[indexPath.row];
        cell.goodsSpecListModel = speclistModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celll"];
        self.liuchengView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ADJUST_PERCENT_FLOAT(425));
        [cell.contentView addSubview:self.liuchengView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
    
}

/**
 点开开关
 */
- (void)clickSwitchBtn:(UIButton *)sender
{
    if (sender.tag == 100) {
        self.isShowAllInforBool = !self.isShowAllInforBool;
    }else if (sender.tag == 200){
        self.isShowAllLiuchengBool = !self.isShowAllLiuchengBool;
    }else if (sender.tag == 300){
        self.isShowAllBaozhangBool = !self.isShowAllBaozhangBool;
    }
    [self.tableView reloadData];
}
/**
 点击seactionview 的手势
 */
- (void)clickseactionViewTap:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1) {
        self.isShowAllInforBool = !self.isShowAllInforBool;
    }else if (tap.view.tag == 2){
        self.isShowAllLiuchengBool = !self.isShowAllLiuchengBool;
    }else if (tap.view.tag == 3){
        self.isShowAllBaozhangBool = !self.isShowAllBaozhangBool;
    }
    [self.tableView reloadData];
}

#pragma mark - Seventh.懒加载

- (YBGoodsDeatilHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YBGoodsDeatilHeaderView alloc]init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)footerview {
    if (!_footerview) {
        _footerview = [[UIView alloc]init];
        _footerview.backgroundColor = ZJCOLOR.color_c12;
    }
    return _footerview;
}


/**
 猜你喜欢的collectview
 */
- (UICollectionView *)guessCollectView {
    if (!_guessCollectView) {
        YBGoodListControllerFlowLayout *fl      = [[YBGoodListControllerFlowLayout alloc] init];
        fl.delegate                             = self;
        _guessCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-ADJUST_PERCENT_FLOAT(64)) collectionViewLayout:fl];
        _guessCollectView.delegate = self;
        _guessCollectView.dataSource = self;
        _guessCollectView.backgroundColor = ZJCOLOR.color_c12;
        _guessCollectView.scrollEnabled = NO;
    }
    return _guessCollectView;
}

- (NSArray *)seactionArr {
    if (!_seactionArr) {
        _seactionArr = [NSArray array];
        _seactionArr = @[@"商品信息",@"交易流程"];
    }
    return _seactionArr;
}

- (NSArray *)seactioncontenArr {
    if (!_seactioncontenArr) {
        _seactioncontenArr = [NSArray array];
    }
    return _seactioncontenArr;
}

/**
 交易流程弹出视图
 */
- (YBGoodsDeatilPresentFromboomView *)presentformboomView {
    if (!_presentformboomView) {
        _presentformboomView = [[YBGoodsDeatilPresentFromboomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT + ADJUST_PERCENT_FLOAT(PRESENTVIEWFROMBOOMHEIGHT), SCREEN_WIDTH, ADJUST_PERCENT_FLOAT(PRESENTVIEWFROMBOOMHEIGHT))];
        
    }
    return _presentformboomView ;
}

- (ZJBaseView *)presentformboomBackView {
    if (!_presentformboomBackView) {
        _presentformboomBackView = [[ZJBaseView alloc]initWithFrame:self.view.bounds];
        _presentformboomBackView.alpha = 0.0;
        _presentformboomBackView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickpresentbackview:)];
        [_presentformboomBackView addGestureRecognizer:tap];
    }
    return _presentformboomBackView ;
}

/**
 底部的状态条
 */
- (YBGoodsDeatilBoomBarView *)boomBarView {
    if (!_boomBarView) {
        _boomBarView = [[YBGoodsDeatilBoomBarView alloc]init];
        _boomBarView.backgroundColor = [UIColor whiteColor];
    }
    return _boomBarView;
}

/**
 猜你喜欢的 模型数组
 */
- (NSMutableArray *)goodListArray {
    if (!_goodListArray) {
        _goodListArray = [NSMutableArray array];
    }
    return _goodListArray;
}


#pragma mark  ***  导航栏上的字控件
/**
 关闭btn
 */
- (YBDefaultButton *)MyNaviViewColseBtn {
    if (!_MyNaviViewColseBtn) {
        _MyNaviViewColseBtn = [YBDefaultButton buttonImageWithImageFilePath:IMAGEFILEPATH_PUBLIC
                                                                 imageNamed:@"public_back"
                                                                       type:ZJProjectButtonSetImageDefault
                                                                     target:self
                                                                   selector:@selector(clickNaviItemsWithTag:)];
        _MyNaviViewColseBtn.tag  = 102;
    }
    return _MyNaviViewColseBtn;
}

/**
 分享
 */
- (YBDefaultButton *)MyNaviViewShareBtn {
    if (!_MyNaviViewShareBtn) {
        _MyNaviViewShareBtn = [YBDefaultButton buttonImageWithImageFilePath:IMAGEFILEPATH_DETAIL
                                                                 imageNamed:@"details_navshare"
                                                                       type:ZJProjectButtonSetImageDefault
                                                                     target:self
                                                                   selector:@selector(clickNaviItemsWithTag:)];
        _MyNaviViewShareBtn.tag  = 100;
    }
    return _MyNaviViewShareBtn;
}

/**
 更多
 */
- (YBDefaultButton *)MyNaviViewMoreBtn {
    if (!_MyNaviViewMoreBtn) {
        _MyNaviViewMoreBtn = [YBDefaultButton buttonImageWithImageFilePath:IMAGEFILEPATH_DETAIL
                                                                imageNamed:@"details_more"
                                                                      type:ZJProjectButtonSetImageDefault
                                                                    target:self
                                                                  selector:@selector(clickNaviItemsWithTag:)];
        _MyNaviViewMoreBtn.tag = 101;
    }
    return _MyNaviViewMoreBtn;
}
/**
 标题
 */
- (YBDefaultLabel *)MyNaviViewTitleLable {
    if (!_MyNaviViewTitleLable) {
        _MyNaviViewTitleLable = [YBDefaultLabel labelWithFont:SYSTEM_REGULARFONT(18)
                                                         text:@""
                                                    textColor:ZJCOLOR.color_c2];
        _MyNaviViewTitleLable.textAlignment = NSTextAlignmentCenter;
        _MyNaviViewTitleLable.text = @"详情";
    }
    return _MyNaviViewTitleLable;
}

/**
 导航栏的覆盖视图
 */
- (ZJBaseView *)MyNaviCoverView {
    if (!_MyNaviCoverView) {
        _MyNaviCoverView =  [[ZJBaseView alloc]init];
        
        self.MyNaviCoverViewUserImageView = [[UIImageView alloc]init];
        self.MyNaviCoverViewUserImageView.layer.cornerRadius = ADJUST_PERCENT_FLOAT(17);
        self.MyNaviCoverViewUserImageView.layer.masksToBounds = YES;
        [_MyNaviCoverView addSubview:self.MyNaviCoverViewUserImageView];
        
        self.MyNaviCoverViewUserNameLable = [YBDefaultLabel labelWithFont:SYSTEM_LIGHTFONT(14)
                                                                     text:@""
                                                                textColor:ZJCOLOR.color_c4];
        self.MyNaviCoverViewUserNameLable.text = @"test";
        [_MyNaviCoverView addSubview:self.MyNaviCoverViewUserNameLable];
        
        self.MyNaviCoverViewPriceLable = [YBAttributedStringLabel labelWithFont:SYSTEM_MEDIUMFONT(18)
                                                                  text:@""
                                                             textColor:ZJCOLOR.color_c6];
        self.MyNaviCoverViewPriceLable.textAlignment = NSTextAlignmentRight;
        [_MyNaviCoverView addSubview:self.MyNaviCoverViewPriceLable];
        
        [self.MyNaviCoverViewUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_MyNaviCoverView).mas_offset(ADJUST_PERCENT_FLOAT(15));
            make.top.mas_equalTo(_MyNaviCoverView).mas_offset(ADJUST_PERCENT_FLOAT(3) + 22);
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(34), ADJUST_PERCENT_FLOAT(34)));
        }];
        
        [self.MyNaviCoverViewUserNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.MyNaviCoverViewUserImageView.mas_right).mas_offset(ADJUST_PERCENT_FLOAT(10));
            make.top.mas_equalTo(self.MyNaviCoverViewUserImageView.mas_top);
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(100), ADJUST_PERCENT_FLOAT(34)));
        }];
        [self.MyNaviCoverViewPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.MyNaviCoverViewUserNameLable.mas_right).mas_offset(ADJUST_PERCENT_FLOAT(10));
            make.top.mas_equalTo(self.MyNaviCoverViewUserImageView.mas_top);
            make.right.mas_equalTo(_MyNaviCoverView).mas_offset(ADJUST_PERCENT_FLOAT(-10));
            make.height.mas_equalTo(self.MyNaviCoverViewUserNameLable.mas_height);
        }];
        
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor =  ZJCOLOR.color_c16;
        [_MyNaviCoverView addSubview:lineview];
        
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_MyNaviCoverView.mas_bottom).mas_offset(ADJUST_PERCENT_FLOAT(0));
            make.right.left.mas_equalTo(_MyNaviCoverView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _MyNaviCoverView;
}
/**
 类似原生导航栏的控件
 */

- (ZJBaseView *)MyNaviView {
    if (!_MyNaviView) {
        _MyNaviView = [[ZJBaseView alloc]init];
        
        [_MyNaviView addSubview:self.MyNaviViewColseBtn];
        [_MyNaviView addSubview:self.MyNaviViewMoreBtn];
        [_MyNaviView addSubview:self.MyNaviViewShareBtn];
        [_MyNaviView addSubview:self.MyNaviViewTitleLable];
        
        [self.MyNaviViewColseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_MyNaviView).mas_offset(ADJUST_PERCENT_FLOAT(12));
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(28), ADJUST_PERCENT_FLOAT(28)));
            make.top.mas_equalTo(_MyNaviView).mas_offset(ADJUST_PERCENT_FLOAT(31));
        }];
        
        [self.MyNaviViewMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_MyNaviView).mas_offset(ADJUST_PERCENT_FLOAT(-12));
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(28), ADJUST_PERCENT_FLOAT(28)));
            make.centerY.mas_equalTo(self.MyNaviViewColseBtn.centerY);
        }];
        
        [self.MyNaviViewShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.MyNaviViewMoreBtn.mas_left).mas_offset(ADJUST_PERCENT_FLOAT(-22));
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(28), ADJUST_PERCENT_FLOAT(28)));
            make.centerY.mas_equalTo(self.MyNaviViewColseBtn.centerY);
        }];
        [self.MyNaviViewTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(ADJUST_PERCENT_FLOAT(60), ADJUST_PERCENT_FLOAT(28)));
            make.centerX.mas_equalTo(_MyNaviView);
            make.centerY.mas_equalTo(self.MyNaviViewColseBtn.centerY);
        }];
        
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor =  ZJCOLOR.color_c16;
        [_MyNaviView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_MyNaviView.mas_bottom).mas_offset(ADJUST_PERCENT_FLOAT(0));
            make.right.left.mas_equalTo(_MyNaviView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _MyNaviView;
}

- (UIView *)guessCollectBackView {
    if (!_guessCollectBackView) {
        _guessCollectBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -ADJUST_PERCENT_FLOAT(64))];
        _guessCollectBackView.backgroundColor = ZJCOLOR.color_c12;
    }
    return _guessCollectBackView;
}

- (NSMutableArray *)imageUrlStringArray {
    if (!_imageUrlStringArray) {
        _imageUrlStringArray = [NSMutableArray array];
    }
    return _imageUrlStringArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = ZJCOLOR.color_c12;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
/**
 流程图
 */
- (UIImageView *)liuchengView {
    if (!_liuchengView) {
        _liuchengView = [[UIImageView alloc]init];
        _liuchengView.image = [UIImage imageNamed:@"details_deal_bg"];
    }
    return _liuchengView;
}

@end