﻿package com.dyc.photo {	import com.globalworks.SlideMarker;	import com.globalworks.TextHandle;	import fl.video.FLVPlayback;	import flash.display.MovieClip;	import flash.display.Loader;	import flash.events.MouseEvent;	import flash.media.SoundMixer;	import gs.TweenLite;		import flash.net.URLRequest;			import flash.events.Event;	import flash.events.ProgressEvent;	public class Slideshow_2 extends MovieClip {				public var current_container:MovieClip;				private var photo_list:Array;		private var portfolio_target:Array;		private var photo_label:Array;		private var photo_caption:Array;		private var slide_loader:Loader;				private var current_slide_index:int = 0;		private var total_slides:int;		private var fade_time:int =	1;		private var easing_style:String;				private var image1_container:MovieClip;		public var image2_container:MovieClip		private var _label:TextHandle;		private var _caption:TextHandle;						private var _assetsList:XMLList;				private var my_SlideMarker:SlideMarker;		private var flvPlayback:FLVPlayback;				public function Slideshow_2( assetsList:XMLList, _timerDelay:int = 5, _fadeTime:Number = 1, _easing:String = "easeOutExpo") 		{						_assetsList = assetsList;			photo_list = xmlListToArray(assetsList.visual.text());			portfolio_target = xmlListToArray(assetsList.portfolio_target.text());			photo_label = xmlListToArray(assetsList.label.text());			photo_caption = xmlListToArray(assetsList.caption.text());						fade_time = _fadeTime;			easing_style = _easing;						initSlideshow();		}		private function initSlideshow():void 		{			// Create slideMarker			my_SlideMarker = new SlideMarker(_assetsList.length());			my_SlideMarker.y = 410;			addChild(my_SlideMarker);						// Create Containers			image1_container = new MovieClip();			image2_container = new MovieClip();			addChild(image1_container);			addChild(image2_container);						current_container = image2_container; // reference to front container			total_slides = photo_list.length;						// Create label			_label = new TextHandle(500, 50, 0, 345, 20, 0xffffff, "left", false, "left", false, false, true, "helvetica", 0);			addChild(_label);						_caption = new TextHandle(500, 50, 0, 370, 12, 0xffffff, "left", true, "left", false, false, true, "helvetica", 0);			addChild(_caption);							changeSlide();		}				public function clickToNextSlide(e:MouseEvent):void 		{			if(current_slide_index + 1 < photo_list.length)				current_slide_index++;			else				current_slide_index = 0;				changeSlide();			my_SlideMarker.clickToNextSlide();		}				public function clickToPreviousSlide(e:MouseEvent):void 		{			if(current_slide_index == 0)				current_slide_index = photo_list.length -1;			else				current_slide_index--;							changeSlide();			my_SlideMarker.clickToPreviousSlide();		}							private function changeSlide(e:Event = null):void 		{			resetSlides();						// swap container depths			if (current_container == image2_container)			{				current_container = image1_container;				//image2_container.alpha = 0;				}			else			{				current_container = image2_container;				//image1_container.alpha = 0;			}			// Switch the photo			current_container.alpha = 0;			swapChildren(image2_container, image1_container);						TweenLite.to(image1_container, fade_time, { alpha:0 });							switch(_assetsList[current_slide_index].visual.@type.toString())			{				case "image":				loadImage();				break;								case "video":				loadVideo();				break;								case "flash":				loadFlash();				break;			}						// set the label for the slide:			_label.htmlText = photo_label[current_slide_index];						// set the caption for the slide:			_caption.htmlText = photo_caption[current_slide_index];		}				private function loadFlash():void		{			// create a new loader for the slide:			slide_loader = new Loader();			slide_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayFlash);			slide_loader.load(new URLRequest(photo_list[current_slide_index]));			}		private function displayFlash(e:Event):void 		{						current_container.addChild(slide_loader);  			current_container.alpha = 0;			current_container.x = (590 - current_container.width) / 2;			current_container.y = (332 - current_container.height) / 2;			TweenLite.to(current_container, fade_time, { alpha:1 } );					}								private function loadImage():void		{   			// create a new loader for the slide:			slide_loader = new Loader();			slide_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayImage);			slide_loader.load(new URLRequest(photo_list[current_slide_index]));						}		private function displayImage(e:Event):void 		{						current_container.addChild(slide_loader);			current_container.alpha = 0;			current_container.x = 0;			current_container.y = 0;						TweenLite.to(current_container, fade_time, { alpha:1 } );					}						private function loadVideo():void				{				flvPlayback = new FLVPlayback(); 			flvPlayback.scaleMode = "maintainAspectRatio";			flvPlayback.skin = "assets/SkinOverPlayStopSeekFullVol.swf" 			flvPlayback.autoPlay = true;			flvPlayback.width = 590;			flvPlayback.height = 332;			flvPlayback.skinAutoHide = true;			flvPlayback.skinBackgroundColor = 0x000000;			flvPlayback.skinFadeTime = .5;			flvPlayback.skinBackgroundAlpha = .2;			flvPlayback.source = photo_list[current_slide_index]				current_container.addChild(flvPlayback);			current_container.x = 0;			current_container.y = 0;							current_container.alpha = 0;			TweenLite.to(current_container, fade_time, { alpha:1} );									//flvPlayback.playPauseButton.visible = false			//flvPlayback.volumeBar.visible = false		}						public static function xmlListToArray($x:XMLList):Array {               			var a:Array=[], i:String;			for (i in $x) a[i] = $x[i];			return a;		}		public function resetSlides():void		{			// Kill all sounds.			SoundMixer.stopAll();			// Stop the video:			if (flvPlayback) 			{ 				// remove flvPlayback							current_container.removeChild(flvPlayback);				flvPlayback = null; 			};						if (slide_loader) 			{ 				//remove slide_loader				current_container.removeChild(slide_loader);				slide_loader = null			};				trace ("current_container " +current_container.numChildren)			}			}}						