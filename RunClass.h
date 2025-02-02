//
//  RunClass.h
//  YaoPao
//
//  Created by zc on 15-1-27.
//  Copyright (c) 2015年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RunClass : NSManagedObject

@property (nonatomic, retain) NSNumber * averageHeart;
@property (nonatomic, retain) NSString * clientBinaryFilePath;
@property (nonatomic, retain) NSString * clientImagePaths;
@property (nonatomic, retain) NSString * clientImagePathsSmall;
@property (nonatomic, retain) NSNumber * dbVersion;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * feeling;
@property (nonatomic, retain) NSNumber * generateTime;
@property (nonatomic, retain) NSNumber * gpsCount;
@property (nonatomic, retain) NSString * gpsString;
@property (nonatomic, retain) NSNumber * heat;
@property (nonatomic, retain) NSNumber * howToMove;
@property (nonatomic, retain) NSNumber * isMatch;
@property (nonatomic, retain) NSString * jsonParam;
@property (nonatomic, retain) NSNumber * kmCount;
@property (nonatomic, retain) NSNumber * maxHeart;
@property (nonatomic, retain) NSNumber * mileCount;
@property (nonatomic, retain) NSNumber * minCount;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSNumber * runway;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * secondPerKm;
@property (nonatomic, retain) NSString * serverBinaryFilePath;
@property (nonatomic, retain) NSString * serverImagePaths;
@property (nonatomic, retain) NSString * serverImagePathsSmall;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * targetType;
@property (nonatomic, retain) NSNumber * targetValue;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSNumber * weather;

@end
