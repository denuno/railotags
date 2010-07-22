/*
 * fspdfs - Free Java Reporting Library.
 * Copyright (C) 2001 - 2009 Jaspersoft Corporation. All rights reserved.
 * http://www.jaspersoft.com
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of fspdfs.
 *
 * fspdfs is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * fspdfs is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with fspdfs. If not, see <http://www.gnu.org/licenses/>.
 */
package net.sf.fspdfs.chartthemes.simple;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import net.sf.fspdfs.chartthemes.ChartThemeMapBundle;
import net.sf.fspdfs.engine.JRPropertiesMap;
import net.sf.fspdfs.engine.util.JRProperties;
import net.sf.fspdfs.extensions.DefaultExtensionsRegistry;
import net.sf.fspdfs.extensions.ExtensionsRegistry;
import net.sf.fspdfs.extensions.ExtensionsRegistryFactory;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: XmlChartThemeExtensionsRegistryFactory.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class XmlChartThemeExtensionsRegistryFactory implements
		ExtensionsRegistryFactory
{

	/**
	 * 
	 */
	public final static String XML_CHART_THEME_PROPERTY_PREFIX = 
		JRProperties.PROPERTY_PREFIX + "xml.chart.theme.";
	public final static String PROPERTY_XML_CHART_THEME_REGISTRY_FACTORY =
		DefaultExtensionsRegistry.PROPERTY_REGISTRY_FACTORY_PREFIX + "xml.chart.themes";
	
	/**
	 * 
	 */
	public ExtensionsRegistry createRegistry(String registryId,
			JRPropertiesMap properties)
	{
		List themeProperties = JRProperties.getProperties(properties, 
				XML_CHART_THEME_PROPERTY_PREFIX);
		Map themes = new HashMap();
		for (Iterator it = themeProperties.iterator(); it.hasNext();)
		{
			JRProperties.PropertySuffix themeProp = (JRProperties.PropertySuffix) it.next();
			String themeName = themeProp.getSuffix();
			String themeLocation = themeProp.getValue();
			XmlChartTheme theme = new XmlChartTheme(themeLocation);
			themes.put(themeName, theme);
		}
		
		ChartThemeMapBundle bundle = new ChartThemeMapBundle();
		bundle.setThemes(themes);
		return new ChartThemeBundlesExtensionsRegistry(bundle);
	}

	/**
	 * 
	 */
	public static void saveToJar(ChartThemeSettings settings, String themeName, File file) throws IOException
	{
		FileOutputStream fos = null;

		try
		{
			fos = new FileOutputStream(file);
			ZipOutputStream zipos = new ZipOutputStream(fos);
			zipos.setMethod(ZipOutputStream.DEFLATED);
			
			ZipEntry propsEntry = new ZipEntry("fspdfs_extension.properties");
			zipos.putNextEntry(propsEntry);
			Properties props = new Properties();
			props.put(PROPERTY_XML_CHART_THEME_REGISTRY_FACTORY, XmlChartThemeExtensionsRegistryFactory.class.getName());
			props.put(XML_CHART_THEME_PROPERTY_PREFIX + themeName, themeName + ".jrctx");
			props.store(zipos, null);

			ZipEntry jrctxEntry = new ZipEntry(themeName + ".jrctx");
			zipos.putNextEntry(jrctxEntry);
			XmlChartTheme.saveSettings(settings, new OutputStreamWriter(zipos));

			zipos.flush();
			zipos.finish();
		}
		finally
		{
			if (fos != null)
			{
				try
				{
					fos.close();
				}
				catch (IOException e)
				{
				}
			}
		}
	}

}