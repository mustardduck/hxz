//
//  PH_UITextView.m
//  CommonFrame_Pro
//
//  Created by 倩 莫 on 15/8/20.
//  Copyright (c) 2015年 ionitech. All rights reserved.
//

#import "PH_UITextView.h"

@implementation PH_UITextView

@synthesize placeHolderLabel;

@synthesize placeholder;

@synthesize placeholderColor;

- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [self setPlaceholder:@""];
    
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}



- (id)initWithFrame:(CGRect)frame

{
    
    if( (self = [super initWithFrame:frame]) )
        
    {
        
        [self setPlaceholder:@""];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
    
}



- (void)textChanged:(NSNotification *)notification

{
    
    if([[self placeholder] length] == 0)
        
    {
        
        return;
        
    }
    
    
    if([[self text] length] == 0)
        
    {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }
    
    else
        
    {
        
        [[self viewWithTag:999] setAlpha:0];
        
    }
    
}



- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}



- (void)drawRect:(CGRect)rect

{
    if( [[self placeholder] length] > 0 )
    {
        
        if ( placeHolderLabel == nil )
            
        {
            if(rect.size.height == 40)
            {
                placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,8,self.bounds.size.width - 16,0)];
            }
            else if (rect.size.height == 38)
            {
                placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,8,self.bounds.size.width - 16,0)];
            }
            else
            {
                placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,12,self.bounds.size.width - 16,0)];
            }
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = self.font;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
            
        }

        placeHolderLabel.text = self.placeholder;
        
        [placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:placeHolderLabel];
        
    }

    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        
    {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }
    
    [super drawRect:rect];
    
}

@end
