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
package jcharts;

import net.sf.fspdfs.engine.JRExpression;
import net.sf.fspdfs.engine.component.XmlDigesterConfigurer;
import net.sf.fspdfs.engine.xml.JRExpressionFactory;

import org.apache.commons.digester.Digester;

/**
 * 
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: ChartsDigester.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class ChartsDigester implements XmlDigesterConfigurer
{

	public void configureDigester(Digester digester)
	{
		String axisChartPattern = "*/componentElement/axisChart";
		digester.addFactoryCreate(axisChartPattern, AxisChartXmlFactory.class.getName());
		
		String axisDatasetPattern = axisChartPattern + "/axisDataset";
		digester.addFactoryCreate(axisDatasetPattern, AxisDatasetXmlFactory.class.getName());
		digester.addSetNext(axisDatasetPattern, "setDataset", AxisDataset.class.getName());

		String labelExpressionPattern = axisDatasetPattern + "/labelExpression";
		digester.addFactoryCreate(labelExpressionPattern, JRExpressionFactory.StringExpressionFactory.class.getName());
		digester.addCallMethod(labelExpressionPattern, "setText", 0);
		digester.addSetNext(labelExpressionPattern, "setLabelExpression", JRExpression.class.getName());

		String valueExpressionPattern = axisDatasetPattern + "/valueExpression";
		digester.addFactoryCreate(valueExpressionPattern, JRExpressionFactory.DoubleExpressionFactory.class.getName());
		digester.addCallMethod(valueExpressionPattern, "setText", 0);
		digester.addSetNext(valueExpressionPattern, "setValueExpression", JRExpression.class.getName());

		String legendExpressionPattern = axisChartPattern + "/legendLabelExpression";
		digester.addFactoryCreate(legendExpressionPattern, JRExpressionFactory.StringExpressionFactory.class.getName());
		digester.addCallMethod(legendExpressionPattern, "setText", 0);
		digester.addSetNext(legendExpressionPattern, "setLegendLabelExpression", JRExpression.class.getName());
	}

}