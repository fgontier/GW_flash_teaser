// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.ColorTransform; 

[DefaultProperty("motion")]

/**
 *  Dispatched when the motion finishes playing,
 *  either when it reaches the end, or when the motion has 
 *  been interrupted by a call to the <code>stop()</code> or <code>end()</code> methods.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_END
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 */
[Event(name="motionEnd", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the motion starts playing.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_START
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="motionStart", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the motion has changed and the screen has been updated.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_UPDATE
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="motionUpdate", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the Animator's <code>time</code> value has changed, 
 *  but the screen has not yet been updated (i.e., the <code>motionUpdate</code> event).
 * 
 *  @eventType fl.motion.MotionEvent.TIME_CHANGE
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="timeChange", type="fl.motion.MotionEvent")]






/**
 * The Animator class applies an XML description of a motion tween to a display object.
 * The properties and methods of the Animator class control the playback of the motion,
 * and Flash Player broadcasts events in response to changes in the motion's status.
 * The Animator class is primarily used by the Copy Motion as ActionScript command in
 * Flash CS3. You can then edit the ActionScript using the application programming interface
 * (API) or construct your own custom animation.
 * <p>If you plan to call methods of the Animator class within a function, declare the Animator 
 * instance outside of the function so the scope of the object is not restricted to the 
 * function itself. If you declare the instance within a function, Flash Player deletes the 
 * Animator instance at the end of the function as part of Flash Player's routine "garbage collection"
 * and the target object will not animate.</p>
 * 
 * @internal <p><strong>Note:</strong> If you're not using Flash CS3 to compile your SWF file, you need the
 * fl.motion classes in your classpath at compile time to apply the motion to the display object.</p>
 *
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 * @keyword Animator, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 */
public class Animator extends EventDispatcher
{
	
    /**
     * @private
     */
	private var _motion:Motion;

    /**
     * The object that contains the motion tween properties for the animation. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword motion     
     */
    public function get motion():Motion
    {
        return this._motion;
    }

    /**
     * @private (setter)
     */
	public function set motion(value:Motion):void
	{
		this._motion = value;
		if (value.source 
			&& value.source.transformationPoint)
			this.transformationPoint = value.source.transformationPoint.clone();
	}





    /**
     * Sets the position of the display object along the motion path. If set to <code>true</code>
     * the baseline of the display object orients to the motion path; otherwise the registration
     * point orients to the motion path.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword orientToPath, orientation
     */
	public var orientToPath:Boolean = false;



    /**
     * The point of reference for rotating or scaling a display object. The transformation point is 
     * relative to the display object's bounding box.
     * The point's coordinates must be scaled to a 1px x 1px box, where (1, 1) is the object's lower-right corner, 
     * and (0, 0) is the object's upper-left corner.  
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword transformationPoint
     */
    public var transformationPoint:Point;



    /**
     * Sets the animation to restart after it finishes.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword autoRewind, loop
     */
    public var autoRewind:Boolean = false;



    /**
     * The Matrix object that applies an overall transformation to the motion path. 
     * This matrix allows the path to be shifted, scaled, skewed or rotated, 
     * without changing the appearance of the display object.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword positionMatrix     
     */
	public var positionMatrix:Matrix;
	
	
	


    /**
     *  Number of times to repeat the animation.
     *  Possible values are any integer greater than or equal to <code>0</code>.
     *  A value of <code>1</code> means to play the animation once.
     *  A value of <code>0</code> means to play the animation indefinitely
     *  until explicitly stopped (by a call to the <code>end()</code> method, for example).
     *
     * @default 1
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword repeatCount, repetition, loop   
     * @see #end()
     */
	public var repeatCount:int = 1;

	
	/**
     * @private
     */
    private var _isPlaying:Boolean = false;

    /**
     * Indicates whether the animation is currently playing.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword isPlaying        
     */
	public function get isPlaying():Boolean
	{
		return _isPlaying;
	}


    /**
     * @private
     */
	private var _target:DisplayObject;

    /**
     * The display object being animated. 
     * Any subclass of flash.display.DisplayObject can be used, such as a <code>MovieClip</code>, <code>Sprite</code>, or <code>Bitmap</code>.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword target
     * @see flash.display.DisplayObject
     */
    public function get target():DisplayObject
    {
        return this._target;
    }

    /**
     * @private (setter)
     */
	public function set target(value:DisplayObject):void 
	{
		if (!value) return;
		this._target = value;

		this.targetState = {};
 		this.targetState.scaleX = this._target.scaleX;
		this.targetState.scaleY = this._target.scaleY;
		this.targetState.skewX = MatrixTransformer.getSkewX(this._target.transform.matrix);
		this.targetState.skewY = MatrixTransformer.getSkewY(this._target.transform.matrix);
		this.targetState.matrix = this._target.transform.matrix;
		
		var bounds:Object = this.targetState.bounds = this._target.getBounds(this._target);	
		if (this.transformationPoint)
		{
			// find the position of the transform point proportional to the bounding box of the target
			var transformX:Number = this.transformationPoint.x*bounds.width + bounds.left;
			var transformY:Number = this.transformationPoint.y*bounds.height + bounds.top;
			this.targetState.transformPointInternal = new Point(transformX, transformY);
		
			var transformPointExternal:Point = 
				this.targetState.matrix.transformPoint(this.targetState.transformPointInternal);
	 		this.targetState.x = transformPointExternal.x;
			this.targetState.y = transformPointExternal.y;
		}
		else
		{
			// Use the origin as the transformation point if not supplied.
			this.targetState.transformPointInternal = new Point(0, 0);
	 		this.targetState.x = this._target.x;
			this.targetState.y = this._target.y;
		}
	}
	 

	/**
     * @private
     */
	private var _lastRenderedTime:int = -1; 

	 
	/**
     * @private
     */
	private var _time:int = -1; 

    /**
     * A zero-based integer that indicates and controls the time in the current animation. 
     * At the animation's first frame <code>time</code> is <code>0</code>. 
     * If the animation has a duration of 10 frames, at the last frame <code>time</code> is <code>9</code>. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword time
     */
	public function get time():int
	{
		return this._time;
	}

    /**
     * @private (setter)
     */
	public function set time(newTime:int):void 
	{
		if (newTime == this._time) return;
		
		var thisMotion:Motion = this.motion;
		
		if (newTime > thisMotion.duration-1) 
			newTime = thisMotion.duration-1;
		else if (newTime < 0) 
			newTime = 0;
			
		this._time = newTime;
		this.dispatchEvent(new MotionEvent(MotionEvent.TIME_CHANGE));
		
		var curKeyframe:Keyframe = thisMotion.getCurrentKeyframe(newTime);
		// optimization to detect when a keyframe is "holding" for several frames and not tweening
		var isHoldKeyframe:Boolean = curKeyframe.index == this._lastRenderedTime 
									 && !curKeyframe.tweens.length; 
		if (isHoldKeyframe)
			return;
		
		this._target.visible = false;
		
		if (!curKeyframe.blank)
		{
			var positionX:Number = thisMotion.getValue(newTime, Tweenables.X);
			var positionY:Number = thisMotion.getValue(newTime, Tweenables.Y);
			var position:flash.geom.Point = new flash.geom.Point(positionX, positionY);
	   		// apply matrix transformation to path--e.g. stretch or rotate the whole motion path
	   		if (this.positionMatrix)
				position = this.positionMatrix.transformPoint(position); 
			// add position to target's initial position, so motion is relative
			position.x += this.targetState.x;
			position.y += this.targetState.y;
			
			var scaleX:Number = thisMotion.getValue(newTime, Tweenables.SCALE_X) * this.targetState.scaleX; 
			var scaleY:Number = thisMotion.getValue(newTime, Tweenables.SCALE_Y) * this.targetState.scaleY; 	
			var skewX:Number = 0;
			var skewY:Number = 0; 
		
			// override the rotation and skew in the XML if orienting to path
			if (this.orientToPath)
			{
				var positionX2:Number = thisMotion.getValue(newTime+1, Tweenables.X);
				var positionY2:Number = thisMotion.getValue(newTime+1, Tweenables.Y);
				var pathAngle:Number = Math.atan2(positionY2-positionY, positionX2-positionX) * (180 / Math.PI);
				if (!isNaN(pathAngle))
				{
					skewX = pathAngle + this.targetState.skewX;
					skewY = pathAngle + this.targetState.skewY;
				}
			}
			else
			{
				skewX = thisMotion.getValue(newTime, Tweenables.SKEW_X) + this.targetState.skewX; 
				skewY = thisMotion.getValue(newTime, Tweenables.SKEW_Y) + this.targetState.skewY; 
			}
	
			var targetMatrix:Matrix = new Matrix(
				scaleX*Math.cos(skewY*(Math.PI/180)), 
				scaleX*Math.sin(skewY*(Math.PI/180)), 
			   -scaleY*Math.sin(skewX*(Math.PI/180)), 				
				scaleY*Math.cos(skewX*(Math.PI/180)), 
				position.x,
				position.y);
			
				 
			// Shift the object so its transformation point (not registration point) 
			// lines up with the x and y values from the Keyframe.
			var transformationPointLocation:Point = targetMatrix.transformPoint(this.targetState.transformPointInternal);
			var dx:Number = targetMatrix.tx - transformationPointLocation.x;
			var dy:Number = targetMatrix.ty - transformationPointLocation.y;				
			targetMatrix.tx += dx;
			targetMatrix.ty += dy;
			
			
			// This otherwise redundant step is necessary for Player 9r16 
			// where setting the matrix doesn't produce rotation.
			// Unfortunately, there doesn't seem to be a way to render skew in 9r16. 
			this._target.rotation = skewY;
			// At long last, apply the transformations to the display object.
			// Note that we have to assign the matrix each time because 
			// if one frame has skew and the next has just rotation, we can't remove
			// the skew by just setting the rotation property. We have to clear the skew with the matrix.
			this._target.transform.matrix = targetMatrix;
			// workaround for a Player 9r28 bug, where setting the matrix causes scaleX or scaleY to go to 0
			this._target.scaleX = scaleX;
			this._target.scaleY = scaleY; 
	 
			var colorTransform:ColorTransform = thisMotion.getColorTransform(newTime);
			if (colorTransform)
			{
				this._target.transform.colorTransform = colorTransform;
			}
	
			this._target.filters = thisMotion.getFilters(newTime); 
			this._target.blendMode = curKeyframe.blendMode;
			this._target.cacheAsBitmap = curKeyframe.cacheAsBitmap;	
			this._target.visible = true;
		}
		
		this._lastRenderedTime = this._time;
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_UPDATE));
	}
	
	
	
    /**
     * Creates an Animator object to apply the XML-based motion tween description to a display object.
     *
     * @param xml An E4X object containing an XML-based motion tween description.
     *
     * @param target The display object using the motion tween.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword Animator
     * @see ../../motionXSD.html Motion XML Elements
     */
	function Animator(xml:XML=null, target:DisplayObject=null)
	{
		this.motion = new Motion(xml);
		this.target = target;
	}

   /**
     * Creates an Animator object from a string of XML. 
     * This method is an alternative to using the Animator constructor, which accepts an E4X object instead.
     *
     * @param xmlString A string of XML describing the motion tween.
     *
     * @param target The display object using the motion tween.
     *
     * @return An Animator instance that applies the specified <code>xmlString</code> to the specified <code>target</code>.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword createFromXMLString, Animator
     * @see ../../motionXSD.html Motion XML Elements     
     */
	public static function fromXMLString(xmlString:String, target:DisplayObject=null):Animator
	{
		return new Animator(new XML(xmlString), target);
	}
	


    /**
     * Advances Flash Player to the next frame in the animation sequence.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword nextFrame     
     */
	public function nextFrame():void 
	{
		if (this.time >= this.motion.duration-1)
			this.handleLastFrame();
		else
			this.time++;
	}




    /**
     *  Begins the animation. Call the <code>end()</code> method 
     *  before you call the <code>play()</code> method to ensure that any previous 
     *  instance of the animation has ended before you start a new one.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword play, begin
     * @see #end()
     */
	public function play():void
	{
		if (!this._isPlaying)
		{
			enterFrameBeacon.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler, false, 0, true);
			this._isPlaying = true;
		}
		this.playCount = 0;
		// enterFrame event will fire on the following frame, 
		// so call the time setter to update the position immediately
		this.rewind();
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_START));
	
	}


    /**
     *  Stops the animation and Flash Player goes immediately to the last frame in the animation sequence. 
     *  If the <code>autoRewind</code> property is set to <code>true</code>, Flash Player goes to the first
     * frame in the animation sequence. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword end, stop
     * @see #autoRewind     
     */
	public function end():void
	{
		enterFrameBeacon.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		this._isPlaying = false;
		this.playCount = 0;
		
		if (this.autoRewind) 
			this.rewind();
		else if (this.time != this.motion.duration-1)
			this.time = this.motion.duration-1;
			
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
    }



    /**
     *  Stops the animation and Flash Player goes back to the first frame in the animation sequence.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword stop, end
     * @see #end()      
     */
	public function stop():void
	{
		enterFrameBeacon.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		this._isPlaying = false;
		this.playCount = 0;
		this.rewind();
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
    }


    /**
     *  Pauses the animation until you call the <code>resume()</code> method.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword pause
     * @see #resume()        
     */
	public function pause():void
	{
		enterFrameBeacon.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		this._isPlaying = false;
    }



    /**
     *  Resumes the animation after it has been paused 
     *  by the <code>pause()</code> method.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword resume
     * @see #pause()       
     */
	public function resume():void
	{
		enterFrameBeacon.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler, false, 0, true);
		this._isPlaying = true;
    }



    /**
     * Sets Flash Player to the first frame of the animation. 
     * If the animation was playing, it continues playing from the first frame. 
     * If the animation was stopped, it remains stopped at the first frame.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword rewind
     */
	public function rewind():void
	{
		this.time = 0;
    }
   
   
 //////////////////////////////////////////////////////////////  

	/**
     * @private
     */
    private var playCount:int = 0;


    /**
     * @private
     */
	// This code is run just once, during the class initialization.
	// Create a MovieClip to generate enterFrame events.
 	private static var enterFrameBeacon:MovieClip = new MovieClip();
 


    /**
     * @private
     */
    // The initial state of the target when assigned to the Animator. 
	private var targetState:Object;
  
  
    /**
     * @private
     */
	private function handleLastFrame():void 
	{
		++this.playCount;
		if (this.repeatCount == 0 || this.playCount < this.repeatCount)
		{
			this.rewind();
		}
		else
		{
			this.end();
		}
	}



    /**
     * @private
     */
	private function enterFrameHandler(event:Event):void 
	{
		this.nextFrame();
	}



	
	
}
}
