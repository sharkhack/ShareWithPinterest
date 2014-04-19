//
//  ShareWithPinterest.m
//  ShareWithPinterest
//
//  Created by Azer Bulbul on 4/19/14.
//  Copyright (c) 2014 azer. All rights reserved.
//

#import "ShareWithPinterest.h"

FREContext PinCtx = nil;

static dispatch_once_t pinOnceToken;

@implementation ShareWithPinterest

@synthesize pinterest = _pinterest;
@synthesize pinterestClientId = _pinterestClientId;

static ShareWithPinterest *sharedInstance = nil;

+ (ShareWithPinterest *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [ShareWithPinterest sharedInstance];
}

- (id)copy
{
    return self;
}

- (void)dealloc
{
    [_pinterest release];
    [_pinterestClientId release];
    
    [super dealloc];
}



- (BOOL) pinterestInitializeWithClientId:( NSString* )clientId{
    
    self.pinterestClientId = clientId;
    
    if (!self.pinterest)
    {
        dispatch_once(&pinOnceToken, ^{
            self.pinterest = [[[Pinterest alloc] initWithClientId:self.pinterestClientId] autorelease];
        });
    }
    
    return (self.pinterest != nil ? [self.pinterest canPinWithSDK] : NO);
}
- (void) createPinterestWithUrl:(NSString*)imageUrl sourceURL:(NSString*)sourceURL description:(NSString*)description{
    
    if (!self.pinterest && self.pinterestClientId!=nil)
    {
        dispatch_once(&pinOnceToken, ^{
            self.pinterest = [[[Pinterest alloc] initWithClientId:self.pinterestClientId] autorelease];
        });
    }
    
    
    @try {
        if ([self.pinterest canPinWithSDK])
        {
            NSURL* imageUrl_  = [NSURL URLWithString:imageUrl];
            NSURL* sourceUrl_ = [NSURL URLWithString:sourceURL];
            [self.pinterest createPinWithImageURL:[imageUrl_ copy] sourceURL:[sourceUrl_ copy] description:description];
            imageUrl_ = nil;
            sourceUrl_ = nil;
        } else
        {
            NSLog(@"Cannot create Pin");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end

NSData *toNSDataByteArray(FREObject *ba)
{
    FREByteArray byteArray;
    FREAcquireByteArray(ba, &byteArray);
    
    NSData *d = [NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length];
    FREReleaseByteArray(ba);
    
    return d;
}
NSString * toFREObjectToNSString(FREObject object)
{
    uint32_t stringLength;
    const uint8_t *string;
    FREGetObjectAsUTF8(object, &stringLength, &string);
    return [NSString stringWithUTF8String:(char*)string];
}

FREObject toBOOLToFREObject(BOOL boolean)
{
    FREObject result;
    FRENewObjectFromBool(boolean, &result);
    return result;
}

FREObject pinterestInitialize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *clid = toFREObjectToNSString(argv[0]);
    return toBOOLToFREObject([[ShareWithPinterest sharedInstance] pinterestInitializeWithClientId:clid]);
}
FREObject createPin(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    NSString *imagePath = toFREObjectToNSString(argv[0]);
    NSString *sourcePath = toFREObjectToNSString(argv[1]);
    NSString *pinDescription = toFREObjectToNSString(argv[2]);
    
    [[ShareWithPinterest sharedInstance] createPinterestWithUrl:imagePath sourceURL:sourcePath description:pinDescription];
    
    
    return nil;
}

void PinContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 2;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 2);
	func[0].name = (const uint8_t*) "pinterestInitialize";
	func[0].functionData = NULL;
    func[0].function = &pinterestInitialize;
    
    func[1].name = (const uint8_t*) "createPin";
	func[1].functionData = NULL;
    func[1].function = &createPin;
    
    *functionsToSet = func;
    
    PinCtx = ctx;
    
}

void PinContextFinalizer(FREContext ctx)
{
    PinCtx = nil;
    return;
}

void PinExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                           FREContextFinalizer* ctxFinalizerToSet)
{
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &PinContextInitializer;
    *ctxFinalizerToSet = &PinContextFinalizer;
}

void PinExtFinalizer(void* extData)
{
    return;
}