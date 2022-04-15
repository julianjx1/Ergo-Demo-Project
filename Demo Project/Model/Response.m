//
//  Response.m
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 15/4/22.
//




// Response.m

#import "Response.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface Response (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface QTEntry (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

// These enum-like reference types are needed so that enum
// values can be contained by NSArray and NSDictionary.

@implementation QTAuth
+ (NSDictionary<NSString *, QTAuth *> *)values
{
    static NSDictionary<NSString *, QTAuth *> *values;
    return values = values ? values : @{
        @"apiKey": [[QTAuth alloc] initWithValue:@"apiKey"],
        @"": [[QTAuth alloc] initWithValue:@""],
        @"OAuth": [[QTAuth alloc] initWithValue:@"OAuth"],
        @"User-Agent": [[QTAuth alloc] initWithValue:@"User-Agent"],
        @"X-Mashape-Key": [[QTAuth alloc] initWithValue:@"X-Mashape-Key"],
    };
}

+ (QTAuth *)apiKey { return QTAuth.values[@"apiKey"]; }
+ (QTAuth *)empty { return QTAuth.values[@""]; }
+ (QTAuth *)oAuth { return QTAuth.values[@"OAuth"]; }
+ (QTAuth *)userAgent { return QTAuth.values[@"User-Agent"]; }
+ (QTAuth *)xMashapeKey { return QTAuth.values[@"X-Mashape-Key"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTAuth.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation QTCors
+ (NSDictionary<NSString *, QTCors *> *)values
{
    static NSDictionary<NSString *, QTCors *> *values;
    return values = values ? values : @{
        @"no": [[QTCors alloc] initWithValue:@"no"],
        @"unknown": [[QTCors alloc] initWithValue:@"unknown"],
        @"yes": [[QTCors alloc] initWithValue:@"yes"],
    };
}

+ (QTCors *)no { return QTCors.values[@"no"]; }
+ (QTCors *)unknown { return QTCors.values[@"unknown"]; }
+ (QTCors *)yes { return QTCors.values[@"yes"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return QTCors.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

Response *_Nullable QTResponseFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [Response fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

Response *_Nullable QTResponseFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return QTResponseFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable QTResponseToData(Response *response, NSError **error)
{
    @try {
        id json = [response JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable QTResponseToJSON(Response *response, NSStringEncoding encoding, NSError **error)
{
    NSData *data = QTResponseToData(response, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation Response
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"count": @"count",
        @"entries": @"entries",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return QTResponseFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTResponseFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[Response alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _entries = map(_entries, λ(id x, [QTEntry fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = Response.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = Response.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:Response.properties.allValues] mutableCopy];

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"entries": map(_entries, λ(id x, [x JSONDictionary])),
    }];

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return QTResponseToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return QTResponseToJSON(self, encoding, error);
}
@end

@implementation QTEntry
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"API": @"api",
        @"Description": @"entryDescription",
        @"Auth": @"auth",
        @"HTTPS": @"https",
        @"Cors": @"cors",
        @"Link": @"link",
        @"Category": @"category",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[QTEntry alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _auth = [QTAuth withValue:(id)_auth];
        _cors = [QTCors withValue:(id)_cors];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = QTEntry.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = QTEntry.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:QTEntry.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in QTEntry.properties) {
        id propertyName = QTEntry.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"Auth": [_auth value],
        @"HTTPS": _https ? @YES : @NO,
        @"Cors": [_cors value],
    }];

    return dict;
}
@end

NS_ASSUME_NONNULL_END
