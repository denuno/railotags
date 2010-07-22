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
package net.sf.fspdfs.chartthemes.simple;

import java.awt.Image;

import net.sf.fspdfs.engine.JRConstants;
import net.sf.fspdfs.engine.JRException;
import net.sf.fspdfs.engine.JRRuntimeException;
import net.sf.fspdfs.engine.util.JRImageLoader;
import net.sf.fspdfs.engine.util.JRLoader;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: FileImageProvider.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class FileImageProvider implements ImageProvider
{
	/**
	 * 
	 */
	private static final long serialVersionUID = JRConstants.SERIAL_VERSION_UID;

	/**
	 *
	 */
	private String file = null;

	
	/**
	 *
	 */
	public FileImageProvider()
	{
	}
	
	
	/**
	 *
	 */
	public FileImageProvider(String file)
	{
		this.file = file;
	}
	
	
	/**
	 *
	 */
	public Image getImage()
	{
		try
		{
			return
				JRImageLoader.loadImage(
					JRLoader.loadBytesFromLocation(file)
					);
		}
		catch (JRException e)
		{
			throw new JRRuntimeException(e);
		}
	}


	public String getFile() {
		return file;
	}


	public void setFile(String file) {
		this.file = file;
	}

}
