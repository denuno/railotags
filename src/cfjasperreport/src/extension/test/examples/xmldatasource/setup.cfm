<cfset datafile = getDirectoryFromPath(getCurrentTemplatePath()) & "/data/northwind.xml" />
<cf_jasperreport action="compile" jrxml="#getDirectoryFromPath(getCurrentTemplatePath())#/reports/OrdersReport.jrxml" resultsVar="subreport">
<cfset reportparams["OrdersReport"] = subreport />