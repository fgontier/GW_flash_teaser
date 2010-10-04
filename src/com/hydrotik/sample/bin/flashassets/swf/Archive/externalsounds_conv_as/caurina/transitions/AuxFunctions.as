package caurina.transitions 
{
    public class AuxFunctions extends Object
    {
        public function AuxFunctions()
        {
            super();
            return;
        }

        public static function getObjectLength(arg1:Object):uint
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = 0;
            loc3 = null;
            loc2 = 0;
            loc4 = 0;
            loc5 = arg1;
            for (loc3 in loc5)
            {
                loc2 = (loc2 + 1);
            }
            return loc2;
        }

        public static function isInArray(arg1:String, arg2:Array):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc4 = 0;
            loc3 = arg2.length;
            loc4 = 0;
            while (loc4 < loc3) 
            {
                if (arg2[loc4] == arg1)
                {
                    return true;
                }
                loc4 = (loc4 + 1);
            }
            return false;
        }

        public static function numberToG(arg1:Number):Number
        {
            return (arg1 & 65280) >> 8;
        }

        public static function numberToB(arg1:Number):Number
        {
            return arg1 & 255;
        }

        public static function numberToR(arg1:Number):Number
        {
            return (arg1 & 16711680) >> 16;
        }
    }
}
