//
//  NSDataAddition.h
//  DoubanAlbum
//
//  modify from Three20 by Tonny on 6/5/11.
//  Copyright 2012 SlowsLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Addition) 

- (NSString*) stringWithHexBytes1;

- (NSString*) stringWithHexBytes2;
@property (nonatomic, readonly) NSString* md5Hash;

@end
