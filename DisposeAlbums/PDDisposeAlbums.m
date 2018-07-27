//
//  PDDisposeAlbums.m
//  PDBuDeJie
//
//  Created by 裴铎 on 2018/7/24.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import "PDDisposeAlbums.h"

@implementation PDDisposeAlbums

/**
 创建一个和应用同名的自定义相册
 
 @return 返回创建好的自定义相册,如果是nil说明创建失败了
 */
+ (PHAssetCollection *)createdCollection
{
    /**
     获得软件名字,在主资源包内得到info.plist文件(字典类型)
     通过key获取项目名称(bundle name)
     */
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
    // 抓取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            //如果查询到和项目名称一样的自定义相册就返回这个相册
            return collection;
        }
    }
    
    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError *error = nil;//用来存放错误信息
    __block NSString *createdCollectionID = nil;//用来接收得到的自定义相册标识符
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    /** 创建自定义相册失败了 */
    if (error) return nil;
    
    // 创建成功,根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}


/**
 把一个UIImage图片保存到手机的相册中,并在相册中拿到这个图片,方便引用到自定义的相册中

 @param image 需要保存到相册中的图片.
 @return 返回保存在相册中的图片.
 */
+ (PHFetchResult<PHAsset *> *)createdAssetsWithImage:(UIImage *)image
{
    NSError *error = nil;
    __block NSString *assetID = nil;//用来接收保存好的图片的标识符
    
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    /** 保存图片到系统相册失败了 */
    if (error) return nil;
    
    // 获取刚才保存的相片,通过标识符
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

/**
 保存图片到系统相册中,并引用到自定义相册

 @param image 需要保存的图片
 @return 结果(YES or NO)
 */
+ (BOOL)saveImagetoIntoAlbumWithImage:(UIImage *)image{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssetsWithImage:image];
    if (createdAssets == nil) {
        return NO;
    }
    
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    /** 创建或者获取相册失败！ */
    if (createdCollection == nil) return NO;
    
    // 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        /** 用插入图片,可以让新保存的图片显示在前面 */
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 最后的判断
    if (error) {
        /** 有错误信息证明引用图片到自定义相册时失败了 */
        return NO;
    } else {
        return YES;
    }
}

/**
 请求\检查 隐私访问权限

 @return 用户的授权状态
 */
+ (PHAuthorizationStatus)requestAuthorization{
    /**
     请求\检查 隐私访问权限 :
     如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
     如果之前已经做过选择，会直接执行block
     这个block会在子线程执行,如果要对UI界面操作需要回到主线程
     */
    //拿到用户的对本应用的相册授权状态
    __block PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        authorizationStatus = status;
    }];
    
    return authorizationStatus;
/**
 隐私授权状态
 PHAuthorizationStatusNotDetermined = 0, // 用户未选择时的状态,一般是App第一次安装/
 PHAuthorizationStatusRestricted,        // 系统原因无法访问相册,用户自己也无法手动打开隐私权限,例如在家长控制状态时.
 PHAuthorizationStatusDenied,            // 用户允许当前App访问相册
 PHAuthorizationStatusAuthorized         // 用户拒绝当前App访问相册
 */
}

@end
