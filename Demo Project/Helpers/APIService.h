//
//  APIService.h
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 13/4/22.
//

#ifndef APIService_h
#define APIService_h


#endif /* APIService_h */
#import <Foundation/Foundation.h>
#import "Response.h"
@interface APIService : NSObject
    
-(void) apiToGetData: (void (^)(NSArray<QTEntry *>* entries))completion;

@end
