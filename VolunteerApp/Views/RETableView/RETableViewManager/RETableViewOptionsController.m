//
// RETableViewOptionsController.m
// RETableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "RETableViewOptionsController.h"
#import "RETableViewItem.h"
#import "RETableViewManager.h"


@interface RETableViewOptionsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}


@end

@implementation RETableViewOptionsController

- (id)initWithItem:(RETableViewItem *)item options:(NSArray *)options multipleChoice:(BOOL)multipleChoice completionHandler:(void(^)(void))completionHandler
{
    self = [super init];
    if (!self)
        return nil;
    
    self.item = item;
    self.options = options;
    self.title = item.title;
    self.multipleChoice = multipleChoice;
    self.completionHandler = completionHandler;

    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
	// Do any additional setup after loading the view.
    tableView                   = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.height, 320, self.view.height-self.navView.height) style:UITableViewStyleGrouped];
    tableView.dataSource        = self;
    tableView.delegate          = self;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];
    
    
    
    _tableViewManager = [[RETableViewManager alloc] initWithTableView:tableView delegate:self.delegate];
    _mainSection = [[RETableViewSection alloc] init];
    [_tableViewManager addSection:_mainSection];
    
    if (self.style)
        _tableViewManager.style = self.style;
    
    __typeof (&*self) __weak weakSelf = self;
    void (^refreshItems)(void) = ^{
        REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (RETableViewItem *sectionItem in weakSelf.mainSection.items) {
            for (NSString *strValue in item.value) {
                if ([strValue isEqualToString:sectionItem.title])
                    [results addObject:sectionItem.title];
            }
        }
        item.value = results;
    };
    
    void (^addItem)(NSString *title) = ^(NSString *title) {
        UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
        if (!weakSelf.multipleChoice) {
            if ([title isEqualToString:self.item.detailLabelText])
                accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
            for (NSString *strValue in item.value) {
                if ([strValue isEqualToString:title]) {
                    accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
        [_mainSection addItem:[RETableViewItem itemWithTitle:title accessoryType:accessoryType selectionHandler:^(RETableViewItem *selectedItem) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedItem.indexPath];
            if (!weakSelf.multipleChoice) {
                for (NSIndexPath *indexPath in [tableView indexPathsForVisibleRows]) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                for (RETableViewItem *item in weakSelf.mainSection.items) {
                    item.accessoryType = UITableViewCellAccessoryNone;
                }
                selectedItem.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                RERadioItem * __weak item = (RERadioItem *)weakSelf.item;
                item.value = selectedItem.title;
                if (weakSelf.completionHandler)
                    weakSelf.completionHandler();
            } else { // Multiple choice item
                REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
                [tableView deselectRowAtIndexPath:selectedItem.indexPath animated:YES];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (NSString *val in item.value) {
                        if (![val isEqualToString:selectedItem.title])
                            [items addObject:val];
                    }
                    
                    item.value = items;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:item.value];
                    [items addObject:selectedItem.title];
                    item.value = items;
                    refreshItems();
                }
                if (weakSelf.completionHandler)
                    weakSelf.completionHandler();
            }
        }]];
    };
    
    for (RETableViewItem *item in self.options) {
        addItem([item isKindOfClass:[[RERadioItem item] class]] ? item.title : (NSString *)item);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleWithString:@"选项"];
}

@end
