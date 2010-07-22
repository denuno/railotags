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

import java.io.IOException;

import net.sf.fspdfs.engine.component.Component;
import net.sf.fspdfs.engine.component.ComponentKey;
import net.sf.fspdfs.engine.component.ComponentXmlWriter;
import net.sf.fspdfs.engine.component.ComponentsEnvironment;
import net.sf.fspdfs.engine.type.EvaluationTimeEnum;
import net.sf.fspdfs.engine.util.JRXmlWriteHelper;
import net.sf.fspdfs.engine.util.XmlNamespace;
import net.sf.fspdfs.engine.xml.JRXmlWriter;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: PieChartXmlWriter.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class PieChartXmlWriter implements ComponentXmlWriter
{

	public void writeToXml(ComponentKey componentKey, Component component,
			JRXmlWriter reportWriter) throws IOException
	{
		PieChartComponent chart = (PieChartComponent) component;
		JRXmlWriteHelper writer = reportWriter.getXmlWriteHelper();
		
		String namespaceURI = componentKey.getNamespace();
		String schemaLocation = ComponentsEnvironment
			.getComponentsBundle(namespaceURI).getXmlParser().getPublicSchemaLocation();
		XmlNamespace namespace = new XmlNamespace(namespaceURI, componentKey.getNamespacePrefix(),
				schemaLocation);
		
		writer.startElement("pieChart", namespace);
		
		writer.addAttribute("evaluationTime", chart.getEvaluationTime(), EvaluationTimeEnum.NOW);
		if (chart.getEvaluationTime() == EvaluationTimeEnum.GROUP)
		{
			writer.addEncodedAttribute("evaluationGroup", chart.getEvaluationGroup());
		}
		
		PieDataset dataset = chart.getDataset();
		writer.startElement("pieDataset");
		
		reportWriter.writeElementDataset(dataset);
		
		writer.writeExpression("keyExpression", dataset.getKeyExpression(), false);
		writer.writeExpression("valueExpression", dataset.getValueExpression(), false);
		
		writer.closeElement();//pieDataset
		
		writer.writeExpression("titleExpression", chart.getTitleExpression(), false);
		
		writer.closeElement();//pieChart
	}

}
