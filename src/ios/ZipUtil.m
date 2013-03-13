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

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
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
	CDVPluginResult* pluginResult = nil;
	
	if (result.ok) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsDict];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:jsDict];
	}
    
    // the context of the ZipResult is the callbackId
    [self.commandDelegate sendPluginResult:pluginResult callbackId:result.context];
}

- (void) zipProgress:(ZipProgress*)progress
{
	NSDictionary* jsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[progress toDictionary], nil] 
													   forKeys:[NSArray arrayWithObjects:@"zipProgress", nil]];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsDict];
    // the context of the ZipProgress is the callbackId
    [self.commandDelegate sendPluginResult:pluginResult callbackId:progress.context];
}

#pragma mark -
#pragma mark Cordova commands

- (void) unzipWithOperation:(ZipOperation*)zipOperation
{
	[self.operationQueue addOperation:zipOperation];
}

- (void) unzip:(CDVInvokedUrlCommand*)command
{
	NSString* sourcePath = [command.arguments objectAtIndex:0];
	NSString* targetFolder = [command.arguments objectAtIndex:1];
	
    NSFileManager* fileManager = [[NSFileManager new] autorelease];
	if ([fileManager fileExistsAtPath:sourcePath])
	{
		ZipOperation* zipOp = [[ZipOperation alloc] initAsDeflate:NO withSource:sourcePath target:targetFolder andContext:command.callbackId];
		zipOp.delegate = self;
		[self unzipWithOperation:zipOp];
		[zipOp release];
	}
	else 
	{
		NSString* errorString = [NSString stringWithFormat:@"Source path '%@' does not exist.", sourcePath];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorString];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}
}

- (void) zipWithOperation:(ZipOperation*)zipOperation
{
    // FUTURE: TODO:
}

- (void) zip:(CDVInvokedUrlCommand*)command
{
    // FUTURE: TODO:
}

@end
