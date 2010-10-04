package com.globalworks.not_used
{
	import com.jumpeye.Events.FLASHEFFEvents;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import FlashEff2Code;
	import com.jumpeye.flashEff2.text.alpha.FETAlpha;
	
	public class test2 extends MovieClip
	{
		[Embed(source = '../../Verdana.ttf', fontFamily = "Arial", mimeType = "application/x-font-truetype")]		
		public static const verdana:String;
		
		private var effect:FlashEff2Code
		
		public function test2() 
		{
			effect = new FlashEff2Code();
			addChild(effect);
			
			var pattern11:FETAlpha = new FETAlpha();
			pattern11.preset=1;
			pattern11.groupDuration=0.1;
			pattern11.partialGroup='letters';
			pattern11.partialPercent=100;
			pattern11.partialBlurAmount=0;
			pattern11.partialStart=50;
			pattern11.tweenDuration=0.7;
			pattern11.tweenType='Quadratic';
			pattern11.easeType = 'easeInOut';
			
			effect.showTransition = pattern11;		
						
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.align = "center";
			txtFormat.color = 0x0099FF;
			txtFormat.size = 40;

			var _linkLabelText2:TextField = new TextField();
			_linkLabelText2.type = "dynamic";
			_linkLabelText2.antiAliasType = "advanced";
			_linkLabelText2.multiline = true;
			_linkLabelText2.embedFonts = true;
			_linkLabelText2.wordWrap = true;
			_linkLabelText2.autoSize = "center";
			_linkLabelText2.width = 200
			addChild(_linkLabelText2);
			_linkLabelText2.defaultTextFormat = txtFormat;
			_linkLabelText2.htmlText = "The quick brown fox jumps over the lazy dog";	
		
			effect.target = _linkLabelText2;
			effect.targetVisibility = false;
			effect.showAutoPlay = true;
			effect.showDelay = 5;
			//effect.show();
			
			effect.addEventListener(FLASHEFFEvents.TRANSITION_START, onTransStart);

		}
		
		private function onTransStart(e:FLASHEFFEvents):void 
		{
			//effect.showDelay = 5;
			trace ("lala")
		}	
	}
}