#import <UIKit/UIKit.h>#import "prefrenceHeader.h"#import "UIImageView+imageSizeOperation.h"#define kCellHeigh 64@interface myTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>@property(nonatomic,strong)NSMutableArray *dataList;@property(nonatomic,strong)UITableView *tableView;-(void)createModels;-(NSString *)tips;@end