<cfset datafile = getDirectoryFromPath(getCurrentTemplatePath()) & "/data/northwind.xml" />
<cfset font = createObject("java","java.awt.Font") />
<cfset ge = createObject("java","java.awt.GraphicsEnvironment").getLocalGraphicsEnvironment() />
<cfset fontFile = createObject("java","java.io.File").init("/workspace/railotags/src/cfjasperreport/src/extension/test/examples/charts/fonts/dejavu/DejaVuSerif.ttf") />
<cfdump var="#fontfile.exists()#">
<cfset ge.registerFont(font.createFont(font.TRUETYPE_FONT, fontFile)) />
