/*
 * Copyright 2007-2008 (c) Donovan Adams, http://blog.hydrotik.com/
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package com.hydrotik.utils {
	import flash.events.IOErrorEvent;	
	import flash.events.ProgressEvent;	
	import flash.net.URLRequest;			import fl.motion.easing.Quadratic;			import flash.media.SoundChannel;	
	import flash.utils.Dictionary;
	import flash.media.Sound;
	//import flash.media.SoundChannel;
	//import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import com.hydrotik.go.HydroTween;

	import fl.motion.easing.Linear;	
	
	//import flash.events.TimerEvent;
	//import flash.utils.Timer;
	//import flash.net.LocalConnection;
	//import flash.utils.ByteArray;
	//import flash.utils.Endian;
	/**
		 * SoundManager AS 3 Beta
		 *
		 * @author: Donovan Adams, E-Mail: donovan[(at)]hydrotik.com, url: http://blog.hydrotik.com/
		 * @version: 0.0.3
		 *
		 * @description SoundManager is a Sound Management and playback utility for library assets.
		 *
		 * @todo: Try tandem looping with vol/fading for transitioning between loops for gap issue
		 * @todo: crossfading of auto sequences
		 *
		 * @history 10.22.2007 - 0.0.1 Initial port to AS3
		 * @history 11.7.2007 - 0.0.2 Added panning, stopAll, enableAll, and loop chaining/sequencing
		 *
		 * @example This example shows how to use SoundManager:
				<code>
					import com.hydrotik.utils.SoundManager;
					
					//Add item to playlist
					SoundManager.getInstance().addItem(new Loop1());
					
					
					//Play a sound from the Library
					SoundManager.getInstance().play("Loop1", 999, 1);
					
					//Remove a sound from the Library
					SoundManager.getInstance().removeItem("Loop1");
					
					
					// Start an manual step sequence
					SoundManager.getInstance().startSequencer("Loop1");
					
					// Add an item to the sequence - args: (sound id:String, crossfade:Boolean)
					// This will automatically start playing Loop2 next time the playing loop hits the end point
					// and then continue looping until another loop is added.
					SoundManager.getInstance().startSequenceItem("Loop2", true);
					
					
					// Start an "auto" step sequence
					SoundManager.getInstance().startSequencer(["Loop1, Loop1, Loop1, Loop1, Loop2, Loop2, Loop2, Loop2, Loop3, Loop3, Loop3, Loop3"]);
				</code>
		 */ 
	
	public class SoundManager {
		
		public static const VERSION:String = "SoundManager 0.0.3";
		
		public static const AUTHOR:String = "Donovan Adams - donovan[(at)]hydrotik.com - http://blog.hydrotik.com";
		
		private static var _oSoundManager:SoundManager;
		
		private static var _sndArray:Dictionary;
		
		private static var _channelArray:Dictionary;
		
		private static var _soundTransform:SoundTransform;
		
		private var _currPos:int;
		
		private var _seqArray:Array = new Array();
		
		//private var _timer:Timer;
		
		private var _seqIsManual:Boolean;
		
		private var _currSequenceItem:String = "";
		
		private var _nextSequenceItem:String = "";
		
		private var _xFadeNext:Boolean;
		
		private var _itemArray:Array = new Array();
		
		private var _isMuted:Boolean = false;				private var _callback : Function;
		//private var _byteArray:Array = new Array();
		
		/**
		 * @description Singleton access
		 */
		
		public static function getInstance() : SoundManager {
			if(_oSoundManager == null) _oSoundManager = new SoundManager(new SingletonEnforcer());
			return _oSoundManager;
		}
		
		
		/**
		 * @param	snd:String - Class definition
		 * @return	void
		 * @description Add a Sound
		 */
		public function addItem(sndClass:*):void{
			_sndArray[getQualifiedClassName(sndClass)] = sndClass as Sound;
			_itemArray.push(getQualifiedClassName(sndClass));
		}
		
		
		/**
		 * @param	snd:String - Class definition
		 * @return	* - Class reference
		 * @description Get a sound
		 */
		public function getItem(snd:String):*{
			return _sndArray[snd];
		}

		/**
		 * @param	snd:String - Class definition
		 * @return	* - Class reference
		 * @description Get a sound
		 */
		public function getSoundChannel(snd:String):SoundChannel{
			return _channelArray[snd];
		}
		
		
		/**
		 * @param	snd:String - Class definition
		 * @return	void
		 * @description Remove a Sound
		 */
		public function removeItem(snd:String):void{
			_channelArray[snd] = null;
			_sndArray[snd] = null;
			_itemArray.splice(_itemArray.indexOf(snd), 1);
		}
		
		
		/**
		 * @param	snd:String - Class definition
		 * @param	l:int - Number of loops
		 * @param	vol:Number - Volume level
		 * @return	void
		 * @description Starts playback of a Sound
		 */
		public function play(snd:String, l:int = 0, vol:Number = 1, isSeq:Boolean = false):void {
			if(!_isMuted){
				try {
					//if(_channelArray[snd] != null) stop(snd);
					_channelArray[snd] = _sndArray[snd].play(0, l);
					if(vol != -1){
						_soundTransform = _channelArray[snd].soundTransform;
					   _soundTransform.volume = vol;
						_channelArray[snd].soundTransform = _soundTransform;
					}
					if(isSeq){
						_channelArray[snd].addEventListener(Event.SOUND_COMPLETE, advanceSequencer, false, 0, true);
					}else{
						_channelArray[snd].addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
					};
					_soundTransform = null;
				}catch(e:Error) {
					throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
				}
			}
		}
		
		public function playStream(id:String, path:String, vol:Number = 1, callback:Function = null):void {
			if(!_isMuted){
					//if(_channelArray[snd] != null) stop(snd);
					_callback = callback;
					_sndArray[id] = new Sound();
					_sndArray[id].addEventListener(Event.COMPLETE, completeHandler);
            		_sndArray[id].addEventListener(Event.ID3, id3Handler);
            		_sndArray[id].addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            		_sndArray[id].addEventListener(ProgressEvent.PROGRESS, progressHandler);
					
					_sndArray[id].load(new URLRequest(path));
					_channelArray[id] = _sndArray[id].play(0);
					
					if(vol != -1){
						_soundTransform = _channelArray[id].soundTransform;
					   _soundTransform.volume = vol;
						_channelArray[id].soundTransform = _soundTransform;
					}
					_channelArray[id].addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
					_soundTransform = null;
			}
		}
		
		
		private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
            _callback.call();
        }

        private function id3Handler(event:Event):void {
            trace("id3Handler: " + event);
        }

        private function ioErrorHandler(event:Event):void {
            trace("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: " + event);
        }
		
		
		/**
		 * @param	snd:String - Class definition
		 * @return	void
		 * @description Stops playback of a Sound
		 */
		public function stop(snd:String):void {
			try {
                _channelArray[snd].stop();
            }catch(e:Error) {
                throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
            }
		}
		
		
		/**
		 * @param	snd:String - Class definition
		 * @return	void
		 * @description Fades and disables playback of ALL Sounds
		 */
		public function stopAll(t:Number = 0):void {
			_channelArray[_currSequenceItem].removeEventListener(Event.SOUND_COMPLETE, advanceSequencer);
			_nextSequenceItem = "";
			_xFadeNext = false;
			for(var i:int = 0; i<_itemArray.length; i++){
				HydroTween.go(_channelArray[_itemArray[i]], {_volume:0}, t, 0, Linear.easeNone, function():void{stopAllComplete(_itemArray[i]);});
			}
			_isMuted = true;
		}
		
		/**
		 * @return	void
		 * @description Stops all sounds and disposes for GC
		 */
		public function dispose():void {
				_nextSequenceItem = null;
				_xFadeNext = false;
               for(var i:int = 0; i<_itemArray.length; i++){
				   _channelArray[_itemArray[i]] = null;
				   _sndArray[_itemArray[i]] = null;
			   }
			   _isMuted = false;
		}
		
		/**
		 * @return	void
		 * @description Enables playback of ALL Sounds
		 */
		public function enableAll():void {
			   _isMuted = false;
		}
		
		/**
		 * @return	Boolean
		 * @description Get Muted status
		 */
		public function get muted():Boolean {
			   return _isMuted;
		}
		
		private function stopAllComplete(t:String = null):void{
			stop(t);
		}
		
		/**
		 * @param	snd:String - Class definition
		 * @param	vol:Number - Volume level
		 * @param	t:Number - Length of change in Seconds
		 * @return	void
		 * @description Fade volume of a Sound
		 */
		public function fade(snd:String, vol:Number, t:Number = .5, ease:Function = null):void{
			try {
				HydroTween.go(_channelArray[snd], {volume:vol}, t, 0, (ease == null) ? Linear.easeNone : ease);
			}catch(e:Error) {
                throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
            }
		}
		
		/**
		 * @param	snd:String - Class definition
		 * @param	vol:Number - Volume level
		 * @param	t:Number - Length of change in Seconds
		 * @return	void
		 * @description Fade volume of a Sound down and stop (For streaming sound)
		 */
		public function fadeAndStop(snd:String, t:Number = .5, ease:Function = null):void{
			try {
				HydroTween.go(_channelArray[snd], {volume:0}, t, 0, (ease == null) ? Linear.easeNone : ease, _channelArray[snd].stop);
			}catch(e:Error) {
                throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
            }
		}
		
		/**
		 * @param	snd:String - Class definition
		 * @param	vol:Number - Volume level
		 * @param	t:Number - Length of change in Seconds
		 * @return	void
		 * @description Fade volume of a Sound down and stop (For streaming sound)
		 */
		public function fadeAndPlay(snd:String, vol:Number = 1, t:Number = .5, ease:Function = null):void{
			try {
				_channelArray[snd] = _sndArray[snd].play();
				var st:SoundTransform = _channelArray[snd].soundTransform;
				st.volume = 0;
				_channelArray[snd].soundTransform = st;
				HydroTween.go(_channelArray[snd], {volume:vol}, t, 0, (ease == null) ? Linear.easeNone : ease);
			}catch(e:Error) {
                throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
            }
		}
		
		/**
		 * @param	snd:String - Class definition
		 * @param	pan:Number - Panning level
		 * @param	t:Number - Length of change in seconds
		 * @return	void
		 * @description Panning of the Sound
		 */
		public function pan(snd:String, pan:Number, t:Number = .5, ease:Function = null):void{
			try {
				HydroTween.go(_channelArray[snd], {_panning:pan}, t, 0, (ease == null) ? Linear.easeNone : ease);
			}catch(e:Error) {
                throw new Error("SoundManager: "+snd+" has not been loaded into the SoundManager.");
            }
		}
		
		/**
		 * @param	ar:* Array or String - Array runs a sequence, String loops the sound until another is added
		 * @return	void
		 * @description Starts the loop sequencer
		 */
		public function startSequencer(ar:*):void {
			if(ar is Array){
				trace("manual sequence");
				_seqArray = ar;
				_seqIsManual = false;
			}else{
				trace("auto sequence");
				_seqIsManual = true;
				_currSequenceItem = ar;
			}
			
			//_byteArray.endian = Endian.LITTLE_ENDIAN;
			//_timer = new Timer(31);
			//_timer.addEventListener("timer", spectrum);
			//_timer.start();
       
			enableAll();
			advanceSequencer();
		}
		
		/**
		 * @param	snd:String - Class definition
		 * @param	cf:Boolean - Crossfade sounds
		 * @return	void
		 * @description Adds an item to the queue to be started at the end of the previous sound
		 */
		public function addSequenceItem(snd:String, cf:Boolean = false):void{
			_nextSequenceItem = snd;
			_xFadeNext = cf;
			trace(_nextSequenceItem+" > "+_xFadeNext);
		}

        
		
		// --== Private Methods ==--
		/*
		private function autoSequencer():void{
			_seqIsManual;
		}
		
		private function timerHandler(event:Event):void {
			var perc:Number = (_channelArray[_seqArray[_currPos-1]].position/_sndArray[_seqArray[_currPos-1]].length);
        }
		*/
		private function advanceSequencer(event:Event = null):void{
			trace(">> Sequencer Advance: "+_nextSequenceItem, _xFadeNext);
			if(_seqIsManual){
				if(_nextSequenceItem != ""){
					play(_nextSequenceItem, 0, (_xFadeNext) ? 0 : .8, true);
					if(_xFadeNext){
						trace("\tauto: "+_currSequenceItem + " >< " + _nextSequenceItem);
						play(_currSequenceItem, 0, .8, false);
						fade(_currSequenceItem, 0, _sndArray[_currSequenceItem].length * .001, Quadratic.easeIn);
						fade(_nextSequenceItem, .8, _sndArray[_nextSequenceItem].length * .001, Quadratic.easeOut);
					}else{
						trace("\tauto: "+_nextSequenceItem);
					}
					_currSequenceItem = _nextSequenceItem;
					_nextSequenceItem = "";
					_xFadeNext = false;
				}else{
					trace("\tauto: "+_currSequenceItem);
					play(_currSequenceItem, 0, .8, true);
				}
			
			}else{
				_currPos++;
				play(_seqArray[_currPos-1], 0, .8, (_currPos == _seqArray.length) ? false : true);
				if(_seqArray[_currPos] != _seqArray[_currPos-1]){
					trace("\tplaylist: "+_seqArray[_currPos-1] + " >< " + _seqArray[_currPos]);
					play(_seqArray[_currPos], 0, 0, false);
					fade(_seqArray[_currPos-1], 0, _sndArray[_seqArray[_currPos-1]].length * .001, Quadratic.easeIn);
					fade(_seqArray[_currPos], .8, _sndArray[_seqArray[_currPos]].length * .001, Quadratic.easeOut);
				}else{
					trace("\tplaylist: "+_seqArray[_currPos-1]);
				}
			}
		}
		
		
		/**
		 * @description "Private" contructor
		 */
		public function SoundManager(ul:SingletonEnforcer):void {
			if (ul == null) {
				throw new Error("SoundManager: Instantiation failed - Use SoundManager.getInstance() instead of new.");
			}else{
				_sndArray = new Dictionary(true);
				_channelArray = new Dictionary(true);
			}
		}
		
		private function soundCompleteHandler(event:Event):void {
            //trace(">> Sound Complete");
			//_timer.stop();
        }
		
		/*
		private function spectrum(event:Event):void {
			var ba:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum(ba,true,0);
			//_byteArray.push(ba);
			trace(ba.readDouble());
		}
		*/
	}
}
	
class SingletonEnforcer {}
