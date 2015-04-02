//
//  Comment.h
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentString;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Book *commentedBooks;

@end
