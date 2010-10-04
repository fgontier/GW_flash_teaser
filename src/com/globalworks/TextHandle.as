package com.globalworks{

	import flash.text.*

	public class TextHandle extends TextField 
	{
		[Embed(source = '../HelveticaNeueLTStd-Bd.otf', fontFamily = "helvetica", fontWeight="bold", mimeType = "application/x-font-truetype")]
		public static const helvetica:String;
		
		[Embed(source = '../Verdana.ttf', fontFamily = "verdana", mimeType = "application/x-font-truetype")]		
		public static const verdana:String;
		
		private var _format:TextFormat;
		private var _myFont:Class;
		
		public function TextHandle(w:Number = 20, h:Number = 10, xt:Number = 0, yt:Number = 0, size:int = 13, colour:uint = 0x222222, align:String = "left", mult:Boolean = true, auto:String = "left", sel:Boolean = true, bord:Boolean = false, wWrap:Boolean = true, textFont:String = "helvetica", lineSpacing:Number = 0){
			
			x					= xt;
			y					= yt;
			width 				= w;
			height				= h;

			_format				= new TextFormat();
			_format.font		= textFont;
			_format.color		= colour;
			_format.size		= size;
			_format.align		= align;
			_format.leading		= lineSpacing;		

			defaultTextFormat	= _format;
			embedFonts			= true;
			autoSize			= auto;
			multiline			= mult;
			selectable			= sel;
			antiAliasType		= AntiAliasType.ADVANCED;
			condenseWhite 		= true	
			mouseEnabled		= true;
			border 				= bord;
			wordWrap			= wWrap;
		}
		
		public function get format():TextFormat { return _format; }
		  
	}
}