//
//  ViewController.m
//  MQTest2
//
//  Created by CC on 16/8/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "ViewController.h"
#import <RMQClient/RMQClient.h>
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"示例%ld",(long)indexPath.row+1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"segue1" sender:nil];
    }
}
@end
