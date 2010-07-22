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
package net.sf.fspdfs.components.ofc;

import java.util.ArrayList;
import java.util.List;

import net.sf.fspdfs.engine.JRExpressionCollector;
import net.sf.fspdfs.engine.design.JRDesignElementDataset;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: DesignBarDataset.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class DesignBarDataset extends JRDesignElementDataset implements BarDataset
{
	
	private static final long serialVersionUID = 1L;

	private List seriesList = new ArrayList();
	
	public void collectExpressions(JRExpressionCollector collector)
	{
		BarChartCompiler.collectExpressions(this, collector);
	}

	public List getSeries()
	{
		return seriesList;
	}
	
	public void addSeries(BarSeries series)
	{
		seriesList.add(series);
	}

}
