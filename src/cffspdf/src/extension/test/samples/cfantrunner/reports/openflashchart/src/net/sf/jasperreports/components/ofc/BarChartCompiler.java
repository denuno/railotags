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

import java.util.Iterator;


import net.sf.fspdfs.components.ofc.BarDataset;
import net.sf.fspdfs.components.ofc.BarSeries;
import net.sf.fspdfs.engine.JRExpressionCollector;
import net.sf.fspdfs.engine.base.JRBaseObjectFactory;
import net.sf.fspdfs.engine.component.Component;
import net.sf.fspdfs.engine.component.ComponentCompiler;
import net.sf.fspdfs.engine.design.JRVerifier;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: BarChartCompiler.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class BarChartCompiler implements ComponentCompiler
{

	public void collectExpressions(Component component, JRExpressionCollector collector)
	{
		BarChartComponent chart = (BarChartComponent) component;
		collector.addExpression(chart.getTitleExpression());
		collectExpressions(chart.getDataset(), collector);
	}

	public static void collectExpressions(BarDataset dataset, JRExpressionCollector collector)
	{
		collector.collect(dataset);
		
		JRExpressionCollector datasetCollector = collector.getCollector(dataset);
		for (Iterator it = dataset.getSeries().iterator(); it.hasNext();)
		{
			BarSeries series = (BarSeries) it.next();
			datasetCollector.addExpression(series.getSeriesExpression());
			datasetCollector.addExpression(series.getCategoryExpression());
			datasetCollector.addExpression(series.getValueExpression());
		}
	}

	public void verify(Component component, JRVerifier verifier)
	{
		//TODO
	}

	public Component toCompiledComponent(Component component,
			JRBaseObjectFactory baseFactory)
	{
		BarChartComponent chart = (BarChartComponent) component;
		BarChartComponent compiledChart = new BarChartComponent(chart, baseFactory);
		return compiledChart;
	}
	
}
