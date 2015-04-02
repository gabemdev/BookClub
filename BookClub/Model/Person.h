//
//  Person.h
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Person;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSData * friendImage;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *suggestions;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Person *)value;
- (void)removeFriendsObject:(Person *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addSuggestionsObject:(Book *)value;
- (void)removeSuggestionsObject:(Book *)value;
- (void)addSuggestions:(NSSet *)values;
- (void)removeSuggestions:(NSSet *)values;

@end
