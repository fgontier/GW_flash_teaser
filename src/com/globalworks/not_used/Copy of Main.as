package com.globalworks
{
	import com.jumpeye.flashEff2.text.alpha.FETAlpha;	
	import com.jumpeye.flashEff2.text.blur.FETBlurryLight;
	import com.jumpeye.Events.FLASHEFFEvents;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.hydrotik.queueloader.QueueLoader;
	import com.hydrotik.queueloader.QueueLoaderEvent;	
	import flash.utils.Timer;
	import gs.TweenMax;
	import org.casalib.layout.Distribution;

	public class Main extends Sprite 
	{
		private var _teaser:Teaser;
		private var _teaserArray:Array = new Array();
		private var _portfolio:Portfolio_1;
		private var _counter:int = 0;
		private var _oLoader:QueueLoader = new QueueLoader();
		private var _xmlData:XML;
		private var _bodyText:TextHandle;		
		private var _linkLabelText:TextHandle;		
		private var dist:Distribution;
		private var timer:Timer;
		
		private var _label:String;
		private var _color:uint;
		private var _thumbnail:String;
		private var _body:String;
		private var _link_label:String;
		private var _link_target:String;
		private var _portfolio_target:String;
		
		private var fe:FlashEff2Flex;
		private var fe2:FlashEff2Flex;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, showXML);
			xmlLoader.load(new URLRequest("xml/gw.xml"));
		}
		
		private function showXML(e:Event):void 
		{
			XML.ignoreWhitespace = true; 
			_xmlData = new XML(e.target.data);
			
			// distributes the buttons:
			dist = new Distribution(1024);
			dist.setMargin(0, 5, 10, 0);
			dist.x = 85;
			dist.y = 275;
			addChild(dist);
							
			createTeaser()
		}	
		
		private function createTeaser():void
		{
			for (var i:Number = 0; i < _xmlData.teaser.length(); i++) 
			//for (var i:Number = 0; i < 8; i++) 
			{
				_label = _xmlData.teaser[i].label.text();
				_color = _xmlData.teaser[i].color.text();
				_thumbnail = _xmlData.teaser[i].thumbnail.text();
				_body = _xmlData.teaser[i].body.text();
				_link_label = _xmlData.teaser[i].link_label.text();
				_link_target = _xmlData.teaser[i].link_target.text();
				_portfolio_target = _xmlData.teaser[i].portfolio_target.text();
				
				_teaser = new Teaser(_label, _color, _body, _link_label, _link_target, _portfolio_target);
				
				//_teaser.addEventListener(MouseEvent.CLICK, mouseClick_handler);
				
				_teaser.index = i;
				
				// listen to mousse over teaser:
				_teaser.addEventListener("teaserOver", teaserOver_handler);
				// listen to mousse out teaser:
				_teaser.addEventListener("teaserOut", teaserOut_handler);
				// listen to mousse click teaser:
				_teaser.addEventListener("teaserClick", teaserClick_handler);
				
				_teaser.useHandCursor = true;
				_teaser.buttonMode = true;
			
				_oLoader.addItem(_thumbnail, _teaser);
			}
		
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_COMPLETE, onItemComplete, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueComplete,false, 0, true);

			_oLoader.execute();
			
		}
		
		private function onItemComplete(event:QueueLoaderEvent):void 
		{
			// adds the teasers to the dist
			dist.addChild(event.container);
			// move the image down 3 px:
			event.content.y = 23;
			// push finished teaser into the array:
			_teaserArray.push(event.container);
		}
		
		private function onQueueComplete(event:QueueLoaderEvent):void 
		{
			// distributes the teasers: 
			dist.position();
			
			// creates the bodyText
			_bodyText = new TextHandle(855, 500, 85, 0, 60, 0x808080, "left", true, "left", false, false, true, "helvetica", -15);		
			addChild(_bodyText);
			_bodyText.htmlText = _xmlData.defaul_teaser.body.text();
			
			// creates the linkLabelText
			_linkLabelText = new TextHandle(855, 500, 85, 0, 40, 0x424242, "left", true, "left", false, false, true, "helvetica", 0);		
			addChild(_linkLabelText);
			_linkLabelText.htmlText = _xmlData.defaul_teaser.link_label.text();
			_linkLabelText.y = _bodyText.y + _bodyText.height;
			
			animation();
		}
		
		private function animation():void
		{
			// body flashEFF:
			fe = new FlashEff2Flex();
			this.addChild(fe);
			fe.target = _bodyText;
			var pattern0:FETBlurryLight = new FETBlurryLight();
			pattern0.preset=19;
			pattern0.glowColor=0xFFFFFF;
			pattern0.maxGlow=10;
			pattern0.maxBlurX=2;
			pattern0.maxBlurY=30;
			pattern0.blurQuality=2;
			pattern0.alphaPercentage=50;
			pattern0.groupDuration=1.3;
			pattern0.partialGroup='letters';
			pattern0.partialPercent=100;
			pattern0.partialBlurAmount=0;
			pattern0.partialStart=50;
			pattern0.tweenDuration=1.6;
			pattern0.tweenType='Strong';
			pattern0.easeType='easeOut';
			fe.showTransition = pattern0;
			
			// link Label flashEFF
			fe2 = new FlashEff2Flex();
			this.addChild(fe2);
			fe2.target = _linkLabelText;
			var pattern1:FETAlpha = new FETAlpha();
			pattern1.preset=1;
			pattern1.groupDuration=0.1;
			pattern1.partialGroup='letters';
			pattern1.partialPercent=100;
			pattern1.partialBlurAmount=0;
			pattern1.partialStart=50;
			pattern1.tweenDuration=0.7;
			pattern1.tweenType='Quadratic';
			pattern1.easeType='easeInOut';
			fe2.showTransition = pattern1;

			// start a timer:
			timer = new Timer(3000, 0);
			timer.addEventListener(TimerEvent.TIMER, updateCounter);
			timer.start();			
			
		}
		
		private function updateCounter(evt:TimerEvent):void 
		{	
			if (_counter < _xmlData.teaser.length()-1) 
			{
				_counter ++;
			} else 
			{
				_counter = 0;
			}
			
			showCurrentTeaser();
		}	
		
		private function showCurrentTeaser():void
		{
			var k:Number = 0;
			while ( k < _xmlData.teaser.length()) 
			{
				// move all bgds down:
				_teaserArray[k]._bgd.y = 0;
				// change the label to black:
				TweenMax.to(_teaserArray[k]._labelText, .1, { tint:0x000000 } );				
				k++;
			}
			
			// show the body text
			_bodyText.htmlText = _xmlData.teaser[_counter].body.text();
			fe.show();			
			
			// show the link label text:
			_linkLabelText.htmlText = _xmlData.teaser[_counter].link_label.text(); 
			fe2.show();
			
			// move the current teaser bgd up:
			_teaserArray[_counter]._bgd.y = -25;
			
			// change the label to white:
			TweenMax.to(_teaserArray[_counter]._labelText, .1, { tint:0xffffff } );
		}
		
		private function teaserOver_handler(e:Event):void 
		{
			timer.stop();
			_counter = e.target.index;
			showCurrentTeaser();
		}
		
		private function teaserOut_handler(e:Event):void 
		{
			timer.start();
		}
		
		private function teaserClick_handler(e:Event):void 
		{
			timer.stop();		trace("e " + e.currentTarget)
			_portfolio = new Portfolio_1(e.currentTarget.color, e.currentTarget.portfolio_target);
			addChild(_portfolio);
		}
	}
}




