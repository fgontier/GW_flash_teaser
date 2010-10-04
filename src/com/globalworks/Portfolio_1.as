package com.globalworks 
{
	import com.greensock.*;
	import com.jumpeye.flashEff2.symbol.waves.FESWaves;
	import com.dyc.photo.Slideshow_1;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Portfolio_1 extends MovieClip
	{
		private var _color:uint;
		private var _portfolio_target:String;
		private var _bgd:Background;
		private var _closeButton:Sprite;
		private var _cross:Cross;
		private var _title:TextHandle;
		private var _titleLink:TextHandle;
		private var _xmlData:XML;
		private var _portfolio:Portfolio_2;
		private var my_slideshow:Slideshow_1;
		private var _assetsList:XMLList;
		private var myEffect:FlashEff2Flex;
		
		public function Portfolio_1(color:uint, portfolio_target:String) 
		{
			_color = color;
			_portfolio_target = portfolio_target;

			// load the portfolio target xml:
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, showXML);
			xmlLoader.load(new URLRequest(_portfolio_target));	
		}
		
		private function showXML(e:Event):void 
		{
			XML.ignoreWhitespace = true; 
			_xmlData = new XML(e.target.data);					
			_assetsList = _xmlData.work;
			
			// create a portfolio container:
			var _myPortfolio:Sprite = new Sprite();
			addChild(_myPortfolio);
			
			// creates the background
			_bgd = new Background(0, 270, 1024, 219, _color);
			_myPortfolio.addChild(_bgd);

			var bgdEffect:FlashEff2Flex = new FlashEff2Flex();
			_myPortfolio.addChild(bgdEffect);

			// Create the wave filter instance and set it up as you like.
			var pattern0:FESWaves = new FESWaves();
			pattern0.preset=1;
			pattern0.waveThickness=20;
			pattern0.groupDuration=1;
			pattern0.tweenDuration=1.5;
			pattern0.tweenType='Strong';
			pattern0.easeType = 'easeOut';
			
			// Set the target object to the FlashEff2Flex instance. Once you do this, the filter will be applied immediately. 	
 			bgdEffect.showTransition = pattern0;
			bgdEffect.showAutoPlay = true	
			bgdEffect.target = _bgd;		
			
			// creates the close button:
			_closeButton = new Sprite();
			addChild(_closeButton);
			_cross = new Cross(2, 15, 15);
			_cross.x = 880;
			_cross.y = 285;
			_cross.useHandCursor = true;
			_cross.buttonMode = true;
			_cross.mouseChildren = false;
			_closeButton.addChild(_cross);
			_closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick_handler);
			_myPortfolio.addChild(_closeButton);
			
			// create the slideshow:
			my_slideshow = new Slideshow_1(_assetsList, 3, 2, "easeOutExpo");
			my_slideshow.x = 200;
			my_slideshow.y = 290;
			my_slideshow.name = "my_slideshow";
			_myPortfolio.addChild(my_slideshow);
			// Click handler
			my_slideshow.addEventListener(MouseEvent.CLICK, which_portfolioHandler);
			my_slideshow.useHandCursor = true;
			my_slideshow.buttonMode = true;			
			
			var slideshowEffect:FlashEff2Flex = new FlashEff2Flex();
			_myPortfolio.addChild(slideshowEffect);			
			// Set the target object to the FlashEff2Flex instance. Once you do this, the filter will be applied immediately. 	
 			slideshowEffect.showTransition = pattern0;
			slideshowEffect.showAutoPlay = true;
			slideshowEffect.targetVisibility = false
			slideshowEffect.showDelay = 0.5;
			slideshowEffect.target = my_slideshow;			
			
			// Create arrows:
			if (_assetsList.length() > 0)
			{				
				var _arrowRight:Arrow = new Arrow(0, 8, 8, 50);
				_arrowRight.x = 530;
				_arrowRight.y = 345;
				_arrowRight.alpha = 0;
				_arrowRight.addEventListener(MouseEvent.CLICK, my_slideshow.clickToNextSlide);
				_myPortfolio.addChild(_arrowRight);
				TweenMax.fromTo(_arrowRight, 0.4, {alpha:0, x:500}, {alpha:0.5, x:525, delay:1.5} );
				
				var _arrowLeft:Arrow = new Arrow(0, 8, 8, 50);
				_arrowLeft.scaleX = -1
				_arrowLeft.x = 155;
				_arrowLeft.y = 348;
				_arrowLeft.alpha = 0;
				_arrowLeft.addEventListener(MouseEvent.CLICK, my_slideshow.clickToPreviousSlide);
				_myPortfolio.addChild(_arrowLeft);	
				TweenMax.fromTo(_arrowLeft, 0.4, {alpha:0, x:200}, {alpha:0.5, x:155, delay:1.5} );
			}
			
			// create the title:
			_title = new TextHandle(350, 50, 580, 320, 22, 0xffffff, "left", true, "left", false, false, true, "helvetica", 0);
			_title.htmlText = _xmlData.title.text();
			_title.alpha = 0;
			_myPortfolio.addChild(_title);
			// move and fade in the title			
			TweenMax.fromTo(_title, 0.4, {alpha:0, x:700}, {alpha:1, x:580, delay:1} );
			
			// create the title link:
			_titleLink = new TextHandle(400, 50, 580, 320, 14, 0xffffff, "left", true, "left", false, false, true, "helvetica", 0);
			_titleLink.htmlText = _xmlData.links.text();
			_titleLink.y = _title.y + _title.height + 10;
			_titleLink.alpha = 0;
			_titleLink.addEventListener(MouseEvent.ROLL_OVER, rollOverLink);
			_titleLink.addEventListener(MouseEvent.ROLL_OUT, rollOutLink);
			_myPortfolio.addChild(_titleLink);
			// move and fade in the title link			
			TweenMax.fromTo(_titleLink, 0.4, {alpha:0, x:700}, {alpha:1, x:580, delay:1.5} );	
		}
		
		private function rollOutLink(e:MouseEvent):void 
		{
			TweenLite.to(e.target, .1, { tint:0xffffff } ); 
		}
		
		private function rollOverLink(e:MouseEvent):void 
		{
			TweenLite.to(e.target, .1, { tint:0x000000 } ); 
		}
		
		private function which_portfolioHandler(e:Event):void 
		{
			// Pass which xml to load to create the second portfolio:
			this.dispatchEvent(new EventType("TYPE_NAME", false, false, e.currentTarget.current_portfolio_target, "arg2"));
			
			// pause the portfolio 1 slideshow:
			my_slideshow.pause();
		}

		private function restart_timer(e:Event):void 
		{
			//timer.addEventListener(TimerEvent.TIMER, updateCounter);
			//timer.start();
			//remove the portfolio 2 from the display list:
			removeChild(_portfolio);
			_portfolio = null;
		}		
		
		public static function xmlListToArray($x:XMLList):Array {               
			var a:Array=[], i:String;
			for (i in $x) a[i] = $x[i];
			return a;
		}	
		
		private function closeButtonClick_handler(e:Event):void 
		{
			// The first portfolio has been closed:
			this.dispatchEvent(new Event("portfolio_1_closed", true));
		}
		
	}
}