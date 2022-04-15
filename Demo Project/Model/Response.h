//
//  Response.h
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 15/4/22.
//

#ifndef Response_h
#define Response_h


#endif /* Response_h */
#import <Foundation/Foundation.h>


@class Response;
@class QTEntry;
@class QTAuth;
@class QTCors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface QTAuth : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (QTAuth *)apiKey;
+ (QTAuth *)empty;
+ (QTAuth *)oAuth;
+ (QTAuth *)userAgent;
+ (QTAuth *)xMashapeKey;
@end

@interface QTCors : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (QTCors *)no;
+ (QTCors *)unknown;
+ (QTCors *)yes;
@end

#pragma mark - Object interfaces

@interface Response : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy)   NSArray<QTEntry *> *entries;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTEntry : NSObject
@property (nonatomic, copy)   NSString *api;
@property (nonatomic, copy)   NSString *entryDescription;
@property (nonatomic, assign) QTAuth *auth;
@property (nonatomic, assign) BOOL https;
@property (nonatomic, assign) QTCors *cors;
@property (nonatomic, copy)   NSString *link;
@property (nonatomic, copy)   NSString *category;
@end

NS_ASSUME_NONNULL_END
