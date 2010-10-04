// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion
{
	
import flash.geom.ColorTransform;
import flash.utils.*;
import flash.filters.*;
import flash.utils.getQualifiedClassName;
	
[DefaultProperty("keyframesCompact")]

/**
 * The Motion class stores a keyframe animation sequence that can be applied to a visual object.
 * The animation data includes position, scale, rotation, skew, color, filters, and easing.
 * The Motion class has methods for retrieving data at specific points in time, and
 * interpolating values between keyframes automatically. 
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 * @keyword Motion, Copy Motion as ActionScript    
 * @see ../../motionXSD.html Motion XML Elements   
 */
public class Motion 
{

    /**
     * An object that stores information about the context in which the motion was created,
     * such as framerate, dimensions, transformation point, and initial position, scale, rotation and skew.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     */
	public var source:Source;



    /**
     * An array of keyframes that define the motion's behavior over time.
     * This property is a sparse array, where a keyframe is placed at an index in the array
     * that matches its own index. A motion object with keyframes at 0 and 5 has 
     * a keyframes array with a length of 6.  
     * Indices 0 and 5 in the array each contain a keyframe, 
     * and indices 1 through 4 have null values.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     */
	[ArrayElementType("fl.motion.Keyframe")]
	public var keyframes:Array;



    /**
     * @private
     */
	private var _keyframesCompact:Array;

    /**
     * A compact array of keyframes, where each index is occupied by a keyframe. 
     * By contrast, a sparse array has empty indices (as in the <code>keyframes</code> property). 
     * In the compact array, no <code>null</code> values are used to fill indices between keyframes.
     * However, the index of a keyframe in <code>keyframesCompact</code> likely does not match its index in the <code>keyframes</code> array.
     * <p>This property is primarily used for compatibility with the Flex MXML compiler,
     * which generates a compact array from the motion XML.</p>
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript 
     * @see #keyframes
     */
	public function get keyframesCompact():Array
	{  
		this._keyframesCompact = [];
		for each (var kf:Keyframe in this.keyframes)
		{
			if (kf)
				this._keyframesCompact.push(kf);
		}
		return this._keyframesCompact;
	}

    /**
     * @private (setter)
     */
	[ArrayElementType("fl.motion.Keyframe")]
	public function set keyframesCompact(compactArray:Array):void
	{
		this._keyframesCompact = compactArray.concat();
		this.keyframes = [];
		for each (var kf:Keyframe in this._keyframesCompact)
		{
			this.addKeyframe(kf);
		}
	}
 
 
    /**
     * Constructor for Motion instances.
     * By default, one initial keyframe is created automatically, with default transform properties.
     *
     * @param xml Optional E4X XML object defining a Motion instance.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     */
	function Motion(xml:XML=null)
	{
		this.keyframes = [];
		
		this.parseXML(xml);
		if (!this.source)
			this.source = new Source();
			
		// ensure there is at least one keyframe
		if (this.duration == 0)
		{
			var kf:Keyframe = new Keyframe();
			kf.index = 0;
			this.addKeyframe(kf);
		}
	}



    /**
     * @private
     */
	private var _duration:int = 0;

    /**
     * Controls the Motion instance's length of time, measured in frames.
     * The duration cannot be less than the time occupied by the Motion instance's keyframes.
     * @default 0
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     */
	public function get duration():int
	{
		// check again on the getter because the keyframes array may have changed after the setter was called
		if (this._duration < this.keyframes.length)
			this._duration = this.keyframes.length;
		return this._duration;
	}

    /**
     * @private (setter)
     */
	public function set duration(value:int):void
	{
		if (value < this.keyframes.length)
			value = this.keyframes.length;
		this._duration = value;
	}



    /**
     * @private
     */
	private function indexOutOfRange(index:int):Boolean
	{
		return (isNaN(index) || index < 0 || index > this.duration-1);
	}


	
	/**
	 * Retrieves the keyframe that is currently active at a specific frame in the Motion instance.
	 * A frame that is not a keyframe derives its values from the keyframe that preceded it.  
	 * 
	 * <p>This method can also filter values by the name of a specific tweenables property.
	 * You can find the currently active keyframe for <code>x</code>, which may not be
	 * the same as the currently active keyframe in general.</p>
	 * 
	 * @param index The index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 * 
     * @param tweenableName Optional name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
	 * 
	 * @return The closest matching keyframe at or before the supplied frame index.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     * @see fl.motion.Tweenables
	 */
	public function getCurrentKeyframe(index:int, tweenableName:String=''):Keyframe
	{
		// catch out-of-range frame values
		if ((isNaN(index) || index < 0 || index > this.duration-1))
			return null;
		// start at the given time and go backward until we hit a keyframe that matches
		for (var i:int=index; i>0; i--) 
		{
			var kf:Keyframe = this.keyframes[i];
			// if a keyframe exists, return it if the name matches or no name was given, 
			// or if it's tweening all properties
			if (kf && kf.affectsTweenable(tweenableName))
			{
				return kf;
			}
		}
		// return the first keyframe if no other match
		return this.keyframes[0];
	}


	/**
	 * Retrieves the next keyframe after a specific frame in the Motion instance.
	 * If a frame is not a keyframe, and is in the middle of a tween, 
	 * this method derives its values from both the preceding keyframe and the following keyframe.
	 * 
	 * <p>This method can also filter by the name of a specific tweenables property.
     * This allows you to find the next keyframe for <code>x</code>, which may not be
	 * the same as the next keyframe in general.</p>
	 * 
	 * @param index The index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 * 
     * @param tweenableName Optional name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
	 * 
	 * @return The closest matching keyframe after the supplied frame index.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     * @see fl.motion.Tweenables     
	 */
	public function getNextKeyframe(index:int, tweenableName:String=''):Keyframe
	{
		// catch out-of-range frame values 
		if ((isNaN(index) || index < 0 || index > this.duration-1))
			return null;
		
		// start just after the given time and go forward until we hit a keyframe that matches
		for (var i:int=index+1; i<this.keyframes.length; i++) 
		{
			var kf:Keyframe = this.keyframes[i];
			// if a keyframe exists, return it if no name was given or the name matches or there's a keyframe tween
			if (kf && kf.affectsTweenable(tweenableName))
			{
				return kf;
			}
		}
		return null;
	}

	

    /**
     * Sets the value of a specific tweenables property at a given time index in the Motion instance.
     * If a keyframe doesn't exist at the index, one is created automatically.
     *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than zero.
	 * If the index is zero, no change is made. 
	 * Because the transform properties are relative to the starting transform of the target object,
	 * the first frame's values are always default values and should not be changed.
     *
     * @param tweenableName The name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
     *
     * @param value The new value of the tweenable property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript      
     * @see fl.motion.Tweenables         
     */
	public function setValue(index:int, tweenableName:String, value:Number):void
	{
		if (index==0) return;
		
		var kf:Keyframe = this.keyframes[index];
		if (!kf)
		{
			kf = new Keyframe();
			kf.index = index;
			this.addKeyframe(kf);
		}
 		
		kf.setValue(tweenableName, value);
	}



    /**
     * Retrieves an interpolated ColorTransform object at a specific time index in the Motion instance.
     *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than or equal to zero.
     *
     * @return The interpolated ColorTransform object.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see flash.geom.ColorTransform
     */
 	public function getColorTransform(index:int):ColorTransform
	{
		var result:ColorTransform = null;
		var curKeyframe:Keyframe = this.getCurrentKeyframe(index, 'color');	
		if (!curKeyframe || !curKeyframe.color) 
			return null;
		
		var begin:ColorTransform = curKeyframe.color;
		var timeFromKeyframe:Number = index - curKeyframe.index;
		var tween:ITween = curKeyframe.getTween('color') || curKeyframe.getTween('alpha') || curKeyframe.getTween();

		if (timeFromKeyframe == 0 || !tween)
		{
			result = begin;
		}	
		else if (tween)
		{
			var nextKeyframe:Keyframe = this.getNextKeyframe(index, 'color');
			if (!nextKeyframe || !nextKeyframe.color) 
			{
				result = begin;
			}
			else
			{
				var nextColor:ColorTransform = nextKeyframe.color;
				var keyframeDuration:Number = nextKeyframe.index - curKeyframe.index;
				var easedTime:Number = tween.getValue(timeFromKeyframe, 0, 1, keyframeDuration);
			
				result = Color.interpolateTransform(begin, nextColor, easedTime);
			}
		}

		return result;
	} 


    /**
     * Retrieves an interpolated array of filters at a specific time index in the Motion instance.
     *
	 * @param index The time index of a frame in the Motion, as an integer greater than or equal to zero.
     *
     * @return The interpolated array of filters. 
     * If there are no applicable filters, returns an empty array.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see flash.filters
     */
 	public function getFilters(index:Number):Array
	{
		var result:Array = null;
		var curKeyframe:Keyframe = this.getCurrentKeyframe(index, 'filters');	
		if (!curKeyframe || !curKeyframe.filters.length) 
			return [];
		
		var begin:Array = curKeyframe.filters;
		var timeFromKeyframe:Number = index - curKeyframe.index;
		var tween:ITween = curKeyframe.getTween('filters') || curKeyframe.getTween();

		if (timeFromKeyframe == 0 || !tween)
		{
			result = begin;
		}	
		else if (tween)
		{ 
			var nextKeyframe:Keyframe = this.getNextKeyframe(index, 'filters');
			if (!nextKeyframe || !nextKeyframe.filters.length) 
			{
				result = begin;
			}
			else
			{
				var nextFilters:Array = nextKeyframe.filters;
				var keyframeDuration:Number = nextKeyframe.index - curKeyframe.index;
				var easedTime:Number = tween.getValue(timeFromKeyframe, 0, 1, keyframeDuration);
			
				result = interpolateFilters(begin, nextFilters, easedTime);
			}
		}

		return result;
	} 


    /**
     * Retrieves the value for an animation property at a point in time.
     *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than or equal to zero.
     *
     * @param tweenableName The name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see fl.motion.Tweenables     
     */
	public function getValue(index:Number, tweenableName:String):Number
	{
		var result:Number = NaN;
		
		// range checking is done in getCurrentKeyindex()
		var curKeyframe:Keyframe = this.getCurrentKeyframe(index, tweenableName);
		if (!curKeyframe || curKeyframe.blank) return NaN;
		
		var begin:Number = curKeyframe.getValue(tweenableName);
		
		// If the property isn't defined at this keyframe, 
		// we have to figure out what it should be at this time, 
		// so grab the value from the previous keyframe--works recursively.
		if (isNaN(begin) && curKeyframe.index > 0)
		{
			//var prevKeyframe:Keyframe = this.getCurrentKeyframe(curKeyframe.index-1, tweenableName);
			begin = this.getValue(curKeyframe.index-1, tweenableName);
		}
		
		if (isNaN(begin)) return NaN;
		
		var timeFromKeyframe:Number = index - curKeyframe.index;
		// if we're right on the first keyframe, use the value defined on it 
		if (timeFromKeyframe == 0) 
			return begin;
		
		// Search for a possible tween targeted to an individual property. 
		// If the property doesn't have a tween, check for a tween targeting all properties.
		var tween:ITween = curKeyframe.getTween(tweenableName) 
			|| curKeyframe.getTween();
		
		// if there is no interpolation, use the value at the current keyframe 
		if (!tween  
	   		|| (!curKeyframe.tweenScale 
	   			&& (tweenableName == Tweenables.SCALE_X || tweenableName == Tweenables.SCALE_Y)) 
 
 	   		|| (curKeyframe.rotateDirection == RotateDirection.NONE 
	   			&& (tweenableName == Tweenables.ROTATION || tweenableName == Tweenables.SKEW_X || tweenableName == Tweenables.SKEW_Y)) 		   		
			)
		{
			return begin;
		}

		// Now we know we have a tween, so find the next keyframe and interpolate
		var nextKeyframeTweenableName:String = tweenableName;
		// If the tween is targeting all properties, the next keyframe will terminate the tween, 
		// even if it doesn't directly affect the tweenable.
		// This check is necessary for the case where the object doesn't change x, y, etc. in the XML at all 
		// during the tween, but rotates using the rotateTimes property.
		if (tween.target == '') 
			nextKeyframeTweenableName = '';
		var nextKeyframe:Keyframe = this.getNextKeyframe(index, nextKeyframeTweenableName);
		
		if (!nextKeyframe || nextKeyframe.blank) 
		{
			return begin;
		}
		else
		{
			var nextValue:Number = nextKeyframe.getValue(tweenableName);
			if (isNaN(nextValue))
			{
				nextValue = begin;
			}
				
			var change:Number = nextValue - begin; 
				
			if ((tweenableName == Tweenables.SKEW_X 
				|| tweenableName == Tweenables.SKEW_Y)
				|| tweenableName == Tweenables.ROTATION)
			{
				// At this point, we've already eliminated RotateDirection.NONE as a possibility.
				// The remaining options are AUTO, CW and CCW
				if (curKeyframe.rotateDirection == RotateDirection.AUTO)
				{
					change %= 360;
					// detect the shortest direction around the circle 
					// i.e. keep the amount of rotation less than 180 degrees 
					if (change > 180)
						change -= 360;
					else if (change < -180)
						change += 360;
				}
				else if (curKeyframe.rotateDirection == RotateDirection.CW)
				{
					// force the rotation to be positive and clockwise
					if (change < 0) 
					{
						change = change % 360 + 360;
					}
					change += curKeyframe.rotateTimes * 360;
				}
				else	// CCW
				{
					// force the rotation to be negative and counter-clockwise
					if (change > 0) 
					{
						change = change % 360 - 360;
					}
					change -= curKeyframe.rotateTimes * 360;
				}
			}
			
			var keyframeDuration:Number = nextKeyframe.index - curKeyframe.index;
			result = tween.getValue(timeFromKeyframe, begin, change, keyframeDuration);
		}
			
		return result;
	}


    /**
     * Adds a keyframe object to the Motion instance. 
     *
     * @param newKeyframe A keyframe object with an index property already set.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see fl.motion.Keyframe       
     */
	public function addKeyframe(newKeyframe:Keyframe):void
	{ 
		this.keyframes[newKeyframe.index] = newKeyframe;
		if (this.duration < this.keyframes.length)
			this.duration = this.keyframes.length;
	}



    /**
     * @private
     */
	private function parseXML(xml:XML):Motion
	{
		if (!xml) return this;
			
		//// ATTRIBUTES
		if (xml.@duration.length())
			this._duration = parseInt(xml.@duration);

		//// CHILD ELEMENTS
		var elements:XMLList = xml.elements();
		for (var i:Number=0; i<elements.length(); i++)
		{
			var child:XML = elements[i];
			if (child.localName() == 'source')
			{
				var sourceChild:XML = child.children()[0];
				this.source = new Source(sourceChild);
			}
			else if (child.localName() == 'Keyframe')
			{
				this.addKeyframe(new Keyframe(child));
			}
		}

		return this;
	}



    /**
     * A method needed to create a Motion instance from a string of XML.
     *
     * @param xmlString A string of motion XML.
     *
     * @return A new Motion instance.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     */
	public static function fromXMLString(xmlString:String):Motion
	{
		var xml:XML = new XML(xmlString);
		return new Motion(xml);
	}
 


	

    /**
     * Blends filters smoothly from one array of filter objects to another.
     * 
     * @param fromFilters The starting array of filter objects.
     *
     * @param toFilters The ending array of filter objects.
     *
     * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
     * 
     * @return The interpolated array of filter objects.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see flash.filters       
     */
	public static function interpolateFilters(fromFilters:Array, toFilters:Array, progress:Number):Array
	{
		if (fromFilters.length != toFilters.length)
			return null;
			
		var resultFilters:Array = [];
		for (var i:int=0; i<fromFilters.length; i++)
		{
			var fromFilter:BitmapFilter = fromFilters[i];
			var toFilter:BitmapFilter = toFilters[i];
			var resultFilter:BitmapFilter = interpolateFilter(fromFilter, toFilter, progress);
			if (resultFilter)
				resultFilters.push(resultFilter);
		}
		
		return resultFilters;	
	}


    /**
     * Blends filters smoothly from one filter object to another.
     * 
     * @param fromFilters The starting filter object.
     *
     * @param toFilters The ending filter object.
     *
     * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
     * 
     * @return The interpolated filter object.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Motion, Copy Motion as ActionScript  
     * @see flash.filters       
     */
	public static function interpolateFilter(fromFilter:BitmapFilter, toFilter:BitmapFilter, progress:Number):BitmapFilter
	{
		// If we can't find a valid interpolation, because the second filter is null
		// or doesn't match the first filter, return the first filter.
		if (!toFilter || fromFilter['constructor'] != toFilter['constructor'])
			return fromFilter;
			
		if (progress > 1) progress = 1;
		else if (progress < 0) progress = 0;
		var q:Number = 1-progress;
		
		var resultFilter:BitmapFilter = fromFilter.clone();
		var filterTypeInfo:XML = getTypeInfo(fromFilter);		
		var accessorList:XMLList = filterTypeInfo.accessor;
		for each (var accessor:XML in accessorList)
		{
			var accessorName:String = accessor.@name.toString();
			var attribType:String = accessor.@type;
			if (attribType == 'Number' || attribType == 'int')	
			{
				resultFilter[accessorName] = fromFilter[accessorName]*q + toFilter[accessorName]*progress;
			}	
			else if (attribType == 'uint')
			{
				switch (accessorName)
				{
					case 'color':
					case 'highlightColor':
					case 'shadowColor':
						// for these properties, uint is a 0xRRGGBB color value, so we must interpolate r, g, b separately
		 				var color1:uint = fromFilter[accessorName];
		 				var color2:uint = toFilter[accessorName];
						var colorBlended:uint = Color.interpolateColor(color1, color2, progress);
						resultFilter[accessorName] = colorBlended;
						break;
					default:
						resultFilter[accessorName] = fromFilter[accessorName]*q + toFilter[accessorName]*progress;
						break; 
				}
			} 
		}// end accessor loop
		
		// interpolate gradient, which has arrays for colors, alphas, and ratios
		if (fromFilter is GradientGlowFilter || fromFilter is GradientBevelFilter)
		{
			var resultRatios:Array = [];
			var resultColors:Array = [];
			var resultAlphas:Array = [];
			var fromLength:int = fromFilter['ratios'].length;
			var toLength:int = toFilter['ratios'].length;
			var maxLength:int = Math.max(fromLength, toLength);
			for (var i:int=0; i<maxLength; i++)
			{
				var fromIndex:int = Math.min(i, fromLength-1);
				var fromRatio:Number = fromFilter['ratios'][fromIndex];
				var fromColor:uint = fromFilter['colors'][fromIndex];
				var fromAlpha:Number = fromFilter['alphas'][fromIndex];

				var toIndex:int = Math.min(i, toLength-1);
				var toRatio:Number = toFilter['ratios'][toIndex];
				var toColor:uint = toFilter['colors'][toIndex];
				var toAlpha:Number = toFilter['alphas'][toIndex];  
				
				var resultRatio:int = fromRatio*q + toRatio*progress;
				var resultColor:uint = Color.interpolateColor(fromColor, toColor, progress);
				var resultAlpha:Number = fromAlpha*q + toAlpha*progress;
				resultRatios[i] = resultRatio;
				resultColors[i] = resultColor;
				resultAlphas[i] = resultAlpha;
			}
			resultFilter['colors'] = resultColors;
			resultFilter['alphas'] = resultAlphas;
			resultFilter['ratios'] = resultRatios;
		}
	
 		return resultFilter;		
	}


	/**
	 *  @private
	 */
	private static var typeCache:Object = {};

	
	/**
	 * @private
	 */
	private static function getTypeInfo(o:*):XML
	{
		var className:String = '';

		if (o is String)
			className = o;
		else
			className = getQualifiedClassName(o);

		if (className in typeCache)
		{
			return typeCache[className];
		}

		if (o is String)
			o = getDefinitionByName(o);
			
		return (typeCache[className] = flash.utils.describeType(o));
	}

	
}
}
