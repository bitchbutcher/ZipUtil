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
 
#import "ZipUtil.h"


@implementation ZipUtil

@synthesize operationQueue;

-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (ZipUtil*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
        self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
	return self;
}

#pragma mark -
#pragma mark ZipOperationDelegate

- (void) zipResult:(ZipResult*)result
{
	NSDictionary* jsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[result toDictionary], nil] 
													   forKeys:[NSArray arrayWithObjects:@"zipResult", nil]];
	PluginResult* pluginResult = nil;
	
	if (result.ok) {
		pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:jsDict];
		[super writeJavascript:[pluginResult toSuccessCallbackString:result.context]];
	} else {
		pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsDictionary:jsDict];
		[super writeJavascript:[pluginResult toErrorCallbackString:result.context]];
	}
}

- (void) zipProgress:(ZipProgress*)progress
{
	NSDictionary* jsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[progress toDictionary], nil] 
													   forKeys:[NSArray arrayWithObjects:@"zipProgress", nil]];
	
	PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsDictionary:jsDict];
	[super writeJavascript:[pluginResult toSuccessCallbackString:progress.context]];
}


#pragma mark -
#pragma mark PhoneGap commands

- (void) unzip:(ZipOperation*)zipOperation
{
	[self.operationQueue addOperation:zipOperation];
}

- (void) unzip:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSString* callbackId = [arguments pop];
	VERIFY_ARGUMENTS(arguments, 2, callbackId)
	
	NSString* sourcePath = [arguments objectAtIndex:0];
	NSString* targetFolder = [arguments objectAtIndex:1];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:sourcePath]) 
	{
		ZipOperation* zipOp = [[ZipOperation alloc] initAsDeflate:NO withSource:sourcePath target:targetFolder andContext:callbackId];
		zipOp.delegate = self;
		[self unzip:zipOp];
		[zipOp release];
	}
	else 
	{
		NSString* errorString = [NSString stringWithFormat:@"Source path '%@' does not exist.", sourcePath];
		PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:errorString];
		[super writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
	}
}

- (void) zip:(ZipOperation*)zipOperation
{
    // FUTURE: TODO:
}


- (void) zip:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    // FUTURE: TODO:
}

@end
