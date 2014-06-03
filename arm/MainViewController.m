//
//  AppDelegate.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "MainViewController.h"
#import "FMDatabase.h"
#import "NotesSettingsController.h"
#import <Dropbox/Dropbox.h>

@interface MainViewController ()
@property (nonatomic, retain) SettingsController *settingsController;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ナビゲーションバー非表示
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // NSUserDefaultsの取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // KEY_BOOLの内容を取得し、BOOL型変数へ格納
    BOOL isBool = [defaults boolForKey:@"KEY_BOOL"];
    // isBoolがNOの場合、アラート表示
    if (!isBool) {
        //データベース作成
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
        NSString    *sql = @"CREATE TABLE Survey (sur_id TEXT,sur_name TEXT NOT NULL,sur_division TEXT NOT NULL,PRIMARY KEY(sur_id));";
        NSString    *sql2 = @"CREATE TABLE Question (q_id TEXT,q_name TEXT NOT NULL,PRIMARY KEY(q_id));";
        NSString    *sql3 = @"CREATE TABLE Enterprise (e_id TEXT, e_name TEXT NOT NULL, division TEXT NOT NULL, PRIMARY KEY(e_id));";
        NSString    *sql4 = @"CREATE TABLE Section(e_id TEXT,sec_id TEXT,sec_name TEXT NOT NULL, PRIMARY KEY(e_id,sec_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id));";
        NSString    *sql5 = @"CREATE TABLE Choice (cho_id TEXT, choice1 TEXT NOT NULL, choice2 TEXT NOT NULL, choice3 TEXT, choice4 TEXT, choice5 TEXT, choice6 TEXT, PRIMARY KEY(cho_id));";
        
        NSString    *sql6 = @"CREATE TABLE QuestionDetail (sur_id TEXT, q_id TEXT, qd_id TEXT,qd_name TEXT NOT NULL, cho_kubun TEXT NOT NULL,cho_id TEXT,PRIMARY KEY(sur_id,q_id,qd_id) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(cho_id) REFERENCES Choice(cho_id));";

        NSString    *sql7 = @"CREATE TABLE Answer (sur_id TEXT, q_id TEXT, qd_id TEXT,e_id TEXT,sec_id TEXT,ans_date NUMERIC,answerer TEXT NOT NULL,charge TEXT NOT NULL,ans_cho TEXT,ans_str TEXT,memo TEXT,PRIMARY KEY(sur_id,q_id,qd_id,e_id,sec_id,ans_date) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(qd_id) REFERENCES QuestionDetail(qd_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id),FOREIGN KEY(sec_id) REFERENCES Section(sec_id));";
        
        NSString    *sql8 = @"create table Comment (sur_id TEXT not null,q_id TEXT not null,qd_id TEXT not null,e_id TEXT not null,comment TEXT,primary key (sur_id,q_id,qd_id,e_id),foreign key (sur_id) references Survey (sur_id),foreign key (q_id) references Question (q_id),foreign key (qd_id) references QuestionDetail (sur_id),foreign key (e_id) references Enterprise (e_id));";
            
        NSString    *sql9 =@"CREATE TABLE Temporary (sur_id TEXT, q_id TEXT, qd_id TEXT,e_id TEXT,sec_id TEXT,ans_date NUMERIC,answerer TEXT NOT NULL,charge TEXT NOT NULL,ans_cho TEXT,ans_str TEXT,memo TEXT,PRIMARY KEY(sur_id,q_id,qd_id,e_id,sec_id,ans_date) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(qd_id) REFERENCES QuestionDetail(qd_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id),FOREIGN KEY(sec_id) REFERENCES Section(sec_id));";
            
        [db executeUpdate:sql];
        [db executeUpdate:sql2];
        [db executeUpdate:sql3];
        [db executeUpdate:sql4];
        [db executeUpdate:sql5];
        [db executeUpdate:sql6];
        [db executeUpdate:sql7];
        [db executeUpdate:sql8];
        [db executeUpdate:sql9];
        //survey
        NSString*   sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Survey VALUES ('SUR0001','実態調査','行政');"];
        [db executeUpdate:sqlinsert];
        //question
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00001','文書管理基準・ルールについての確認');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00002','配架ルールについての確認');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00003','文書の保有期間の設定について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00004','ファイリングについて');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00005','その他確認事項');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00006','ファイル移管について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00007','廃棄手続きについて');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00008','文書保管庫の管理について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00009','外部保管庫について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00010','電子化について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Question VALUES ('Q00011','現状の文書管理全般について');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00001','QD01','御市（町・村)文書分類表以外に独自の基準がありますか','cho','CHO000001');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00001','QD02','文書分類のどの分類を主に使用しますか','cho','CHO000002');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00002','QD01','課（または係）独自の配架ルールはありますか','cho','CHO000001');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00003','QD01','文書保有期間の設定ルールはありますか。ない場合は、今までの設定基準はどうしていましたか','cho','CHO000001');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00003','QD02','リテンションスケジュール（法務室○年・書庫○年）','str','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00004','QD01','ファイルのタイトル付けの標準的なルールなどはありますか','cho','CHO000001');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00004','QD02','ファイルの作成方法（綴り方、使用サプライ等）のルールはありますか','cho','CHO000001');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00005','QD01','書類管理作業のご担当者はどなたですか','cho','CHO000003');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00005','QD02','キャビネット及び書庫のレイアウトは適切ですか','cho','CHO000004');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00005','QD03','執務室以外に文書を保管していますか','cho','CHO000005');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00005','QD04','合併前の旧市町村名・旧課名はなんですか（市町村合併が行われた場合）','str','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00005','QD05','目的の文書をどのような方法で検索から取出しまでにどの程度時間がかかりますか','cho','CHO000006');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00006','QD01','保管庫・書庫へのファイル移管はどうしていますか','cho','CHO000007');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00006','QD02','執務室内に本来文書庫に移管すべき年度のファイルはありますか','cho','CHO000008');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00007','QD01','文書の廃棄手続き・作業はどうしていますか','cho','CHO000009');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00007','QD02','個人情報の破棄処理は適切に行われていますか','cho','CHO000010');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00007','QD03','保存期間満了を迎えた文書の破棄・延長判断はどうしていますか','cho','CHO000011');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00008','QD01','保存庫・書庫の管理はどうしていますか','cho','CHO000012');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00008','QD02','収納している文書の所在管理を行っていますか','cho','CHO000013');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00008','QD03','文書を閲覧する場合、文書の取り出し、返却の決まりはありますか','cho','CHO000014');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00008','QD04','重要文書の保存について、セキュリティ対策を行っていますか。','cho','CHO000013');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00009','QD01','外部保存庫等の利活用を検討していますか','cho','CHO000015');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00010','QD01','文書や図面の電子化を実施していますか（過去に電子化されたデータを保存している場合を含む）','cho','CHO000016');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO QuestionDetail VALUES ('SUR0001','Q00011','QD01','要望・改善点・問題点などはありますか？','str','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000001','ある','ない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000002','大','中','小','大・中・小どれもよく使用する','よくわからない','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000003','文書管理担当者','その他職員','個人（決まっていない）','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000004','適切である','適切でない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000005','保存している','保存していない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000006','システム上で所在を確認','台帳を使用して検索','保管場所で直接検索','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000007','定期的に','年末などに自動的に','課の習慣で','その都度','人事移動の際に','事務室に保管年度を決めて');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000008','ある','ない','分からない','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000009','課のルール','文書管理規定','個人判断（決まっていない）','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000010','行われている','行われていない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000011','課の文書管理担当者','課長判断','担当者判断','課全員で判断','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000012','担当者管理','その都度やれる人が整理','総務課が管理','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000013','行っている','行っていない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000014','決まりあり','決まりなし','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000015','検討している','検討していない','','','','');"];
        [db executeUpdate:sqlinsert];
        sqlinsert = [ NSString stringWithFormat : @"INSERT INTO Choice VALUES ('CHO000016','実施している','実施していない','','','','');"];
        [db executeUpdate:sqlinsert];
        
        [db close];
        // KEY_BOOLにYESを設定
        [defaults setBool:YES forKey:@"KEY_BOOL"];
        // NSUserDefaultsに保存する
        [defaults setInteger:10001 forKey:@"KEY_I"];
        // 設定を保存
        [defaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)data:(id)sender
{
    _settingsController = [[NotesSettingsController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
