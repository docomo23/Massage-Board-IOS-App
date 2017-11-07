

#import "CreatePostViewController.h"
#import "PostManager.h"
#import "Post.h"

static NSString * const PostTextPlaceHolder = @"Enter your post here...";

@interface CreatePostViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation CreatePostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = NSLocalizedString(@"Post", nil);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"POST", nil) style:UIBarButtonItemStyleDone target:self action:@selector(createPost)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0];
    self.postTextView.delegate = self;
    self.postTextView.text = PostTextPlaceHolder;
    self.postTextView.textColor = [UIColor lightGrayColor];
}

#pragma mark -- action
- (void)createPost
{
    __weak typeof(self) weakSelf = self;
    [PostManager createPostWithMessage:self.postTextView.text andCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Please try again later.", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okButton];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSLog(@"Post created");
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([weakSelf.delegate respondsToSelector:@selector(didCreatePost)]) {
                [weakSelf.delegate didCreatePost];
            }
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PostTextPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor darkTextColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = PostTextPlaceHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end


