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
package net.sf.fspdfs.chartthemes.simple.handlers;

import java.awt.Color;

import net.sf.fspdfs.engine.util.JRColorUtil;

import org.exolab.castor.mapping.GeneralizedFieldHandler;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: ColorFieldHandler.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class ColorFieldHandler extends GeneralizedFieldHandler
{
	/**
	 *
	 */
	public ColorFieldHandler()
	{
		super();
	}
	
	/**
	 *
	 */
	public Object convertUponGet(Object value)
	{
		if (value == null)
		{
			return null;
		}
		return "#" + JRColorUtil.getColorHexa((Color)value);
	}

	/**
	 *
	 */
	public Object convertUponSet(Object value)
	{
		if (value == null)
		{
			return null;
		}
		return JRColorUtil.getColor((String)value, null);
	}
	
	/**
	 *
	 */
	public Class getFieldType()
	{
		return Color.class;
	}

	/**
	 *
	 */
	public Object newInstance(Object parent) throws IllegalStateException
	{
		//-- Since it's marked as a string...just return null,
		//-- it's not needed.
		return null;
	}
}
