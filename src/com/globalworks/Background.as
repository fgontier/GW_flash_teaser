package com.globalworks 
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Background extends Sprite 
	{
		private var _color:uint;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function Background(x:Number, y:Number, width:Number, height:Number, color:uint) 
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_color = color;
			
			var rectangle:Shape = new Shape();
			rectangle.graphics.beginFill(_color);
			rectangle.graphics.drawRect(_x, _y, _width, _height);
			rectangle.graphics.endFill();
			addChild(rectangle); 
		}
		
	}

}