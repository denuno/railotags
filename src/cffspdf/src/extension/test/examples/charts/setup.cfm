<!--- 
<cf_fspdf action="jrdatasource" 
		datasource="#getDirectoryFromPath(getCurrentTemplatePath())#/data/northwind.xml" 
		datasourcexpath="//ShippedDates" resultsvar="ds">
<cfset field = createObject("java","net.sf.fspdfs.engine.design.JRDesignField").init() />
<cfset field.setName("ShippedDate") />
<cfset field.setValueClassName("java.sql.Timestamp") />
<cfdump var="#ds.getFieldValue(field)#">
<cfabort>
<cfset dsname = getDirectoryFromPath(getCurrentTemplatePath()) & "/data/northwind.xml" />
 --->


<!--- 
<cfset font = createObject("java","java.awt.Font") />
<cfset ge = createObject("java","java.awt.GraphicsEnvironment").getLocalGraphicsEnvironment() />
<cfset fontFile = createObject("java","java.io.File").init("/workspace/railotags/src/cffspdf/src/extension/test/examples/charts/fonts/dejavu/DejaVuSerif.ttf") />
<cfdump var="#fontfile.exists()#">
<cfset ge.registerFont(font.createFont(font.TRUETYPE_FONT, fontFile)) />
 --->

<cfset thisdir = getDirectoryFromPath(getCurrentTemplatePath()) />
<cfset dsname = "fspdf_" & listLast(thisdir,"\/") />
<cfset dbpath = "#gettempDirectory()#/db/" & dsname />
<cfset h2util.createDSN(dsn="#dsname#",path="#dbpath#") />
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `ADDRESS` 
</cfquery>
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `ORDERS` 
</cfquery>
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `PRODUCT` 
</cfquery>
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `DOCUMENT` 
</cfquery>
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `POSITIONS` 
</cfquery>
<cfquery datasource="#dsname#">
	DROP TABLE IF EXISTS `TASKS` 
</cfquery>
<cfloop file="#thisdir#/data/northwind.sql" index="line">
	<cfquery datasource="#dsname#">
		#preserveSingleQuotes(line)#;
	</cfquery>
</cfloop>
<cfset reportparams["MaxOrderID"] = javacast("int",9999999999) />
