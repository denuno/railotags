<cfset h2util = createObject("component","H2Util").init(cfadminpassword="testtest") />
<cfoutput>
	<cfif not isDefined("action")>
		<cffunction name="action">
			<cfargument name="name">
			<cfreturn '?'>
		</cffunction>
	</cfif>
	<cfdirectory action="list" directory="./examples" name="exampledirs"/>
	<cfloop query="exampledirs">
		<h3>#name#</h3>
		<cfdirectory action="list" directory="./examples/#name#/reports" name="examplereports" filter="*.jrxml"/>
		<cfloop query="examplereports">
			<form action="#action('overview')#runreport=1" method="post">
				<input type="hidden" name="exampledir" value="#exampledirs.name#">
				<input type="hidden" name="jrxml" value="#examplereports.name#">
				<strong>#examplereports.name#</strong>
				type:
				<select name="exporttype">
					<cfset exporttypes = "PDF:pdf,Excel (POI):xls,RTF:rtf,xml:xml,xmlEmbed:xmlEmbed,HTML:html,Excel (jExcelAPI):jxl,CSV:csv,ODT:odt,ODS:ods,DOCX:docx,XLSX:xlsx,PowerPoint (PPTX):pptx,XHTML:xhtml" />
					<cfloop list="#exporttypes#" index="lst">
						<option value="#listLast(lst,':')#">#listFirst(lst,':')#</option>
					</cfloop>
				</select>
				<input type="submit" value="run report">
				<br />	
			</form>
		</cfloop>
	</cfloop>
	<cfdump var="#exampleDirs#">
	<cfif structKeyExists(url,"runreport")>
		<cfset dsname = "" />
		<cfset datafile = "" />
		<cfinclude template="examples/#form.exampledir#/setup.cfm">
		<cf_jasperreport 
			jrxml="#expandPath('.')#/examples/#form.exampledir#/reports/#form.jrxml#" 
			filename="#listFirst(form.jrxml,'.')#"
			dsn="#dsname#"
			datafile="#datafile#"
			exporttype="#form.exporttype#"/>	
	</cfif>

	<a href="#action('overview')#&viewsource=1" style="float:right;">View Source</a>
	<h3>Report 1</h3>
	<a href="#action('overview')#&testdownload=1&exporttype=pdf">Test PDF Download</a> |
	<a href="#action('overview')#&testdownload=1&exporttype=rtf">Test RTF Download</a> |
	<a href="#action('overview')#&testdownload=1&exporttype=xls">Test Excel Download</a> |
	<a href="#action('overview')#&testdownload=1&exporttype=csv">Test CSV Download</a>
	<cfif structKeyExists(url,"testdownload")>
		<cf_jasperreport jrxml="#getDirectoryFromPath(getMetadata(this).path)#test.jrxml" exportfile="/tmp/roobs.pdf" exporttype="#url.exportType#"/>
		<cf_jasperreport jrxml="#getDirectoryFromPath(getMetadata(this).path)#test.jrxml" filename="Report1Test" exporttype="#url.exportType#"/>
	</cfif>

</cfoutput>
