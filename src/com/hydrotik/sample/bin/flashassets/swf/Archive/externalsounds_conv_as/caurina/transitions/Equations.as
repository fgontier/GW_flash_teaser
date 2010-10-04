package caurina.transitions 
{
    public class Equations extends Object
    {
        public function Equations()
        {
            super();
            trace("Equations is a static class and should not be instantiated.");
            return;
        }

        public static function easeOutBounce(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            if (loc5 < 1 / 2.75)
            {
                return arg3 * 7.5625 * arg1 * arg1 + arg2;
            }
            if (arg1 < 2 / 2.75)
            {
                arg1 = loc5 = arg1 - 1.5 / 2.75;
                return arg3 * (7.5625 * loc5 * arg1 + 0.75) + arg2;
            }
            if (arg1 < 2.5 / 2.75)
            {
                arg1 = loc5 = arg1 - 2.25 / 2.75;
                return arg3 * (7.5625 * loc5 * arg1 + 0.9375) + arg2;
            }
            arg1 = loc5 = arg1 - 2.625 / 2.75;
            return arg3 * (7.5625 * loc5 * arg1 + 0.984375) + arg2;
        }

        public static function easeInOutElastic(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN, arg6:Number=NaN):Number
        {
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / (arg4 / 2);
            if (loc8 == 2)
            {
                return arg2 + arg3;
            }
            if (!arg6)
            {
                arg6 = arg4 * 0.3 * 1.5;
            }
            if (!arg5 || arg5 < Math.abs(arg3))
            {
                arg5 = arg3;
                loc7 = arg6 / 4;
            }
            else 
            {
                loc7 = arg6 / (2 * Math.PI) * Math.asin(arg3 / arg5);
            }
            if (arg1 < 1)
            {
                arg1 = loc8 = (arg1 - 1);
                return -0.5 * arg5 * Math.pow(2, 10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / arg6) + arg2;
            }
            arg1 = loc8 = (arg1 - 1);
            return arg5 * Math.pow(2, -10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / arg6) * 0.5 + arg3 + arg2;
        }

        public static function easeInOutQuad(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 + arg2;
            }
            return (-arg3) / 2 * (--arg1 * (arg1 - 2) - 1) + arg2;
        }

        public static function easeInOutBounce(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeInBounce(arg1 * 2, 0, arg3, arg4) * 0.5 + arg2;
            }
            return easeOutBounce(arg1 * 2 - arg4, 0, arg3, arg4) * 0.5 + arg3 * 0.5 + arg2;
        }

        public static function easeInOutBack(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN):Number
        {
            var loc6:*;

            if (!arg5)
            {
                arg5 = 1.70158;
            }
            arg1 = loc6 = arg1 / (arg4 / 2);
            if (loc6 < 1)
            {
                arg5 = loc6 = arg5 * 1.525;
                return arg3 / 2 * arg1 * arg1 * ((loc6 + 1) * arg1 - arg5) + arg2;
            }
            arg1 = loc6 = arg1 - 2;
            arg5 = loc6 = arg5 * 1.525;
            return arg3 / 2 * (loc6 * arg1 * ((loc6 + 1) * arg1 + arg5) + 2) + arg2;
        }

        public static function easeOutInCubic(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutCubic(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInCubic(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeNone(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return arg3 * arg1 / arg4 + arg2;
        }

        public static function easeOutBack(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN):Number
        {
            var loc6:*;

            if (!arg5)
            {
                arg5 = 1.70158;
            }
            arg1 = loc6 = (arg1 / arg4 - 1);
            return arg3 * (loc6 * arg1 * ((arg5 + 1) * arg1 + arg5) + 1) + arg2;
        }

        public static function easeInOutSine(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (-arg3) / 2 * (Math.cos(Math.PI * arg1 / arg4) - 1) + arg2;
        }

        public static function easeInBack(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN):Number
        {
            var loc6:*;

            if (!arg5)
            {
                arg5 = 1.70158;
            }
            arg1 = loc6 = arg1 / arg4;
            return arg3 * loc6 * arg1 * ((arg5 + 1) * arg1 - arg5) + arg2;
        }

        public static function easeInQuart(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 * arg1 + arg2;
        }

        public static function easeOutInQuint(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutQuint(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInQuint(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeOutInBounce(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutBounce(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInBounce(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function init():void
        {
            Tweener.registerTransition("easenone", easeNone);
            Tweener.registerTransition("linear", easeNone);
            Tweener.registerTransition("easeinquad", easeInQuad);
            Tweener.registerTransition("easeoutquad", easeOutQuad);
            Tweener.registerTransition("easeinoutquad", easeInOutQuad);
            Tweener.registerTransition("easeoutinquad", easeOutInQuad);
            Tweener.registerTransition("easeincubic", easeInCubic);
            Tweener.registerTransition("easeoutcubic", easeOutCubic);
            Tweener.registerTransition("easeinoutcubic", easeInOutCubic);
            Tweener.registerTransition("easeoutincubic", easeOutInCubic);
            Tweener.registerTransition("easeinquart", easeInQuart);
            Tweener.registerTransition("easeoutquart", easeOutQuart);
            Tweener.registerTransition("easeinoutquart", easeInOutQuart);
            Tweener.registerTransition("easeoutinquart", easeOutInQuart);
            Tweener.registerTransition("easeinquint", easeInQuint);
            Tweener.registerTransition("easeoutquint", easeOutQuint);
            Tweener.registerTransition("easeinoutquint", easeInOutQuint);
            Tweener.registerTransition("easeoutinquint", easeOutInQuint);
            Tweener.registerTransition("easeinsine", easeInSine);
            Tweener.registerTransition("easeoutsine", easeOutSine);
            Tweener.registerTransition("easeinoutsine", easeInOutSine);
            Tweener.registerTransition("easeoutinsine", easeOutInSine);
            Tweener.registerTransition("easeincirc", easeInCirc);
            Tweener.registerTransition("easeoutcirc", easeOutCirc);
            Tweener.registerTransition("easeinoutcirc", easeInOutCirc);
            Tweener.registerTransition("easeoutincirc", easeOutInCirc);
            Tweener.registerTransition("easeinexpo", easeInExpo);
            Tweener.registerTransition("easeoutexpo", easeOutExpo);
            Tweener.registerTransition("easeinoutexpo", easeInOutExpo);
            Tweener.registerTransition("easeoutinexpo", easeOutInExpo);
            Tweener.registerTransition("easeinelastic", easeInElastic);
            Tweener.registerTransition("easeoutelastic", easeOutElastic);
            Tweener.registerTransition("easeinoutelastic", easeInOutElastic);
            Tweener.registerTransition("easeoutinelastic", easeOutInElastic);
            Tweener.registerTransition("easeinback", easeInBack);
            Tweener.registerTransition("easeoutback", easeOutBack);
            Tweener.registerTransition("easeinoutback", easeInOutBack);
            Tweener.registerTransition("easeoutinback", easeOutInBack);
            Tweener.registerTransition("easeinbounce", easeInBounce);
            Tweener.registerTransition("easeoutbounce", easeOutBounce);
            Tweener.registerTransition("easeinoutbounce", easeInOutBounce);
            Tweener.registerTransition("easeoutinbounce", easeOutInBounce);
            return;
        }

        public static function easeOutExpo(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (arg1 != arg4) ? arg3 * (-Math.pow(2, -10 * arg1 / arg4) + 1) + arg2 : arg2 + arg3;
        }

        public static function easeOutInBack(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutBack(arg1 * 2, arg2, arg3 / 2, arg4, arg5);
            }
            return easeInBack(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4, arg5);
        }

        public static function easeInExpo(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (arg1 != 0) ? arg3 * Math.pow(2, 10 * (arg1 / arg4 - 1)) + arg2 : arg2;
        }

        public static function easeInCubic(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 + arg2;
        }

        public static function easeInQuint(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 * arg1 * arg1 + arg2;
        }

        public static function easeInOutCirc(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return (-arg3) / 2 * (Math.sqrt(1 - arg1 * arg1) - 1) + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return arg3 / 2 * (Math.sqrt(1 - loc5 * arg1) + 1) + arg2;
        }

        public static function easeInQuad(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 + arg2;
        }

        public static function easeInBounce(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return arg3 - easeOutBounce(arg4 - arg1, 0, arg3, arg4) + arg2;
        }

        public static function easeOutInExpo(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutExpo(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInExpo(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeOutQuart(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return (-arg3) * (loc5 * arg1 * arg1 * arg1 - 1) + arg2;
        }

        public static function easeInSine(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (-arg3) * Math.cos(arg1 / arg4 * Math.PI / 2) + arg3 + arg2;
        }

        public static function easeInOutQuart(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return (-arg3) / 2 * (loc5 * arg1 * arg1 * arg1 - 2) + arg2;
        }

        public static function easeOutQuad(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return (-arg3) * loc5 * (arg1 - 2) + arg2;
        }

        public static function easeOutInElastic(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN, arg6:Number=NaN):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutElastic(arg1 * 2, arg2, arg3 / 2, arg4, arg5, arg6);
            }
            return easeInElastic(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4, arg5, arg6);
        }

        public static function easeInElastic(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN, arg6:Number=NaN):Number
        {
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / arg4;
            if (loc8 == 1)
            {
                return arg2 + arg3;
            }
            if (!arg6)
            {
                arg6 = arg4 * 0.3;
            }
            if (!arg5 || arg5 < Math.abs(arg3))
            {
                arg5 = arg3;
                loc7 = arg6 / 4;
            }
            else 
            {
                loc7 = arg6 / (2 * Math.PI) * Math.asin(arg3 / arg5);
            }
            arg1 = loc8 = (arg1 - 1);
            return -arg5 * Math.pow(2, 10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / arg6) + arg2;
        }

        public static function easeOutCubic(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return arg3 * (loc5 * arg1 * arg1 + 1) + arg2;
        }

        public static function easeOutQuint(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return arg3 * (loc5 * arg1 * arg1 * arg1 * arg1 + 1) + arg2;
        }

        public static function easeOutInQuad(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutQuad(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInQuad(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeOutSine(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return arg3 * Math.sin(arg1 / arg4 * Math.PI / 2) + arg2;
        }

        public static function easeInOutCubic(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return arg3 / 2 * (loc5 * arg1 * arg1 + 2) + arg2;
        }

        public static function easeInOutQuint(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return arg3 / 2 * (loc5 * arg1 * arg1 * arg1 * arg1 + 2) + arg2;
        }

        public static function easeInCirc(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return (-arg3) * (Math.sqrt(1 - loc5 * arg1) - 1) + arg2;
        }

        public static function easeOutInSine(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutSine(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInSine(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeInOutExpo(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            if (arg1 == 0)
            {
                return arg2;
            }
            if (arg1 == arg4)
            {
                return arg2 + arg3;
            }
            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * Math.pow(2, 10 * (arg1 - 1)) + arg2;
            }
            return arg3 / 2 * (-Math.pow(2, -10 * --arg1) + 2) + arg2;
        }

        public static function easeOutElastic(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number=NaN, arg6:Number=NaN):Number
        {
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / arg4;
            if (loc8 == 1)
            {
                return arg2 + arg3;
            }
            if (!arg6)
            {
                arg6 = arg4 * 0.3;
            }
            if (!arg5 || arg5 < Math.abs(arg3))
            {
                arg5 = arg3;
                loc7 = arg6 / 4;
            }
            else 
            {
                loc7 = arg6 / (2 * Math.PI) * Math.asin(arg3 / arg5);
            }
            return arg5 * Math.pow(2, -10 * arg1) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / arg6) + arg3 + arg2;
        }

        public static function easeOutCirc(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return arg3 * Math.sqrt(1 - loc5 * arg1) + arg2;
        }

        public static function easeOutInQuart(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutQuart(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInQuart(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }

        public static function easeOutInCirc(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < arg4 / 2)
            {
                return easeOutCirc(arg1 * 2, arg2, arg3 / 2, arg4);
            }
            return easeInCirc(arg1 * 2 - arg4, arg2 + arg3 / 2, arg3 / 2, arg4);
        }
    }
}
