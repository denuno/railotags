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

import java.util.HashMap;
import java.util.Map;

import net.sf.fspdfs.engine.JREmptyDataSource;
import net.sf.fspdfs.engine.JRException;
import net.sf.fspdfs.engine.JasperExportManager;
import net.sf.fspdfs.engine.JasperFillManager;
import net.sf.fspdfs.engine.util.AbstractSampleApp;

/**
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: Java5App.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class Java5App extends AbstractSampleApp
{


	/**
	 *
	 */
	public static void main(String[] args) 
	{
		main(new Java5App(), args);
	}
	
	
	/**
	 *
	 */
	public void test() throws JRException
	{
		fill();
		pdf();
	}
	
	
	/**
	 *
	 */
	public void fill() throws JRException
	{
		long start = System.currentTimeMillis();
		Map<String,Object> parameters = new HashMap<String,Object>();
		parameters.put("greeting", Greeting.bye);
		
		JasperFillManager.fillReportToFile("build/reports/Java5Report.jasper", parameters, new JREmptyDataSource());
		System.err.println("Filling time : " + (System.currentTimeMillis() - start));
	}
	
	
	/**
	 *
	 */
	public void pdf() throws JRException
	{
		long start = System.currentTimeMillis();
		JasperExportManager.exportReportToPdfFile("build/reports/Java5Report.jrprint");
		System.err.println("PDF creation time : " + (System.currentTimeMillis() - start));
	}

}
