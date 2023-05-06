//
//  Log.m
//  oc2mango
//
//  Created by jianmei on 2019/4/20.
//

#import "Log.h"
NSString *_generatorFormmt(size_t argc){
    NSMutableString *format = [NSMutableString string];
    for (int i = 0; i < argc; i++) {
        [format appendString:@"%@ "];
    }
    
    return format;
}

