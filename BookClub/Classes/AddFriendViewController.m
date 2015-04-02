//
//  AddFriendViewController.m
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AddFriendViewController.h"
#import "Person.h"

@interface AddFriendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *friendsArray;
@property Person *person;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriends];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Person *person = [self.friendsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    if ([self.person.friends containsObject:person]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *selected = [self.friendsArray objectAtIndex:indexPath.row];
    if ([self.person.friends containsObject:selected]) {
        [self.person removeFriendsObject:selected];
    } else {
        [self.person addFriendsObject:selected];
    }
    [self.moc save:nil];
    [self.tableView reloadData];
}

#pragma mark - Actions
- (void)loadFriends {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];
    request.predicate = [NSPredicate predicateWithFormat:@"name != %@", @"Friend"];
    self.friendsArray = [self.moc executeFetchRequest:request error:nil];

    if (self.friendsArray.count == 0) {
        [self getData];
    }

    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Friend"];
    NSArray *personArray = [self.moc executeFetchRequest:request error:nil];
    self.person = personArray.firstObject;
    [self.tableView reloadData];
}

- (void)getData {
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *friends = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    Person *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.moc];
    person.name = @"Friend";

    NSMutableArray *personArray = [NSMutableArray new];
    for (NSString *personName in friends) {
        Person *newPerson  = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.moc];
        newPerson.name = personName;
        [personArray addObject:newPerson];
    }
    self.friendsArray = personArray;
    [self.moc save:nil];
}



@end
