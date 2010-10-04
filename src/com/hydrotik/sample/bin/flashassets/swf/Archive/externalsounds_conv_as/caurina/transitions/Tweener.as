package caurina.transitions 
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class Tweener extends Object
    {
        public function Tweener()
        {
            super();
            trace("Tweener is a static class and should not be instantiated.");
            return;
        }

        public static function registerSpecialPropertyModifier(arg1:String, arg2:Function, arg3:Function):void
        {
            var loc4:*;

            loc4 = null;
            if (!_inited)
            {
                init();
            }
            loc4 = new SpecialPropertyModifier(arg2, arg3);
            _specialPropertyModifierList[arg1] = loc4;
            return;
        }

        public static function registerSpecialProperty(arg1:String, arg2:Function, arg3:Function, arg4:Array=null):void
        {
            var loc5:*;

            loc5 = null;
            if (!_inited)
            {
                init();
            }
            loc5 = new SpecialProperty(arg2, arg3, arg4);
            _specialPropertyList[arg1] = loc5;
            return;
        }

        public static function addCaller(arg1:Object=null, arg2:Object=null):Boolean
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc4 = null;
            loc5 = NaN;
            loc6 = NaN;
            loc7 = null;
            loc8 = NaN;
            loc9 = NaN;
            loc10 = null;
            loc11 = null;
            loc12 = NaN;
            loc13 = null;
            if (arguments.length < 2 || arguments[0] == undefined)
            {
                return false;
            }
            loc4 = new Array();
            if (arguments[0] as Array)
            {
                loc5 = 0;
                while (loc5 < arguments[0].length) 
                {
                    loc4.push(arguments[0][loc5]);
                    loc5 = (loc5 + 1);
                }
            }
            else 
            {
                loc5 = 0;
                while (loc5 < (arguments.length - 1)) 
                {
                    loc4.push(arguments[loc5]);
                    loc5 = (loc5 + 1);
                }
            }
            loc7 = arguments[(arguments.length - 1)];
            if (!_inited)
            {
                init();
            }
            if (!_engineExists || !Boolean(__tweener_controller__))
            {
                startEngine();
            }
            loc8 = isNaN(loc7.time) ? 0 : loc7.time;
            loc9 = isNaN(loc7.delay) ? 0 : loc7.delay;
            if (typeof loc7.transition != "string")
            {
                loc10 = loc7.transition;
            }
            else 
            {
                loc13 = loc7.transition.toLowerCase();
                loc10 = _transitionList[loc13];
            }
            if (!Boolean(loc10))
            {
                loc10 = _transitionList["easeoutexpo"];
            }
            loc5 = 0;
            while (loc5 < loc4.length) 
            {
                (loc11 = new TweenListObj(loc4[loc5], _currentTime + loc9 * 1000 / _timeScale, _currentTime + (loc9 * 1000 + loc8 * 1000) / _timeScale, loc7.useFrames == true, loc10)).properties = null;
                loc11.onStart = loc7.onStart;
                loc11.onUpdate = loc7.onUpdate;
                loc11.onComplete = loc7.onComplete;
                loc11.onOverwrite = loc7.onOverwrite;
                loc11.onStartParams = loc7.onStartParams;
                loc11.onUpdateParams = loc7.onUpdateParams;
                loc11.onCompleteParams = loc7.onCompleteParams;
                loc11.onOverwriteParams = loc7.onOverwriteParams;
                loc11.isCaller = true;
                loc11.count = loc7.count;
                loc11.waitFrames = loc7.waitFrames;
                _tweenList.push(loc11);
                if (loc8 == 0 && loc9 == 0)
                {
                    loc12 = (_tweenList.length - 1);
                    updateTweenByIndex(loc12);
                    removeTweenByIndex(loc12);
                }
                loc5 = (loc5 + 1);
            }
            return true;
        }

        public static function init(arg1:*=null):void
        {
            _inited = true;
            _transitionList = new Object();
            Equations.init();
            _specialPropertyList = new Object();
            _specialPropertyModifierList = new Object();
            _specialPropertySplitterList = new Object();
            SpecialPropertiesDefault.init();
            return;
        }

        private static function updateTweens():Boolean
        {
            var loc1:*;

            loc1 = 0;
            if (_tweenList.length == 0)
            {
                return false;
            }
            loc1 = 0;
            while (loc1 < _tweenList.length) 
            {
                if (_tweenList[loc1] == undefined || !_tweenList[loc1].isPaused)
                {
                    if (!updateTweenByIndex(loc1))
                    {
                        removeTweenByIndex(loc1);
                    }
                    if (_tweenList[loc1] == null)
                    {
                        removeTweenByIndex(loc1, true);
                        loc1 = (loc1 - 1);
                    }
                }
                ++loc1;
            }
            return true;
        }

        public static function removeTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && !AuxFunctions.isInArray(rest[loc4], loc3))
                {
                    loc3.push(rest[loc4]);
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(removeTweenByIndex, arg1, loc3);
        }

        public static function pauseAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc1 = false;
            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                pauseTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public static function splitTweens(arg1:Number, arg2:Array):uint
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc3 = null;
            loc4 = null;
            loc5 = 0;
            loc6 = null;
            loc7 = false;
            loc3 = _tweenList[arg1];
            loc4 = loc3.clone(false);
            loc5 = 0;
            while (loc5 < arg2.length) 
            {
                loc6 = arg2[loc5];
                if (Boolean(loc3.properties[loc6]))
                {
                    loc3.properties[loc6] = undefined;
                    delete loc3.properties[loc6];
                }
                loc5 = (loc5 + 1);
            }
            loc8 = 0;
            loc9 = loc4.properties;
            for (loc6 in loc9)
            {
                loc7 = false;
                loc5 = 0;
                while (loc5 < arg2.length) 
                {
                    if (arg2[loc5] == loc6)
                    {
                        loc7 = true;
                        break;
                    }
                    loc5 = (loc5 + 1);
                }
                if (loc7)
                {
                    continue;
                }
                loc4.properties[loc6] = undefined;
                delete loc4.properties[loc6];
            }
            _tweenList.push(loc4);
            return (_tweenList.length - 1);
        }

        public static function resumeTweenByIndex(arg1:Number):Boolean
        {
            var loc2:*;

            loc2 = null;
            loc2 = _tweenList[arg1];
            if (loc2 == null || !loc2.isPaused)
            {
                return false;
            }
            loc2.timeStart = loc2.timeStart + _currentTime - loc2.timePaused;
            loc2.timeComplete = loc2.timeComplete + _currentTime - loc2.timePaused;
            loc2.timePaused = undefined;
            loc2.isPaused = false;
            return true;
        }

        public static function debug_getList():String
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = 0;
            loc1 = "";
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                loc1 = loc1 + "[" + loc2 + "] ::\n";
                loc3 = 0;
                while (loc3 < _tweenList[loc2].properties.length) 
                {
                    loc1 = loc1 + "  " + _tweenList[loc2].properties[loc3].name + " -> " + _tweenList[loc2].properties[loc3].valueComplete + "\n";
                    loc3 = (loc3 + 1);
                }
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public static function getVersion():String
        {
            return "AS3 1.25.53";
        }

        public static function onEnterFrame(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = false;
            updateTime();
            loc2 = false;
            loc2 = updateTweens();
            if (!loc2)
            {
                stopEngine();
            }
            return;
        }

        public static function updateTime():void
        {
            _currentTime = getTimer();
            return;
        }

        private static function updateTweenByIndex(arg1:Number):Boolean
        {
            var b:Number;
            var c:Number;
            var d:Number;
            var i:Number;
            var isOver:Boolean;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var mustUpdate:Boolean;
            var nv:Number;
            var pName:String;
            var pv:Number;
            var t:Number;
            var tProperty:Object;
            var tScope:Object;
            var tTweening:caurina.transitions.TweenListObj;

            tTweening = null;
            isOver = false;
            mustUpdate = false;
            nv = NaN;
            t = NaN;
            b = NaN;
            c = NaN;
            d = NaN;
            pName = null;
            tScope = null;
            tProperty = null;
            pv = NaN;
            i = arg1;
            tTweening = _tweenList[i];
            if (tTweening == null || !Boolean(tTweening.scope))
            {
                return false;
            }
            isOver = false;
            if (_currentTime >= tTweening.timeStart)
            {
                tScope = tTweening.scope;
                if (tTweening.isCaller)
                {
                    do 
                    {
                        t = (tTweening.timeComplete - tTweening.timeStart) / tTweening.count * (tTweening.timesCalled + 1);
                        b = tTweening.timeStart;
                        c = tTweening.timeComplete - tTweening.timeStart;
                        d = tTweening.timeComplete - tTweening.timeStart;
                        nv = tTweening.transition(t, b, c, d);
                        if (_currentTime >= nv)
                        {
                            if (Boolean(tTweening.onUpdate))
                            {
                                try
                                {
                                    tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
                                }
                                catch (e:Error)
                                {
                                };
                            }
                            loc4 = ((loc3 = tTweening).timesCalled + 1);
                            loc3.timesCalled = loc4;
                            if (tTweening.timesCalled >= tTweening.count)
                            {
                                isOver = true;
                                break;
                            }
                            if (tTweening.waitFrames)
                            {
                                break;
                            }
                        }
                    }
                    while (_currentTime >= nv);
                }
                else 
                {
                    mustUpdate = tTweening.skipUpdates < 1 || !tTweening.skipUpdates || tTweening.updatesSkipped >= tTweening.skipUpdates;
                    if (_currentTime >= tTweening.timeComplete)
                    {
                        isOver = true;
                        mustUpdate = true;
                    }
                    if (!tTweening.hasStarted)
                    {
                        if (Boolean(tTweening.onStart))
                        {
                            try
                            {
                                tTweening.onStart.apply(tScope, tTweening.onStartParams);
                            }
                            catch (e:Error)
                            {
                            };
                        }
                        loc3 = 0;
                        loc4 = tTweening.properties;
                        for (pName in loc4)
                        {
                            pv = getPropertyValue(tScope, pName);
                            tTweening.properties[pName].valueStart = isNaN(pv) ? tTweening.properties[pName].valueComplete : pv;
                        }
                        mustUpdate = true;
                        tTweening.hasStarted = true;
                    }
                    if (mustUpdate)
                    {
                        loc3 = 0;
                        loc4 = tTweening.properties;
                        for (pName in loc4)
                        {
                            tProperty = tTweening.properties[pName];
                            if (isOver)
                            {
                                nv = tProperty.valueComplete;
                            }
                            else 
                            {
                                if (tProperty.hasModifier)
                                {
                                    t = _currentTime - tTweening.timeStart;
                                    d = tTweening.timeComplete - tTweening.timeStart;
                                    nv = tTweening.transition(t, 0, 1, d);
                                    nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
                                }
                                else 
                                {
                                    t = _currentTime - tTweening.timeStart;
                                    b = tProperty.valueStart;
                                    c = tProperty.valueComplete - tProperty.valueStart;
                                    d = tTweening.timeComplete - tTweening.timeStart;
                                    nv = tTweening.transition(t, b, c, d);
                                }
                            }
                            if (tTweening.rounded)
                            {
                                nv = Math.round(nv);
                            }
                            setPropertyValue(tScope, pName, nv);
                        }
                        tTweening.updatesSkipped = 0;
                        if (Boolean(tTweening.onUpdate))
                        {
                            try
                            {
                                tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
                            }
                            catch (e:Error)
                            {
                            };
                        }
                    }
                    else 
                    {
                        loc4 = ((loc3 = tTweening).updatesSkipped + 1);
                        loc3.updatesSkipped = loc4;
                    }
                }
                if (isOver && Boolean(tTweening.onComplete))
                {
                    try
                    {
                        tTweening.onComplete.apply(tScope, tTweening.onCompleteParams);
                    }
                    catch (e:Error)
                    {
                    };
                }
                return !isOver;
            }
            return true;
        }

        public static function setTimeScale(arg1:Number):void
        {
            var loc2:*;

            loc2 = NaN;
            if (isNaN(arg1))
            {
                arg1 = 1;
            }
            if (arg1 < 1e-05)
            {
                arg1 = 1e-05;
            }
            if (arg1 != _timeScale)
            {
                loc2 = 0;
                while (loc2 < _tweenList.length) 
                {
                    _tweenList[loc2].timeStart = _currentTime - (_currentTime - _tweenList[loc2].timeStart) * _timeScale / arg1;
                    _tweenList[loc2].timeComplete = _currentTime - (_currentTime - _tweenList[loc2].timeComplete) * _timeScale / arg1;
                    if (_tweenList[loc2].timePaused != undefined)
                    {
                        _tweenList[loc2].timePaused = _currentTime - (_currentTime - _tweenList[loc2].timePaused) * _timeScale / arg1;
                    }
                    loc2 = (loc2 + 1);
                }
                _timeScale = arg1;
            }
            return;
        }

        public static function resumeAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc1 = false;
            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                resumeTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        private static function startEngine():void
        {
            _engineExists = true;
            _tweenList = new Array();
            __tweener_controller__ = new MovieClip();
            __tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            updateTime();
            return;
        }

        public static function removeAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc1 = false;
            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                removeTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public static function addTween(arg1:Object=null, arg2:Object=null):Boolean
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;

            loc4 = null;
            loc5 = NaN;
            loc6 = NaN;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = NaN;
            loc11 = NaN;
            loc12 = null;
            loc13 = null;
            loc14 = null;
            loc15 = null;
            loc16 = null;
            loc17 = null;
            loc18 = NaN;
            loc19 = null;
            loc20 = null;
            loc21 = null;
            if (arguments.length < 2 || arguments[0] == undefined)
            {
                return false;
            }
            loc4 = new Array();
            if (arguments[0] as Array)
            {
                loc5 = 0;
                while (loc5 < arguments[0].length) 
                {
                    loc4.push(arguments[0][loc5]);
                    loc5 = (loc5 + 1);
                }
            }
            else 
            {
                loc5 = 0;
                while (loc5 < (arguments.length - 1)) 
                {
                    loc4.push(arguments[loc5]);
                    loc5 = (loc5 + 1);
                }
            }
            loc9 = arguments[(arguments.length - 1)];
            if (!_inited)
            {
                init();
            }
            if (!_engineExists || !Boolean(__tweener_controller__))
            {
                startEngine();
            }
            loc10 = isNaN(loc9.time) ? 0 : loc9.time;
            loc11 = isNaN(loc9.delay) ? 0 : loc9.delay;
            loc12 = new Array();
            loc13 = {"time":true, "delay":true, "useFrames":true, "skipUpdates":true, "transition":true, "onStart":true, "onUpdate":true, "onComplete":true, "onOverwrite":true, "rounded":true, "onStartParams":true, "onUpdateParams":true, "onCompleteParams":true, "onOverwriteParams":true};
            loc14 = new Object();
            loc22 = 0;
            loc23 = loc9;
            for (loc7 in loc23)
            {
                if (loc13[loc7])
                {
                    continue;
                }
                if (_specialPropertySplitterList[loc7])
                {
                    loc19 = _specialPropertySplitterList[loc7].splitValues(loc9[loc7]);
                    loc5 = 0;
                    while (loc5 < loc19.length) 
                    {
                        loc12[loc19[loc5].name] = {"valueStart":undefined, "valueComplete":loc19[loc5].value};
                        loc5 = (loc5 + 1);
                    }
                    continue;
                }
                if (_specialPropertyModifierList[loc7] != undefined)
                {
                    loc20 = _specialPropertyModifierList[loc7].modifyValues(loc9[loc7]);
                    loc5 = 0;
                    while (loc5 < loc20.length) 
                    {
                        loc14[loc20[loc5].name] = {"modifierParameters":loc20[loc5].parameters, "modifierFunction":_specialPropertyModifierList[loc7].getValue};
                        loc5 = (loc5 + 1);
                    }
                    continue;
                }
                loc12[loc7] = {"valueStart":undefined, "valueComplete":loc9[loc7]};
            }
            loc22 = 0;
            loc23 = loc14;
            for (loc7 in loc23)
            {
                if (loc12[loc7] == undefined)
                {
                    continue;
                }
                loc12[loc7].modifierParameters = loc14[loc7].modifierParameters;
                loc12[loc7].modifierFunction = loc14[loc7].modifierFunction;
            }
            if (typeof loc9.transition != "string")
            {
                loc15 = loc9.transition;
            }
            else 
            {
                loc21 = loc9.transition.toLowerCase();
                loc15 = _transitionList[loc21];
            }
            if (!Boolean(loc15))
            {
                loc15 = _transitionList["easeoutexpo"];
            }
            loc5 = 0;
            while (loc5 < loc4.length) 
            {
                loc16 = new Object();
                loc22 = 0;
                loc23 = loc12;
                for (loc7 in loc23)
                {
                    loc16[loc7] = new PropertyInfoObj(loc12[loc7].valueStart, loc12[loc7].valueComplete, loc12[loc7].modifierFunction, loc12[loc7].modifierParameters);
                }
                (loc17 = new TweenListObj(loc4[loc5], _currentTime + loc11 * 1000 / _timeScale, _currentTime + (loc11 * 1000 + loc10 * 1000) / _timeScale, loc9.useFrames == true, loc15)).properties = loc16;
                loc17.onStart = loc9.onStart;
                loc17.onUpdate = loc9.onUpdate;
                loc17.onComplete = loc9.onComplete;
                loc17.onOverwrite = loc9.onOverwrite;
                loc17.onStartParams = loc9.onStartParams;
                loc17.onUpdateParams = loc9.onUpdateParams;
                loc17.onCompleteParams = loc9.onCompleteParams;
                loc17.onOverwriteParams = loc9.onOverwriteParams;
                loc17.rounded = loc9.rounded;
                loc17.skipUpdates = loc9.skipUpdates;
                removeTweensByTime(loc17.scope, loc17.properties, loc17.timeStart, loc17.timeComplete);
                _tweenList.push(loc17);
                if (loc10 == 0 && loc11 == 0)
                {
                    loc18 = (_tweenList.length - 1);
                    updateTweenByIndex(loc18);
                    removeTweenByIndex(loc18);
                }
                loc5 = (loc5 + 1);
            }
            return true;
        }

        public static function registerTransition(arg1:String, arg2:Function):void
        {
            if (!_inited)
            {
                init();
            }
            _transitionList[arg1] = arg2;
            return;
        }

        private static function affectTweens(arg1:Function, arg2:Object, arg3:Array):Boolean
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = false;
            loc5 = 0;
            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            loc9 = 0;
            loc4 = false;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc5 = 0;
            while (loc5 < _tweenList.length) 
            {
                if (_tweenList[loc5] && _tweenList[loc5].scope == arg2)
                {
                    if (arg3.length != 0)
                    {
                        loc6 = new Array();
                        loc7 = 0;
                        while (loc7 < arg3.length) 
                        {
                            if (Boolean(_tweenList[loc5].properties[arg3[loc7]]))
                            {
                                loc6.push(arg3[loc7]);
                            }
                            loc7 = (loc7 + 1);
                        }
                        if (loc6.length > 0)
                        {
                            if ((loc8 = AuxFunctions.getObjectLength(_tweenList[loc5].properties)) != loc6.length)
                            {
                                loc9 = splitTweens(loc5, loc6);
                                arg1(loc9);
                                loc4 = true;
                            }
                            else 
                            {
                                arg1(loc5);
                                loc4 = true;
                            }
                        }
                    }
                    else 
                    {
                        arg1(loc5);
                        loc4 = true;
                    }
                }
                loc5 = (loc5 + 1);
            }
            return loc4;
        }

        public static function getTweens(arg1:Object):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 0;
            loc3 = null;
            loc4 = null;
            loc4 = new Array();
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (_tweenList[loc2].scope == arg1)
                {
                    loc5 = 0;
                    loc6 = _tweenList[loc2].properties;
                    for (loc3 in loc6)
                    {
                        loc4.push(loc3);
                    }
                }
                loc2 = (loc2 + 1);
            }
            return loc4;
        }

        private static function setPropertyValue(arg1:Object, arg2:String, arg3:Number):void
        {
            if (_specialPropertyList[arg2] == undefined)
            {
                arg1[arg2] = arg3;
            }
            else 
            {
                if (Boolean(_specialPropertyList[arg2].parameters))
                {
                    _specialPropertyList[arg2].setValue(arg1, arg3, _specialPropertyList[arg2].parameters);
                }
                else 
                {
                    _specialPropertyList[arg2].setValue(arg1, arg3);
                }
            }
            return;
        }

        private static function getPropertyValue(arg1:Object, arg2:String):Number
        {
            if (_specialPropertyList[arg2] != undefined)
            {
                if (Boolean(_specialPropertyList[arg2].parameters))
                {
                    return _specialPropertyList[arg2].getValue(arg1, _specialPropertyList[arg2].parameters);
                }
                return _specialPropertyList[arg2].getValue(arg1);
            }
            return arg1[arg2];
        }

        public static function isTweening(arg1:Object):Boolean
        {
            var loc2:*;

            loc2 = 0;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (_tweenList[loc2].scope == arg1)
                {
                    return true;
                }
                loc2 = (loc2 + 1);
            }
            return false;
        }

        public static function getTweenCount(arg1:Object):Number
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = NaN;
            loc3 = 0;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (_tweenList[loc2].scope == arg1)
                {
                    loc3 = loc3 + AuxFunctions.getObjectLength(_tweenList[loc2].properties);
                }
                loc2 = (loc2 + 1);
            }
            return loc3;
        }

        private static function stopEngine():void
        {
            _engineExists = false;
            _tweenList = null;
            _currentTime = 0;
            __tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            __tweener_controller__ = null;
            return;
        }

        public static function pauseTweenByIndex(arg1:Number):Boolean
        {
            var loc2:*;

            loc2 = null;
            loc2 = _tweenList[arg1];
            if (loc2 == null || loc2.isPaused)
            {
                return false;
            }
            loc2.timePaused = _currentTime;
            loc2.isPaused = true;
            return true;
        }

        public static function removeTweensByTime(arg1:Object, arg2:Object, arg3:Number, arg4:Number):Boolean
        {
            var i:uint;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var pName:String;
            var p_properties:Object;
            var p_scope:Object;
            var p_timeComplete:Number;
            var p_timeStart:Number;
            var removed:Boolean;
            var removedLocally:Boolean;
            var tl:uint;

            removed = false;
            removedLocally = false;
            i = 0;
            tl = 0;
            pName = null;
            p_scope = arg1;
            p_properties = arg2;
            p_timeStart = arg3;
            p_timeComplete = arg4;
            removed = false;
            tl = _tweenList.length;
            i = 0;
            while (i < tl) 
            {
                if (Boolean(_tweenList[i]) && p_scope == _tweenList[i].scope)
                {
                    if (p_timeComplete > _tweenList[i].timeStart && p_timeStart < _tweenList[i].timeComplete)
                    {
                        removedLocally = false;
                        loc6 = 0;
                        loc7 = _tweenList[i].properties;
                        for (pName in loc7)
                        {
                            if (!Boolean(p_properties[pName]))
                            {
                                continue;
                            }
                            if (Boolean(_tweenList[i].onOverwrite))
                            {
                                try
                                {
                                    _tweenList[i].onOverwrite.apply(_tweenList[i].scope, _tweenList[i].onOverwriteParams);
                                }
                                catch (e:Error)
                                {
                                };
                            }
                            _tweenList[i].properties[pName] = undefined;
                            delete _tweenList[i].properties[pName];
                            removedLocally = true;
                            removed = true;
                        }
                        if (removedLocally)
                        {
                            if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0)
                            {
                                removeTweenByIndex(i);
                            }
                        }
                    }
                }
                i = (i + 1);
            }
            return removed;
        }

        public static function registerSpecialPropertySplitter(arg1:String, arg2:Function):void
        {
            var loc3:*;

            loc3 = null;
            if (!_inited)
            {
                init();
            }
            loc3 = new SpecialPropertySplitter(arg2);
            _specialPropertySplitterList[arg1] = loc3;
            return;
        }

        public static function removeTweenByIndex(arg1:Number, arg2:Boolean=false):Boolean
        {
            _tweenList[arg1] = null;
            if (arg2)
            {
                _tweenList.splice(arg1, 1);
            }
            return true;
        }

        public static function resumeTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && !AuxFunctions.isInArray(rest[loc4], loc3))
                {
                    loc3.push(rest[loc4]);
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(resumeTweenByIndex, arg1, loc3);
        }

        public static function pauseTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && !AuxFunctions.isInArray(rest[loc4], loc3))
                {
                    loc3.push(rest[loc4]);
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(pauseTweenByIndex, arg1, loc3);
        }

        
        {
            _engineExists = false;
            _inited = false;
            _timeScale = 1;
        }

        private static var _timeScale:Number=1;

        private static var _specialPropertySplitterList:Object;

        private static var _engineExists:Boolean=false;

        private static var _specialPropertyModifierList:Object;

        private static var _currentTime:Number;

        private static var _tweenList:Array;

        private static var _specialPropertyList:Object;

        private static var _transitionList:Object;

        private static var _inited:Boolean=false;

        private static var __tweener_controller__:flash.display.MovieClip;
    }
}
