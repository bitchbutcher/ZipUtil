ZipUtil Plugin for Apache Cordova
=====================================
created by Shazron Abdullah

[Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html) except for the zip library that is under **src/ios/ZipArchive**

Follows the [Cordova Plugin spec](https://github.com/apache/cordova-plugman/blob/master/plugin_spec.md), so that it works with [Plugman](https://github.com/apache/cordova-plugman), or you can install it manually below.
 
1. Add the files in **src/ios** in Xcode (add as a group)
2. Add **ZipUtil.js** to your **www** folder, and reference it in a script tag, after your cordova.js
3. a. In **config.xml**, under the **'plugins'** element, add a new **&lt;plugin&gt;** element: attribute **name** is **"ZipUtil"** and the attribute **value** is **"ZipUtil"**

        <plugins>
            <plugin name="ZipUtil" value="ZipUtil" />
            <!-- other plugins here ... -->
        </plugins>
        
	b. For __config.xml__, add a new **&lt;feature&gt;** tag (2.8.0 and up):

         <feature name="ZipUtil">
            <param name="ios-package" value="ZipUtil" />
         </feature>
    
        
5. Add the lib **"libz.dylib"** in your Build Phases tab of your Project
    
The plugin's JavaScript functions are called after getting the plugin object thus:
 
        // Get a reference to the plugin first
        var zu = cordova.require("cordova/plugin/ziputil");

        /*
         Unzips a file.
     
         @param successCallback function
         @param failureCallback function
         @param sourcePath string the filepath of the .zip file
         @param targetFolder string the folder path of where to unzip the contents to
         */
		zu.unzip = function(successCallBack, failureCallback, sourcePath, targetFolder);


Sample code: 

		// this is both a zip progress and and result handler
		var win = function(json) {
			if (json.zipProgress) {
				// {"zipProgress":{"entryNumber":1,"source":"/path/to/test.zip","filename":"myfolder/myfile.png","entryTotal":10,"zip":false}}
				console.log((json.zipProgress.zip? "zip" : "unzip") + " entry " + json.zipProgress.entryNumber + "/" + json.zipProgress.entryTotal + " ("+ ((json.zipProgress.entryNumber/json.zipProgress.entryTotal)*100).toFixed(2) + "%)" );
		
			} else if (json.zipResult) {
				// zip ok, and done
				// {"zipResult":{"zip":false,"source":"/path/to/test.zip","target":"/path/to/targetfolder/"}}
		
				console.log((json.zipResult.zip? "zip" : "unzip") + " OK: " + JSON.stringify(json));
			}
		}
		
		// handles failure
		var fail = function(obj) {
			if (obj && obj.zipResult) {
				// zip failed, and done
				// {"zipResult":{"zip":false,"source":"/path/to/test.zip","target":"/path/to/targetfolder/"}}
				console.log((obj.zipResult.zip? "zip" : "unzip") + " FAIL: " + JSON.stringify(obj));
			} else {
				// general failure message
				console.log("FAIL: " + obj);
			}
		}

		var zu = cordova.require("cordova/plugin/ziputil");
		zu.unzip(win, fail, "/path/to/test.zip", "/path/to/targetfolder/");