//
//  Book.h
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Person;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSData * bookImage;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *suggestor;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addSuggestorObject:(Person *)value;
- (void)removeSuggestorObject:(Person *)value;
- (void)addSuggestor:(NSSet *)values;
- (void)removeSuggestor:(NSSet *)values;

@end
