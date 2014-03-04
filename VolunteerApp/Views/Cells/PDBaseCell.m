//
//  PDBaseCell.m
//  QiaoQiaoMovie
//
//  Created by zelong zou on 13-3-22.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "PDBaseCell.h"

@implementation PDBaseCell

- (void)reset
{
    
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style cellID:(NSString*)cellID
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:cellID] ;
    }
    return cell;
}

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style
{
    NSString *cellID = nil;
    if (style == UITableViewCellStyleDefault)
        cellID = @"UITableViewCellStyleDefault";
    else if (style == UITableViewCellStyleValue1)
        cellID = @"UITableViewCellStyleValue1";
    else if (style == UITableViewCellStyleValue2)
        cellID = @"UITableViewCellStyleValue2";
    else if (style == UITableViewCellStyleSubtitle)
        cellID = @"UITableViewCellStyleSubtitle";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:style
                            reuseIdentifier:cellID] ;
    }
    return cell;
}

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSLog(@"cell new");
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(PDBaseCell *)cell reset];
    }
    
    return cell;
}

+ (NSString *)nibName {
    return [self cellIdentifier];
}

+ (UINib *)nib {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}
+ (CGFloat)cellHeight
{
    return 44;
}
@end
