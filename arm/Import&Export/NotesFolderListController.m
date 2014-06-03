#import "NotesFolderListController.h"
#import "NoteController.h"
#import "Util.h"
#import "InExVC.h"

@interface NotesFolderListController () <UIActionSheetDelegate>

@property (nonatomic, retain) DBFilesystem *filesystem;
@property (nonatomic, retain) DBPath *root;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) DBPath *fromPath;
@property (nonatomic, retain) UITableViewCell *loadingCell;
@property (nonatomic, assign) BOOL loadingFiles;
@property (nonatomic, assign) NSString *iden;
@property (nonatomic, assign) BOOL importFiles;
@property (nonatomic, retain) DBFile *fileI;
@property (nonatomic, retain) NSString *filename;
@end


@implementation NotesFolderListController

- (id)initWithFilesystem:(DBFilesystem *)filesystem root:(DBPath *)root {
    if ((self = [super init])) {
        self.filesystem = filesystem;
        self.root = root;
        self.navigationItem.title = [root isEqual:[DBPath root]] ? @"Dropbox" : [root name];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_filesystem removeObserver:self];
}


#pragma mark - UIViewController methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak NotesFolderListController *weakSelf = self;
    [_filesystem addObserver:self block:^() { [weakSelf reload]; }];
    [_filesystem addObserver:self forPathAndChildren:self.root block:^() { [weakSelf loadFiles]; }];
    [self.navigationController setToolbarHidden:NO];
    [self loadFiles];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_filesystem removeObserver:self];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_contents) return 1;

    return [_contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_contents) {
        return self.loadingCell;
    }

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    DBFileInfo *info = [_contents objectAtIndex:[indexPath row]];
    cell.textLabel.text = [info.path name];
    if (info.isFolder) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {

    DBFileInfo *info = [_contents objectAtIndex:[indexPath row]];
    if ([_filesystem deletePath:info.path error:nil]) {
        [_contents removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        Alert(@"Error", @"There was an error deleting that file.");
        [self reload];
    }
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((NSInteger)[_contents count] <= [indexPath row]) return;
    
    _importFiles = YES;
    DBFileInfo *info = [_contents objectAtIndex:[indexPath row]];
    DBFile *file = [_filesystem openFile:info.path error:nil];
    _fileI = file;
    _filename = [info.path name];
    if (!file) {
        Alert(@"Error", @"There was an error opening your note");
        return;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
        initWithTitle:@"Importしますか?" message:nil delegate:self
        cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alertView show];
    }
}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case 0:{
                _iden = @"Survey";
                NSString *title = @"Export Survey?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 1:{
                _iden = @"Question";
                NSString *title = @"Export Question?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 2:{
                _iden = @"QuestionDetail";
                NSString *title = @"Export QuestionDetail?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 3:{
                _iden = @"Choice";
                NSString *title = @"Export Choice?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 4:{
                _iden = @"Comment";
                NSString *title = @"Export Comment?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 5:{
                _iden = @"Enterprise";
                NSString *title = @"Export Enterprise?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 6:{
                _iden = @"Section";
                NSString *title = @"Export Section?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
            case 7:{
                _iden = @"Answer";
                NSString *title = @"Export Answer?";
                UIAlertView *alertView =
                [[UIAlertView alloc]
                 initWithTitle:title message:nil delegate:self
                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export", nil];
                [alertView show];
                break;
            }
        }
    }
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_importFiles){
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self importFile];
        }
        [_fileI close];
    }else{
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self createAt];
        }
    }
    _importFiles = NO;
    self.fromPath = nil;
    [self loadFiles];
}


#pragma mark - private methods

//NSInteger sortFileInfos(id obj1, id obj2, void *ctx) {
//    return [[obj1 path] compare:[obj2 path]];
//}

- (void)loadFiles {
    if (_loadingFiles) return;
    _loadingFiles = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
        NSArray *immContents = [_filesystem listFolder:_root error:nil];
        NSMutableArray *mContents = [NSMutableArray arrayWithArray:immContents];
//        [mContents sortUsingFunction:sortFileInfos context:NULL];
        dispatch_async(dispatch_get_main_queue(), ^() {
            self.contents = mContents;
            _loadingFiles = NO;
            [self reload];
        });
    });
}

- (void)reload {
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    target:self action:@selector(didPressAction)];
}

- (void)didPressAction {
    _importFiles = NO;
    UIActionSheet *actionSheet =
        [[UIActionSheet alloc]
         initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
         otherButtonTitles:@"Export Survey",@"Export Question",@"Export QuestionDetail",@"Export Choice",@"Export Comment",@"Export Enterprise",@"Export Section",@"Export Answer", nil];
    [actionSheet showInView:self.navigationController.view];
}

- (void)didPressCancel {
    [self reload];
}

- (void)createAt {
    NSString *noteFilename = [NSString stringWithFormat:@"%@.csv",_iden];
    DBPath *path = [_root childPath:noteFilename];
    DBFile *file = [_filesystem createFile:path error:nil];
    InExVC *inexvc = [[InExVC alloc]init];
    NSMutableString *all;
    if([_iden isEqualToString:@"Survey"]){
        all = [inexvc survey_export];
    }else if([_iden isEqualToString:@"Question"]){
        all = [inexvc question_export];
    }else if([_iden isEqualToString:@"QuestionDetail"]){
        all = [inexvc question_d_export];
    }else if([_iden isEqualToString:@"Choice"]){
        all = [inexvc choice_export];
    }else if([_iden isEqualToString:@"Comment"]){
        all = [inexvc comment_export];
    }else if([_iden isEqualToString:@"Enterprise"]){
        all = [inexvc enterprise_export];
    }else if([_iden isEqualToString:@"Section"]){
        all = [inexvc section_export];
    }else if([_iden isEqualToString:@"Answer"]){
        all = [inexvc answer_export];
    }
    [file writeString:all error:nil];
    if (!file) {
        Alert(@"ファイルが作成されませんでした", @"既にファイルが作成されています");
    }
}

-(void)importFile {
    InExVC *inexvc = [[InExVC alloc]init];
    NSString *filestext = [_fileI readString:nil];
    int cnt = 0;
    if([_filename isEqualToString:@"Survey.csv"]){
        cnt = [inexvc survey_import:filestext];
    }else if([_filename isEqualToString:@"Question.csv"]){
        cnt = [inexvc question_import:filestext];
    }else if([_filename isEqualToString:@"QuestionDetail.csv"]){
        cnt = [inexvc question_d_import:filestext];
    }else if([_filename isEqualToString:@"Choice.csv"]){
        cnt = [inexvc choice_import:filestext];
    }else if([_filename isEqualToString:@"Comment.csv"]){
        cnt = [inexvc comment_import:filestext];
    }else if([_filename isEqualToString:@"Enterprise.csv"]){
        cnt = [inexvc enterprise_import:filestext];
    }else if([_filename isEqualToString:@"Section.csv"]){
        cnt = [inexvc section_import:filestext];
    }else if([_filename isEqualToString:@"Answer.csv"]){
        cnt = [inexvc answer_import:filestext];
    }
    
    if(cnt == 0){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"完了しました"
                                  delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"既にデータが入っています"
                                  delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
    }
}

- (DBAccount *)account {
    return _filesystem.account;
}

- (UITableViewCell *)loadingCell {
    if (!_loadingCell) {
        _loadingCell =
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadingCell.textLabel.text = @"Loading...";
        _loadingCell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loadingCell;
}

@end
