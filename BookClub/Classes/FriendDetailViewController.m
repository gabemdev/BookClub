//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Rockstar. on 4/1/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "AddBookViewController.h"
#import "BookDetailViewController.h"
#import "Person.h"
#import "Book.h"

@interface FriendDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
@property (nonatomic) UIImage *selectedImage;
@property NSManagedObjectContext *moc;
@property NSArray *bookArray;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    [singleTap setNumberOfTapsRequired:1];
    singleTap.delegate = self;
    [self.friendImageView addGestureRecognizer:singleTap];
    self.moc = [self.selected managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBooks];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Book *book = [self.bookArray objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title;
    cell.imageView.image = [UIImage imageWithData:book.bookImage];
    return cell;
}

#pragma mark - Helper Methods
- (void)loadBooks {
    self.bookArray = [self.selected.suggestions allObjects];
    self.navigationItem.title = self.selected.name;
    self.suggestionLabel.text = [NSString stringWithFormat:@"%lu Suggestions", (unsigned long)self.bookArray.count];

    self.friendImageView.image = [UIImage imageWithData:self.selected.friendImage];
    self.friendImageView.layer.cornerRadius = self.friendImageView.frame.size.width/2;
    [self.friendImageView sizeToFit];
    self.friendImageView.clipsToBounds = YES;
    [self.tableView reloadData];
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bookDetail"]) {
        BookDetailViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        Book *book = [self.bookArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
        vc.book = book;
    } else {
        UINavigationController *nvc = segue.destinationViewController;
        AddBookViewController *vc = [[AddBookViewController alloc] init];
        vc = nvc.viewControllers[0];
        vc.selected = self.selected;
    }
}

#pragma mark - UIImagePickerDelegate
- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.friendImageView setImage:image];
    self.selectedImage = image;
    self.friendImageView.layer.cornerRadius = self.friendImageView.frame.size.width/2;
    self.friendImageView.layer.masksToBounds = YES;

    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.moc];
    NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
    self.selected.friendImage = imageData;

    [self.selected addFriendsObject:newPerson];
    [self.moc save:nil];


    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)selectPic:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = nil;
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                             delegate:self cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];

    // only add avaliable source to actionsheet
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [actionSheet addButtonWithTitle:@"Photo Library"];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addButtonWithTitle:@"Camera Roll"];
    }

    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];

    [actionSheet showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForPhotoRoll];
        } else {
            [self promptForCamera];
        }
    }
}

@end
