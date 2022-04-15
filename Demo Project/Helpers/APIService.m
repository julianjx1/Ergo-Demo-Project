//
//  APIService.m
//  Demo Project
//
//  Created by Mahir Shahriar Lipeng on 13/4/22.
//

#import "APIService.h"
#import "Response.h"
@interface APIService()

@end

@implementation APIService

-(void) apiToGetData: (void (^)(NSArray<QTEntry *>* entries))completion{
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.publicapis.org/entries"]];

        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];

        NSURLSession *session = [NSURLSession sharedSession];

        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          if(httpResponse.statusCode == 200)
          {
            NSError *parseError = nil;
            Response *response = [Response fromData:data error:&parseError];
            completion(response.entries);
          }
          else
          {
            NSLog(@"Error");
          }
        }];
        [dataTask resume];
    }




@end

 
