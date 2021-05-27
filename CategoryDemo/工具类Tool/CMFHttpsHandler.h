//
//  CMFHttpsHandler.h
//  CMF-Core
//
//  Created by dukui on 2020/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMFHttpsHandler : NSObject

@property (nonatomic, strong) NSDictionary *publicKeysDict;

+ (CMFHttpsHandler *)sharedInstance;
- (BOOL)AFValidation:(NSURLAuthenticationChallenge *)challenge;

- (NSString *)handleGETRequestWithParams:(NSDictionary *)parameters;
+ (NSString *)handleErrorMessageWithCode:(NSInteger)statusCode errCode:(NSInteger)code;
+ (void)handleRequestLogWithStartTime:(NSString *)startTime url:(NSString *)url httpCode:(NSInteger)httpCode bffCode:(NSInteger)bffCode errMessage:(NSString *)errMessage;
@end

NS_ASSUME_NONNULL_END
