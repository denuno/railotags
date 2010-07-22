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

import net.sf.fspdfs.engine.JRGenericPrintElement;
import net.sf.fspdfs.engine.JRPrintText;
import net.sf.fspdfs.engine.JRRuntimeException;
import net.sf.fspdfs.engine.export.JRExporterGridCell;
import net.sf.fspdfs.engine.export.oasis.GenericElementOdtHandler;
import net.sf.fspdfs.engine.export.oasis.JROdtExporter;
import net.sf.fspdfs.engine.export.oasis.JROdtExporterContext;

/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: ChartPdfHandler.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class ChartOdtHandler extends BaseChartHandler implements GenericElementOdtHandler
{
	public void exportElement(
		JROdtExporterContext exporterContext,
		JRGenericPrintElement element,
		JRExporterGridCell gridCell
		)
	{
		JROdtExporter exporter = (JROdtExporter)exporterContext.getExporter();
		
		JRExporterGridCell newGridCell = getGridCellReplacement(exporterContext, element, gridCell); 
		
		try
		{
			exporter.exportText(exporterContext.getTableBuilder(), (JRPrintText)newGridCell.getElement(), newGridCell);
		}
		catch (IOException e)
		{
			throw new JRRuntimeException(e);
		}
	}
}