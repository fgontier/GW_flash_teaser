package caurina.transitions 
{
    public class SpecialPropertyModifier extends Object
    {
        public function SpecialPropertyModifier(arg1:Function, arg2:Function)
        {
            super();
            modifyValues = arg1;
            getValue = arg2;
            return;
        }

        public function toString():String
        {
            var loc1:*;

            loc1 = null;
            loc1 = "";
            loc1 = loc1 + "[SpecialPropertyModifier ";
            loc1 = loc1 + "modifyValues:" + String(modifyValues);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "getValue:" + String(getValue);
            loc1 = loc1 + "]";
            return loc1;
        }

        public var getValue:Function;

        public var modifyValues:Function;
    }
}
