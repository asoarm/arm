#import "SettingsController.h"
#import "Util.h"
#import "FolderController.h"
#import "MainViewController.h"
#import "FMDatabase.h"

typedef enum {
    LinkRow,
    UnlinkRow,
    AccountRow
} RowType;

@interface SettingsController () <UIActionSheetDelegate>

@property (nonatomic, readonly) DBAccountManager *manager;
@property (nonatomic, copy) void(^navigationBlock)() ;
@property (nonatomic, assign) int i;

@end


@implementation SettingsController

- (id)initWithNavigationBlock:(void (^)())navigationBlock
{
    if (!(self = [super initWithStyle:UITableViewStyleGrouped])) return nil;

    self.title = @"Settings";
    self.navigationBlock = navigationBlock;
    __weak SettingsController *weakSelf = self;
    
    [self.manager addObserver:self block: ^(DBAccount *account) {
        [weakSelf accountUpdated:account];
    }];

    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self initWithNavigationBlock:nil];
}

- (id)init {
   return [self initWithNavigationBlock:nil];
}

- (void)dealloc {
    [self.manager removeObserver:self];
}

-(void)viewDidLoad{
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithTitle:@"戻る"
     style:UIBarButtonItemStylePlain
     target:self action:@selector(didPressBack)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithTitle:@"データ削除"
     style:UIBarButtonItemStylePlain
     target:self action:@selector(didPressDelete)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.manager.linkedAccounts count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == (NSInteger)[self.manager.linkedAccounts count] ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    cell.textLabel.textAlignment = DBX_ALIGN_CENTER;
    cell.accessoryType = UITableViewCellAccessoryNone;

    switch ([self rowTypeForIndexPath:indexPath]) {
        case AccountRow: {
            NSString *text = @"Dropbox";
            DBAccountInfo *info = [self accountForSection:[indexPath section]].info;
            if (info) {
                text = info.displayName;
            }

            cell.textLabel.text = text;
            cell.textLabel.textAlignment = DBX_ALIGN_LEFT;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case LinkRow:
            cell.textLabel.text = @"Link";
            break;
        case UnlinkRow:
            cell.textLabel.text = @"Unlink";
            break;
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self rowTypeForIndexPath:indexPath]) {
        case AccountRow: {
            DBAccount *account = [self accountForSection:[indexPath section]];
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [self showDataForAccount:account fileSystem:filesystem];
            break;
        }
        case LinkRow:
            [self didPressAdd];
            break;
        case UnlinkRow:
            [[self accountForSection:[indexPath section]] unlink];
            break;
    }
}

- (void)showDataForAccount:(DBAccount *)account fileSystem:(DBFilesystem *)filesystem
{
    // Override in subclass
}

- (void)didPressAdd {
    [self.manager linkFromController:self.navigationController];
}


#pragma mark - private methods

- (DBAccountManager *)manager {
    return [DBAccountManager sharedManager];
}

- (void)reload {
    [self.tableView reloadData];
}

- (void)accountUpdated:(DBAccount *)account {
    if (!account.linked && [self.currentAccount isEqual:account]) {
        [self.navigationController popToViewController:self animated:YES];
        Alert(@"Your account was unlinked!", nil);
/*  } else if (!account.linked && [_accounts containsObject:account]) {
        NSInteger index = [_accounts indexOfObject:account];
        [_accounts removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
 */
    } else {
        [self reload];
    }
}

- (DBAccount *)accountForSection:(NSInteger)section {
    return [self.manager.linkedAccounts objectAtIndex:section];
}

- (DBAccount *)currentAccount {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers count] < 2) return nil;

    id<FolderController> folderController =
        (id<FolderController>)[viewControllers objectAtIndex:1];
    return folderController.account;
}

- (RowType)rowTypeForIndexPath:(NSIndexPath *)indexPath {
    NSArray *linkedAccounts = self.manager.linkedAccounts;
    if (!linkedAccounts || [indexPath section] == (NSInteger)[linkedAccounts count]) {
        return LinkRow;
    } else if ([indexPath row] == 1) {
        return UnlinkRow;
    } else {
        return AccountRow;
    }
}

-(void)didPressBack{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self presentViewController:mainViewController animated:YES completion:nil];
}

-(void)didPressDelete{
    _i = 0;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                             initWithTitle:@"全データを削除しますか?" message:nil delegate:self
                             cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        _i = _i + 1;
        if(_i == 1){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"本当によろしいですか?" message:nil delegate:self
                                      cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            [alertView show];
        }else if(_i == 2){
            [self deleteData];
        }
    }
}

- (void)deleteData{
    //データ削除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //テーブル作成
    NSString    *sql = @"Delete from Survey;";
    NSString    *sql2 = @"Delete from Question;";
    NSString    *sql3 = @"Delete from QuestionDetail;";
    NSString    *sql4 = @"Delete from Choice;";
    NSString    *sql5 = @"Delete from Enterprise;";
    NSString    *sql6 = @"Delete from Section;";
    NSString    *sql7 = @"Delete from Comment;";
    NSString    *sql8 = @"Delete from Answer;";
    [db executeUpdate:sql];
    [db executeUpdate:sql2];
    [db executeUpdate:sql3];
    [db executeUpdate:sql4];
    [db executeUpdate:sql5];
    [db executeUpdate:sql6];
    [db executeUpdate:sql7];
    [db executeUpdate:sql8];
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"データを削除しました"
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
}
@end
