<cfcomponent name="fspdf">

	<!--- Meta data --->
	<cfset this.metadata.attributetype="fixed" />
	<cfset this.metadata.attributes={
		action:			{required:false,type:"string",default:"render"},
		xhtml:			{required:false,type:"string",default:""},
		exportfile:			{required:false,type:"string",default:""},
		params:			{required:false,type:"struct"},
		resultsVar:			{required:false,type:"string",default:"cffspdf"},
		filename:			{required:false,type:"string",default:"rendering.pdf"},
		forceDownload: {required:false,type:"boolean",default:"false"}
		} />

	<cffunction name="init" output="no" returntype="void" hint="invoked after tag is constructed">
		<cfargument name="hasEndTag" type="boolean" required="yes" />
		<cfargument name="parent" type="component" required="no" hint="the parent cfc custom tag, if there is one" />
		<cfset var libs = "" />
		<cfset variables.hasEndTag = arguments.hasEndTag />
	</cffunction>

	<cffunction name="throw">
		<cfargument name="message" />
		<cfargument name="error" />
		<cfif structKeyExists(arguments,"error")>
			<!--- <cfset request.debug(error) /> --->
			<cftry>
				<cfthrow type="cffspdf.error" message="#message#" detail="#error.stacktrace#" />
				<cfcatch>
					<cfthrow type="cffspdf.error" message="#message#" detail="#error.toString()#" />
				</cfcatch>
			</cftry>
		</cfif>
		<cfthrow type="cffspdf.error" message="#message#" />
	</cffunction>

	<cffunction name="onStartTag" output="yes" returntype="boolean">
		<cfargument name="attributes" type="struct" />
		<cfargument name="caller" type="struct" />
		<cfscript>
			var report = "";
			var runFunk = this[attributes.action];
			var results = runFunk(argumentCollection=attributes);
			if(attributes.action == "runReport") {
				if(attributes.exportfile gt "") {
					reportToFile(results,attributes.exportfile);
				} else {
					download("#attributes.filename#.#attributes.exporttype#",results,attributes.forceDownload)
				}
			}
			caller[attributes.resultsVar] = results;
		</cfscript>
		<cfif not variables.hasEndTag>
			<cfset onEndTag(attributes,caller,"") />
		</cfif>
		<cfreturn variables.hasEndTag />
	</cffunction>

	<cffunction name="render">
		<cfargument name="xhtml" type="string" required="yes" />
		<cfargument name="exportfile" default="" />
		<cflock name="jasperLock" type="exclusive" timeout="10">
			<cfscript>
				try{
					var FileOutputStream = createObject("java","java.io.FileOutputStream");
					var ByteArrayOutputStream = createObject("java","java.io.ByteArrayOutputStream");
					var ITextRenderer = createObject("java","org.xhtmlrenderer.pdf.ITextRenderer");
					var XMLResource = createObject("java","org.xhtmlrenderer.pdf.ITextRenderer");
					var InputSource = createObject("java","org.xml.sax.InputSource");
					var File = createObject("java","java.io.File");
					var os = ByteArrayOutputStream.init();
					if(fileExists(xhtml)){
						//xhtml = File.init(xhtml).toURI().toURL().toString();
						xhtml = readFile(xhtml);
					} else if (findNocase("http",xhtml)) {
						xhtml = getFileFromURL(xhtml);
					}
					renderer = ITextRenderer.init();
            		renderer.setDocumentFromString(trim(htmlParse(xhtml)));
/*
 					if(isSimplevalue(xhtml) && xhtml.startsWith("http")) {
						request.debug(xhtml);
	            		renderer.setDocumentFromString(trim(xhtml));
					} else {
						renderer.setDocument(xmlParse(readFile(xhtml)), xhtml);
					}

 */
  					renderer.layout();
					renderer.createPDF(os);
					os.close();
					if(exportfile neq "") {
						writeFile(os,exportfile);
					}
					return os.toString();
				} finally {
				   try {
				      // os.close();
				   } catch (IOException e) {
				       os.close();
				   }
				}

			</cfscript>
		</cflock>
	</cffunction>

	<cffunction name="onEndTag" output="yes" returntype="boolean">
		<cfargument name="attributes" type="struct" />
		<cfargument name="caller" type="struct" />
		<cfargument name="generatedContent" type="string" />
		<cfreturn false />
	</cffunction>

	<cffunction name="getFileFromURL">
		<cfargument name="url" required="true">
		<cfhttp url="#arguments.url#" redirect="true" resolveurl="false" />
		<cfreturn cfhttp.FileContent />
	</cffunction>

	<cffunction name="readFile" output="false" returntype="any" access="private">
		<cfargument name="filepath" type="string" required="yes" />
		<cfargument name="readtype" default="binary">
		<cfset var daFile = "" />
		<cffile action="read#readtype#" variable="daFile" file="#arguments.filepath#">
		<cfreturn daFile />
	</cffunction>

	<cffunction name="getfspdfsClassPath" output="false" returntype="any" access="private">
		<cfscript>
			var jarsArry = CreateObject("java","net.sf.fspdfs.engine.JasperFillManager").getClass().getClassLoader().getURLs();
			var system = CreateObject("java", "java.lang.System");
			var classpath = system.getProperty("java.class.path");
			var delim = system.getProperty("path.separator");
			for(x = 1; x lte arrayLen(jarsArry); x++) {
				jarpath = replace(jarsArry[x].toString(),"file:","");
				classpath = listAppend(classpath,jarpath,delim);
			}
		</cfscript>
		<cfreturn classpath />
	</cffunction>

	<cffunction name="writeFile" output="false" returntype="void" access="private">
		<cfargument name="fileContent" required="true" />
		<cfargument name="file" type="string" required="yes" />
		<cfset var daJR = "" />
		<cffile action="write" output="#arguments.fileContent#" file="#arguments.file#">
	</cffunction>

	<cffunction name="download" output="true" returntype="void" access="private">
		<cfargument name="fileName" required="true" />
		<cfargument name="fileContent" required="true" />
		<cfargument name="forceDownload" default="false" />
		<cfset var cvalue = "" />
		<cfset var out = "" />
		<cfset var content = "" />
		<cfset var context = "" />
		<cfset var response = "" />
		<cfsetting showdebugoutput="no">
		<cfsetting enablecfoutputonly="yes">
		<cfif arguments.forceDownload>
			<cfset cvalue = 'attachment;' />
		</cfif>
		<cfset cvalue = cvalue & "filename=#arguments.fileName#" />
		<cfheader name="Content-Disposition" value="#cvalue#" charset="utf-8">
		<!---
			<cfdump var="#filecontent#" abort>
			--->
		<!---
			Doesn't work for some reason, maybe application.cfc?
			<cfheader name="Content-Disposition" value="#cvalue#" charset="utf-8">
			<cfcontent type="application/#exportType#" reset="true"><cfoutput>#arguments.fileContent#</cfoutput>
			--->
		<cfscript>
			content = toBinary(arguments.fileContent);
			 context = getPageContext();
			 response = context.getResponse();
			 out = response.getOutputStream();
			 response.setContentType("application/#listLast(filename,'.')#");
			 response.setContentLength(arrayLen(content));
			 out.write(content);
			 out.flush();
			 out.close();
		</cfscript>
	</cffunction>

</cfcomponent>
