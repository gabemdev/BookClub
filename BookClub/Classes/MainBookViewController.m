//
//  MainBookViewController.m
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "MainBookViewController.h"
#import "AddFriendViewController.h"
#import "FriendDetailViewController.h"
#import "AppDelegate.h"
#import "Person.h"

@interface MainBookViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSManagedObjectContext *moc;
@property NSArray *friends;
@property NSArray *filteredFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL isAscending;


@end

@implementation MainBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
    self.isAscending = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFriends];
}

#pragma mark - Helper Methods
- (void)sortFriends:(BOOL)isAscending {
    //http://stackoverflow.com/questions/20531319/coredata-fetch-with-nssortdescriptor-by-count-of-to-many-relationship
    NSSortDescriptor *sortBookCount = [NSSortDescriptor sortDescriptorWithKey:@"suggestions.@count" ascending:isAscending];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedFriends = [[self.person.friends allObjects] sortedArrayUsingDescriptors:@[sortBookCount, sortByName]];
    self.friends = sortedFriends;
    [self.tableView reloadData];
}
- (void)loadFriends {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person description]];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Friend"];
    NSArray *userArray = [self.moc executeFetchRequest:request error:nil];
    self.person = userArray.firstObject;
    [self sortFriends:self.isAscending];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBar.text.length != 0) {
        return self.filteredFriends.count;
    } else {
        return self.friends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *friend;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchBar.text.length != 0) {
        friend = [self.filteredFriends objectAtIndex:indexPath.row];
    } else {
        friend = [self.friends objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Suggested books: %lu", (unsigned long)friend.suggestions.count];

    if (cell.imageView.image == nil) {
        cell.imageView.image = [UIImage imageNamed:@"no-user"];
    } else {
        NSData *imageData = friend.friendImage;
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - TextFieldDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
    self.filteredFriends = [NSMutableArray arrayWithArray:[self.friends filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addFriend"]) {
        AddFriendViewController *vc = segue.destinationViewController;
        vc.moc = self.moc;
    } else if ([segue.identifier isEqualToString:@"friendDetail"]) {
        FriendDetailViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        Person *selectedFriend;
        if (self.searchBar.text.length != 0) {
            selectedFriend = [self.filteredFriends objectAtIndex:[self.tableView indexPathForCell:cell].row];
        } else {
            selectedFriend = [self.friends objectAtIndex:[self.tableView indexPathForCell:cell].row];
        }
        vc.selected = selectedFriend;
    }
}


@end
