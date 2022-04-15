//
//  ViewController.m
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 12/4/22.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "APIService.h"
@interface ViewController (){
    APIService *apiservice;
    NSArray<QTEntry *> *entryList;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    apiservice = [[APIService alloc] init];
    entryList = [[NSArray alloc]init];
    [apiservice apiToGetData:^(NSArray<QTEntry *> *entries) {
        self->entryList = entries;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.reloadData;
        });
        
        
    }];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.apiName.text = entryList[indexPath.row].api;
    cell.apiDescription.text = entryList[indexPath.row].entryDescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return entryList.count;
}
@end
