//
//  BookDetailViewController.m
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Book.h"
#import "Comment.h"

@interface BookDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *commentsArray;
@property NSManagedObjectContext *moc;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.book.title;
    self.moc = [self.book managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadComments];
}

#pragma mark - Helper Methods
- (void)loadComments {
    self.commentsArray = [self.book.comments allObjects];
    [self.tableView reloadData];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = [self.commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.commentString;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *date = [NSString stringWithFormat:@"Posted: %@", [dateFormatter stringFromDate:comment.date]];
    cell.detailTextLabel.text = date;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSData *imageData = self.book.bookImage;
    UIImage *headerImge = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImge];
    imageView.frame = CGRectMake(0, 0, tableView.frame.size.width, 150);
    imageView.alpha = .3;


    UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 32)];
    bookTitle.text = [NSString stringWithFormat:@"Author: %@",self.book.title];
    bookTitle.textColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.76 alpha:1.00];
    bookTitle.font = [UIFont fontWithName:@"Avenir-Heavy" size:20];

    UILabel *authort = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, tableView.frame.size.width, 32)];
    authort.text = [NSString stringWithFormat:@"Author: %@",self.book.author];
    authort.textColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.76 alpha:1.00];
    authort.font = [UIFont fontWithName:@"Avenir-Heavy" size:20];



    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 150)];
    [headerView addSubview:imageView];
    [headerView addSubview:bookTitle];
    [headerView addSubview:authort];
    [headerView sendSubviewToBack:imageView];

    return headerView;
}

#pragma mark - Actions
- (IBAction)onAddCommentButtonTapped:(UIBarButtonItem *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Write a comment about %@:", self.book.title]
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        nil;
    }];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       UITextField *alertTextField = alert.textFields.firstObject;
                                                       Comment *newComment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class])
                                                                                                        inManagedObjectContext:self.moc];
                                                       newComment.commentString = alertTextField.text;
                                                       newComment.date = [NSDate date];
                                                       [self.book addCommentsObject:newComment];
                                                       [self.moc save:nil];
                                                       [self loadComments];
                                                   }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
