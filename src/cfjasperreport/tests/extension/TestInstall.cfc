<cfcomponent displayname="TestInstall"  extends="mxunit.framework.TestCase">  


  <cffunction name="setUp" returntype="void" access="public">
		<cfset variables.extensionTag = "cfjasperreport" />
 		<cfset variables.Install = createObject("component","#variables.extensionTag#.src.extension.Install") />
		<cfset variables.extensionzip = "/#variables.extensionTag#/dist/#variables.extensionTag#-extension.zip">
		<cfset variables.defaultconfig = {"mixed":{"isBuiltInTag":true,"installTestPlugin":true}}>
		<cfset request.adminType = "web" />
		<cffile action="read" file="#expandpath('/'&variables.extensionTag)#/tests/cfadminpassword.txt" variable="session.password#request.adminType#" />
  </cffunction>

	<cffunction name="dumpvar" access="private">
		<cfargument name="var">
		<cfdump var="#var#">
		<cfabort/>
	</cffunction>


	<cffunction name="testAddJars">
		<cfscript>
			var error = structNew();
			var path = expandPath("/#variables.extensionTag#/lib/");
			var config = variables.defaultconfig;
			var result = variables.Install.addJars(error,path,config);
	//		debug(result);
//			assertEquals(true,result.status,result.message);
			testRemoveJars();
		</cfscript>
	</cffunction>

	<cffunction name="testInstall">
		<cfargument name="uninstall" default="true">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var libraryPath = expandPath('{railo-#request.adminType#}/library');
			var result = variables.Install.install(error,path,config);
			if(config.mixed.isBuiltInTag) {
				assertTrue(fileExists("#libraryPath#/tag/#variables.extensionTag#/cfc/#rereplace(variables.extensionTag,'^cf','')#.cfc"));
			} else {
				assertTrue(fileExists("#libraryPath#/../customtags/#variables.extensionTag#/#rereplace(variables.extensionTag,'^cf','')#.cfc"));
			}
//			assertEquals(true,result.status,result.message);
			if(arguments.uninstall){
				testUnInstall();
			}
		</cfscript>
	</cffunction>

	<cffunction name="testUnInstall" access="private">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var result = variables.Install.uninstall(path,config);
			var libraryPath = expandPath('{railo-#request.adminType#}/library');
			if(config.mixed.isBuiltInTag) {
				assertFalse(fileExists("#libraryPath#/tag/#variables.extensionTag#/cfc/#rereplace(variables.extensionTag,'^cf','')#.cfc"));
			} else {
				assertFalse(fileExists("#libraryPath#/../customtags/#variables.extensionTag#/cfc/#rereplace(variables.extensionTag,'^cf','')#.cfc"));
			}
	//		debug(result);
//			assertEquals(true,result.status,result.message);
		</cfscript>
	</cffunction>


	<cffunction name="testInstallCustomTag">
		<cfargument name="uninstall" default="true">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var result = variables.Install.install(error,path,config);
	//		debug(result);
//			assertEquals(true,result.status,result.message);
			if(arguments.uninstall){
				testUnInstallCustomTag();
			}
		</cfscript>
	</cffunction>

	<cffunction name="testUnInstallCustomTag" access="private">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var result = variables.Install.uninstall(path,config);
	//		debug(result);
//			assertEquals(true,result.status,result.message);
		</cfscript>
	</cffunction>


	<cffunction name="testInstallDevCustomTag">
		<cfargument name="uninstall" default="true">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var result = variables.Install.addCustomTagsMapping("#expandPath("/"&variables.extensionTag)#/src/tag");
			if(arguments.uninstall){
				testUnInstallDevCustomTag();
			}
			return 'added mapping: #expandPath("/"&variables.extensionTag)#/src/tag';
		</cfscript>
	</cffunction>

	<cffunction name="testUnInstallDevCustomTag" access="private">
		<cfscript>
			var error = structNew(); 
			var path = "zip://" & expandPath("#variables.extensionzip#!/");
			var config = variables.defaultconfig;
			var result = variables.Install.removeCustomTagsMapping("#expandPath("/"&variables.extensionTag)#/src/tag");
		</cfscript>
	</cffunction>

	<cffunction name="testRemoveJars" access="private">
		<cfscript>
			var error = structNew();
			var path = expandPath("/#variables.extensionTag#/lib/");
			var config = variables.defaultconfig;
			var result = variables.Install.removeJars(error,path,config);
		</cfscript>
	</cffunction>

	<cffunction name="listFiles" access="private">
		<cfargument name="dir" required="true" />
		<cfset var files = "" />
		<cfdirectory action="list" directory="#dir#" name="files">
		<cfreturn files />
	</cffunction>

</cfcomponent>