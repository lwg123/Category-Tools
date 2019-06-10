//
//  NSString+Utils.m
//  DuiFuDao
//
//  Created by weiguang on 2018/8/7.
//  Copyright © 2018年 DuiA. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL)isPhoneNumber {
    
    // 最新正则表达式
    NSString *MOBILE = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    return [self matchUsingRegex:MOBILE];
}

- (BOOL)isChinese
{
    NSString *match = @"^[\u4e00-\u9fa5]+$";
    return [self matchUsingRegex:match];
}

- (BOOL)matchUsingRegex:(NSString*)regex {
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = [regextestmobile evaluateWithObject:self];
    return isRight;
}

+ (BOOL)isBlank:(NSString *)judgmentString{
    if (judgmentString == nil) {
        return YES;
    }
    if (judgmentString == NULL) {
        return YES;
    }
    
    if ([judgmentString isKindOfClass:[NSNull class]]) {
        return YES;
        
    }
    if ([[judgmentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (CGSize)boundingRectWithSize:(CGSize)_size font:(UIFont *)_font{
    // 编译检查SDK版本号
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_1
    return [self sizeWithFont:_font constrainedToSize:_size lineBreakMode:NSLineBreakByCharWrapping];
#else
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [self boundingRectWithSize:_size
                                 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                              attributes:attributes
                                 context:nil].size;
#endif
}

+ (NSString *)formatFloat:(float)numFloat
{
    if (fmodf(numFloat, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",numFloat];
    } else if (fmodf(numFloat*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",numFloat];
    } else {
        return [NSString stringWithFormat:@"%.2f",numFloat];
    }
}

// 获取字符长度,汉字两个，英文是一个
- (int)getByteNum{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

//截取字符长度，index是字符位置,中文是2个，英文是1个
- (NSString *)subStringByByteWithIndex:(NSInteger)index{
    
    NSInteger sum = 0;
    
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[self length]; i++){
        
        unichar strChar = [self characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            
            subStr = [self substringToIndex:i+1];
            return subStr;
        }
        
    }
    
    return subStr;
}

//截取字符长度，index是字符位置,中文是2个，英文是1个
- (NSString *)subStringByByteWithFromIndex:(NSInteger)index{
    
    NSInteger sum = 0;
    
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[self length]; i++){
        
        unichar strChar = [self characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            
            subStr = [self substringFromIndex:i+1];
            return subStr;
        }
        
    }
    
    return subStr;
}


/// 将url和parameters拼接成完整的get请求的url
+ (NSString *)URLStringPrefixUrl:(NSString *)prefixUrl urlstr:(NSString *)urlstr parameters:(NSDictionary *)parameters{
    NSMutableString *spliceURL;
    
    if ([NSString isBlank:prefixUrl]){
        spliceURL = [NSMutableString stringWithFormat:@"%@%@",@"KDAFDBaseUrl",urlstr];
    }else{
        spliceURL = prefixUrl.mutableCopy;
    }
    
    if (!parameters || !parameters.allKeys.count){
        return spliceURL;
    }
    
    //获取字典的所有keys
    NSArray *keys = [parameters allKeys];
    
    NSArray *values = [parameters allValues];
    
    BOOL isHaveQuestionMark = [prefixUrl containsString:@"?"];
    
    //拼接字符串
    for (int index = 0; index < keys.count; index ++){
        NSString *string;
        if (index == 0 && !isHaveQuestionMark){
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[index], values[index]];
            
        }else{
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[index], values[index]];
        }
        //拼接字符串
        [spliceURL appendString:string];
    }
    
    return spliceURL;
}



+(BOOL)isIDCardNumber:(NSString *)cardNumber
{
    cardNumber = [cardNumber uppercaseString];
    if (cardNumber.length != 18) return false ;
    // 17位加权因子，与身份证号前17位依次相乘。
    int w[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    int sum = 0;// 保存级数和
    for (int i = 0; i < cardNumber.length - 1; i++)
    {
        sum += [[cardNumber substringWithRange:NSMakeRange(i, 1)] intValue] * w[i] ;
    }
    /**
     * 校验结果，上一步计算得出的结果与11取模，得到的结果相对应的字符就是身份证最后一位，也就是校验位。
     * 例如：0对应下面数组第一个元素，以此类推。
     */
    NSArray *sums = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ];
    if ([sums[(sum % 11)] isEqualToString:[cardNumber substringWithRange:NSMakeRange(cardNumber.length - 1, 1)]])
    {// 与身份证最后一位比较
        return true;
    }
    return false;
}


/**
 *  银行卡号正则表达式
 *
 *  @param cardNumber 银行卡号
 *
 *  @return
 */
+ (BOOL)isBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
@end
