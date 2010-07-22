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
import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.fspdfs.engine.JRException;
import net.sf.fspdfs.engine.JasperExportManager;
import net.sf.fspdfs.engine.JasperFillManager;
import net.sf.fspdfs.engine.util.AbstractSampleApp;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id:ChartsApp.java 2317 2008-08-27 09:06:42Z teodord $
 */
public class ChartsApp extends AbstractSampleApp
{


	/**
	 *
	 */
	public static void main(String[] args)
	{
		main(new ChartsApp(), args);
	}
	
	
	/**
	 *
	 */
	public void test() throws JRException
	{
		fill();
		pdf();
		html();//FIXMESAMPLES move to xhtml everywhere
	}


	/**
	 *
	 */
	public void fill() throws JRException
	{
		Map parameters = new HashMap();
		parameters.put("MaxOrderID", new Integer(12500));
		
		File[] files = getFiles(new File("build/reports"), "jasper");
		for(int i = 0; i < files.length; i++)
		{
			File reportFile = files[i];
			long start = System.currentTimeMillis();
			JasperFillManager.fillReportToFile(
				reportFile.getAbsolutePath(), 
				parameters, 
				getDemoHsqldbConnection()
				);
			System.err.println("Report : " + reportFile + ". Filling time : " + (System.currentTimeMillis() - start));
		}
	}
	
	
	/**
	 *
	 */
	public void pdf() throws JRException
	{
		File[] files = getFiles(new File("build/reports"), "jrprint");
		for(int i = 0; i < files.length; i++)
		{
			File reportFile = files[i];
			long start = System.currentTimeMillis();
			JasperExportManager.exportReportToPdfFile(
				reportFile.getAbsolutePath()
				);
			System.err.println("Report : " + reportFile + ". PDF export time : " + (System.currentTimeMillis() - start));
		}
	}
	
	
	/**
	 *
	 */
	public void html() throws JRException
	{
		File[] files = getFiles(new File("build/reports"), "jrprint");
		for(int i = 0; i < files.length; i++)
		{
			File reportFile = files[i];
			long start = System.currentTimeMillis();
			JasperExportManager.exportReportToHtmlFile(
				reportFile.getAbsolutePath()
				);
			System.err.println("Report : " + reportFile + ". Html export time : " + (System.currentTimeMillis() - start));
		}
	}


	/**
	 *
	 */
	public static final Date truncateToMonth(Date date)
	{
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		calendar.clear();
		calendar.set(Calendar.YEAR, year);
		calendar.set(Calendar.MONTH, month);
		return calendar.getTime();
	}

}