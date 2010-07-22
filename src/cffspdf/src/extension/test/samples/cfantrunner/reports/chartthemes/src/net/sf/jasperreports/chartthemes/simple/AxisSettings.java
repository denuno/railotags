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

import java.awt.Stroke;
import java.io.Serializable;

import net.sf.fspdfs.engine.JRConstants;
import net.sf.fspdfs.engine.JRFont;
import net.sf.fspdfs.engine.base.JRBaseFont;
import net.sf.fspdfs.engine.design.events.JRChangeEventsSupport;
import net.sf.fspdfs.engine.design.events.JRPropertyChangeSupport;

import org.jfree.chart.axis.AxisLocation;
import org.jfree.ui.RectangleInsets;


/**
 * @author Teodor Danciu (teodord@users.sourceforge.net)
 * @version $Id: AxisSettings.java 3030 2009-08-27 11:12:48Z teodord $
 */
public class AxisSettings implements JRChangeEventsSupport, Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = JRConstants.SERIAL_VERSION_UID;

	public static final String PROPERTY_visible = "visible";
	public static final String PROPERTY_location = "location";
	public static final String PROPERTY_linePaint = "linePaint";
	public static final String PROPERTY_lineStroke = "lineStroke";
	public static final String PROPERTY_lineVisible = "lineVisible";
//	public static final String PROPERTY_fixedDimension = "fixedDimension";
//	public static final String PROPERTY_label = "label";
	public static final String PROPERTY_labelAngle = "labelAngle";
	public static final String PROPERTY_labelPaint = "labelPaint";
	public static final String PROPERTY_labelFont = "labelFont";
	public static final String PROPERTY_labelInsets = "labelInsets";
	public static final String PROPERTY_labelVisible = "labelVisible";
	public static final String PROPERTY_tickLabelPaint = "tickLabelPaint";
	public static final String PROPERTY_tickLabelFont = "tickLabelFont";
	public static final String PROPERTY_tickLabelInsets = "tickLabelInsets";
	public static final String PROPERTY_tickLabelsVisible = "tickLabelsVisible";
	public static final String PROPERTY_tickMarksInsideLength = "tickMarksInsideLength";
	public static final String PROPERTY_tickMarksOutsideLength = "tickMarksOutsideLength";
	public static final String PROPERTY_tickMarksPaint = "tickMarksPaint";
	public static final String PROPERTY_tickMarksStroke = "tickMarksStroke";
	public static final String PROPERTY_tickMarksVisible = "tickMarksVisible";
	public static final String PROPERTY_tickCount = "tickCount";
	public static final String PROPERTY_tickInterval = "tickInterval";

	/**
	 *
	 */
	private Boolean visible = null;
	private AxisLocation location = null;
	private PaintProvider linePaint = null;
	private Stroke lineStroke = null;
	private Boolean lineVisible = null;
//	private String label = null;
	private Double labelAngle = null;
	private PaintProvider labelPaint = null;
	private JRFont labelFont = new JRBaseFont();
	private RectangleInsets labelInsets = null;
	private Boolean labelVisible = null;
	private PaintProvider tickLabelPaint = null;
	private JRFont tickLabelFont = new JRBaseFont();
	private RectangleInsets tickLabelInsets = null;
	private Boolean tickLabelsVisible = null;
	private Float tickMarksInsideLength = null;
	private Float tickMarksOutsideLength = null;
	private PaintProvider tickMarksPaint = null;
	private Stroke tickMarksStroke = null;
	private Boolean tickMarksVisible = null;
	private Integer tickCount = null;
	private Number tickInterval = null;
	
	/**
	 *
	 */
	public AxisSettings()
	{
	}
	

	private transient JRPropertyChangeSupport eventSupport;
	
	public JRPropertyChangeSupport getEventSupport()
	{
		synchronized (this)
		{
			if (eventSupport == null)
			{
				eventSupport = new JRPropertyChangeSupport(this);
			}
		}
		
		return eventSupport;
	}

	/**
	 * @return the visible
	 */
	public Boolean getVisible() {
		return visible;
	}

	/**
	 * @param visible the visible property to set
	 */
	public void setVisible(Boolean visible) {
		Boolean old = getVisible();
		this.visible = visible;
		getEventSupport().firePropertyChange(PROPERTY_visible, old, getVisible());
	}

	/**
	 * @return the location
	 */
	public AxisLocation getLocation()
	{
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(AxisLocation location)
	{
		AxisLocation old = getLocation();
		this.location = location;
		getEventSupport().firePropertyChange(PROPERTY_location, old, getLocation());
	}

	/**
	 * @return the linePaint
	 */
	public PaintProvider getLinePaint()
	{
		return linePaint;
	}

	/**
	 * @param linePaint the linePaint to set
	 */
	public void setLinePaint(PaintProvider linePaint)
	{
		PaintProvider old = getLinePaint();
		this.linePaint = linePaint;
		getEventSupport().firePropertyChange(PROPERTY_linePaint, old, getLinePaint());
	}

	/**
	 * @return the lineVisible
	 */
	public Boolean getLineVisible()
	{
		return lineVisible;
	}

	/**
	 * @param lineVisible the lineVisible to set
	 */
	public void setLineVisible(Boolean lineVisible)
	{
		Boolean old = getLineVisible();
		this.lineVisible = lineVisible;
		getEventSupport().firePropertyChange(PROPERTY_lineVisible, old, getLineVisible());
	}

//	/**
//	 * @return the label
//	 */
//	public String getLabel()
//	{
//		return label;
//	}

//	/**
//	 * @param label the label to set
//	 */
//	public void setLabel(String label)
//	{
//		String old = getLabel();
//		this.label = label;
//		getEventSupport().firePropertyChange(PROPERTY_label, old, getLabel());
//	}

	/**
	 * @return the labelAngle
	 */
	public Double getLabelAngle()
	{
		return labelAngle;
	}

	/**
	 * @param labelAngle the labelAngle to set
	 */
	public void setLabelAngle(Double labelAngle)
	{
		Double old = getLabelAngle();
		this.labelAngle = labelAngle;
		getEventSupport().firePropertyChange(PROPERTY_labelAngle, old, getLabelAngle());
	}

	/**
	 * @return the labelPaint
	 */
	public PaintProvider getLabelPaint()
	{
		return labelPaint;
	}

	/**
	 * @param labelPaint the labelPaint to set
	 */
	public void setLabelPaint(PaintProvider labelPaint)
	{
		PaintProvider old = getLabelPaint();
		this.labelPaint = labelPaint;
		getEventSupport().firePropertyChange(PROPERTY_labelPaint, old, getLabelPaint());
	}

	/**
	 * @return the labelFont
	 */
	public JRFont getLabelFont()
	{
		return labelFont;
	}

	/**
	 * @param labelFont the labelFont to set
	 */
	public void setLabelFont(JRFont labelFont)
	{
		JRFont old = getLabelFont();
		this.labelFont = labelFont;
		getEventSupport().firePropertyChange(PROPERTY_labelFont, old, getLabelFont());
	}

	/**
	 * @return the labelInsets
	 */
	public RectangleInsets getLabelInsets()
	{
		return labelInsets;
	}

	/**
	 * @param labelInsets the labelInsets to set
	 */
	public void setLabelInsets(RectangleInsets labelInsets)
	{
		RectangleInsets old = getLabelInsets();
		this.labelInsets = labelInsets;
		getEventSupport().firePropertyChange(PROPERTY_labelInsets, old, getLabelInsets());
	}

	/**
	 * @return the labelVisible
	 */
	public Boolean getLabelVisible()
	{
		return labelVisible;
	}

	/**
	 * @param labelVisible the labelVisible to set
	 */
	public void setLabelVisible(Boolean labelVisible)
	{
		Boolean old = getLabelVisible();
		this.labelVisible = labelVisible;
		getEventSupport().firePropertyChange(PROPERTY_labelVisible, old, getLabelVisible());
	}

	/**
	 * @return the tickLabelPaint
	 */
	public PaintProvider getTickLabelPaint()
	{
		return tickLabelPaint;
	}

	/**
	 * @param tickLabelPaint the tickLabelPaint to set
	 */
	public void setTickLabelPaint(PaintProvider tickLabelPaint)
	{
		PaintProvider old = getTickLabelPaint();
		this.tickLabelPaint = tickLabelPaint;
		getEventSupport().firePropertyChange(PROPERTY_tickLabelPaint, old, getTickLabelPaint());
	}

	/**
	 * @return the tickLabelFont
	 */
	public JRFont getTickLabelFont()
	{
		return tickLabelFont;
	}

	/**
	 * @param tickLabelFont the tickLabelFont to set
	 */
	public void setTickLabelFont(JRFont tickLabelFont)
	{
		JRFont old = getTickLabelFont();
		this.tickLabelFont = tickLabelFont;
		getEventSupport().firePropertyChange(PROPERTY_tickLabelFont, old, getTickLabelFont());
	}

	/**
	 * @return the tickLabelInsets
	 */
	public RectangleInsets getTickLabelInsets()
	{
		return tickLabelInsets;
	}

	/**
	 * @param tickLabelInsets the tickLabelInsets to set
	 */
	public void setTickLabelInsets(RectangleInsets tickLabelInsets)
	{
		RectangleInsets old = getTickLabelInsets();
		this.tickLabelInsets = tickLabelInsets;
		getEventSupport().firePropertyChange(PROPERTY_tickLabelInsets, old, getTickLabelInsets());
	}

	/**
	 * @return the tickLabelsVisible
	 */
	public Boolean getTickLabelsVisible()
	{
		return tickLabelsVisible;
	}

	/**
	 * @param tickLabelsVisible the tickLabelsVisible to set
	 */
	public void setTickLabelsVisible(Boolean tickLabelsVisible)
	{
		Boolean old = getTickLabelsVisible();
		this.tickLabelsVisible = tickLabelsVisible;
		getEventSupport().firePropertyChange(PROPERTY_tickLabelsVisible, old, getTickLabelsVisible());
	}

	/**
	 * @return the tickMarksInsideLength
	 */
	public Float getTickMarksInsideLength()
	{
		return tickMarksInsideLength;
	}

	/**
	 * @param tickMarksInsideLength the tickMarksInsideLength to set
	 */
	public void setTickMarksInsideLength(Float tickMarksInsideLength)
	{
		Float old = getTickMarksInsideLength();
		this.tickMarksInsideLength = tickMarksInsideLength;
		getEventSupport().firePropertyChange(PROPERTY_tickMarksInsideLength, old, getTickMarksInsideLength());
	}

	/**
	 * @return the tickMarksOutsideLength
	 */
	public Float getTickMarksOutsideLength()
	{
		return tickMarksOutsideLength;
	}

	/**
	 * @param tickMarksOutsideLength the tickMarksOutsideLength to set
	 */
	public void setTickMarksOutsideLength(Float tickMarksOutsideLength)
	{
		Float old = getTickMarksOutsideLength();
		this.tickMarksOutsideLength = tickMarksOutsideLength;
		getEventSupport().firePropertyChange(PROPERTY_tickMarksOutsideLength, old, getTickMarksOutsideLength());
	}

	/**
	 * @return the tickMarksPaint
	 */
	public PaintProvider getTickMarksPaint()
	{
		return tickMarksPaint;
	}

	/**
	 * @param tickMarksPaint the tickMarksPaint to set
	 */
	public void setTickMarksPaint(PaintProvider tickMarksPaint)
	{
		PaintProvider old = getTickMarksPaint();
		this.tickMarksPaint = tickMarksPaint;
		getEventSupport().firePropertyChange(PROPERTY_tickMarksPaint, old, getTickMarksPaint());
	}

	/**
	 * @return the tickMarksVisible
	 */
	public Boolean getTickMarksVisible()
	{
		return tickMarksVisible;
	}

	/**
	 * @param tickMarksVisible the tickMarksVisible to set
	 */
	public void setTickMarksVisible(Boolean tickMarksVisible)
	{
		Boolean old = getTickMarksVisible();
		this.tickMarksVisible = tickMarksVisible;
		getEventSupport().firePropertyChange(PROPERTY_tickMarksVisible, old, getTickMarksVisible());
	}

	/**
	 * @return the tickCount
	 */
	public Integer getTickCount()
	{
		return tickCount;
	}

	/**
	 * @param tickCount the tickCount to set
	 */
	public void setTickCount(Integer tickCount)
	{
		Integer old = getTickCount();
		this.tickCount = tickCount;
		getEventSupport().firePropertyChange(PROPERTY_tickCount, old, getTickCount());
	}

	/**
	 * @return the tickInterval
	 */
	public Number getTickInterval()
	{
		return tickInterval;
	}

	/**
	 * @param tickInterval the tickInterval to set
	 */
	public void setTickInterval(Number tickInterval)
	{
		Number old = getTickInterval();
		this.tickInterval = tickInterval;
		getEventSupport().firePropertyChange(PROPERTY_tickInterval, old, getTickInterval());
	}

	/**
	 * @return the lineStroke
	 */
	public Stroke getLineStroke() {
		return lineStroke;
	}

	/**
	 * @param lineStroke the lineStroke to set
	 */
	public void setLineStroke(Stroke lineStroke) {
		Stroke old = getLineStroke();
		this.lineStroke = lineStroke;
		getEventSupport().firePropertyChange(PROPERTY_lineStroke, old, getLineStroke());
	}

	/**
	 * @return the tickMarksStroke
	 */
	public Stroke getTickMarksStroke() {
		return tickMarksStroke;
	}

	/**
	 * @param tickMarksStroke the tickMarksStroke to set
	 */
	public void setTickMarksStroke(Stroke tickMarksStroke) {
		Stroke old = getTickMarksStroke();
		this.tickMarksStroke = tickMarksStroke;
		getEventSupport().firePropertyChange(PROPERTY_tickMarksStroke, old, getTickMarksStroke());
	}

}