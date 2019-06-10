
#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (void)changeLineSpace:(CGFloat )space lineHeight:(CGFloat )lineHeight {
    if (self.text.length == 0)return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    if (space != 0){
        paragraphStyle.lineSpacing = space;
    }
    
    if (lineHeight != 0){
        paragraphStyle.maximumLineHeight = lineHeight;
        paragraphStyle.minimumLineHeight = lineHeight;
    }

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    CGFloat baselineOffset = (lineHeight - self.font.lineHeight) / 4;
    attributes[NSBaselineOffsetAttributeName] = @(baselineOffset);
    [attributedString addAttributes:attributes range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}

-(void)setLineSpacing:(CGFloat)lineSpacing {
    NSString *text = self.text;
    
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

@end
