package com.globalworks 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.*;

	public class Teaser extends Sprite 
	{
		public var color:uint;
		public var portfolio_target:String;
		public var index:int;
		
		private var _label:String;
		public var _body:String;
		public var _link_label:String;
		private var _link_target:String;
		
		public var _bgd:Background;
		public var _labelText:TextHandle;
		public var myTweenBgd:TweenMax;
		public var myTweenLabel:TweenMax;
		
		public var myTimeline:TimelineLite;
			
		public function Teaser(myLabel:String, myColor:uint, myBody:String, myLink_label:String, myLink_target:String, myPortfolio_target:String) 
		{
			color = myColor;
			portfolio_target = myPortfolio_target;
			
			_label = myLabel;		
			_body = myBody;
			_link_label = myLink_label;
			_link_target = myLink_target;
		
			// creates the background
			_bgd = new Background(0, 20, 210, 82, color);
			_bgd.alpha = 0;
			addChild(_bgd);
			
			// creates the label
			_labelText = new TextHandle(140, 20, 0, 0, 12, 0x000000, "left", true, "left", false, false, true, "verdana", 0);
			_labelText.htmlText = _label;
			_labelText.alpha = 0;
			addChild(_labelText);		
			
			//this.addEventListener(MouseEvent.ROLL_OVER, mouseOver_handler);
			//this.addEventListener(MouseEvent.ROLL_OUT, mouseOut_handler);
			//this.addEventListener(MouseEvent.CLICK, mouseClick_handler);

			//myTweenBgd = new TweenMax(this._bgd, 0.05, { alpha:1, repeat:3, repeatDelay:0, yoyo:false, delay:0, onComplete:tweenComplete } );
			//myTweenLabel = new TweenMax(this._labelText, 0.1, { alpha:1, delay:0 } )
			
			//TweenMax.to(_bgd, 0.1, { alpha:1, repeat:2, yoyo:true, delay:0.5, onComplete:tweenComplete } );
			//TweenMax.to(_labelText, 0.1, { alpha:1, delay:0.2 } );
			
			//myTimeline = new TimelineLite();
			//myTimeline.insert(new TweenLite(_bgd, 0.1, { alpha:1, repeat:2, yoyo:true, delay:0, onComplete:tweenComplete } ), 0);
			//myTimeline.insert(new TweenLite(_labelText, 0.1, { alpha:1, delay:0.2 } ), 0);
			
		}
		
		private function tweenComplete():void
		{
			_bgd.alpha = 1;
			_bgd.visible = true;
		}
		
		private function mouseClick_handler(e:MouseEvent):void 
		{
			e.target.dispatchEvent(new Event("teaserClick1", true));	
		}
		
		private function mouseOver_handler(e:MouseEvent):void 
		{
			_bgd.y = -25;
			TweenMax.to(_labelText, .1, { tint:0xffffff } );
			e.target.dispatchEvent(new Event("teaserOver", true));
		}
		
		private function mouseOut_handler(e:MouseEvent):void 
		{
			//_bgd.y = 0;
			//TweenMax.to(_labelText, .1, { tint:0x000000 } );
			e.target.dispatchEvent(new Event("teaserOut", true));			
		}
		
	}

}