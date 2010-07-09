<cfset props = {
			"dist":expandPath("download"),
			"extension.extensionDownloadURL":"#getContextRoot()#/extensions/ExtensionProvider.cfc?method=download&amp;id="
			} />


<cfset extens = "cfantrunner,cfdocfonts,memory" />
<cfset extens = "cfdocfonts,cfjasperreport,cfsvn,cfantrunner,memory" />
<!--- 
<cfset target = "build-test" />
 --->
<cfparam name="target" default="build" />

<cfdirectory action="list" directory="../src/" name="src">
<cfoutput>
<h3><a href="?">Available Extension Builds</a></h3>
<p>Run the "build" target next to an extension listed below</p>
<p>Log into the <a href="#getContextRoot()#/railo-context/admin/server.cfm?action=extension.applications">Railo Server Admin : Applications</a> to install after building (password: testtest)</p>
<p>The provider (<a href="http://#cgi.HTTP_HOST##getContextRoot()#/extensions/ExtensionProvider.cfc?method=extensionlist">http://#cgi.HTTP_HOST##getContextRoot()#/extensions/ExtensionProvider.cfc</a>) has already been added.</p>
</cfoutput>
<ul>
<!--- 
	<li><a href="?build=all">Build All</a> | <a href="?build=all&ignore-build-errors=1">Build All Ignore</a></li>
 --->
<cfoutput query="src">
  <cfif fileExists(directory & "/#name#/build/build.xml")>
<!--- 
		<cf_antrunner action="getTargets" antfile="#directory#/#name#/build/build.xml"/>
		<select name="target">
		<cfloop query="cfantrunner.targets">
		<option value="#name#">target: #name# | if: #if# | unless: #unless# | depends: #depends#</option>
		</cfloop>
		</select>
 --->
		<li>
			<form action="?build=#name#" method="post">
				<strong>#name#</strong>
				<cf_antrunner action="getTargets" antfile="#directory#/#name#/build/build.xml"/>
				<select name="target">
				<cfloop query="cfantrunner.targets">
					<cfif description neq "">
						<option value="#name#">#listLast(name,".")# (#description#)</option>
					</cfif>
				</cfloop>
				</select>
				<input type="submit" value="run target">
			</form>
<!--- 
			<a href="?build=#name#">build</a> |
			<a href="?build=#name#&ignore-build-errors=1">build ignore-error</a> | 
			<a href="?build=#name#&target=build-test">build-test</a> | 
			<a href="?build=#name#&ignore-build-errors=1&target=build-test">build-test ignore-error</a> | 
			<a href="?build=#name#&target=build-revision">build and bump version up</a> |
			<a href="?build=#name#&target=build-revision-test">test and build and bump version up</a></li>
 --->
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
