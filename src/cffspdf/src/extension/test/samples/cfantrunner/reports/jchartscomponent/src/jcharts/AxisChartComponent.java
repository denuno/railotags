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

import java.awt.Color;
import java.io.Serializable;

import net.sf.fspdfs.engine.JRExpression;
import net.sf.fspdfs.engine.base.JRBaseObjectFactory;
import net.sf.fspdfs.engine.component.Component;
import net.sf.fspdfs.engine.type.EvaluationTimeEnum;

/**
 * 
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: AxisChartComponent.java 3515 2010-03-05 11:22:10Z teodord $
 */
public class AxisChartComponent implements Component, Serializable
{

	private static final long serialVersionUID = 1L;

	private Color areaColor;
	private EvaluationTimeEnum evaluationTime;
	private String evaluationGroup;
	
	private JRExpression legendLabelExpression;
	private AxisDataset dataset;

	public AxisChartComponent()
	{
	}

	protected AxisChartComponent(AxisChartComponent chart, JRBaseObjectFactory baseFactory)
	{
		this.areaColor = chart.getAreaColor();
		this.evaluationTime = chart.getEvaluationTime();
		this.evaluationGroup = chart.getEvaluationGroup();
		
		this.legendLabelExpression = baseFactory.getExpression(chart.getLegendLabelExpression());
		this.dataset = new CompiledAxisDataset(chart.getDataset(), baseFactory);
	}
	
	public AxisDataset getDataset()
	{
		return dataset;
	}

	public void setDataset(AxisDataset dataset)
	{
		this.dataset = dataset;
	}
	
	public EvaluationTimeEnum getEvaluationTime()
	{
		return evaluationTime;
	}

	public void setEvaluationTime(EvaluationTimeEnum evaluationTime)
	{
		this.evaluationTime = evaluationTime;
	}

	public String getEvaluationGroup()
	{
		return evaluationGroup;
	}

	public void setEvaluationGroup(String evaluationGroup)
	{
		this.evaluationGroup = evaluationGroup;
	}
	
	public Color getAreaColor()
	{
		return areaColor;
	}

	public void setAreaColor(Color areaColor)
	{
		this.areaColor = areaColor;
	}
	
	public JRExpression getLegendLabelExpression()
	{
		return legendLabelExpression;
	}

	public void setLegendLabelExpression(JRExpression legendLabelExpression)
	{
		this.legendLabelExpression = legendLabelExpression;
	}

}