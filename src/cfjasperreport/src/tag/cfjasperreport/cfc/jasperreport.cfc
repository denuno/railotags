<cfcomponent name="cfantrunner">

	<!--- Meta data --->
	<cfset this.metadata.attributetype="fixed" />
	<cfset this.metadata.attributes={
		action:			{required:false,type:"string",default:"runReport"},
		jrxml:			{required:false,type:"string",default:""},
		exporttype:			{required:false,type:"string",default:"pdf"},
		exportfile:			{required:false,type:"string",default:""},
		dsn:			{required:false,type:"string",default:""},
		datasource:			{required:false,type:"string",default:""},
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
			var runFunk = this[attributes.action];
			if(attributes.dsn neq "") {
				attributes.datasource = attributes.dsn;
			}
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

	<cffunction name="runReport">
		<cfargument name="jrxml" type="string" required="yes" />
		<cfargument name="dataSource" default="" />
		<cfargument name="datafile" default="" />
		<cfargument name="exportType" default="pdf" />
		<cfargument name="reportparams" default="#structNew()#" />
		<cfargument name="download" default="no" />
		<cfargument name="newquery" default="" />
		<cfargument name="locale" default="US" />
		<cfargument name="localeLanguage" default="ENGLISH" />
		<cflock name="jasperLock" type="exclusive" timeout="10">
			<cfif fileExists(arguments.jrxml)>
				<cfset var daJRXML = readJRXMLFile(arguments.jrxml) />
			<cfelseif isXML(arguments.jrxml)>
				<cfset var daJRXML = xmlparse(arguments.jrxml) />
			<cfelse>
				<cfthrow type="cfjasperreport.filenotfound" detail="the file #jrxml# could not be found or was not valid XML" />
			</cfif>
			<cfscript>
				var jasperReport = compile(arguments.jrxml);
				var system = CreateObject("java", "java.lang.System");			
				var classpath = system.getProperty("java.class.path");
				var daTitle = daJRXML.jasperReport.xmlAttributes.name;
				var daXM = toString(daJRXML);
				var params = reportparams;
				var parameters = CreateObject("java", "java.util.HashMap");
				var ka = structNew();
				var daConnection = "";
				var LocaleOb = createObject("java","java.util.Locale");
				var JRParameter = createObject("java","net.sf.jasperreports.engine.JRParameter");
				
				if(NOT isStruct(params)) {
					params = structNew();
				}
				var ka = StructKeyArray(params);
				// convert params to hashmap
				for(i=1; i LTE ArrayLen(ka); i=i+1){
					parameters.put(ka[i], params[ka[i]]);
				}
				if(findNoCase("language=""groovy""",daXM)) {
					throw("jasperreports.compile.error","ask denny how to run groovy expressions, or remove language=""groovy"" from your JRXML file.");
				}
				if(arguments.locale gt "") {
					parameters.put(JRParameter.REPORT_LOCALE, LocaleOb[ucase(locale)]);
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
				
				if(datasource gt "" && listLast(datasource,".") == "xml") {
					var file = createObject("java","java.io.File");
					var jRXmlDataSource = CreateObject("java","net.sf.jasperreports.engine.data.JRXmlDataSource");
					daConnection = jRXmlDataSource.init(file.init(datafile));
				} else if(datasource eq "empty") {
					daConnection = createObject("java","net.sf.jasperreports.engine.JREmptyDataSource");
				} else if(datasource neq "") {
					var daFactory = CreateObject ("Java","coldfusion.server.ServiceFactory");
					daConnection = daFactory.getDataSourceService().getDatasource(dataSource).getConnection();
				} 
				
				if (datafile !="") {
					if(listLast(datafile,".") == "xml") {
				 		//JRloader = createObject("java","net.sf.jasperreports.engine.util.JRLoader");
						var JRXPathQueryExecuterFactory = createObject("java","net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory");
						parameters.put(JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, xmlParse(datafile));
						parameters.put(JRXPathQueryExecuterFactory.XML_DATE_PATTERN, "yyyy-MM-dd");
						parameters.put(JRXPathQueryExecuterFactory.XML_NUMBER_PATTERN, "##,####0.####");
						parameters.put(JRXPathQueryExecuterFactory.XML_LOCALE, LocaleOb[ucase(localeLanguage)]);
					} else {
						throw(type="cfjasperreport.datafile.error", message="unsupported datafile type #datafile#");
					}
				}
				var jasperFillManager = CreateObject("java","net.sf.jasperreports.engine.JasperFillManager");
				//JasperFillManager.fillReportToFile(fileName, null,
				    //            new JRXmlDataSource(new BufferedInputStream(new FileInputStream("northwind.xml")), "/Northwind/Customers"));
				//System.err.println("Filling time : " + (System.currentTimeMillis() - start));
				//System.exit(0);
				var jasperPrint = "";
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
							throw(type="cfjasperreport.error", message=e.printStackTrace());
						}						
					} 
					else if (datasource gt ""){
						try{
							jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, daConnection);
							try {
								daConnection.close();
							} catch(any e) {
								// we do not care, only certain datasources need closing
							}
						}
						catch(JRException e){
							throw(type="cfjasperreport.error", message=e.printStackTrace());
						}
					} else {
						try{
							jasperPrint = jasperFillManager.fillReport(jasperReport, parameters);
						}
						catch(JRException e){
							throw(type="cfjasperreport.error", message=e.printStackTrace());
						}
					}
					///virtualizer.setReadOnly(true);
					//jasperPrint = jasperFillManager.fillReport(jasperReport, parameters, jRXmlDataSource);
					var jasperExportManager = CreateObject("java","net.sf.jasperreports.engine.JasperExportManager");					
				    var expparam = CreateObject("java", "net.sf.jasperreports.engine.JRExporterParameter");
					var outStream = CreateObject("java","java.io.ByteArrayOutputStream").init();
					var argy = '';
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
					outstream.close();
					return argy;
			</cfscript> 
		</cflock>
	</cffunction>

	<cffunction name="compile">
		<cfargument name="jrxml" type="string" required="yes" />
		<cfargument name="tofile" type="string" default="" />

		<cfif fileExists(arguments.jrxml)>
			<cfset var daJRXML = readJRXMLFile(arguments.jrxml) />
		<cfelseif isXML(arguments.jrxml)>
			<cfset var daJRXML = xmlparse(arguments.jrxml) />
		<cfelse>
			<cfthrow type="cfjasperreport.filenotfound" detail="the file #jrxml# could not be found or was not valid XML" />
		</cfif>
		<cfscript>
			var system = CreateObject("java", "java.lang.System");			
			var classpath = system.getProperty("java.class.path");
			var daTitle = daJRXML.jasperReport.xmlAttributes.name;
			var daXM = toString(daJRXML);
			var xmlBuffer = CreateObject("java","java.lang.String").init(daXM).getBytes();
			var xmlInputStream = CreateObject("java","java.io.ByteArrayInputStream").init(xmlBuffer);
			var jRXmlLoader = CreateObject ("Java","net.sf.jasperreports.engine.xml.JRXmlLoader");
			var jasperDesign = jRXmlLoader.load(xmlInputStream);
	 		var jasperCompileManager = CreateObject("java","net.sf.jasperreports.engine.JasperCompileManager");
			var jasperVerify = jasperCompileManager.verifyDesign(jasperDesign);
			///virtualizer = CreateObject("java", "net.sf.jasperreports.engine.fill.JRFileVirtualizer");
			///virtualizer.init(2,javacast("String","/tmp"));
			///params["REPORT_VIRTUALIZER"] = virtualizer;
			// move the param structure to an array to evaluate
			if(arrayLen(jasperVerify) gt 0) {
				errors = ""
				for(var x = 1; x lte arrayLen(jasperVerify); x++) {
					errors = listAppend(errors, jasperVerify[x].getMessage() & "(" & jasperVerify[x].getSource().getText() & ")");
				}
				throw("jasperreports.report.design.flaw",errors);
			}
			try {
				if(tofile neq "") {
					var jasperReport = jasperCompileManager.compileReportToFile(tofile);
				} else {
					var jasperReport = jasperCompileManager.compileReport(jasperDesign);
				}
			} catch (any e) {
				throw("jasperreports.report.compile.error",e.message & " -- " & e.detail);
			}
			xmlInputStream.close();
			return jasperReport;
		</cfscript> 
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
		<cffile action="read" variable="daJR" file="#arguments.jrxmlfile#" charset="utf-8">
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
