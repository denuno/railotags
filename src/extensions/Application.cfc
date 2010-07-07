<cfcomponent output="false">
<cfsilent>
<cfset this.name = "railoextensions" />

<!--- 
<cffunction name="onRequest" output="true">
	<cfif structKeyExists(url,"wsdl")>
		<cfcontent type="text/xml" file="wsdl.txt">
	<cfelse>
		<cfinclude template="#targetPage#">
	</cfif>
</cffunction>
 --->


<!--- 
<cffunction name="onRequest" output="Yes">
  <cfargument name="targetPage" type="string" required="true">
	<cfif structKeyExists(url,"method") AND url.method eq "getinfo">
		<cfheader name="Content-Length" value="477" />
		<cfheader name="Keep-Alive" value="timeout=5, max=99" />
		<cfheader name="Railo-Version" value="3.1.1.000" />
		<cfheader name="Content-Type" value="text/html;charset=UTF-8" />
		<cfheader name="Connection" value="Keep-Alive" />
	<cfsavecontent variable="info">    
			<wddxPacket version='1.0'><header/><data><struct><var name='URL'><string>http://coldshen.com</string></var><var name='DESCRIPTION'><string></string></var><var name='IMAGE'><string>http://www.getrailo.org/tasks/sites/railoorg/assets/Image/Images/railo-3-1-release.png</string></var><var name='MODE'><string>develop</string></var><var name='TITLE'><string>coldshen (railoshen.local)</string></var></struct></data></wddxPacket>
</cfsavecontent>	
	<cfset writeOutput(info)>
	<cfelseif structKeyExists(url,"method") AND url.method eq "listapplications">
		<cfheader name="Content-Length" value="477" />
		<cfheader name="Keep-Alive" value="timeout=5, max=99" />
		<cfheader name="Railo-Version" value="3.1.1.000" />
		<cfheader name="Content-Type" value="text/html;charset=UTF-8" />
		<cfheader name="Connection" value="Keep-Alive" />
	<cfsavecontent variable="info"><wddxPacket version='1.0'><header/><data><recordset rowCount='1' fieldNames='type,id,name,label,description,version,category,image,download,paypal,author,codename,video,support,documentation,forum,mailinglist,network,created' type='coldfusion.sql.QueryTable'><field name='type'><string>any</string></field><field name='id'><string>1</string></field><field name='name'><string>antrunner</string></field><field name='label'><string>antrunner</string></field><field name='description'><string>A utility tag for running ant scripts within CF</string></field><field name='version'><string>0.001</string></field><field name='category'><string>Utility</string></field><field name='image'><string></string></field><field name='download'><string>/extensions/download/antrunner-extension.zip</string></field><field name='paypal'><string></string></field><field name='author'><string>denstar</string></field><field name='codename'><string>harbinger</string></field><field name='video'><string></string></field><field name='support'><string>http://coldshen.com</string></field><field name='documentation'><string>http://coldshen.com</string></field><field name='forum'><string>http://coldshen.com</string></field><field name='mailinglist'><string></string></field><field name='network'><string></string></field><field name='created'><string>2008-8-16T6:0:0+0:0</string></field></recordset></data></wddxPacket></cfsavecontent>	
	<cfset writeOutput(info)>
	<cfelse>
		<cfinclude template="#targetPage#">
	</cfif>
</cffunction>
 --->

<!--- 
<cffunction name="onRequestEnd" output="Yes"><cfsetting enablecfoutputonly="Yes">
    <!--- forceful strip of whitespaces from CFMX Java output buffer - idea thanks to Dmitry Namiot --->
    <cfset pageContent = getPageContext().getOut().getString()>
    <cfset getPageContext().getOut().clearBuffer()>
    <!--- AJAX whitespace stripping --->
    <cfset pageContent = REReplace(pageContent, "^[[:space:]]+\*\*\*\*\/", " ****/", "all" )>
    <cfset pageContent = REReplace(pageContent, "\*\/[[:space:]]+$", "*/", "all" )>
    <cfset pageContent = REReplace(pageContent, "^[[:space:]]+<", "<", "all" )>
    <cfset pageContent = REReplace(pageContent, ">[[:space:]]+$", ">", "all" )>
    <!--- capture pure whitespace pages for those CFLOCATION tags in the middle of a logic block --->
    <cfset pageContent = REReplace(pageContent, "^[[:space:]]+$", "", "all" )>
    <cfset writeOutput("err"&pageContent&"errr")>
    <cfset getPageContext().getOut().flush()>
<cfsetting enablecfoutputonly="No"></cffunction>
 ---></cfsilent></cfcomponent>

