package com.hydrotik.utils 
{
    import caurina.transitions.*;
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;
    
    public class SoundManager extends Object
    {
        public function SoundManager(arg1:SingletonEnforcer)
        {
            _seqArray = new Array();
            _currSequenceItem = "";
            _nextSequenceItem = "";
            _itemArray = new Array();
            _isMuted = false;
            super();
            if (arg1 == null)
            {
                throw new Error("SoundManager: Instantiation failed - Use SoundManager.getInstance() instead of new.");
            }
            _sndArray = new Dictionary(true);
            _channelArray = new Dictionary(true);
            return;
        }

        public function stop(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var snd:String;

            snd = arg1;
            try
            {
                _channelArray[snd].stop();
            }
            catch (e:Error)
            {
                throw new Error("SoundManager: " + snd + " has not been loaded into the SoundManager.");
            }
            return;
        }

        public function getItem(arg1:String):*
        {
            return _sndArray[arg1];
        }

        private function soundCompleteHandler(arg1:flash.events.Event):void
        {
            trace(">> Sound Complete");
            return;
        }

        public function addItem(arg1:*):void
        {
            _sndArray[getQualifiedClassName(arg1)] = arg1 as Sound;
            _itemArray.push(getQualifiedClassName(arg1));
            return;
        }

        public function startSequencer(arg1:*):void
        {
            if (arg1 as Array)
            {
                trace("manual sequence");
                _seqArray = arg1;
                _seqIsManual = false;
            }
            else 
            {
                trace("auto sequence");
                _seqIsManual = true;
                _currSequenceItem = arg1;
            }
            enableAll();
            advanceSequencer();
            return;
        }

        private function stopAllComplete(arg1:String):void
        {
            stop(arg1);
            return;
        }

        public function pan(arg1:String, arg2:Number, arg3:Number=0.5, arg4:String="linear"):void
        {
            var ease:String="linear";
            var loc5:*;
            var loc6:*;
            var pan:Number;
            var snd:String;
            var t:Number=0.5;

            snd = arg1;
            pan = arg2;
            t = arg3;
            ease = arg4;
            try
            {
                Tweener.addTween(_channelArray[snd], {"_sound_pan":pan, "time":t, "transition":ease});
            }
            catch (e:Error)
            {
                throw new Error("SoundManager: " + snd + " has not been loaded into the SoundManager.");
            }
            return;
        }

        public function enableAll():void
        {
            _isMuted = false;
            return;
        }

        public function dispose():void
        {
            var loc1:*;

            loc1 = 0;
            _nextSequenceItem = null;
            _xFadeNext = false;
            loc1 = 0;
            while (loc1 < _itemArray.length) 
            {
                _channelArray[_itemArray[loc1]] = null;
                _sndArray[_itemArray[loc1]] = null;
                ++loc1;
            }
            _isMuted = false;
            return;
        }

        public function get muted():Boolean
        {
            return _isMuted;
        }

        private function advanceSequencer(arg1:flash.events.Event=null):void
        {
            var loc2:*;
            var loc3:*;

            trace(">> Sequencer Advance: " + _nextSequenceItem, _xFadeNext);
            if (_seqIsManual)
            {
                if (_nextSequenceItem == "")
                {
                    trace("\tauto: " + _currSequenceItem);
                    play(_currSequenceItem, 0, 0.8, true);
                }
                else 
                {
                    play(_nextSequenceItem, 0, _xFadeNext ? 0 : 0.8, true);
                    if (_xFadeNext)
                    {
                        trace("\tauto: " + _currSequenceItem + " >< " + _nextSequenceItem);
                        play(_currSequenceItem, 0, 0.8, false);
                        fade(_currSequenceItem, 0, _sndArray[_currSequenceItem].length * 0.001, "easeinquad");
                        fade(_nextSequenceItem, 0.8, _sndArray[_nextSequenceItem].length * 0.001, "easeoutquad");
                    }
                    else 
                    {
                        trace("\tauto: " + _nextSequenceItem);
                    }
                    _currSequenceItem = _nextSequenceItem;
                    _nextSequenceItem = "";
                    _xFadeNext = false;
                }
            }
            else 
            {
                _currPos++;
                play(_seqArray[(_currPos - 1)], 0, 0.8, (_currPos != _seqArray.length) ? true : false);
                if (_seqArray[_currPos] == _seqArray[(_currPos - 1)])
                {
                    trace("\tplaylist: " + _seqArray[(_currPos - 1)]);
                }
                else 
                {
                    trace("\tplaylist: " + _seqArray[(_currPos - 1)] + " >< " + _seqArray[_currPos]);
                    play(_seqArray[_currPos], 0, (0), false);
                    fade(_seqArray[(_currPos - 1)], 0, _sndArray[_seqArray[(_currPos - 1)]].length * 0.001, "easeinquad");
                    fade(_seqArray[_currPos], 0.8, _sndArray[_seqArray[_currPos]].length * 0.001, "easeoutquad");
                }
            }
            return;
        }

        public function play(arg1:String, arg2:int=0, arg3:Number=1, arg4:Boolean=false):void
        {
            var isSeq:Boolean=false;
            var l:int=0;
            var loc5:*;
            var loc6:*;
            var snd:String;
            var vol:Number=1;

            snd = arg1;
            l = arg2;
            vol = arg3;
            isSeq = arg4;
            if (!_isMuted)
            {
                try
                {
                    _channelArray[snd] = _sndArray[snd].play(0, l);
                    if (vol != -1)
                    {
                        _soundTransform = _channelArray[snd].soundTransform;
                        _soundTransform.volume = vol;
                        _channelArray[snd].soundTransform = _soundTransform;
                    }
                    if (isSeq)
                    {
                        _channelArray[snd].addEventListener(Event.SOUND_COMPLETE, advanceSequencer, false, 0, true);
                    }
                    else 
                    {
                        _channelArray[snd].addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
                    }
                    _soundTransform = null;
                }
                catch (e:Error)
                {
                    throw new Error("SoundManager: " + snd + " has not been loaded into the SoundManager.");
                }
            }
            return;
        }

        public function addSequenceItem(arg1:String, arg2:Boolean=false):void
        {
            _nextSequenceItem = arg1;
            _xFadeNext = arg2;
            trace(_nextSequenceItem + " > " + _xFadeNext);
            return;
        }

        public function removeItem(arg1:String):void
        {
            _channelArray[arg1] = null;
            _sndArray[arg1] = null;
            _itemArray.splice(_itemArray.indexOf(arg1), 1);
            return;
        }

        public function fade(arg1:String, arg2:Number, arg3:Number=0.5, arg4:String="linear"):void
        {
            var ease:String="linear";
            var loc5:*;
            var loc6:*;
            var snd:String;
            var t:Number=0.5;
            var vol:Number;

            snd = arg1;
            vol = arg2;
            t = arg3;
            ease = arg4;
            try
            {
                Tweener.addTween(_channelArray[snd], {"_sound_volume":vol, "time":t, "transition":ease});
            }
            catch (e:Error)
            {
                throw new Error("SoundManager: " + snd + " has not been loaded into the SoundManager.");
            }
            return;
        }

        public function stopAll(arg1:Number=0):void
        {
            var loc2:*;

            loc2 = 0;
            _channelArray[_currSequenceItem].removeEventListener(Event.SOUND_COMPLETE, advanceSequencer);
            _nextSequenceItem = "";
            _xFadeNext = false;
            loc2 = 0;
            while (loc2 < _itemArray.length) 
            {
                Tweener.addTween(_channelArray[_itemArray[loc2]], {"_sound_volume":0, "time":arg1, "transition":"linear", "onComplete":stopAllComplete});
                ++loc2;
            }
            _isMuted = true;
            return;
        }

        public static function getInstance():com.hydrotik.utils.SoundManager
        {
            if (_oSoundManager == null)
            {
                _oSoundManager = new SoundManager(new SingletonEnforcer());
            }
            return _oSoundManager;
        }

        public static const AUTHOR:String="Donovan Adams - donovan[(at)]hydrotik.com - http://blog.hydrotik.com";

        public static const VERSION:String="SoundManager 0.0.2";

        private var _currPos:int;

        private var _itemArray:Array;

        private var _seqIsManual:Boolean;

        private var _seqArray:Array;

        private var _isMuted:Boolean=false;

        private var _currSequenceItem:String="";

        private var _nextSequenceItem:String="";

        private var _xFadeNext:Boolean;

        private static var _oSoundManager:com.hydrotik.utils.SoundManager;

        private static var _sndArray:flash.utils.Dictionary;

        private static var _channelArray:flash.utils.Dictionary;

        private static var _soundTransform:flash.media.SoundTransform;
    }
}


class SingletonEnforcer extends Object
{
    public function SingletonEnforcer()
    {
        super();
        return;
    }
}