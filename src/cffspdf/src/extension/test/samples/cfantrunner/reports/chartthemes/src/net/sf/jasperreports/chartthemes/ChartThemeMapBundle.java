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
package net.sf.fspdfs.chartthemes;

import java.util.Map;

import net.sf.fspdfs.charts.ChartTheme;
import net.sf.fspdfs.charts.ChartThemeBundle;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net) 
 * @version $Id: ChartThemeMapBundle.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class ChartThemeMapBundle implements ChartThemeBundle
{

	private Map themes;
	
	public ChartTheme getChartTheme(String themeName)
	{
		return (ChartTheme) themes.get(themeName);
	}

	public String[] getChartThemeNames()
	{
		return (String[]) themes.keySet().toArray(new String[themes.size()]);
	}

	/**
	 * @return the themes
	 */
	public Map getThemes()
	{
		return themes;
	}

	/**
	 * @param themes the themes to set
	 */
	public void setThemes(Map themes)
	{
		this.themes = themes;
	}

}
