<cfcomponent name="cfantrunner">

	<!--- Meta data --->
	<cfset this.metadata.attributetype="fixed" />
	<cfset this.metadata.attributes={
		jrxml:			{required:false,type:"string",default:""},
		exporttype:			{required:false,type:"string",default:"pdf"},
		exportfile:			{required:false,type:"string",default:""},
		dsn:			{required:false,type:"string",default:""},
		params:			{required:false,type:"struct"},
		sqlstring:			{required:false,type:"string",default:""},
		datafile:			{required:false,type:"any",default:""},
		resultsVar: {required:false,type:"string",default:"report"},
		filename:			{required:false,type:"string",default:"report"},
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
				<cfthrow type="cfjasperreport.error" message="#message#" detail="#error.stacktrace#" />
				<cfcatch>
					<cfthrow type="cfjasperreport.error" message="#message#" detail="#error.toString()#" />
				</cfcatch>
			</cftry>
		</cfif>
		<cfthrow type="cfjasperreport.error" message="#message#" />
	</cffunction>

	<cffunction name="onStartTag" output="yes" returntype="boolean">
		<cfargument name="attributes" type="struct" />
		<cfargument name="caller" type="struct" />
		<cfscript>
			var report = "";

			if(structKeyExists(attributes,"params")){
				report = runReport(argumentCollection=attributes);
			}	else {
				report = runReport(argumentCollection=attributes);
			}
			if(attributes.exportfile gt "") {
				reportToFile(report,attributes.exportfile);
			} else {
				download("#attributes.filename#.#attributes.exporttype#",report,attributes.forceDownload)
			}
			caller[attributes.resultsVar] = report;
		</cfscript> 
		<cfif not variables.hasEndTag>
			<cfset onEndTag(attributes,caller,"") />
		</cfif>
		<cfreturn variables.hasEndTag />
	</cffunction>

	<cffunction name="runReport">
		<cfargument name="jrxml" type="string" required="yes" />
		<cfargument name="dataSource" default="" />
		<cfargument name="datafile" default="" />
		<cfargument name="exportType" default="pdf" />
		<cfargument name="reportparams" default="#structNew()#" />
		<cfargument name="download" default="no" />
		<cfargument name="newquery" default="" />
		<cfif fileExists(arguments.jrxml)>
			<cfset daJRXML = readJRXMLFile(arguments.jrxml) />
		<cfelseif isXML(arguments.jrxml)>
			<cfset daJRXML = xmlparse(arguments.jrxml) />
		<cfelse>
			<cfthrow type="cfjasperreport.filenotfound" detail="the file #jrxml# could not be found or was not valid XML" />
		</cfif>
		<cflock name="jasperLock" type="exclusive" timeout="10">
			<cfscript>
				var system = CreateObject("java", "java.lang.System");			
				var classpath = system.getProperty("java.class.path");
				var daTitle = daJRXML.jasperReport.xmlAttributes.name;
				var daXM = toString(daJRXML);
				var params = reportparams;
				var parameters = CreateObject("java", "java.util.HashMap");
				var ka = structNew();
				var xmlBuffer = "";
				var xmlInputStream = "";
				var daConnection = "";
				if(NOT isStruct(params)) {
				 params = structNew();
				}
				ka = StructKeyArray(params);
				// convert params to hashmap
				for(i=1; i LTE ArrayLen(ka); i=i+1){
					curr_ka = ka[i];
					parameters.put(curr_ka, Evaluate("params." & curr_ka));
				}
				if(findNoCase("language=""groovy""",daXM)) {
					throw("jasperreports.compile.error","ask denny how to run groovy expressions, or remove language=""groovy"" from your JRXML file.");
				}
				
				/*				
				dicking around to get groovy expressions to work-- might need to specifically 
				use JRGroovyCompiler and set path.  Groovy works if all jars are in JVM classpath.
				
				  jasperclasspath = getJasperreportsClassPath();
				  system.setProperty("jasper.reports.compile.class.path",jasperclasspath); 
				  system.setProperty("java.class.path",jasperclasspath);
				  system.setProperty("groovy.classpath",jasperclasspath);	      
				  jrprops = CreateObject("java","net.sf.jasperreports.engine.util.JRProperties");
				  jrprops.setProperty(jrprops.COMPILER_CLASSPATH, jasperclasspath);
				*/
				
				///virtualizer = CreateObject("java", "net.sf.jasperreports.engine.fill.JRFileVirtualizer");
				///virtualizer.init(2,javacast("String","/tmp"));
				///params["REPORT_VIRTUALIZER"] = virtualizer;
				// move the param structure to an array to evaluate
				
				   //system.setProperty("jasper.reports.compiler.class","net.sf.jasperreports.compilers.JRGroovyCompiler"); 
				xmlBuffer = CreateObject("java","java.lang.String").init(daXM).getBytes();
				xmlInputStream = CreateObject("java","java.io.ByteArrayInputStream").init(xmlBuffer);
				
				if(datasource gt "") {
					var daFactory = CreateObject ("Java","coldfusion.server.ServiceFactory");
					daConnection = daFactory.getDataSourceService().getDatasource(dataSource).getConnection();
				} else if (datafile !="") {
					if(listLast(datafile,".") == "xml") {
						var xmlDataBuffer = CreateObject("java","java.lang.String").init(readBinaryFile(datafile)).getBytes();
						var xmlDataInputStream = CreateObject("java","java.io.ByteArrayInputStream").init(xmlDataBuffer);
						var jRXmlDataSource = CreateObject("java","net.sf.jasperreports.engine.data.JRXmlDataSource");
						daConnection = jRXmlDataSource.init(xmlDataInputStream,"/");
					} else {
						throw(type="cfjasperreport.datafile.error", message="unsupported datafile type #datafile#");
					}
				}
				else {
					daConnection = createObject("java","net.sf.jasperreports.engine.JREmptyDataSource");
				}
				
				var jRXmlLoader = CreateObject ("Java","net.sf.jasperreports.engine.xml.JRXmlLoader");
				var jasperDesign = jRXmlLoader.load(xmlInputStream);
				 		var jasperCompileManager = CreateObject("java","net.sf.jasperreports.engine.JasperCompileManager");
				//jasperReport = jasperCompileManager.compileReportToFile("/tmp/something.jasper");
				var jasperVerify = jasperCompileManager.verifyDesign(jasperDesign);
				if(arrayLen(jasperVerify) gt 0) {
					throw("jasperreports.report.design.flaw",jasperVerify.toString());
				}
				/*
				  used to use compileToStream for something
					outCompileStream = CreateObject("java","java.io.ByteArrayOutputStream").init();
					jasperCompileManager.compileReportToStream(jasperDesign,outCompileStream);
					saveCompiledReport(getJR.jrxmlID,outCompileStream);
					outCompileStream.close();				
				*/
				try {
					jasperReport = jasperCompileManager.compileReport(jasperDesign);
				} catch (any e) {
					//request.debug(e);
					throw("jasperreports.report.design.flaw",e.detail);
				}
				jasperFillManager = CreateObject("java","net.sf.jasperreports.engine.JasperFillManager");
				//JasperFillManager.fillReportToFile(fileName, null,
				    //            new JRXmlDataSource(new BufferedInputStream(new FileInputStream("northwind.xml")), "/Northwind/Customers"));
				//System.err.println("Filling time : " + (System.currentTimeMillis() - start));
				//System.exit(0);
				
					if(isQuery(newquery) OR newquery NEQ ""){
						if (isQuery(newquery)) {
							rs = newquery;
						}
						else {
							stmt = CreateObject("java","java.sql.Statement");
							stmt = daConnection.createStatement();
							rs = CreateObject("java","java.sql.ResultSet");
							rs = stmt.executeQuery(newquery);
						}
						drs = CreateObject("java", "net.sf.jasperreports.engine.JRResultSetDataSource");
						drs.init(rs);
						jasperPrint = CreateObject("java","net.sf.jasperreports.engine.JasperPrint");
						try{
						  jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, drs);
						}catch(JRException e){
							e.printStackTrace();
						}						
					} 
					else if (datasource gt ""){
						try{
							jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, daConnection);
							daConnection.close();
						}
						catch(JRException e){
							e.printStackTrace();
						}
					} else {
						try{
							jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, daConnection);
						}
						catch(JRException e){
							e.printStackTrace();
						}
					}
					///virtualizer.setReadOnly(true);
					//jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, jRXmlDataSource);
					var jasperExportManager = CreateObject("java","net.sf.jasperreports.engine.JasperExportManager");					
				    var expparam = CreateObject("java", "net.sf.jasperreports.engine.JRExporterParameter");
					var outStream = CreateObject("java","java.io.ByteArrayOutputStream").init();
				     //exporter.setParameter(expparam.OUTPUT_FILE_NAME,outfile);
					if (exportType is "pdf") {
						argy = jasperExportManager.exportReportToPdf(jasperPrint);
					} else {
						exporterType = ucase(left(exportType,1)) & lcase(right(exportType,len(exportType)-1)); 
				    	jRExporterParameter = CreateObject("java", "net.sf.jasperreports.engine.JRExporterParameter");
						jasperRtfExporter = CreateObject("java","net.sf.jasperreports.engine.export.JR#exporterType#Exporter");
					  	jasperRtfExporter.setParameter(jRExporterParameter.JASPER_PRINT, jasperPrint);
						jasperRtfExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, outstream);
						jasperRtfExporter.exportReport(); 
						argy = outstream;
					}
					xmlInputStream.close();
					//xmlDataInputStream.close();
					outstream.close();
					return argy;
			</cfscript> 
		</cflock>
	</cffunction>

	<cffunction name="onEndTag" output="yes" returntype="boolean">
		<cfargument name="attributes" type="struct" />
		<cfargument name="caller" type="struct" />
		<cfargument name="generatedContent" type="string" />
		<cfreturn false />
	</cffunction>

	<cffunction name="readJRXMLFile" output="false" returntype="any" access="private">
		<cfargument name="jrxmlfile" type="string" required="yes" />
		<cfset var daJR = "" />
		<cffile action="read" variable="daJR" file="#arguments.jrxmlfile#">
		<cfreturn xmlparse(daJR) />
	</cffunction>

	<cffunction name="readBinaryFile" output="false" returntype="any" access="private">
		<cfargument name="filepath" type="string" required="yes" />
		<cfset var daFile = "" />
		<cffile action="readbinary" variable="daFile" file="#arguments.filepath#">
		<cfreturn daFile />
	</cffunction>

	<cffunction name="getJasperreportsClassPath" output="false" returntype="any" access="private">
		<cfscript>
			var jarsArry = CreateObject("java","net.sf.jasperreports.engine.JasperFillManager").getClass().getClassLoader().getURLs();
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

	<cffunction name="reportToFile" output="false" returntype="void" access="private">
		<cfargument name="fileContent" required="true" />
		<cfargument name="reportfile" type="string" required="yes" />
		<cfset var daJR = "" />
		<cffile action="write" output="#arguments.fileContent#" file="#arguments.reportfile#">
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
		<cfheader name="Content-Disposition" value="#cvalue#">
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
