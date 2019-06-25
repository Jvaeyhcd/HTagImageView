//
//  ViewController.m
//  TagImageView
//
//  Created by Jvaeyhcd on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import "ViewController.h"
#import "HTagModel.h"
#import "HTagViewModel.h"
#import "HMarkedImageView.h"

@interface ViewController ()<HMarkedImageViewDelegate>

@property (nonatomic, strong) HMarkedImageView *markedImageView;

@property (nonatomic, strong) NSMutableArray<HTagViewModel *> *viewModels;

@property (nonatomic, assign) NSInteger deleteIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.markedImageView];
    [self setupTestData];
}

#pragma mark - test data

- (void)setupTestData {
    HTagModel *model1 = [[HTagModel alloc] initWithName:@"Mar" value:@"11"];
    HTagModel *model2 = [[HTagModel alloc] initWithName:@"Mar" value:@"11"];
    HTagModel *model3 = [[HTagModel alloc] initWithName:@"Mar" value:@"11"];

    HTagViewModel *viewModel = [[HTagViewModel alloc] initWithTagModels:@[model1, model2, model3].mutableCopy coordinate:CGPointMake(0.7, 0.5)];
    
    //test data
    HTagModel *model4 = [[HTagModel alloc] initWithName:@"悬崖" value:@""];

    HTagViewModel *viewModel1 = [[HTagViewModel alloc] initWithTagModels:@[model4].mutableCopy coordinate:CGPointMake(0.6, 0.75)];
    viewModel1.style = HTagViewStyleObliqueLeft;
    
    //data array
    _viewModels = [[NSMutableArray alloc] initWithObjects:viewModel, viewModel1, nil];
    
    [self showMarkedImageView];
}

#pragma mark - getter/setter

- (HMarkedImageView *)markedImageView {
    if (!_markedImageView) {
        UIImage *image = [UIImage imageNamed:@"cloud"];
        _markedImageView = [[HMarkedImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * image.size.height / image.size.width)];
        _markedImageView.y = (SCREEN_HEIGHT - _markedImageView.height) / 2;
        _markedImageView.image = image;
        _markedImageView.contentMode = UIViewContentModeScaleAspectFill;
        _markedImageView.delegate = self;
        _markedImageView.editable = YES;
    }
    return _markedImageView;
}

#pragma mark - private
- (void)showMarkedImageView {
    [self.markedImageView createTagView:self.viewModels];
    [self.markedImageView showTagViews];
}

#pragma mark - HMarkedImageViewDelegate

- (void)didTapMarkedImage:(HTagViewModel *)viewModel {
    
}

- (void)deleteTagView:(HTagViewModel *)viewModel {
    
}

@end
