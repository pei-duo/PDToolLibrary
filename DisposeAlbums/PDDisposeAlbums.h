//
//  PDDisposeAlbums.h
//  PDBuDeJie
//
//  Created by 裴铎 on 2018/7/24.
//  Copyright © 2018年 裴铎. All rights reserved.
//

/** 相册业务处理类
 **************************************************************************/


#import <Foundation/Foundation.h>

/** 系统原生的框架,专门处理相册 */
#import <Photos/Photos.h>

@interface PDDisposeAlbums : NSObject

/**
 创建一个和应用同名的自定义相册

 @return 返回创建好的自定义相册,如果是nil说明创建失败了
 */
+ (PHAssetCollection *)createdCollection;

/**
 把一个UIImage图片保存到手机的相册中,并在相册中拿到这个图片,方便引用到自定义的相册中.
 
 @param image 需要保存到相册中的图片.
 @return 返回保存在相册中的图片.
 */
+ (PHFetchResult<PHAsset *> *)createdAssetsWithImage:(UIImage *)image;

/**
 保存图片到系统相册中,并引用到自定义相册
 
 @param image 需要保存的图片
 @return 结果(YES or NO)
 */
+ (BOOL)saveImagetoIntoAlbumWithImage:(UIImage *)image;

/**
 请求\检查 隐私访问权限
 
 @return 授权状态,0:用户未作出选择,1:系统限制,2:用户拒绝访问,3:用户允许访问
 */
+ (PHAuthorizationStatus)requestAuthorization;

@end
