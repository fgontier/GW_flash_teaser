package caurina.transitions 
{
    public class SpecialPropertySplitter extends Object
    {
        public function SpecialPropertySplitter(arg1:Function)
        {
            super();
            splitValues = arg1;
            return;
        }

        public function toString():String
        {
            var loc1:*;

            loc1 = null;
            loc1 = "";
            loc1 = loc1 + "[SpecialPropertySplitter ";
            loc1 = loc1 + "splitValues:" + String(splitValues);
            loc1 = loc1 + "]";
            return loc1;
        }

        public var splitValues:Function;
    }
}
