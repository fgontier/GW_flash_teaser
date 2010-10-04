package com.globalworks 
{
	import com.greensock.*;	
	import com.jumpeye.flashEff2.symbol.waves.FESWaves;
	import biz.Flashscript.components.textarea.TextHolder;
	import com.jumpeye.flashEff2.text.slice.FETSlice;	
	import com.dyc.photo.Slideshow_2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Portfolio_2 extends Sprite
	{
		private var _color:uint;
		private var _portfolio_target:String;
		private var _bgd:Background;
		private var _closeButton:Sprite;
		private var _cross:Cross;		
		private var _xmlData:XML;
		private var my_slideshow:Slideshow_2;
		private var _assetsList:XMLList;
		
		public function Portfolio_2(color:uint, portfolio_target:String) 
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
			_bgd = new Background(0, 0, 1024, 475, _color);
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
			pattern0.easeType='easeOut';			
			
			// Set the target object to the FlashEff2Flex instance. Once you do this, the filter will be applied immediately. 	
 			bgdEffect.showTransition = pattern0;
			bgdEffect.showAutoPlay = true	
			bgdEffect.target = _bgd;	
			
			// creates the close button:
			_closeButton = new Sprite();
			addChild(_closeButton);
			_cross = new Cross(2, 15, 15);
			_cross.x = 990;
			_cross.y = 20;
			_cross.useHandCursor = true;
			_cross.buttonMode = true;
			_cross.mouseChildren = false;
			_closeButton.addChild(_cross);
			_closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick_handler);
			_myPortfolio.addChild(_closeButton);
			
			// create the slideshow:
			my_slideshow = new Slideshow_2(_assetsList, 3, 1, "easeOutExpo");
			my_slideshow.x = 100;
			my_slideshow.y = 50;
			_myPortfolio.addChild(my_slideshow);

			var slideshowEffect:FlashEff2Flex = new FlashEff2Flex();
			_myPortfolio.addChild(slideshowEffect);			
			// Set the target object to the FlashEff2Flex instance. Once you do this, the filter will be applied immediately. 	
 			slideshowEffect.showTransition = pattern0;
			slideshowEffect.showAutoPlay = true;
			slideshowEffect.targetVisibility = false
			slideshowEffect.showDelay = 0.5;
			slideshowEffect.target = my_slideshow;				
			
			// create the title:
			var _title:TextHandle = new TextHandle(200, 50, 780, 45, 16, 0xffffff, "left", true, "left", false, false, true, "helvetica", 0);
			_title.htmlText = _xmlData.title.text();
			_myPortfolio.addChild(_title);	
			var titleEffect:FlashEff2Flex = new FlashEff2Flex();
			_myPortfolio.addChild(titleEffect);	
			titleEffect.target = _title;
			titleEffect.showAutoPlay = true;
			titleEffect.targetVisibility = false
			titleEffect.showDelay = 1;
			
			// create the title link:
			var _titleLink:TextHandle = new TextHandle(200, 50, 780, 320, 11, 0xffffff, "left", true, "left", false, false, true, "helvetica", 0);
			_titleLink.htmlText = _xmlData.links.text();
			_titleLink.y = titleEffect.y + titleEffect.height + 10;
			_myPortfolio.addChild(_titleLink);	
			var titlelinkEffect:FlashEff2Flex = new FlashEff2Flex();
			_myPortfolio.addChild(titlelinkEffect);			
			titlelinkEffect.target = _titleLink;
			titlelinkEffect.showAutoPlay = true;
			titlelinkEffect.targetVisibility = false
			titlelinkEffect.showDelay = 2;	
			
			var patternText:FETSlice = new FETSlice();
			patternText.preset=19;
			patternText.slices=1;
			patternText.direction='v';
			patternText.position=50;
			patternText.subGrupDuration=0.2;
			patternText.alphaPercentage=100;
			patternText.blurQuality=3;
			patternText.groupDuration=0.3;
			patternText.partialGroup='lines';
			patternText.partialPercent=100;
			patternText.partialBlurAmount=100;
			patternText.partialStart=0;
			patternText.tweenDuration=0.8;
			patternText.tweenType='Strong';
			patternText.easeType='easeOut';

			
			titleEffect.showTransition = patternText
			titlelinkEffect.showTransition = patternText

					
			// Create arrows:
			if (_assetsList.length() > 0)
			{				
				var _arrowRight:Arrow = new Arrow(0, 8, 8, 50);
				_arrowRight.x = 735;
				_arrowRight.y = 190;
				_arrowRight.alpha = 0;
				_arrowRight.addEventListener(MouseEvent.CLICK, my_slideshow.clickToNextSlide)
				_myPortfolio.addChild(_arrowRight);
				TweenMax.fromTo(_arrowRight, 0.4, {alpha:0, x:700}, {alpha:0.5, x:735, delay:1.5} );
				
				var _arrowLeft:Arrow = new Arrow(0, 8, 8, 50);
				_arrowLeft.scaleX = -1
				_arrowLeft.x = 50;
				_arrowLeft.y = 198;
				_arrowLeft.alpha = 0;
				_arrowLeft.addEventListener(MouseEvent.CLICK, my_slideshow.clickToPreviousSlide)
				_myPortfolio.addChild(_arrowLeft);	
				TweenMax.fromTo(_arrowLeft, 0.4, {alpha:0, x:70}, {alpha:0.5, x:50, delay:1.5} );
			}
			
		}
	
		public static function xmlListToArray($x:XMLList):Array {               
			var a:Array=[], i:String;
			for (i in $x) a[i] = $x[i];
			return a;
		}	
		
		private function closeButtonClick_handler(e:Event):void 
		{
			
			//this.dispatchEvent(new Event("portfolio_2_closed", true));
			
			parent.removeChild(this);
			// Kill all sounds.
			SoundMixer.stopAll();
			

		}
		
	}

}