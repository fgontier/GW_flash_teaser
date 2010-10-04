package com.globalworks 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.TweenLite;

	public class SlideMarker extends Sprite
	{
		private var _current_slide_index:int = 0;
		private var _totalSlides:int;
		public var marker:Background;
		
		public function SlideMarker(totalSlides:int):void
		{
			_totalSlides = totalSlides;
			
			for (var i:int = 0; i < _totalSlides; i++) 
			{
				//marker = new Background(100, 460, 73, 2, 0xffffff);
				marker = new Background(0, 0, 73, 2, 0xffffff);
				marker.x = marker.x  + 80 * i;
				marker.alpha = 0.8;
				marker.name = i.toString();
				addChild(marker);
			}
			
			resetMarker();
		}
		
		public function clickToNextSlide():void 
		{
			if(_current_slide_index + 1 < _totalSlides)
				_current_slide_index++;
			else
				_current_slide_index = 0;
	
			resetMarker();			
		}
		
		public function clickToPreviousSlide():void 
		{
			if(_current_slide_index == 0)
				_current_slide_index = _totalSlides -1;
			else
				_current_slide_index--;
				
			resetMarker();
		}
		
		public function resetMarker():void
		{
			for (var i:int = 0; i < _totalSlides; i++) 
			{
				// get marker by name and reset all colors:
				TweenLite.to(this.getChildByName(i.toString()), 0.2, { tint:0x333333 })
			}	
			markerON();
		}
		
		public function markerON():void 
		{
			// set the color of the current marker:
			TweenLite.to(this.getChildByName(_current_slide_index.toString()), 0.2, { tint:0xffffff })
		}
	}

}