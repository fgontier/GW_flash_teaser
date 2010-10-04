package caurina.transitions 
{
    import flash.filters.*;
    import flash.geom.*;
    import flash.media.*;
    
    public class SpecialPropertiesDefault extends Object
    {
        public function SpecialPropertiesDefault()
        {
            super();
            trace("SpecialProperties is a static class and should not be instantiated.");
            return;
        }

        public static function _sound_volume_get(arg1:Object):Number
        {
            return arg1.soundTransform.volume;
        }

        public static function _color_splitter(arg1:*):Array
        {
            var loc2:*;

            loc2 = null;
            loc2 = new Array();
            if (arg1 != null)
            {
                loc2.push({"name":"_color_ra", "value":0});
                loc2.push({"name":"_color_rb", "value":AuxFunctions.numberToR(arg1)});
                loc2.push({"name":"_color_ga", "value":0});
                loc2.push({"name":"_color_gb", "value":AuxFunctions.numberToG(arg1)});
                loc2.push({"name":"_color_ba", "value":0});
                loc2.push({"name":"_color_bb", "value":AuxFunctions.numberToB(arg1)});
            }
            else 
            {
                loc2.push({"name":"_color_ra", "value":1});
                loc2.push({"name":"_color_rb", "value":0});
                loc2.push({"name":"_color_ga", "value":1});
                loc2.push({"name":"_color_gb", "value":0});
                loc2.push({"name":"_color_ba", "value":1});
                loc2.push({"name":"_color_bb", "value":0});
            }
            return loc2;
        }

        public static function frame_get(arg1:Object):Number
        {
            return arg1.currentFrame;
        }

        public static function _sound_pan_get(arg1:Object):Number
        {
            return arg1.soundTransform.pan;
        }

        public static function _color_property_get(arg1:Object, arg2:Array):Number
        {
            return arg1.transform.colorTransform[arg2[0]];
        }

        public static function _sound_volume_set(arg1:Object, arg2:Number):void
        {
            var loc3:*;

            loc3 = null;
            loc3 = arg1.soundTransform;
            loc3.volume = arg2;
            arg1.soundTransform = loc3;
            return;
        }

        public static function _autoAlpha_get(arg1:Object):Number
        {
            return arg1.alpha;
        }

        public static function _filter_splitter(arg1:flash.filters.BitmapFilter):Array
        {
            var loc2:*;

            loc2 = null;
            loc2 = new Array();
            if (arg1 as BlurFilter)
            {
                loc2.push({"name":"_blur_blurX", "value":BlurFilter(arg1).blurX});
                loc2.push({"name":"_blur_blurY", "value":BlurFilter(arg1).blurY});
                loc2.push({"name":"_blur_quality", "value":BlurFilter(arg1).quality});
            }
            else 
            {
                trace("??");
            }
            return loc2;
        }

        public static function init():void
        {
            Tweener.registerSpecialProperty("_frame", frame_get, frame_set);
            Tweener.registerSpecialProperty("_sound_volume", _sound_volume_get, _sound_volume_set);
            Tweener.registerSpecialProperty("_sound_pan", _sound_pan_get, _sound_pan_set);
            Tweener.registerSpecialProperty("_color_ra", _color_property_get, _color_property_set, ["redMultiplier"]);
            Tweener.registerSpecialProperty("_color_rb", _color_property_get, _color_property_set, ["redOffset"]);
            Tweener.registerSpecialProperty("_color_ga", _color_property_get, _color_property_set, ["greenMultiplier"]);
            Tweener.registerSpecialProperty("_color_gb", _color_property_get, _color_property_set, ["greenOffset"]);
            Tweener.registerSpecialProperty("_color_ba", _color_property_get, _color_property_set, ["blueMultiplier"]);
            Tweener.registerSpecialProperty("_color_bb", _color_property_get, _color_property_set, ["blueOffset"]);
            Tweener.registerSpecialProperty("_color_aa", _color_property_get, _color_property_set, ["alphaMultiplier"]);
            Tweener.registerSpecialProperty("_color_ab", _color_property_get, _color_property_set, ["alphaOffset"]);
            Tweener.registerSpecialProperty("_autoAlpha", _autoAlpha_get, _autoAlpha_set);
            Tweener.registerSpecialPropertySplitter("_color", _color_splitter);
            Tweener.registerSpecialPropertySplitter("_colorTransform", _colorTransform_splitter);
            Tweener.registerSpecialProperty("_blur_blurX", _filter_property_get, _filter_property_set, [BlurFilter, "blurX"]);
            Tweener.registerSpecialProperty("_blur_blurY", _filter_property_get, _filter_property_set, [BlurFilter, "blurY"]);
            Tweener.registerSpecialProperty("_blur_quality", _filter_property_get, _filter_property_set, [BlurFilter, "quality"]);
            Tweener.registerSpecialPropertySplitter("_filter", _filter_splitter);
            Tweener.registerSpecialPropertyModifier("_bezier", _bezier_modifier, _bezier_get);
            return;
        }

        public static function _sound_pan_set(arg1:Object, arg2:Number):void
        {
            var loc3:*;

            loc3 = null;
            loc3 = arg1.soundTransform;
            loc3.pan = arg2;
            arg1.soundTransform = loc3;
            return;
        }

        public static function _color_property_set(arg1:Object, arg2:Number, arg3:Array):void
        {
            var loc4:*;

            loc4 = null;
            (loc4 = arg1.transform.colorTransform)[arg3[0]] = arg2;
            arg1.transform.colorTransform = loc4;
            return;
        }

        public static function _filter_property_get(arg1:Object, arg2:Array):Number
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = null;
            loc4 = 0;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc3 = arg1.filters;
            loc5 = arg2[0];
            loc6 = arg2[1];
            loc4 = 0;
            while (loc4 < loc3.length) 
            {
                if (loc3[loc4] as BlurFilter && loc5 == BlurFilter)
                {
                    return loc3[loc4][loc6];
                }
                loc4 = (loc4 + 1);
            }
            loc8 = loc5;
            switch (loc8) 
            {
                case BlurFilter:
                    loc7 = {"blurX":0, "blurY":0, "quality":NaN};
                    break;
            }
            return loc7[loc6];
        }

        public static function _bezier_get(arg1:Number, arg2:Number, arg3:Number, arg4:Array):Number
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = 0;
            loc6 = NaN;
            loc7 = NaN;
            loc8 = NaN;
            if (arg4.length == 1)
            {
                return arg1 + arg3 * (2 * (1 - arg3) * (arg4[0] - arg1) + arg3 * (arg2 - arg1));
            }
            loc5 = Math.floor(arg3 * arg4.length);
            loc6 = (arg3 - loc5 * 1 / arg4.length) * arg4.length;
            if (loc5 != 0)
            {
                if (loc5 != (arg4.length - 1))
                {
                    loc7 = (arg4[(loc5 - 1)] + arg4[loc5]) / 2;
                    loc8 = (arg4[loc5] + arg4[(loc5 + 1)]) / 2;
                }
                else 
                {
                    loc7 = (arg4[(loc5 - 1)] + arg4[loc5]) / 2;
                    loc8 = arg2;
                }
            }
            else 
            {
                loc7 = arg1;
                loc8 = (arg4[0] + arg4[1]) / 2;
            }
            return loc7 + loc6 * (2 * (1 - loc6) * (arg4[loc5] - loc7) + loc6 * (loc8 - loc7));
        }

        public static function frame_set(arg1:Object, arg2:Number):void
        {
            arg1.gotoAndStop(Math.round(arg2));
            return;
        }

        public static function _filter_property_set(arg1:Object, arg2:Number, arg3:Array):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = 0;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc4 = arg1.filters;
            loc6 = arg3[0];
            loc7 = arg3[1];
            loc5 = 0;
            while (loc5 < loc4.length) 
            {
                if (loc4[loc5] as BlurFilter && loc6 == BlurFilter)
                {
                    loc4[loc5][loc7] = arg2;
                    arg1.filters = loc4;
                    return;
                }
                loc5 = (loc5 + 1);
            }
            if (loc4 == null)
            {
                loc4 = new Array();
            }
            loc9 = loc6;
            switch (loc9) 
            {
                case BlurFilter:
                    loc8 = new BlurFilter(0, (0));
                    break;
            }
            loc8[loc7] = arg2;
            loc4.push(loc8);
            arg1.filters = loc4;
            return;
        }

        public static function _autoAlpha_set(arg1:Object, arg2:Number):void
        {
            arg1.alpha = arg2;
            arg1.visible = arg2 > 0;
            return;
        }

        public static function _colorTransform_splitter(arg1:*):Array
        {
            var loc2:*;

            loc2 = null;
            loc2 = new Array();
            if (arg1 != null)
            {
                if (arg1.ra != undefined)
                {
                    loc2.push({"name":"_color_ra", "value":arg1.ra});
                }
                if (arg1.rb != undefined)
                {
                    loc2.push({"name":"_color_rb", "value":arg1.rb});
                }
                if (arg1.ga != undefined)
                {
                    loc2.push({"name":"_color_ba", "value":arg1.ba});
                }
                if (arg1.gb != undefined)
                {
                    loc2.push({"name":"_color_bb", "value":arg1.bb});
                }
                if (arg1.ba != undefined)
                {
                    loc2.push({"name":"_color_ga", "value":arg1.ga});
                }
                if (arg1.bb != undefined)
                {
                    loc2.push({"name":"_color_gb", "value":arg1.gb});
                }
                if (arg1.aa != undefined)
                {
                    loc2.push({"name":"_color_aa", "value":arg1.aa});
                }
                if (arg1.ab != undefined)
                {
                    loc2.push({"name":"_color_ab", "value":arg1.ab});
                }
            }
            else 
            {
                loc2.push({"name":"_color_ra", "value":1});
                loc2.push({"name":"_color_rb", "value":0});
                loc2.push({"name":"_color_ga", "value":1});
                loc2.push({"name":"_color_gb", "value":0});
                loc2.push({"name":"_color_ba", "value":1});
                loc2.push({"name":"_color_bb", "value":0});
            }
            return loc2;
        }

        public static function _bezier_modifier(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = null;
            loc3 = null;
            loc4 = 0;
            loc5 = null;
            loc6 = null;
            loc2 = [];
            if (arg1 as Array)
            {
                loc3 = arg1;
            }
            else 
            {
                loc3 = [arg1];
            }
            loc6 = {};
            loc4 = 0;
            while (loc4 < loc3.length) 
            {
                loc7 = 0;
                loc8 = loc3[loc4];
                for (loc5 in loc8)
                {
                    if (loc6[loc5] == undefined)
                    {
                        loc6[loc5] = [];
                    }
                    loc6[loc5].push(loc3[loc4][loc5]);
                }
                loc4 = (loc4 + 1);
            }
            loc7 = 0;
            loc8 = loc6;
            for (loc5 in loc8)
            {
                loc2.push({"name":loc5, "parameters":loc6[loc5]});
            }
            return loc2;
        }
    }
}
