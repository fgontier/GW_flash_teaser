package com.globalworks
{
    import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.TweenLite;
    
    public class Cross extends Sprite 
	{
		private var _startX:Number;
		private var _thickness:Number;
		private var _width:Number;
		private var _height:Number;
		
        public function Cross(thickness:Number, width:Number, height:Number):void 
		{
			_thickness = thickness;
			_width = width;
			_height = height;
			
			graphics.lineStyle(_thickness, 0xffffff , 1, false, "normal", "square" )
            graphics.moveTo(0, 0);
            graphics.lineTo(_width, _height);
			graphics.moveTo(0, _width);
            graphics.lineTo(_height, 0);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, cross_mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, cross_mouseOutHandler);
			
			this.buttonMode = true
			this.mouseChildren = false;			
			this.useHandCursor = true;
			
			this.alpha = 0.5;
        }
		
		private function cross_mouseOverHandler(e:Event):void 
		{
			//TweenLite.to(e.target, 0.2, { tint:0x333333 })
			TweenLite.to(e.target, 0.2, { alpha:1, scaleX:1.2, scaleY:1.2 })
		}
		
		private function cross_mouseOutHandler(e:Event):void 
		{
			//TweenLite.to(e.target, 0.2, { tint:0xffffff })
			TweenLite.to(e.target, 0.2, { alpha:0.5, scaleX:1, scaleY:1 })
		}
    }
}