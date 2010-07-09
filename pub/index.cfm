<cfset props = {
			"dist":expandPath("download"),
			"extension.extensionDownloadURL":"#getContextRoot()#/extensions/ExtensionProvider.cfc?method=download&amp;id="
			} />


<cfset extens = "cfantrunner,cfdocfonts,memory" />
<cfset extens = "cfdocfonts,cfjasperreport,cfsvn,cfantrunner,memory" />
<!--- 
<cfset target = "build-test" />
 --->
<cfset target = "build" />

<cfdirectory action="list" directory="../src/" name="src">
<cfoutput>
<h3>Available Extension Builds</h3>
<p>Log into the <a href="#getContextRoot()#/railo-context/admin/server.cfm?action=extension.applications">Railo Server Admin : Applications</a> to install after building (password: testtest)</p>
</cfoutput>
<ul>
	<li><a href="?build=all">Build All</a> | <a href="?build=all&ignore-build-errors=1">Build All Ignore</a></li>
<cfoutput query="src">
  <cfif fileExists(directory & "/#name#/build/build.xml")>
		<cf_antrunner action="getTargets" antfile="#directory#/#name#/build/build.xml"/>
		<select name="target">
		<cfloop query="cfantrunner.targets">
		<option value="#name#">target: #name# | if: #if# | unless: #unless# | depends: #depends#</option>
		</cfloop>
		</select>
		<li>#name# : 
			<a href="?build=#name#">build</a> |
			<a href="?build=#name#&ignore-build-errors=1">build-ignore-error</a> | 
			<a href="?build=#name#">build and bump version up</a></li>
		<cfif structKeyExists(url,"build") AND url.build eq name OR structKeyExists(url,"build") AND url.build eq "all">
			<cfif structKeyExists(url,"ignore-build-errors")>
			  <cfset props["mxunit.haltonerror"] = false />
			<cfelse>
			  <cfset props["mxunit.haltonerror"] = true />
			</cfif>
			<cf_antrunner antfile="#directory#/#name#/build/build.xml" properties="#props#" target="#target#" resultsVar="antres"/>
			<cfif antres.errortext eq "">
				<li>Success <a href="file://#directory#/#name#/build/testresults/html/index.html">Test Results</a></li>
				<pre>
				#antres["errortext"]#
				#antres["outtext"]#
				</pre>
			<cfelse>
				<li>Fail: #antres.errortext#</li>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>
</ul>
