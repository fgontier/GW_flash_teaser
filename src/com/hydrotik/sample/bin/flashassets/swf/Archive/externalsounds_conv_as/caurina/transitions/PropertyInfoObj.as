package caurina.transitions 
{
    public class PropertyInfoObj extends Object
    {
        public function PropertyInfoObj(arg1:Number, arg2:Number, arg3:Function, arg4:Array)
        {
            super();
            valueStart = arg1;
            valueComplete = arg2;
            hasModifier = Boolean(arg3);
            modifierFunction = arg3;
            modifierParameters = arg4;
            return;
        }

        public function toString():String
        {
            var loc1:*;

            loc1 = null;
            loc1 = "\n[PropertyInfoObj ";
            loc1 = loc1 + "valueStart:" + String(valueStart);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "valueComplete:" + String(valueComplete);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "modifierFunction:" + String(modifierFunction);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "modifierParameters:" + String(modifierParameters);
            loc1 = loc1 + "]\n";
            return loc1;
        }

        public function clone():caurina.transitions.PropertyInfoObj
        {
            var loc1:*;

            loc1 = null;
            loc1 = new PropertyInfoObj(valueStart, valueComplete, modifierFunction, modifierParameters);
            return loc1;
        }

        public var modifierParameters:Array;

        public var valueComplete:Number;

        public var modifierFunction:Function;

        public var hasModifier:Boolean;

        public var valueStart:Number;
    }
}
