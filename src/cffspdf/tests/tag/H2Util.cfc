<cfcomponent displayname="H2Util" hint="h2 util">

	<cffunction name="init">
		<cfargument name="cfadminpassword" required="true" />
		<cfset variables.cfadminpassword = arguments.cfadminpassword />
		<cfreturn this />
	</cffunction>

	<cffunction name="dsnExists">
		<cfargument name="dsn" required="true" />
		<cfset var datasources = "" />
		<cfadmin action="getDatasources" type="web" password="#variables.cfadminpassword#" returnVariable="datasources">
		<cfset var dsExists = ListFindNoCase(ValueList(datasources.name), arguments.dsn) />
		<cfif NOT dsexists>
			<cfreturn false />
		</cfif>
		<cfreturn true />
	</cffunction>

	<cffunction name="createDSN" access="public" output="false">
		<cfargument name="dsn" required="true" />
		<cfargument name="dbname" default="#arguments.dsn#" />
		<cfargument name="dbtype" default="h2" />
		<cfargument name="dbusername" default="sa" />
		<cfargument name="dbpassword" default="" />
		<cfargument name="host" default="" />
		<cfargument name="path" default="#getDirectoryFrompath(getBaseTemplatePath())#/db/#dbname#">
		<!--- This is the CF7, CF8 installation of Datasources --->
		<cfset var sClassName = "" />
		<cfset var sPort      = "" />
		<cfset var result     = {status:false,message:""} />
		<cftry>
			<cfadmin 
				action="getDatasources"
				type="web"
				password="#variables.cfadminpassword#"
				returnVariable="datasources">
			<cfset dsExists = ListFindNoCase(ValueList(datasources.name), arguments.dsn) />
			<cfif dsexists>
				<cfthrow type="duplicateDatasource" message="Datasource already exists" />
			</cfif>
			<cfif arguments.dbType EQ "mssql" OR arguments.dbType EQ "mssql_2005">
				<cfset var sClassName="com.microsoft.jdbc.sqlserver.SQLServerDriver" />
				<cfset var sPort = "1433" />
				<cfset var sDSN  = "jdbc:sqlserver://{host}:{port}" />
			<cfelseif arguments.dbType EQ "mysql">
				<cfset var sClassName="org.gjt.mm.mysql.Driver" />
				<cfset var sPort = "3306" />
				<cfset var sDSN  = "jdbc:mysql://{host}:{port}/{database}" />
			<cfelseif arguments.dbType EQ "hssql">
				<cfset var sClassName="org.hsqldb.jdbcDriver" />
				<cfset var sDSN  = "jdbc:hsqldb:file:/tmp/#dbname#" />
			<cfelseif arguments.dbType EQ "h2">
				<cfdirectory action="create" directory="#arguments.path#">
				<cfset var sClassName="org.h2.Driver" />
				<cfset var sDSN  = "jdbc:h2:file:#arguments.path#" />
			</cfif>
			<cfadmin 
				action="updateDatasource"
				type="web"
				password="#variables.cfadminpassword#"
				name = "#arguments.dsn#"
				dsn = "#sDSN#"
				host = "#arguments.host#"
				database = "#arguments.dbName#"
				dbusername = "#arguments.dbusername#"
				dbpassword = "#arguments.dbpassword#"
				classname = "#sClassName#"
				port = "#sPort#"
				connectionLimit = -1
				connectionTimeout = 1
				blob = "true"
				clob = "true"
				allowed_select = "true"
				allowed_insert = "true"
				allowed_update = "true"
				allowed_delete = "true"
				allowed_alter = "true"
				allowed_drop = "true"
				allowed_revoke = "true"
				allowed_create = "true"
				allowed_grant = "true"
				custom="#structNew()#" />
			<cftry>
				<cfadmin 
					action="verifyDatasource"
					type="web"
					password="#variables.cfadminpassword#"
					name="#arguments.dsn#"
					dbusername = "#arguments.dbusername#"
					dbpassword = "#arguments.dbpassword#" />
				<cfset result.status=true />
				<cfcatch>
					<!--- Roll back --->
					<cfset result.message =  cfcatch.Message &   " " & cfcatch.Detail />
					<cfset removeDSN(arguments.dsn) />
				</cfcatch>
			</cftry>
			<cfcatch type="any"><cfset result.message =  cfcatch.Message &   " " & cfcatch.Detail /></cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>

	<cffunction name="removeDSN" access="public" output="false">
		<cfargument name="dsn" required="true" />
		<cfargument name="path" default="" />
		<!--- This is the CF7, CF8 installation of Datasources --->
		<cfset var sClassName = "" />
		<cfset var sPort      = "" />
		<cfset var result     = {status:false,message:""} />
		<cftry>
			<cfadmin action="getDatasources" type="web" password="#variables.cfadminpassword#" returnVariable="datasources">
			<cfset dsExists = ListFindNoCase(ValueList(datasources.name), arguments.dsn) />
			<cfif NOT dsexists>
				<cfthrow type="noSuchDatasource" message="Datasource does not exist" />
			</cfif>
			<cfadmin action="removeDatasource" type="web" password="#variables.cfadminpassword#" name="#arguments.dsn#">
			<cfset result.status = true />
			<cfcatch type="any"><cfset result.message =  cfcatch.Message &   " " & cfcatch.Detail /></cfcatch>
		</cftry>
		<cfif arguments.path NEQ "">
			<cfdirectory action="delete" directory="#arguments.path#">
		</cfif>
		<cfreturn result />
	</cffunction>

</cfcomponent>
