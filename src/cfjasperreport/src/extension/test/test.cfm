<cfoutput>
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
