/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@interface ZipResult : NSObject {
}

@property(copy) NSString* source;
@property(copy) NSString* target;
@property(copy) id context;
@property(assign) BOOL zip;
@property(assign) BOOL ok;

+ (id) newResult:(BOOL)aZip ok:(BOOL)aOk source:(NSString*)aSource target:(NSString*)aTarget context:(NSString*)context;

- (NSDictionary*) toDictionary;

@end

@interface ZipProgress : NSObject {
}

@property(copy) NSString* source;
@property(copy) NSString* filename;
@property(copy) id context;
@property(assign) BOOL zip;
@property(assign) uint64_t entryNumber;
@property(assign) uint64_t entryTotal;


+ (id) newProgress:(BOOL)aEncrypt source:(NSString*)aSource filename:(NSString*)aFilename context:(id)aContext
		 entryNumber:(uint64_t)entryNumber entryTotal:(uint64_t)entryTotal;

- (NSDictionary*) toDictionary;

@end


@protocol ZipOperationDelegate<NSObject>

- (void) zipResult:(ZipResult*)result;
- (void) zipProgress:(ZipProgress*)progress;

@end

@interface ZipOperation : NSOperation <ZipArchiveDelegate> {
}

@property(copy) NSString* source;
@property(copy) NSString* target;
@property(copy) id context;
@property(assign) BOOL zip;
@property(assign) NSObject<ZipOperationDelegate>* delegate;

- (id)initAsDeflate:(BOOL)zip withSource:(NSString*)source target:(NSString*)target andContext:(id)context;

@end
