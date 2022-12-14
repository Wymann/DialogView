//
//  HomeViewController.m
//  DialogViewDemo
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <DialogView/DialogDemoViewController.h>

#import <BubbleView/BubbleView-umbrella.h>

#import "HomeViewController.h"

static NSString *const homeReuseIdentifier = @"HomeViewCell";

@interface HomeViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"DialogView Demo";
        [self.view addSubview:self.tableView];
    }
    return self;
}

#pragma mark - Lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:homeReuseIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeReuseIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = indexPath.row == 0 ? @"弹框库 Dialog 示例（Objective-C）" : @"弹框库 Bubble 示例（Swift）";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        DialogDemoViewController *demoVC = [[DialogDemoViewController alloc] init];
        [self.navigationController pushViewController:demoVC animated:YES];
    } else {
//        BubbleDemoViewController *demoVC = [[BubbleDemoViewController alloc] init];
//        [self.navigationController pushViewController:demoVC animated:YES];
    }
}

@end
