package caurina.transitions 
{
    public class TweenListObj extends Object
    {
        public function TweenListObj(arg1:Object, arg2:Number, arg3:Number, arg4:Boolean, arg5:Function)
        {
            super();
            scope = arg1;
            timeStart = arg2;
            timeComplete = arg3;
            useFrames = arg4;
            transition = arg5;
            auxProperties = new Object();
            properties = new Object();
            isPaused = false;
            timePaused = undefined;
            isCaller = false;
            updatesSkipped = 0;
            timesCalled = 0;
            skipUpdates = 0;
            hasStarted = false;
            return;
        }

        public function clone(arg1:Boolean):caurina.transitions.TweenListObj
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc2 = new TweenListObj(scope, timeStart, timeComplete, useFrames, transition);
            loc2.properties = new Array();
            loc4 = 0;
            loc5 = properties;
            for (loc3 in loc5)
            {
                loc2.properties[loc3] = properties[loc3].clone();
            }
            loc2.skipUpdates = skipUpdates;
            loc2.updatesSkipped = updatesSkipped;
            if (!arg1)
            {
                loc2.onStart = onStart;
                loc2.onUpdate = onUpdate;
                loc2.onComplete = onComplete;
                loc2.onOverwrite = onOverwrite;
                loc2.onStartParams = onStartParams;
                loc2.onUpdateParams = onUpdateParams;
                loc2.onCompleteParams = onCompleteParams;
                loc2.onOverwriteParams = onOverwriteParams;
            }
            loc2.rounded = rounded;
            loc2.isPaused = isPaused;
            loc2.timePaused = timePaused;
            loc2.isCaller = isCaller;
            loc2.count = count;
            loc2.timesCalled = timesCalled;
            loc2.waitFrames = waitFrames;
            loc2.hasStarted = hasStarted;
            return loc2;
        }

        public function toString():String
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = 0;
            loc1 = "\n[TweenListObj ";
            loc1 = loc1 + "scope:" + String(scope);
            loc1 = loc1 + ", properties:";
            loc2 = 0;
            while (loc2 < properties.length) 
            {
                if (loc2 > 0)
                {
                    loc1 = loc1 + ",";
                }
                loc1 = loc1 + "[name:" + properties[loc2].name;
                loc1 = loc1 + ",valueStart:" + properties[loc2].valueStart;
                loc1 = loc1 + ",valueComplete:" + properties[loc2].valueComplete;
                loc1 = loc1 + "]";
                loc2 = (loc2 + 1);
            }
            loc1 = loc1 + ", timeStart:" + String(timeStart);
            loc1 = loc1 + ", timeComplete:" + String(timeComplete);
            loc1 = loc1 + ", useFrames:" + String(useFrames);
            loc1 = loc1 + ", transition:" + String(transition);
            if (skipUpdates)
            {
                loc1 = loc1 + ", skipUpdates:" + String(skipUpdates);
            }
            if (updatesSkipped)
            {
                loc1 = loc1 + ", updatesSkipped:" + String(updatesSkipped);
            }
            if (Boolean(onStart))
            {
                loc1 = loc1 + ", onStart:" + String(onStart);
            }
            if (Boolean(onUpdate))
            {
                loc1 = loc1 + ", onUpdate:" + String(onUpdate);
            }
            if (Boolean(onComplete))
            {
                loc1 = loc1 + ", onComplete:" + String(onComplete);
            }
            if (Boolean(onOverwrite))
            {
                loc1 = loc1 + ", onOverwrite:" + String(onOverwrite);
            }
            if (onStartParams)
            {
                loc1 = loc1 + ", onStartParams:" + String(onStartParams);
            }
            if (onUpdateParams)
            {
                loc1 = loc1 + ", onUpdateParams:" + String(onUpdateParams);
            }
            if (onCompleteParams)
            {
                loc1 = loc1 + ", onCompleteParams:" + String(onCompleteParams);
            }
            if (onOverwriteParams)
            {
                loc1 = loc1 + ", onOverwriteParams:" + String(onOverwriteParams);
            }
            if (rounded)
            {
                loc1 = loc1 + ", rounded:" + String(rounded);
            }
            if (isPaused)
            {
                loc1 = loc1 + ", isPaused:" + String(isPaused);
            }
            if (timePaused)
            {
                loc1 = loc1 + ", timePaused:" + String(timePaused);
            }
            if (isCaller)
            {
                loc1 = loc1 + ", isCaller:" + String(isCaller);
            }
            if (count)
            {
                loc1 = loc1 + ", count:" + String(count);
            }
            if (timesCalled)
            {
                loc1 = loc1 + ", timesCalled:" + String(timesCalled);
            }
            if (waitFrames)
            {
                loc1 = loc1 + ", waitFrames:" + String(waitFrames);
            }
            if (hasStarted)
            {
                loc1 = loc1 + ", hasStarted:" + String(hasStarted);
            }
            loc1 = loc1 + "]\n";
            return loc1;
        }

        public var onUpdate:Function;

        public var useFrames:Boolean;

        public var hasStarted:Boolean;

        public var onOverwriteParams:Array;

        public var timeStart:Number;

        public var count:Number;

        public var auxProperties:Object;

        public var timeComplete:Number;

        public var onStartParams:Array;

        public var rounded:Boolean;

        public var updatesSkipped:Number;

        public var onUpdateParams:Array;

        public var onComplete:Function;

        public var properties:Object;

        public var onStart:Function;

        public var skipUpdates:Number;

        public var scope:Object;

        public var isCaller:Boolean;

        public var timePaused:Number;

        public var transition:Function;

        public var onCompleteParams:Array;

        public var timesCalled:Number;

        public var onOverwrite:Function;

        public var isPaused:Boolean;

        public var waitFrames:Boolean;
    }
}
