//
//  FHFilterFileManager.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/19.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHFilterFileManager.h"
#import "FHMediaComponent.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVAsset2MvidResourceLoader.h"
#import "AVFileUtil.h"
#import <SSZipArchive.h>
#import "AVAssetConvertCommon.h"

@interface FHFilterFileManager ()<SSZipArchiveDelegate>

/**
 合成队列
 */
@property (nonatomic, strong) dispatch_queue_t joinAlphaQueue;

@end

@implementation FHFilterFileManager

- (dispatch_queue_t)joinAlphaQueue {
    if (_joinAlphaQueue == nil) {
        _joinAlphaQueue = dispatch_queue_create("zy.FilterQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _joinAlphaQueue;
}
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static FHFilterFileManager *_manager;
    dispatch_once(&onceToken, ^{
        _manager = [[FHFilterFileManager alloc] init];
    });
    return _manager;
}

- (void)checkMVIDFileWithMP4Path:(NSString *)mp4Path zipOutpath:(NSString *)zipPath rect:(CGRect)rect {
    //代理标记
    BOOL delegateFlag = [self.delegate respondsToSelector:@selector(checkMVIDFileDoneWithExist:mvidPath:)];
    NSString *destinationZip = [zipPath lastPathComponent];
    NSString *mvidPath = [AVFileUtil getTmpDirPath:[[destinationZip stringByDeletingPathExtension] stringByAppendingPathExtension:@"mvid"]];
    //直接检查mvid是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:mvidPath]) {
        if (delegateFlag) {
            [self.delegate checkMVIDFileDoneWithExist:YES mvidPath:mvidPath];
            //如果zip不存在，则进行压缩
            if (![[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
                //开始压缩
                [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[mvidPath]];
            }
        }
    }else {
        //检查zip文件是否存在
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
            //解压zip
            [SSZipArchive unzipFileAtPath:zipPath toDestination:[AVFileUtil getTmpDirPath:@""] delegate:self];
            return;
        }else{
            FHMediaComponentVideo *video = [FHMediaComponentVideo videoComponentWithName:mp4Path type:@"mp4" rect:rect];
            video.clipSource = [NSString stringWithFormat:@"%@.mvid",[destinationZip stringByDeletingPathExtension]];
            AVAsset2MvidResourceLoader *resLoader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
            resLoader.movieFilename = video.rgbVideoName;
            resLoader.movieSize = rect.size;
            resLoader.outPath = [AVFileUtil getTmpDirPath:[NSString stringWithFormat:@"%@",video.clipSource]];
            resLoader.alwaysGenerateAdler = TRUE;
            resLoader.serialLoading = TRUE;
#if defined(HAS_LIB_COMPRESSION_API)
            NSLog(@"compressed");
            resLoader.compressed = YES;
//            resLoader.rgbLoader.compressed = YES;
//            resLoader.alphaLoader.compressed = YES;
#endif // HAS_LIB_COMPRESSION_API
            //转换视频
            [resLoader load];
//            [resLoader loadWithGroup:self.joinAlphaQueue];
            dispatch_barrier_async(self.joinAlphaQueue, ^{
               
            });
            dispatch_async(self.joinAlphaQueue, ^{
                //完成mvid生成,回调
                if (delegateFlag) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate checkMVIDFileDoneWithExist:YES mvidPath:mvidPath];
                    });
                }
                //开始压缩
                [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[resLoader.outPath]];

            });
        }
    }
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveFile:(NSString *)zipFile entryPath:(NSString *)entryPath destPath:(NSString *)destPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        if ([self.delegate respondsToSelector:@selector(checkMVIDFileDoneWithExist:mvidPath:)]) {
            [self.delegate checkMVIDFileDoneWithExist:YES mvidPath:destPath];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(checkMVIDFileDoneWithExist:mvidPath:)]) {
            //解压失败
            [self.delegate checkMVIDFileDoneWithExist:NO mvidPath:nil];
        }
    }
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([self.delegate respondsToSelector:@selector(checkMVIDFileDoneWithExist:mvidPath:)]) {
            [self.delegate checkMVIDFileDoneWithExist:YES mvidPath:path];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(checkMVIDFileDoneWithExist:mvidPath:)]) {
            //解压失败
            [self.delegate checkMVIDFileDoneWithExist:NO mvidPath:nil];
        }
    }
}
@end
