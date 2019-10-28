//
//  ViewController.m
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/8.
//  Copyright © 2019 泽泽. All rights reserved.
//
#define Resource_url @"https://codeload.github.com/zezefamily/playlist/zip/master"

#import "ViewController.h"
#import "LivePlayViewController.h"
#import "JXHFileManager.h"
#import "ZipArchive.h"
#import "ZZPlayModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listArray;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    XXLog(@"path == %@",[JXHFileManager documentDirPath]);
    [self.view addSubview:self.tableView];
    [self loadData];
}
- (UITableView *)tableView
{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewDidLayoutSubviews
{
//    _tableView mas_makeConstraints:<#^(MASConstraintMaker *make)block#>
}
#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    ZZPlayModel *item = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",item.group_title];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZPlayModel *item = [self.listArray objectAtIndex:indexPath.row];
    LivePlayViewController *livePlayVC = [[LivePlayViewController alloc]init];
    livePlayVC.liveData = item;
    [self presentViewController:livePlayVC animated:YES completion:nil];
}
#pragma mark - 初始化数据
- (void)loadData
{
    self.listArray = [NSMutableArray array];
    NSString *filePath = [[JXHFileManager documentDirPath]stringByAppendingString:@"/playlist-master/playlist.json"];
    if([JXHFileManager fileExistsAtPath:filePath]){
        NSDictionary *data = [self readLocalFile];
        NSArray *list = [data safe_objectForKey:@"data"];
        self.listArray = [ZZPlayModel mj_objectArrayWithKeyValuesArray:list];
        [self.tableView reloadData];
    }else{
        [self reloadList];
    }
}
- (NSDictionary *)readLocalFile {
    // 获取文件路径
    NSString *path = [[JXHFileManager documentDirPath]stringByAppendingString:@"/playlist-master/playlist.json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)errorList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"playList" ofType:@"plist"];
    NSDictionary *playlist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *data = (NSArray *)[playlist objectForKey:@"data"];
    self.listArray = [ZZPlayModel mj_objectArrayWithKeyValuesArray:data];
    [self.tableView reloadData];
}
#pragma mark - 刷新
- (void)reloadList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.listArray removeAllObjects];
    NSString *unZipPath = [JXHFileManager documentDirPath];
    NSString *fileSavePath = [[JXHFileManager documentDirPath]stringByAppendingString:@"/playlist.zip"];
    [self downloadResourceWithSavePath:fileSavePath progress:^(NSProgress * _Nonnull downloadProgress) {
        XXLog(@"completed == %lld,total == %lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, NSString * _Nullable savePath, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error){
            NSError *unzipError = nil;
            [SSZipArchive unzipFileAtPath:fileSavePath toDestination:unZipPath overwrite:YES password:nil error:&unzipError];
            if(!unzipError){
                XXLog(@"unzip finish");
                NSDictionary *data = [self readLocalFile];
                NSArray *list = [data safe_objectForKey:@"data"];
                self.listArray = [ZZPlayModel mj_objectArrayWithKeyValuesArray:list];
                [self.tableView reloadData];
            }else{
                XXLog(@"error === %@",unzipError);
            }
        }else{
            XXLog(@"error === %@",error);
        }
    }];
}
#pragma mark - 文件下载
- (void)downloadResourceWithSavePath:(NSString *)savePath progress:(void(^)(NSProgress * _Nonnull downloadProgress))porgress completionHandler:(void(^)(NSURLResponse * _Nonnull response, NSString * _Nullable savePath, NSError * _Nullable error))completionHandler
{
    if([JXHFileManager fileExistsAtPath:savePath]){
        [JXHFileManager removeFileWithPath:savePath];
    }
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Resource_url]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        porgress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response,filePath.absoluteString,error);
    }];
    [task resume];
}

@end
