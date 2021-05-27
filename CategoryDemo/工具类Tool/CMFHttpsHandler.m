//
//  CMFHttpsHandler.m
//  CMF-Core
//
//  Created by dukui on 2020/7/16.
//

#import "CMFHttpsHandler.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <AssertMacros.h>


static const unsigned char rsa2048Asn1Header[] =
{
    0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
    0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
};

@interface CMFHttpsHandler ()

@end

@implementation CMFHttpsHandler

+ (CMFHttpsHandler *)sharedInstance {
    static CMFHttpsHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[CMFHttpsHandler alloc] init];
    });
    return handler;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - chanllenge

- (BOOL)AFValidation:(NSURLAuthenticationChallenge *)challenge {
    if (self.publicKeysDict == nil || self.publicKeysDict.allKeys.count == 0) {
        return YES;
    }
    NSString *host = challenge.protectionSpace.host;
    if (![self.publicKeysDict.allKeys containsObject:host]) {
        if (self.publicKeysDict.allKeys.count != 0) {
            return YES;
        }
        return NO;
    }
    NSDictionary *content = self.publicKeysDict[host];
    NSString *deadline = content[@"kPublicKeysCheckDeadlineKey"];
    if (deadline == nil || deadline.length == 0) {
        return YES;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *deadLineDate = [dateFormat dateFromString:deadline];
    NSTimeInterval deadLineTimeInterval = [deadLineDate timeIntervalSince1970];
    if (deadLineDate == nil) {
        return YES;
    }
    
    NSArray *hashArray = content[@"kPublicKeysHashKey"];
    if (hashArray == nil || hashArray.count == 0) {
        return YES;
    }
    NSString *saveKey = [NSString stringWithFormat:@"%@_%@",host,deadline];
    BOOL pinningExpirationLogHasSaved = [[NSUserDefaults standardUserDefaults] boolForKey:saveKey];
    if (deadLineTimeInterval < [[NSDate date] timeIntervalSince1970]) {
        if (pinningExpirationLogHasSaved == NO) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"hostname"] = host;
            dict[@"expiration"] = deadline;
            dict[@"public_key_pins"] = hashArray;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:saveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return YES;
    }
    
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;

    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)host)];
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);

    NSUInteger trustedPublicKeyCount = 0;
    NSArray *publicKeys = [self AFPublicKeyTrustChainForServerTrust:serverTrust];

    NSInteger index = 0;
    for (id trustChainPublicKey in publicKeys) {
        NSData *sha256Data = [self sha256WithPublicKey:(__bridge SecKeyRef)trustChainPublicKey];
        NSString *sha256Base64 = [sha256Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        NSLog(@"sha256_base64_%li %@", index, sha256Base64);
        for (NSString *pinnedPublicKeyBase64 in hashArray) {
            if ([sha256Base64 isEqualToString:pinnedPublicKeyBase64]) {
                trustedPublicKeyCount += 1;
                break;
            }
        }
        index++;
    }
    return trustedPublicKeyCount > 0;
}

- (NSArray *)AFPublicKeyTrustChainForServerTrust:(SecTrustRef)serverTrust {
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);

        SecCertificateRef someCertificates[] = {certificate};
        CFArrayRef certificates = CFArrayCreate(NULL, (const void **)someCertificates, 1, NULL);

        SecTrustRef trust;
        __Require_noErr_Quiet(SecTrustCreateWithCertificates(certificates, policy, &trust), _out);
        SecTrustResultType result;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        __Require_noErr_Quiet(SecTrustEvaluate(trust, &result), _out);
#pragma clang diagnostic pop
        SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
        [trustChain addObject:(__bridge_transfer id)publicKey];

    _out:
        
        if (trust) {
            CFRelease(trust);
        }

        if (certificates) {
            CFRelease(certificates);
        }

        continue;
    }
    CFRelease(policy);

    return [NSArray arrayWithArray:trustChain];
}

- (NSData *)sha256WithPublicKey:(SecKeyRef)publicKey {
    NSData *publicKeyData = (__bridge_transfer NSData *)SecKeyCopyExternalRepresentation(publicKey, NULL);
    
//    CFDictionaryRef publicKeyAttributes = SecKeyCopyAttributes(publicKey);
//    NSString *publicKeyType = CFDictionaryGetValue(publicKeyAttributes, kSecAttrKeyType);
//    NSNumber *publicKeysize = CFDictionaryGetValue(publicKeyAttributes, kSecAttrKeySizeInBits);
//    CFRelease(publicKeyAttributes);

    char *asn1HeaderBytes = (char *)rsa2048Asn1Header;
    unsigned int asn1HeaderSize = sizeof(rsa2048Asn1Header);
    
//    CFRelease(publicKey);

    // Generate a hash of the subject public key info
    NSMutableData *subjectPublicKeyInfoHash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_CTX shaCtx;
    CC_SHA256_Init(&shaCtx);

    // Add the missing ASN1 header for public keys to re-create the subject public key info
    CC_SHA256_Update(&shaCtx, asn1HeaderBytes, asn1HeaderSize);

    // Add the public key
    CC_SHA256_Update(&shaCtx, [publicKeyData bytes], (unsigned int)[publicKeyData length]);
    CC_SHA256_Final((unsigned char *)[subjectPublicKeyInfoHash bytes], &shaCtx);
    return subjectPublicKeyInfoHash;
}

#pragma mark - http get 请求获取参数拼接
- (NSString *)handleGETRequestWithParams:(NSDictionary *)parameters {
    if (parameters == nil || parameters.count == 0) {
        return  @"";
    }
    return [self queryStringFromParameters:parameters];
}

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (NSString *pair in [self queryStringPairsFromDictionary:parameters]) {
        [mutablePairs addObject:pair];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

- (NSArray *)queryStringPairsFromDictionary:(NSDictionary *)dict {
    return [self queryStringPairsFromKey:nil value:dict];
}

- (NSArray *)queryStringPairsFromKey:(NSString *)key value:(id)value {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];

    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray: [self queryStringPairsFromKey:(key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey) value:nestedValue]];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:[self queryStringPairsFromKey:[NSString stringWithFormat:@"%@[]", key] value:nestedValue]];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:[self queryStringPairsFromKey:key value:obj]];
        }
    } else {
        [mutableQueryStringComponents addObject:[self URLEncodedStringWithKey:key value:value]];
    }

    return mutableQueryStringComponents;
}

- (NSString *)URLEncodedStringWithKey:(id)key value:(id)value {
    if (!value || [value isEqual:[NSNull null]]) {
        return [self percentEscapedStringFromString:[key description]];
    } else {
        return [NSString stringWithFormat:@"%@=%@", [self percentEscapedStringFromString:[key description]], [self percentEscapedStringFromString:[value description]]];
    }
}

- (NSString *)percentEscapedStringFromString:(NSString *)string {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];

    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];

    static NSUInteger const batchSize = 50;

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);

        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];

        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];

        index += range.length;
    }

    return escaped;
}

#pragma mark - request

+ (NSString *)handleErrorMessageWithCode:(NSInteger)statusCode errCode:(NSInteger)code {
    NSString *newMessage = @"";

    return newMessage;
}

+ (void)handleRequestLogWithStartTime:(NSString *)startTime url:(NSString *)url httpCode:(NSInteger)httpCode bffCode:(NSInteger)bffCode errMessage:(NSString *)errMessage {
    
    
}


@end
