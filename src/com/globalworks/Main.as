package com.globalworks
{
	import FlashEff2Flex;
	import com.jumpeye.flashEff2.symbol.waves.FESWaves;
	import com.jumpeye.flashEff2.text.alpha.FETAlpha;	
	import com.jumpeye.flashEff2.text.blur.FETBlurryLight;
	import com.jumpeye.flashEff2.filter.blink.FEFBlink;
	import com.jumpeye.flashEff2.text.smartSlide.FETSmartSlide;
	import com.jumpeye.Events.FLASHEFFEvents;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.hydrotik.queueloader.QueueLoader;
	import com.hydrotik.queueloader.QueueLoaderEvent;	
	import flash.utils.Timer;
	import com.greensock.*;
	import org.casalib.layout.Distribution;

	public class Main extends MovieClip 
	{
		private var _teaser:Teaser;
		private var _teaserArray:Array;
		private var _portfolio_1:Portfolio_1;
		private var _portfolio_2:Portfolio_2;
		private var _counter:int = 0;
		private var _oLoader:QueueLoader;
		private var _xmlData:XML;
		private var _bodyText:TextHandle;		
		private var _linkLabelText:TextHandle;
		private var _linkLabelArrow:TextHandle;
		private var dist:Distribution;
		private var timer:Timer;
		
		private var _label:String;
		private var _color:uint;
		private var _thumbnail:String;
		private var _body:String;
		private var _link_label:String;
		private var _link_target:String;
		private var _portfolio_1_target:String;
		private var xmlLoader:URLLoader;
		private var _currentSet:String = "set1";
		
		public var fe:FlashEff2Flex;
		public var fe2:FlashEff2Flex;
		public var pattern10:FETSmartSlide;
		public var pattern00:FETAlpha;
		public var pattern0:FETSmartSlide;
		public var pattern1:FETAlpha;
		
		private var timeline:TimelineLite;
		private var timelineArray:Array;
		
		public var default_effect1:FlashEff2Flex; ///////////// Tak crap
		public var default_effect2:FlashEff2Flex; ///////////// Tak crap
		public var default_effect3:FlashEff2Flex; ///////////// Tak crap
		public var _default_1:TextHandle; ///////////// Tak crap 
		public var _default_2:TextHandle; ///////////// Tak crap 
		public var _default_3:TextHandle; ///////////// Tak crap 
		public var crapDone:Boolean = false;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, showXML);
			xmlLoader.load(new URLRequest("xml/teaser_set1.xml"));
						
			// creates the bodyText
			_bodyText = new TextHandle(895, 500, 85, 0, 62, 0x808080, "left", true, "left", false, false, true, "helvetica", -15);		
			addChild(_bodyText);
			
			// create the _linkLabelArrow
			_linkLabelArrow = new TextHandle(855, 500, 85, 0, 55, 0x424242, "left", true, "left", false, false, true, "helvetica", 0);	
			addChild(_linkLabelArrow);
			_linkLabelArrow.y = 190;
			
			// creates the linkLabelText
			_linkLabelText = new TextHandle(875, 500, 120, 0, 43, 0x424242, "left", true, "left", false, false, true, "helvetica", 0);
			addChild(_linkLabelText);
			_linkLabelText.y = 200;	
			
			// create a timer:
// temporary for testing only// >>>>>>>>>>  timer = new Timer(5000, 0);
			timer = new Timer(8000, 0);
			timer.addEventListener(TimerEvent.TIMER, updateCounter);	
			
			_oLoader = new QueueLoader();
			_teaserArray = new Array();
			
			timelineArray = new Array();
			
			// distributes the buttons:
			dist = new Distribution(1024);		
			dist.setMargin(0, 5, 10, 0);
			dist.x = 85;
			dist.y = 275;
			dist.alpha = 0;
		}
			
		private function showXML(e:Event):void 
		{
			xmlLoader.removeEventListener(Event.COMPLETE, showXML);
			XML.ignoreWhitespace = true; 
			_xmlData = new XML(e.target.data);	
			
			timeline = new TimelineLite( { onComplete:tweenComplete } );
			
			createTeaser()
		}	
		
		private function createTeaser():void
		{
			for (var i:Number = 0; i < _xmlData.teaser.length(); i++) 
			{
				_label = _xmlData.teaser[i].label.text();
				_color = _xmlData.teaser[i].color.text();
				_thumbnail = _xmlData.teaser[i].thumbnail.text();		
				_body = _xmlData.teaser[i].body.text();
				_link_label = _xmlData.teaser[i].link_label.text();
				_link_target = _xmlData.teaser[i].link_target.text();
				_portfolio_1_target = _xmlData.teaser[i].portfolio_target.text();
				
				// creates the teaser:
				_teaser = new Teaser(_label, _color, _body, _link_label, _link_target, _portfolio_1_target);
				// set the teaser index:				
				_teaser.index = i;
				
				// load the image in _teaser:
				_oLoader.addItem(_thumbnail, _teaser);
			}
		
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_COMPLETE, onItemComplete, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueComplete,false, 0, true);
			_oLoader.execute();
		}
		
		private function onItemComplete(event:QueueLoaderEvent):void 
		{
			// adds the teaser to the dist:
			dist.addChild(event.container);
			// move the image down 3 px:
			event.content.y = 23;
			event.content.alpha = 0	
			// push finished teaser in the _teaserArray:
			_teaserArray.push(event.container);
			
			var itemTimeline:TimelineLite = new TimelineLite();			
			itemTimeline.insert(TweenMax.to(event.container._bgd, 0.1, { alpha:1, delay:0.2 } ) );
			itemTimeline.insert(TweenMax.to(event.container._bgd, 0.1, { alpha:0, delay:0.3 } ) );
			itemTimeline.insert(TweenMax.to(event.container._bgd, 0.1, { alpha:1, delay:0.4 } ) );
			
			itemTimeline.insert(new TweenLite(event.container._labelText, 0.1, { alpha:1, delay:0.2 } ) );			
			itemTimeline.insert(TweenMax.to(event.content, 0.2, { alpha:1, delay:1 } ) );
			
			timelineArray.push( itemTimeline );
		}
		
		private function onQueueComplete(event:QueueLoaderEvent):void 
		{		
			// show the default 
			//_bodyText.htmlText = _xmlData.default_teaser.body.text();
			_bodyText.htmlText = "";
			//_linkLabelText.htmlText = _xmlData.default_teaser.link_label.text();
			_linkLabelText.htmlText = "";
							
			// Set up flashEff effects:
			flashEffanimation();

			//timer.start();
			
			trace("timeline " + timeline.totalDuration + "  " + timeline.duration)
			
			// add the dist container:
			addChild(dist);
			// distributes the teasers: 
			dist.position();			
			dist.alpha = 1;

			timeline.appendMultiple(timelineArray, 0, "normal", 0.2 );
			trace("timelineArray " + timelineArray)
			
			// start teasers opening animation:
			timeline.restart();			
			
			trace("onQueueComplete")
			
			////////////////////////////////////////////// Tak crap starts here ///////////////////////////////////////////////
			
			
			if (!crapDone)
			{
				// creates the 2 default texts
				_default_1 = new TextHandle(875, 500, 85, 0, 70, 0x808080, "left", true, "left", false, false, true, "helvetica", -15);	
				_default_1.htmlText = "We are experts in the <font color='#fd6600'>cultures </font>of a changing world…";
				addChild(_default_1);	
				
				_default_2 = new TextHandle(875, 500, 85, 0, 70, 0x808080, "left", true, "left", false, false, true, "helvetica", -15);	
				//_default_2.htmlText = "redefining how <font color='#fd6600'>brands</font> and <font color='#fd6600'>consumers</font> interact.<br><font color='#333333' size='50'>Welcome to GlobalWorks</font>";
				_default_2.htmlText = "redefining how <font color='#fd6600'>brands</font> and <font color='#fd6600'>consumers</font> interact.";
				addChild(_default_2);
					
				_default_3 = new TextHandle(875, 500, 85, 180, 50, 0x333333, "left", true, "left", false, false, true, "helvetica", -15);	
				_default_3.htmlText = "Welcome to GlobalWorks";
				addChild(_default_3);
				
				// default_ShowEffect flashEFF:
				default_effect1 = new FlashEff2Flex();
				this.addChild(default_effect1);	
				default_effect1.target = _default_1;
				default_effect1.targetVisibility = false
				
				default_effect2 = new FlashEff2Flex();
				this.addChild(default_effect2);	
				default_effect2.target = _default_2;
				default_effect2.showAutoPlay = true;
				default_effect2.showDelay = 5;
				default_effect2.targetVisibility = false;
				
				default_effect3 = new FlashEff2Flex();
				this.addChild(default_effect3);	
				default_effect3.target = _default_3;
				default_effect3.showAutoPlay = true;
				default_effect3.showDelay = 7;
				default_effect3.targetVisibility = false;				
				
				pattern10 = new FETSmartSlide();
				pattern10.preset=19;
				pattern10.positionX=0;
				pattern10.positionY=20;
				pattern10.maxScale=1;
				pattern10.alphaPercentage=51;
				pattern10.groupDuration=0.8;
				pattern10.partialGroup='lines';
				pattern10.partialPercent=100;
				pattern10.partialBlurAmount=4;
				pattern10.partialStart=50;
				pattern10.tweenDuration=1.7;
				pattern10.tweenType='Exponential';
				pattern10.easeType='easeOut';
				
				pattern00 = new FETAlpha();
				pattern00.tweenDuration = 0.2;
				
				default_effect1.showTransition = pattern10;
				default_effect1.hideTransition = pattern00;
				default_effect1.hideDelay = 2.5;
				
				default_effect2.showTransition = pattern10;
				default_effect2.hideTransition = pattern00;
				default_effect2.hideDelay = 2.5;
				
				default_effect3.showTransition = pattern10;
				default_effect3.hideTransition = pattern00;
				default_effect3.hideDelay = 1.5;				
				
						
				default_effect3.addEventListener(FLASHEFFEvents.TRANSITION_END, completeHandler);
				
				function completeHandler(evtObj:FLASHEFFEvents):void 
				{
					if (evtObj.currentTransitionType == "hide")	
					{
						trace ("crap Done")
						crapDone = true;
						timer.start();
						updateCounter();
						initTeasers();
						
						default_effect1.removeAll()
						default_effect2.removeAll()
						default_effect3.removeAll()
						removeChild(default_effect1)
						removeChild(default_effect2)	
						removeChild(default_effect3)	
					}	
				}
			}
			////////////////////////////////////////////// Tak crap ends here ///////////////////////////////////////////////			
			
			else 
			{
						trace("here")
						timer.start();
						updateCounter();
						initTeasers();
			}	

		}
		
		private function initTeasers():void
		{
			for (var i:int = 0; i < _teaserArray.length; i++)
			{
				// listen to mousse over teaser:
				_teaserArray[i].addEventListener(MouseEvent.ROLL_OVER, teaserOver_handler);
				// listen to mousse out teaser:
				_teaserArray[i].addEventListener(MouseEvent.ROLL_OUT, teaserOut_handler);
				
				// listen to mousse click teaser to create the first portfolio:
				_teaserArray[i].addEventListener(MouseEvent.CLICK, create_portfolio_1);
				_teaserArray[i].useHandCursor = true;
				_teaserArray[i].buttonMode = true;	
			}	
		}
		
		private function flashEffanimation():void
		{
			// body flashEFF:
			fe = new FlashEff2Flex();
			this.addChild(fe);
			fe.showAutoPlay = true;
			fe.targetVisibility = false
			fe.showDelay = 1;	
			fe.target = _bodyText;

			pattern0 = new FETSmartSlide();
			pattern0.preset=19;
			pattern0.positionX=0;
			pattern0.positionY=20;
			pattern0.maxScale=1;
			pattern0.alphaPercentage=51;
			pattern0.groupDuration=0.8;
			pattern0.partialGroup='lines';
			pattern0.partialPercent=100;
			pattern0.partialBlurAmount=4;
			pattern0.partialStart=50;
			pattern0.tweenDuration=1.7;
			pattern0.tweenType='Exponential';
			pattern0.easeType='easeOut';

			fe.showTransition = pattern0;
			
			// link label flashEFF
			fe2 = new FlashEff2Flex();
			this.addChild(fe2);
			fe2.showAutoPlay = true;
			fe2.targetVisibility = false
			fe2.showDelay = 1;			
			fe2.target = _linkLabelText;
			
			pattern1 = new FETAlpha();
			pattern1.preset=1;
			pattern1.groupDuration=0.05;
			pattern1.partialGroup='letters';
			pattern1.partialPercent=100;
			pattern1.partialBlurAmount=0;
			pattern1.partialStart=0;
			pattern1.tweenDuration=0.9;
			pattern1.tweenType='Quadratic';
			pattern1.easeType='easeInOut';
			fe2.showTransition = pattern1;				
			fe2.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			fe2.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);	
			
			//timer.start();
		}
		
		private function rollOverHandler(evtObj:MouseEvent): void 
		{
			TweenMax.to(evtObj.target, .1, { tint:0xcc0000 } );  trace ("rrrrrrrrrrrrrrrrrrrrrrrrrrr")
		}

		private function rollOutHandler(evtObj:MouseEvent): void 
		{
			TweenMax.to(evtObj.target, .1, { tint:0x424242 } ); 
		}
				
		private function updateCounter(evt:TimerEvent = null):void 
		{	
			if (_counter < _xmlData.teaser.length()) 
			{
				showCurrentTeaser();   trace("_counter " + _counter)
				_counter ++;
			} 
			else if (_counter == _xmlData.teaser.length()) 
			{
				// reset the counter:
				_counter = 0;
				// stop the timer:
				timer.stop();
				
				resetTeasers();
			}
		}
		
		private function resetTeasers():void
		{	
			timelineArray = [];
			timeline.clear();
			timeline = null;
			
			trace ("resetTeasers")
			dist.alpha = 0;
			while (dist.numChildren > 0) 
			{
				_teaserArray[dist.numChildren - 1]._labelText.alpha = 0;
				_teaserArray[dist.numChildren - 1]._bgd.alpha = 0;
				
				dist.removeChildAt(0);
				trace("dist.numChildren " + dist.numChildren)
				//trace("_teaserArray " + _teaserArray[dist.numChildren])
			}

			dist.alpha = 0;
			
			_oLoader.dispose();
			
			// remove the effect on the body text:
			fe.showDelay = 0;			
			fe.removeEffect();	
			// set back the showDelay to zero on the link label. If not the transition never starts and we can't remove the effect:	
			fe2.showDelay = 0;
			fe2.removeEffect();			
			
			_bodyText.htmlText = "";
			_linkLabelArrow.htmlText = "";
			_linkLabelText.htmlText = "";

			_teaserArray = [];
			
			// load the next set of teasers:
			loadNextSet();	
		}
		
		private function loadNextSet():void 
		{						
			xmlLoader.addEventListener(Event.COMPLETE, showXML);

			// load the next set:
			if (_currentSet == "set1")
			{
				xmlLoader.load(new URLRequest("xml/teaser_set2.xml"));
				_currentSet = "set2";
				trace("set2")
			}
			else 
			{
				xmlLoader.load(new URLRequest("xml/teaser_set1.xml"));	
				_currentSet = "set1";
				trace("set1")
			}

		}
		
		private function tweenComplete():void
		{
			trace ("tweenComplete")
		}
		
		private function showCurrentTeaser():void
		{
			var k:Number = 0;
			while ( k < _xmlData.teaser.length()) 
			{
				// move all bgds down:
				TweenMax.to(_teaserArray[k]._bgd, 0.3, { y:0 } );
				
				// change the label color to black:
				TweenMax.to(_teaserArray[k]._labelText, .1, { tint:0x000000 } );
				k++;
			}
						
			_linkLabelArrow.htmlText = "";
			
			// remove the effect on the body text:
			fe.showDelay = 0;
			fe.removeEffect();
			
			// set back the showDelay to zero on the link label. If not the transition never starts and we can't remove the effect:	
			fe2.showDelay = 0;
			fe2.removeEffect();	
			
			// show the new current body text
			_bodyText.htmlText = _xmlData.teaser[_counter].body.text();
			fe.showAutoPlay = true;
			fe.targetVisibility = false
			fe.showDelay = .5;
			fe.addEventListener(FLASHEFFEvents.TRANSITION_END, feEnding);
			
			_linkLabelArrow.alpha = 0;	
			var _currentColor:Number = _xmlData.teaser[_counter].color;
			
			function feEnding():void 
			{
				_linkLabelArrow.htmlText = ">";
				fe.removeEventListener(FLASHEFFEvents.TRANSITION_END, feEnding);
				// Makes the arrow blink:			
				TweenMax.fromTo(_linkLabelArrow, 0.08, { tint:0x424242 }, { tint:_currentColor, alpha:1, repeat:11,  yoyo:true, onComplete:onFinishTween } );
			}			
			
			function onFinishTween():void 
			{
				_linkLabelArrow.alpha = 1;
			}			
			
			// show the new current link label text:
			_linkLabelText.htmlText = _xmlData.teaser[_counter].link_label.text();  
			// set the showDelay to delay the effect on the link text:
			fe2.showAutoPlay = true;
			fe2.targetVisibility = false
			fe2.showDelay = 2.5;
			
			// Makes the current teaser bgd blink:
			TweenMax.fromTo(_teaserArray[_counter]._bgd, 0.08, {tint:0xffffff, y:-25}, {tint:_teaserArray[_counter].color, y:-25, repeat:4,  yoyo:true } );

			// change the current label color to white:
			TweenMax.to(_teaserArray[_counter]._labelText, .1, { tint:0xffffff } );
		
		}

		private function teaserOver_handler(e:MouseEvent):void 
		{
			timer.stop();
			_counter = e.target.index;				
			showCurrentTeaser();
			TweenMax.to(e.target._labelText, .1, { tint:0xffffff } );
			e.target._bgd.y = -25;
		}
		
		private function teaserOut_handler(e:MouseEvent):void 
		{
			_counter ++;
			timer.start();
		}
		
		private function restart_timer(e:Event):void 
		{
			timer.addEventListener(TimerEvent.TIMER, updateCounter);
			timer.start();
			//remove the portfolio from the display list:
			removeChild(_portfolio_1);
			_portfolio_1 = null;
		}		
		
		private function create_portfolio_1(e:Event):void 
		{
			// stop the timer:
			timer.stop();
			// remove the event listener > cancel the mouse over:
			timer.removeEventListener(TimerEvent.TIMER, updateCounter);			
			
			// create the first portfolio:
			_portfolio_1 = new Portfolio_1(e.currentTarget.color, e.currentTarget.portfolio_target);
			addChild(_portfolio_1);
			//
			_portfolio_1.addEventListener("portfolio_1_closed", close_portfolio_1);
			//
			_portfolio_1.addEventListener("TYPE_NAME", create_portfolio_2)
		}
	
		private function close_portfolio_1(e:Event):void 
		{
			timer.addEventListener(TimerEvent.TIMER, updateCounter);
			timer.start();			
			//remove the portfolio from the display list:
			removeChild(_portfolio_1);
			_portfolio_1 = null;
		}
		
		private function create_portfolio_2(e:EventType):void 
		{
			// create the second portfolio:
			_portfolio_2 = new Portfolio_2(0x000000, e.arg[0]);		
			addChild(_portfolio_2);
		}		
		
	}
}




