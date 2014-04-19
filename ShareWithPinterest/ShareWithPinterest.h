//
//  ShareWithPinterest.h
//  ShareWithPinterest
//
//  Created by Azer Bulbul on 4/19/14.
//  Copyright (c) 2014 azer. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Pinterest/Pinterest.h>

@interface ShareWithPinterest : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (ShareWithPinterest *)sharedInstance;

@property (nonatomic, retain) Pinterest* pinterest;
@property (nonatomic, retain) NSString* pinterestClientId;


- (BOOL) pinterestInitializeWithClientId:( NSString* )clientId;
- (void) createPinterestWithUrl:(NSString*)imageUrl sourceURL:(NSString*)sourceURL description:(NSString*)description;

@end

void PinContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                               uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);

void PinContextFinalizer(FREContext ctx);

void PinExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                           FREContextFinalizer* ctxFinalizerToSet);

void PinExtFinalizer(void* extData);