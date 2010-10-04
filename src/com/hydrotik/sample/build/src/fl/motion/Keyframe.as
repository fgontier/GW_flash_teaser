// Copyright � 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion
{
import flash.utils.*;
import flash.geom.ColorTransform;
import flash.filters.BitmapFilter;
import flash.display.BlendMode;

/**
 * The Keyframe class defines the visual state at a specific time in a motion tween.
 * The primary animation properties are <code>position</code>, <code>scale</code>, <code>rotation</code>, <code>skew</code>, and <code>color</code>.
 * A keyframe can, optionally, define one or more of these properties.
 * For instance, one keyframe may affect only position, 
 * while another keyframe at a different point in time may affect only scale.
 * Yet another keyframe may affect all properties at the same time.
 * Within a motion tween, each time index can have only one keyframe. 
 * A keyframe also has other properties like <code>blend mode</code>, <code>filters</code>, and <code>cacheAsBitmap</code>,
 * which are always available. For example, a keyframe always has a blend mode.   
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 * @keyword Keyframe, Copy Motion as ActionScript    
 * @see ../../motionXSD.html Motion XML Elements  
 */
public class Keyframe
{

    /**
     * @private
     */
	private var _index:int = -1;


    /**
     * The keyframe's unique time value in the motion tween. The first frame in a motion tween has an index of <code>0</code>.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript    
     */
	public function get index():int
	{
		return this._index;
	}

    /**
     * @private (setter)
     */
	public function set index(value:int):void
	{
		this._index = (value < 0) ? 0 : value;
		if (this._index == 0)
		{
			this.setDefaults();
		}
	}	
	
	// We need to be able to tell whether the XML explicitly specifies
	// a value for each property at this keyframe, in order to tween correctly. 
	// Using a default of NaN allows us to check that.
    /**
     * The horizontal position of the target object's transformation point in its parent's coordinate space.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript      
     */
	public var x:Number = NaN;


    /**
     * The vertical position of the target object's transformation point in its parent's coordinate space.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
	public var y:Number = NaN;


    /**
     * Indicates the horizontal scale as a percentage of the object as applied from the transformation point.
     * A value of <code>1</code> is 100% of normal size.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
    public var scaleX:Number = NaN;


    /**
     * Indicates the vertical scale as a percentage of the object as applied from the transformation point.
     * A value of <code>1</code> is 100% of normal size.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
    public var scaleY:Number = NaN;


    /**
     * Indicates the horizontal skew angle of the target object in degrees as applied from the transformation point.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript           
     */
    public var skewX:Number = NaN;


    /**
     * Indicates the vertical skew angle of the target object in degrees as applied from the transformation point.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript             
     */
	public var skewY:Number = NaN;


    /**
     * Indicates the rotation of the target object in degrees 
     * from its original orientation as applied from the transformation point.
     * A value of <code>NaN</code> means that the keyframe does not affect this property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
    public function get rotation():Number
    {
		return this.skewY;
    }

    
    /**
     * @private (setter)
     */
	public function set rotation(value:Number):void
	{
    	// Use Flash Player behavior: set skewY to rotation and increase skewX by the difference.
   		if (isNaN(this.skewX) || isNaN(this.skewY)) 
			this.skewX = value;
		else
			this.skewX += value - this.skewY;
		this.skewY = value;
	}



    /**
     * An array that contains each tween object to be applied to the target object at a particular keyframe.
     * One tween can target all animation properties (as with standard tweens on the Flash authoring tool's timeline),
     * or multiple tweens can target individual properties (as with separate custom easing curves).
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     */
	[ArrayElementType("fl.motion.ITween")]
	public var tweens:Array;


    /**
     * An array that contains each filter object to be applied to the target object at a particular keyframe.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
	[ArrayElementType("flash.filters.BitmapFilter")]
	public var filters:Array;


    /**
     * A color object that adjusts the color transform in the target object.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
	public var color:fl.motion.Color;


    /**
     * A string used to describe the keyframe.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
    public var label:String = '';


    /**
     * A flag that controls whether scale will be interpolated during a tween.
     * If <code>false</code>, the display object will stay the same size during the tween, until the next keyframe.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
    public var tweenScale:Boolean = true;
    
    
    /**
     * Stores the value of the Snap checkbox for motion tweens, which snaps the object to a motion guide. 
     * This property is used in the Copy and Paste Motion feature in Flash CS3 
     * but does not affect motion tweens defined using ActionScript. 
     * It is included here for compatibility with the Flex 2 compiler.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
    public var tweenSnap:Boolean = false;


    /**
     * Stores the value of the Sync checkbox for motion tweens, which affects graphic symbols only. 
     * This property is used in the Copy and Paste Motion feature in Flash CS3 
     * but does not affect motion tweens defined using ActionScript. 
     * It is included here for compatibility with the Flex 2 compiler.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript      
     */
    public var tweenSync:Boolean = false;


    /**
     * Stores the value of the Loop checkbox for motion tweens, which affects graphic symbols only. 
     * This property is used in the Copy and Paste Motion feature in Flash CS3 
     * but does not affect motion tweens defined using ActionScript. 
     * It is included here for compatibility with the Flex 2 compiler.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     */
    public var loop:String;


    /**
     * Stores the name of the first frame for motion tweens, which affects graphic symbols only. 
     * This property is used in the Copy and Paste Motion feature in Flash CS3 
     * but does not affect motion tweens defined using ActionScript. 
     * It is included here for compatibility with the Flex 2 compiler.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
    public var firstFrame:String;


    /**
     * If set to <code>true</code>, Flash Player caches an internal bitmap representation of the display object.
     * Using this property often allows faster rendering than the default use of vectors.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
    public var cacheAsBitmap:Boolean = false;


    /**
     * A value from the BlendMode class that specifies how Flash Player 
     * mixes the display object's colors with graphics underneath it.
     * 
     * @see flash.display.BlendMode
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
	public var blendMode:String = flash.display.BlendMode.NORMAL;


    /**
     * Controls how the target object rotates during a motion tween,
     * with a value from the RotateDirection class.
	 *
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     * @see fl.motion.RotateDirection
     */
    public var rotateDirection:String = RotateDirection.AUTO;


    /**
     * Adds rotation to the target object during a motion tween, in addition to any existing rotation.
     * This rotation is dependent on the value of the <code>rotateDirection</code> property,
     * which must be set to <code>RotateDirection.CW</code> or <code>RotateDirection.CCW</code>. 
     * The <code>rotateTimes</code> value must be an integer that is equal to or greater than zero.
     * 
     * <p>For example, if the object would normally rotate from 0 to 40 degrees,
     * setting <code>rotateTimes</code> to <code>1</code> and <code>rotateDirection</code> to <code>RotateDirection.CW</code>
     * will add a full turn, for a total rotation of 400 degrees.</p>
     * 
     * If <code>rotateDirection</code> is set to <code>RotateDirection.CCW</code>,
     * 360 degrees will be <i>subtracted</i> from the normal rotation,
     * resulting in a counterclockwise turn of 320 degrees.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     * @see #rotateDirection    
     */
    public var rotateTimes:uint = 0;


    /**
     * If set to <code>true</code>, this property causes the target object to rotate automatically 
     * to follow the angle of its path. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     */
	public var orientToPath:Boolean = false;


    /**
     * Indicates that the target object should not be displayed on this keyframe.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript         
     */
	public var blank:Boolean = false;


    /**
     * Constructor for keyframe instances.
     *
     * @param xml Optional E4X XML object defining a keyframe in Motion XML format.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
	function Keyframe(xml:XML=null)
	{
		this.tweens = [];
		this.filters = [];
		this.parseXML(xml);
	}


    /**
     * @private
     */
	private function setDefaults():void
	{

		if (isNaN(this.x)) this.x = 0;
		if (isNaN(this.y)) this.y = 0;
		if (isNaN(this.scaleX)) this.scaleX = 1;
		if (isNaN(this.scaleY)) this.scaleY = 1;
		if (isNaN(this.skewX)) this.skewX = 0;
		if (isNaN(this.skewY)) this.skewY = 0;
	
		if (!this.color)
			this.color = new Color();
	}




    /**
     * Retrieves the value of a specific tweenable property on the keyframe.
     *
     * @param tweenableName The name of a tweenable property, such as <code>"x"</code>
     * or <code>"rotation"</code>.
     *
     * @return The numerical value of the tweenable property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
	public function getValue(tweenableName:String):Number
	{
		return Number(this[tweenableName]);
	}



    /**
     * Changes the value of a specific tweenable property on the keyframe.
     *
     * @param tweenableName The name of a tweenable property, such as  <code>"x"</code>
     * or <code>"rotation"</code>.
     *
     * @param newValue A numerical value to assign to the tweenable property.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript       
     */
    public function setValue(tweenableName:String, newValue:Number):void
	{
		this[tweenableName] = newValue;
	}
	


    /**
     * @private
     */
	private function parseXML(xml:XML=null):Keyframe
	{
		if (!xml) return this;
 
 
		//// ATTRIBUTES

 		var indexString:String = xml.@index.toXMLString();
		var indexValue:int = parseInt(indexString);
		if (indexString)
		{
			this.index = indexValue;
		}
		else
			throw new Error('<Keyframe> is missing the required attribute "index".');
		
		if (xml.@label.length())
			this.label = xml.@label;
			
		if (xml.@tweenScale.length())
			this.tweenScale = xml.@tweenScale.toString() == 'true';

		if (xml.@tweenSnap.length())
			this.tweenSnap = xml.@tweenSnap.toString() == 'true';

		if (xml.@tweenSync.length())
			this.tweenSync = xml.@tweenSync.toString() == 'true';

		if (xml.@blendMode.length())
			this.blendMode = xml.@blendMode;
			
		if (xml.@cacheAsBitmap.length())
			this.cacheAsBitmap = xml.@cacheAsBitmap.toString() == 'true';
			
		if (xml.@rotateDirection.length())
			this.rotateDirection = xml.@rotateDirection;

		if (xml.@rotateTimes.length())
			this.rotateTimes = parseInt(xml.@rotateTimes);
		
		if (xml.@orientToPath.length())
			this.orientToPath = xml.@orientToPath.toString() == 'true';
		
		if (xml.@blank.length())
			this.blank = xml.@blank.toString() == 'true';
			
		// need to set rotation first in the order because skewX and skewY override it
		var tweenableNames:Array = ['x', 'y', 'scaleX', 'scaleY', 'rotation', 'skewX', 'skewY'];
		for each (var tweenableName:String in tweenableNames)
		{
			var attribute:XML = xml.attribute(tweenableName)[0];
			if (!attribute) continue;
			
			var attributeValue:String = attribute.toString();
			if (attributeValue)
			{
				this[tweenableName] = Number(attributeValue);
			}
		}

		//// CHILD ELEMENTS
		var elements:XMLList = xml.elements();
		var filtersArray:Array = [];

		for each (var child:XML in elements)
		{
			var name:String = child["localName"]();
			if (name == 'tweens')
			{
				var tweenChildren:XMLList = child.elements();
				for each (var tweenChild:XML in tweenChildren)
				{
					var tweenName:String = tweenChild["localName"]();
					if (tweenName == 'SimpleEase')
						this.tweens.push(new SimpleEase(tweenChild));
					else if (tweenName == 'CustomEase')
						this.tweens.push(new CustomEase(tweenChild));
					else if (tweenName == 'BezierEase')
						this.tweens.push(new BezierEase(tweenChild));
					else if (tweenName == 'FunctionEase')
						this.tweens.push(new FunctionEase(tweenChild));
				} 
			}
			else if (name == 'filters')
			{
				var filtersChildren:XMLList = child.elements();
				for each (var filterXML:XML in filtersChildren)
				{
					var filterName:String = filterXML["localName"]();
					var filterClassName:String = 'flash.filters.' + filterName;
					if (filterName == 'AdjustColorFilter')
					{
						continue;
					}
					
					var filterClass:Object = flash.utils.getDefinitionByName(filterClassName);
					var filterInstance:BitmapFilter = new filterClass();
					var filterTypeInfo:XML = describeType(filterInstance);			
					var accessorList:XMLList = filterTypeInfo.accessor; 
					var ratios:Array = [];
					
					// loop through filter properties
					for each (var attrib:XML in filterXML.attributes())
					{
						var attribName:String = attrib["localName"]();
						var accessor:XML = accessorList.(@name==attribName)[0];
						var attribType:String = accessor.@type;
						var attribValue:String = attrib.toString();
						 
						if (attribType == 'int') 
							filterInstance[attribName] = parseInt(attribValue);
						else if (attribType == 'uint') 
						{
							filterInstance[attribName] = parseInt(attribValue) as uint; 
							var uintValue:uint = parseInt(attribValue) as uint;
						}
						else if (attribType == 'Number') 
							filterInstance[attribName] = Number(attribValue);
						else if (attribType == 'Boolean') 
							filterInstance[attribName] = (attribValue == 'true');
						else if (attribType == 'Array') 
						{
							// remove the brackets at either end of the string
							attribValue = attribValue.substring(1, attribValue.length-1);
							var valuesArray:Array = null;  
							if (attribName == 'ratios' || attribName == 'colors')
							{
								valuesArray = splitUint(attribValue);
							}
							else if (attribName == 'alphas')
							{
								valuesArray = splitNumber(attribValue);
							}

							if (attribName == 'ratios')
								ratios = valuesArray;
							else if (valuesArray)
								filterInstance[attribName] = valuesArray;
								
						}
						else if (attribType == 'String')
						{
							filterInstance[attribName] = attribValue;
						}
					}// end attributes loop
					
					// force ratios array to be set after colors and alphas arrays, otherwise it won't work correctly
					if (ratios.length)
					{
						filterInstance['ratios'] = ratios;
					}
					filtersArray.push(filterInstance);
				}//end filters loop
				
			}
			else if (name == 'color')
			{
				this.color = Color.fromXML(child);
 			}
 			
 			this.filters = filtersArray;
		}
		
		return this;
	}
	 
	/**
	 * @private
	 */
	private static function splitNumber(valuesString:String):Array
	{
		var valuesArray:Array = valuesString.split(','); 
		for (var vi:int=0; vi<valuesArray.length; vi++)
		{
			valuesArray[vi] = Number(valuesArray[vi]);
		}
		return valuesArray;		
	}


	/**
	 * @private
	 */
	private static function splitUint(valuesString:String):Array
	{
		var valuesArray:Array = valuesString.split(','); 
		for (var vi:int=0; vi<valuesArray.length; vi++)
		{
			valuesArray[vi] = parseInt(valuesArray[vi]) as uint;
		}		
		return valuesArray;		
	}


	/**
	 * @private
	 */
	private static function splitInt(valuesString:String):Array
	{
		var valuesArray:Array = valuesString.split(','); 
		for (var vi:int=0; vi<valuesArray.length; vi++)
		{
			valuesArray[vi] = parseInt(valuesArray[vi]) as int;
		}		
		return valuesArray;		
	}
	
	
    /**
     * Retrieves an ITween object for a specific animation property.
     *
     * @param target The name of the property being tweened.
     * @see fl.motion.ITween#target
     *
     * @return An object that implements the ITween interface.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
     */
	public function getTween(target:String=''):ITween
	{
		for each (var tween:ITween in this.tweens)
		{
			if (tween.target == target
				// If we're looking for a skew tween and there isn't one, use rotation if available.
				|| (tween.target == 'rotation' 
					&& (target == 'skewX' || target == 'skewY'))

				|| (tween.target == 'position' 
					&& (target == 'x' || target == 'y'))

				|| (tween.target == 'scale' 
					&& (target == 'scaleX' || target == 'scaleY'))
				)
				return tween;
		}
		return null;
	}


	/**
	 * Indicates whether the keyframe has an influence on a specific animation property.
	 * 
     * @param tweenableName The name of a tweenable property, such as  <code>"x"</code>
     * or <code>"rotation"</code>.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Keyframe, Copy Motion as ActionScript        
	 */
	public function affectsTweenable(tweenableName:String=''):Boolean
	{
		return	(
			!tweenableName                                       
			|| !isNaN(this[tweenableName])                           // a valid numerical value exists for the property
			|| (tweenableName == 'color' && this.color)	           
			|| (tweenableName == 'filters' && this.filters.length)
			|| this.blank				                             // keyframe is empty
			|| this.getTween()                                       // all properties are being tweened
		);
	}
	
}
}
