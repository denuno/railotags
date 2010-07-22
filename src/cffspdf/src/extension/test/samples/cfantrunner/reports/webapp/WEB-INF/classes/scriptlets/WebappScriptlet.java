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
package scriptlets;

import net.sf.fspdfs.engine.JRDefaultScriptlet;
import net.sf.fspdfs.engine.JRScriptletException;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: WebappScriptlet.java 3031 2009-08-27 11:14:57Z teodord $
 */
public class WebappScriptlet extends JRDefaultScriptlet
{


	/**
	 *
	 */
	public void afterGroupInit(String groupName) throws JRScriptletException
	{
		String allCities = (String)this.getVariableValue("AllCities");
		String city = (String)this.getFieldValue("City");
		StringBuffer sbuffer = new StringBuffer();
		
		if (allCities != null)
		{
			sbuffer.append(allCities);
			sbuffer.append(", ");
		}
		
		sbuffer.append(city);
		this.setVariableValue("AllCities", sbuffer.toString());
	}


	/**
	 *
	 */
	public String hello() throws JRScriptletException
	{
		return "Hello! I'm the report's scriptlet object.";
	}


}