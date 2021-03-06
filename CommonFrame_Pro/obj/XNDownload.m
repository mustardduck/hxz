//
//  XNDownload.m
//  CommonFrame_Pro
//
//  Created by 倩 莫 on 15/10/9.
//  Copyright © 2015年 ionitech. All rights reserved.
//

#import "XNDownload.h"

typedef void(^ProgressBlock)(float percent);

@interface XNDownload() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *dataM;

// 文件总长度
@property (nonatomic, assign) long long fileLength;
// 当前下载的文件长度
@property (nonatomic, assign) long long currentLength;

// 回调块代码
@property (nonatomic, copy) ProgressBlock progress;

@end

@implementation XNDownload

- (NSMutableData *)dataM
{
    if (!_dataM) {
        _dataM = [NSMutableData data];
    }
    return _dataM;
}

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress
{
    // 0. 记录块代码
    self.progress = progress;
    
    // 1. request GET
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2. connection
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // 让connection支持多线程，指定代理的工作队列即可
    // NSURLConnection在运行时，运行循环不负责监听代理的具体执行
    [connection setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    // 3. 启动连接
    [connection start];
}

#pragma mark - 代理方法
// 1. 接收到服务器的响应，服务器执行完请求，向客户端回传数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"fileName: %@ 和文件保存名: %@ %lld", _fileName, response.suggestedFilename, response.expectedContentLength);
    // 1. 保存的缓存路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.cachePath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cachePath])
    {//sandbox已经有该文件了
        self.progress(1);
        return;
    }
    
    // 2. 文件总长度
    self.fileLength = response.expectedContentLength;
    // 3. 当前下载的文件长度
    self.currentLength = 0;
    
    // 清空数据
    [self.dataM setData:nil];
}

// 2. 接收数据，从服务器接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 拼接数据
    [self.dataM appendData:data];
    
    // 根据data的长度增加当前下载的文件长度
    self.currentLength += data.length;
    
    float progress = (float)self.currentLength / self.fileLength;
    
    // 判断是否定义了块代码
    if (self.progress) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 强制运行循环执行一次更新
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
            
            self.progress(progress);
        }];
    }
}

// 3. 完成接收
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 将dataM写入沙盒的缓存目录
    // 写入数据，NSURLConnection底层实现是用磁盘做的缓存
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.cachePath])
    {//新建
        
        [self.dataM writeToFile:self.cachePath atomically:YES];
//        [self transformEncodingFromFilePath:_cachePath];

    }
    else
    {//预览
        NSLog(@"sandbox已经有该文件了");
    }
}

//先拓展一下webView处理乱码的方法
- (NSString *)examineTheFilePathStr:(NSString *)str{
    NSStringEncoding *useEncodeing = nil;     //带编码头的如utf-8等，这里会识别出来
    NSString *body = [NSString stringWithContentsOfFile:str usedEncoding:useEncodeing error:nil];     //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug
    if (!body)
    {
        body = [NSString stringWithContentsOfFile:str encoding:0x80000632 error:nil];
    }     //还是识别不到，按GB18030编码再解码一次.
    if (!body)
    {
        body = [NSString stringWithContentsOfFile:str encoding:0x80000631 error:nil];
    }
    return body;//有值代表需要转换  为空表示不需要转换
}

- (void)transformEncodingFromFilePath:(NSString *)filePath{     //调用上述转码方法获取正常字符串
    NSString *body = [self examineTheFilePathStr:filePath];     //转换为二进制
    NSData *data = [body dataUsingEncoding:NSUTF16StringEncoding];     //覆盖原来的文件
    [self.dataM setData:nil];
    [self.dataM appendData:data];
//    [data writeToFile:filePath atomically:YES];     //此时在读取该文件，就是正常格式啦
    [self.dataM writeToFile:self.cachePath atomically:YES];

}

// 4. 出现错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

@end
