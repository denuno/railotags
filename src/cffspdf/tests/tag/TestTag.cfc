<cfcomponent displayname="TestInstall"  extends="mxunit.framework.TestCase">

	<cfimport taglib="/cffspdf/src/tag/cffspdf" prefix="jr" />

	<cffunction name="setUp" returntype="void" access="public">
		<cfset datapath = "#getDirectoryFromPath(getMetadata(this).path)#../data" />
		<cfset workpath = "#getDirectoryFromPath(getMetadata(this).path)#../data/work" />
		<cfset dbpath = datapath & "/db/fspdf" />
		<cftry>
			<jr:fspdf xhtml="#datapath#/test.jrxml" pdf="/tmp/delme.pdf"/>
			<cfcatch>
				<cfset debug(cfcatch) />
				<cfif findNoCase("is not defined in directory",cfcatch.message) OR
					findNoCase("no definition for the class with the specifed name",cfcatch.message)>
					<cfset install = createObject("component","cffspdf.tests.extension.TestInstall") />
					<cfset install.setUp() />
					<cfset install.testInstallDevCustomTag() />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="teardown" returntype="void" access="public">
	</cffunction>

	<cffunction name="testfspdfsFileNotFound">
		<cftry>
			<jr:fspdf jrxml="#datapath#/not-here.jrxml" dsn="fspdf" exportfile="#workpath#/idcards-dsn.pdf" exporttype="pdf"/>
			<cfcatch>
				<cfset assertEquals("cffspdf.filenotfound",cfcatch.type) />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testXmlToPDF">
		<jr:fspdf xhtml="#datapath#/idcards-dsn.jrxml" exportfile="#workpath#/idcards-dsn.pdf" exporttype="pdf"/>
		<!--- <cfset debug(cffspdf)/> --->
	</cffunction>

	<cffunction name="testUrlToPDF">
		<jr:fspdf xhtml="http://www.google.com" exportfile="#workpath#/google.pdf" exporttype="pdf"/>
		<jr:fspdf xhtml="http://www.andreacfm.com/post.cfm/bad-html-to-xhtml-the-railo-way" exportfile="#workpath#/andreacfm.pdf" exporttype="pdf"/>

		<!--- <cfset debug(cffspdf)/> --->
	</cffunction>

	<cffunction name="testUrlToPDF">
		<jr:fspdf xhtml="http://www.andreacfm.com/post.cfm/bad-html-to-xhtml-the-railo-way" exportfile="#workpath#/andreacfm.pdf" exporttype="pdf"/>
		<cfpdf source="cffspdf" pages="1" action="thumbnail" destination="." format="jpg" overwrite="true" resolution="high" scale="25"/>
		<!--- <cfset debug(cffspdf)/> --->
	</cffunction>

</cfcomponent>
