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

import net.sf.fspdfs.engine.component.Component;
import net.sf.fspdfs.engine.component.ComponentFillFactory;
import net.sf.fspdfs.engine.component.FillComponent;
import net.sf.fspdfs.engine.fill.JRFillCloneFactory;
import net.sf.fspdfs.engine.fill.JRFillObjectFactory;

/**
 * 
 * @author Lucian Chirita (lucianc@users.sourceforge.net)
 * @version $Id: AxisChartFillFactory.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class AxisChartFillFactory implements ComponentFillFactory
{

	public FillComponent toFillComponent(Component component,
			JRFillObjectFactory factory)
	{
		return new FillAxisChart((AxisChartComponent) component, factory);
	}

	public FillComponent cloneFillComponent(FillComponent component,
			JRFillCloneFactory factory)
	{
		throw new UnsupportedOperationException();
	}

}
