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
package net.sf.fspdfs.ohloh;

import net.sf.fspdfs.engine.JRGenericPrintElement;
import net.sf.fspdfs.engine.export.GenericElementHtmlHandler;
import net.sf.fspdfs.engine.export.JRHtmlExporterContext;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id:ChartThemesUtilities.java 2595 2009-02-10 17:56:51Z teodord $
 */
public class OhlohWidgetHtmlHandler implements
		GenericElementHtmlHandler
{

	private String projectIDParameter;
	private String widgetName;
	
	public String getWidgetName()
	{
		return widgetName;
	}

	public void setWidgetName(String widgetName)
	{
		this.widgetName = widgetName;
	}

	public String getProjectIDParameter()
	{
		return projectIDParameter;
	}

	public void setProjectIDParameter(String projectIDParameter)
	{
		this.projectIDParameter = projectIDParameter;
	}

	public boolean toExport(JRGenericPrintElement element)
	{
		return getProjectID(element) != null;
	}

	protected Integer getProjectID(JRGenericPrintElement element)
	{
		return (Integer) element.getParameterValue(getProjectIDParameter());
	}

	public String getHtmlFragment(JRHtmlExporterContext context, JRGenericPrintElement element)
	{
		StringBuffer script = new StringBuffer(128);
		script.append("<script type=\"text/javascript\" src=\"http://www.ohloh.net/projects/");
		script.append(getProjectID(element));
		script.append("/widgets/");
		script.append(getWidgetName());
		script.append("\"></script>");
		return script.toString();
	}
	
}
