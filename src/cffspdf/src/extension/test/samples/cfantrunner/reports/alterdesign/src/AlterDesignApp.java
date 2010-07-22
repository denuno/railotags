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
import java.awt.Color;
import java.io.File;

import net.sf.fspdfs.engine.JRDataSource;
import net.sf.fspdfs.engine.JRException;
import net.sf.fspdfs.engine.JRRectangle;
import net.sf.fspdfs.engine.JRStyle;
import net.sf.fspdfs.engine.JasperExportManager;
import net.sf.fspdfs.engine.JasperFillManager;
import net.sf.fspdfs.engine.JasperPrint;
import net.sf.fspdfs.engine.JasperPrintManager;
import net.sf.fspdfs.engine.fspdf;
import net.sf.fspdfs.engine.util.AbstractSampleApp;
import net.sf.fspdfs.engine.util.JRLoader;
import net.sf.fspdfs.engine.util.JRSaver;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: AlterDesignApp.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class AlterDesignApp extends AbstractSampleApp
{
	
	
	/**
	 *
	 */
	public static void main(String[] args)
	{
		main(new AlterDesignApp(), args);
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
		File sourceFile = new File("build/reports/AlterDesignReport.jasper");
		System.err.println(" : " + sourceFile.getAbsolutePath());
		fspdf fspdf = (fspdf)JRLoader.loadObject(sourceFile);
		
		JRRectangle rectangle = (JRRectangle)fspdf.getTitle().getElementByKey("first.rectangle");
		rectangle.setForecolor(new Color((int)(16000000 * Math.random())));
		rectangle.setBackcolor(new Color((int)(16000000 * Math.random())));

		rectangle = (JRRectangle)fspdf.getTitle().getElementByKey("second.rectangle");
		rectangle.setForecolor(new Color((int)(16000000 * Math.random())));
		rectangle.setBackcolor(new Color((int)(16000000 * Math.random())));

		rectangle = (JRRectangle)fspdf.getTitle().getElementByKey("third.rectangle");
		rectangle.setForecolor(new Color((int)(16000000 * Math.random())));
		rectangle.setBackcolor(new Color((int)(16000000 * Math.random())));

		JRStyle style = fspdf.getStyles()[0];
		style.setFontSize(16);
		style.setItalic(true);

		JasperPrint jasperPrint = JasperFillManager.fillReport(fspdf, null, (JRDataSource)null);
		
		File destFile = new File(sourceFile.getParent(), fspdf.getName() + ".jrprint");
		JRSaver.saveObject(jasperPrint, destFile);
		
		System.err.println("Filling time : " + (System.currentTimeMillis() - start));
	}


	/**
	 *
	 */
	public void print() throws JRException
	{
		long start = System.currentTimeMillis();
		JasperPrintManager.printReport("build/reports/AlterDesignReport.jrprint", true);
		System.err.println("Printing time : " + (System.currentTimeMillis() - start));
	}

	
	/**
	 *
	 */
	public void pdf() throws JRException
	{
		long start = System.currentTimeMillis();
		JasperExportManager.exportReportToPdfFile("build/reports/AlterDesignReport.jrprint");
		System.err.println("PDF creation time : " + (System.currentTimeMillis() - start));
	}

	
}
