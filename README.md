ZipUtil Plugin for Apache Cordova
=====================================
created by Shazron Abdullah

[Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html) except for the zip library that is under **src/ios/ZipArchive**

Follows the [Cordova Plugin spec](https://github.com/alunny/cordova-plugin-spec), so that it works with [Plugman](https://github.com/imhotep/plugman), or you can install it manually below.
 
1. Add the files in **src/ios** in Xcode (add as a group)
2. Add **ZipUtil.js** to your **www** folder, and reference it in a script tag, after your cordova.js
3. In **config.xml**, under the **'plugins'** element, add a new **&lt;plugin&gt;** element: attribute **name** is **"ZipUtil"** and the attribute **value** is **"ZipUtil"**

        <plugins>
            <plugin name="ZipUtil" value="ZipUtil" />
            <!-- other plugins here ... -->
        </plugins>
        
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
