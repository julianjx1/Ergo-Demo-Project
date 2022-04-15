//
//  ViewController.h
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 12/4/22.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

