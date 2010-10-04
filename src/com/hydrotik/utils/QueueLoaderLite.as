/*
 * Copyright 2007-2008 (c) Donovan Adams, http://blog.hydrotik.com/
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


package com.hydrotik.utils {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	
	import com.hydrotik.utils.QueueLoaderLiteEvent;	

	[Event(name="ITEM_START", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="ITEM_PROGRESS", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="ITEM_INIT", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="ITEM_ERROR", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="QUEUE_START", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="QUEUE_PROGRESS", type="com.hydrotik.utils.QueueLoaderLiteEvent")]

	[Event(name="QUEUE_INIT", type="com.hydrotik.utils.QueueLoaderLiteEvent")]
	
	public class QueueLoaderLite implements IEventDispatcher {
		
		public static const VERSION : String = "QueueLoaderLite 3.0.12";

		public static const AUTHOR : String = "Donovan Adams - donovan[(at)]hydrotik.com based on as2 version by Felix Raab - f.raab[(at)]betriebsraum.de";

		public static var VERBOSE : Boolean = false;

		public static var VERBOSE_BANDWITH:Boolean = false;

		public static const FILE_IMAGE : int = 1;

		public static const FILE_SWF : int = 2;

		private var _loader : *;

		private var queuedItems : Array;

		private var currItem : Object;

		private var itemsToInit : Array;

		private var loadedItems : Array;

		private var isStarted : Boolean;

		private var isStopped : Boolean;

		private var isLoading : Boolean;

		private var dispatcher : EventDispatcher;

		private var _count : int = 0;

		private var _max : int = 0;

		private var _queuepercentage : Number;

		private var _ignoreErrors : Boolean;

		private var  _currType : int;

		private var _currFile : *;

		private var _loaderContext : LoaderContext;

		private var _w : int;

		private var _h : int;

		private var debug : Function;
		
		private var _cacheKiller : Boolean;
		
		private var loaders : Array;

		/**
		 * QueueLoader AS 3
		 *
		 * @author: Donovan Adams, E-Mail: donovan[(at)]hydrotik.com, url: http://www.hydrotik.com/<br>
		 * @author: Project home: <a href="http://code.google.com/p/queueloader-as3/" target="blank">QueueLoaderLite on Google Code</a><br><br>
		 * @author: Based on Felix Raab's QueueLoader for AS2, E-Mail: f.raab[(at)]betriebsraum.de, url: http://www.betriebsraum.de<br><br>
		 * @author	Project contributors: Justin Winter - justinlevi[(at)]gmail.com, Carlos Ulloa, Jesse Graupmann | www.justgooddesign.com | www.jessegraupmann.com
		 * @version: 3.0.12
		 *
		 * @description QueueLoaderLite is an open source linear asset loading tool with progress monitoring. It's largely used to load a sequence of images or a set of external assets in one step. Please contact me if you make updates or enhancements to this file. If you use QueueLoaderLite, I'd love to hear about it. Special thanks to Felix Raab for the original AS2 version! Please contact me if you find any errors or bugs in the class or documentation or if you would like to contribute.
		 *
		 * @history <a href="http://code.google.com/p/queueloader-as3/wiki/ChangeLog" target="blank">Up-To-Date Change Log Information here</a>
		 *
		 * @example Go to <a href="http://code.google.com/p/queueloader-as3/wiki/QueueLoaderGuide" target="blank">QueueLoader Guide on Google Code</a> for more usage info. This example shows how to use QueueLoader in a basic application:
		<code>
		import com.hydrotik.utils.QueueLoaderLite;
		import com.hydrotik.utils.QueueLoaderLiteEvent;
							
							
		//Instantiate the QueueLoader
		var _oLoader:QueueLoaderLite = new QueueLoaderLite();
							
		//Run a loop that loads 3 images from the flashassets/images/slideshow folder
		var image:Sprite = new Sprite();
		addChild(image);
		//Add a load item to the loader
		_oLoader.addItem(prefix("") + "flashassets/images/slideshow/1.jpg", image, {title:"Image"});
							
		//Add event listeners to the loader
		_oLoader.addEventListener(QueueLoaderLiteEvent.QUEUE_START, onQueueStart, false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.ITEM_START, onItemStart, false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.ITEM_PROGRESS, onItemProgress, false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.ITEM_COMPLETE, onItemComplete,false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.ITEM_ERROR, onItemError,false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.QUEUE_PROGRESS, onQueueProgress, false, 0, true);
		_oLoader.addEventListener(QueueLoaderLiteEvent.QUEUE_COMPLETE, onQueueComplete,false, 0, true);
							
		//Run the loader
		_oLoader.execute();
							
		//Listener functions
		function onQueueStart(event:QueueLoaderLiteEvent):void {
			trace(">> "+event.type);
		}
							
		function onItemStart(event:QueueLoaderLiteEvent):void {
			trace("\t>> "+event.type, "item title: "+event.title);
		}
							
		function onItemProgress(event:QueueLoaderLiteEvent):void {
			trace("\t>> "+event.type+": "+[" percentage: "+event.percentage]);
		}
							
		function onQueueProgress(event:QueueLoaderLiteEvent):void {
			trace("\t>> "+event.type+": "+[" queuepercentage: "+event.queuepercentage]);
		}
							
		function onItemComplete(event:QueueLoaderLiteEvent):void {
			trace("\t>> name: "+event.type + " event:" + event.type+" - "+["target: "+event.targ, "w: "+event.width, "h: "+event.height]+"\n");
		}
							
		function onItemError(event:QueueLoaderLiteEvent):void {
			trace("\n>>"+event.type+"\n");
		}
							
		function onQueueComplete(event:QueueLoaderLiteEvent):void {
			trace("** "+event.type);
		}
		</code>
		 */  
		/**
		 * @param	ignoreErrors:Boolean false for stopping the queue on an error, true for ignoring errors.
		 * @param	loaderContext:Allows access of a loaded SWF's class references
		 * @param	setMIMEType:Allows manual setting of mime types for queue items		 
		 * @return	void
		 * @description Contructor for QueueLoaderLite
		 */
		public function QueueLoaderLite(ignoreErrors : Boolean = false, loaderContext : LoaderContext = null, cacheKiller:Boolean = false) {
			dispatcher = new EventDispatcher(this);
			debug = trace;
			debug("\n\n========== new QueueLoader() version:"+VERSION + " - publish: "+(new Date()).toString()+"==========\n\n");
			
			
			reset();
			_loaderContext = loaderContext;
			_loader = new Loader();
			loadedItems = new Array();
			loaders = new Array();
			_ignoreErrors = ignoreErrors;
			_cacheKiller = cacheKiller;
		}

		/**
		 * @param	url:String - asset file path
		 * @param	targ:* - target location
		 * @param	info:Object - data
		 * @return	void
		 * @description Adds an item to the loading queue
		 */
		public function addItem(url : String, targ : *, info : Object) : void {
			if(VERBOSE) debug(">> addItem() args:" + [url, targ, info]);
			addItemAt(queuedItems.length, url, targ, info);
		}

		/**
		 * @param	index:Number - insertion index
		 * @param	url:String - asset file path
		 * @param	targ:* - target location
		 * @param	info:Object - data to be stored and retrieved later
		 * @return	void
		 * @description Adds an item to the loading queue at a specific position
		 */
		public function addItemAt(index : Number, url : String, targ : *, info : Object) : void {
			if(VERBOSE) debug(">> addItemAt() args:" + [index, url, targ, info]);
			queuedItems.splice(index, 0, {url:url, targ:targ, info:info});
			itemsToInit.splice(index, 0, {url:url, targ:targ, info:info});
			if(isLoading && !isStarted && !isStopped) _max++;
		}

		/**
		 * @param	index:Number - removal index
		 * @return	void
		 * @description Removes an item to the loading queue at a specific position
		 */
		public function removeItemAt(index : Number) : void {
			if(VERBOSE) debug(">> removeItem() args:" + [index]);
			queuedItems.splice(index, 1);
			itemsToInit.splice(index, 1);
			if(isLoading && isStarted && isStopped) _max--;
		}

		/**
		 * @param	index:Number - removal index
		 * @return	void
		 * @description allows input of a sort function for sorting the array see Array.sort();
		 */
		public function sort(... args) : void {
			if(VERBOSE) debug(">> sort() args:" + [args]);
			queuedItems.sort(args);
			itemsToInit.sort(args);
		}
		
		
		//	Justin -------------------------------------------------------
		/**
		 * @param index:Number - reorder index
		 * @return void
		 * @description IN TESTING - reorders the queue based based on a specific position
		 * 
		 *
		public function reorder(index : Number) : void {
			if(VERBOSE) debug(">> reorder() args:" + [index]);
			var _closed : Boolean = false;
			// stop any loading that's currently going on
			if(this.isLoading == true && _loader !== null)
			if(_loader.contentLoaderInfo.bytesLoaded < _loader.contentLoaderInfo.bytesTotal) {
				_loader.close();
				_closed = true;
			}
		
			// make sure the index is within range and greater than already loaded items
			if(index > 0 && index < itemsToInit.length && index >= _count) {
		
				//stop loop from continuing
				isStopped = true; 
		
				//rearrange array 
				var tmpArray : Array = itemsToInit.slice(index).concat(itemsToInit.slice(_count, index));
		
				//stopped current loading so we need to add it back to the end
				if(_closed == true) tmpArray.push(itemsToInit[_count]);
		
				queuedItems = tmpArray;
				itemsToInit = tmpArray; 
		
				execute();
			}
		}*/
		//	______________________________________________________________

		/**
		 * @description Executes the loading sequence
		 * @return	void
		 */
		public function execute() : void {
			if(VERBOSE) debug(">> execute()");
			if (queuedItems.length == 0) return;
			isStarted = true;
			isLoading = true;
			isStopped = false;
			_max = queuedItems.length;
			loadNextItem();	
		}

		/**
		 * @description Stops Loading
		 * @return	void
		 */
		public function stop() : void {
			if(VERBOSE) debug(">> stop()");
			isStarted = true;
			isLoading = false;
			isStopped = true;	
			reset();
		}

		/**
		 * @description Removes Items Loaded from memory for Garbage Collection
		 * @return	void
		 */
		public function dispose() : void {
			if(VERBOSE) debug(">> dispose()");
			isStarted = true;
			isLoading = false;
			isStopped = true;
			deConfigureListeners(_loader.contentLoaderInfo);
			_loader.unload();
			var i : int;
			for(i = 0;i < loaders.length;i++) {
				if(VERBOSE) debug("\t>> dispose() "+loaders[i]);
				loaders[i].unload();
				//deConfigureListeners(loaders[i]);
				loaders[i] = null;
			}
			_loader = null;
			
			if(VERBOSE) debug(">> dispose()");
			//_bwTimer = null;
			
			reset();
		};
		
		// --== Implemented interface methods ==--
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}





		// ____  ____  _____     ___  _____ _____ 
		//|  _ \|  _ \|_ _\ \   / / \|_   _| ____|
		//| |_) | |_) || | \ \ / / _ \ | | |  _|  
		//|  __/|  _ < | |  \ V / ___ \| | | |___ 
		//|_|   |_| \_\___|  \_/_/   \_\_| |_____|
                                        		
		// --== Listeners and Handlers ==--
		private function configureListeners(dispatcher : IEventDispatcher) : void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		private function deConfigureListeners(dispatcher : IEventDispatcher) : void {
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
		}

		private function ioErrorHandler(event : IOErrorEvent) : void {
			if(event.text != "") {
				dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "io error: " + event.text + " could not be loaded into " + currItem.targ.name, _count, queuedItems.length, _max, currItem.info.dataObj));
				if(_ignoreErrors) {
					loadedItems.push(currItem.targ);	
					_count++;
					isQueueComplete();
				}
			}
		}

		private function openHandler(event : Event) : void {
			if (isStarted) {
				dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.QUEUE_START, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, 0, 0, 0, "", _count, queuedItems.length, _max, currItem.info.dataObj));
				isStarted = false;		
			}
			
			dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_START, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, currItem.info.dataObj));
				
		}

		private function progressHandler(event : ProgressEvent) : void { 
			if (isLoading) {
				var delPerc:Number = Math.max(Math.min((((_count * (100 / (_max))) + ((event.bytesLoaded / event.bytesTotal) * (100 / (_max)))) * .01), 1), 0);
				_queuepercentage = (!isNaN(delPerc) || delPerc != Infinity) ? delPerc : _queuepercentage;
				dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_PROGRESS, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, Math.abs(event.bytesLoaded), Math.abs(event.bytesTotal), Math.max(Math.min(Math.abs(event.bytesLoaded / event.bytesTotal), 1), 0), _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, currItem.info.dataObj));
				dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.QUEUE_PROGRESS, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, Math.abs(event.bytesLoaded), Math.abs(event.bytesTotal), Math.max(Math.min(Math.abs(event.bytesLoaded / event.bytesTotal), 1), 0), _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, currItem.info.dataObj));
			}
		}
		
		
		
		private function completeHandler(event : Event = null) : void {
			//if(isLoading && !isStopped) {
					loadedItems.push(event.target.loader.content);
					_currFile = event.target.loader.content;
					if (_currType == FILE_IMAGE ) if ( currItem.info != null ) if ( currItem.info.smoothing != null ) if (_currFile[ "smoothing" ] != null ) {
						_currFile[ "smoothing" ] = currItem.info.smoothing == true;
					}
					_w = event.target.width;
					_h = event.target.height;
				dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_COMPLETE, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 100, _queuepercentage, _w, _h, "", _count, queuedItems.length, _max, currItem.info.dataObj));
				_count++;
				isQueueComplete();
			//}
		}

		//--== checks for completion ==--
		private function isQueueComplete() : void {
			//if (!isStopped) {		
				if (queuedItems.length == 0) {
					dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.QUEUE_COMPLETE, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, currItem.info.dataObj));
					isLoading = false;
							//reset()
				} else {
					loadNextItem();
				}			
			//}
		}

		private function loadNextItem() : void {		
			currItem = queuedItems.shift();		
			//if (!isStopped) {				
				_currType = 0;
				
				if (currItem.url.match(".jpg") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".JPG") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".gif") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".GIF") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".png") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".PNG") != null) _currType = FILE_IMAGE;
				if (currItem.url.match(".swf") != null) _currType = FILE_SWF;
				if (currItem.url.match(".SWF") != null) _currType = FILE_SWF;
				
				
				var request : URLRequest = new URLRequest(currItem.url + ((!_cacheKiller) ? "" : cacheKiller()));
				if(VERBOSE) debug(">> loadNextItem() loading: " + _currType);
				switch (_currType) {
					case FILE_IMAGE:
						if (currItem.targ == undefined) {	
							dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "QueueLoader error: " + currItem.info.title + " could not be loaded into " + currItem.targ.name + "/" + currItem.targ.name, _count, queuedItems.length, _max, currItem.info.dataObj));
						} else {
							_loader = new Loader();
							configureListeners(_loader.contentLoaderInfo);
							_loader.load(request, _loaderContext);
							currItem.targ.addChild(_loader);
							loaders.push(_loader);
						}
						break;
					case FILE_SWF:
						if (currItem.targ == undefined) {	
							dispatchEvent(new QueueLoaderLiteEvent(QueueLoaderLiteEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "QueueLoader error: " + currItem.info.title + " could not be loaded into " + currItem.targ.name + "/" + currItem.targ.name, _count, queuedItems.length, _max, currItem.info.dataObj));
						} else {
							_loader = new Loader();
							configureListeners(_loader.contentLoaderInfo);
							_loader.load(request, _loaderContext);
							currItem.targ.addChild(_loader);
							loaders.push(_loader);
						}
						break;
					default:
						if(VERBOSE) debug(">> loadNextItem() NO TYPE DETECTED!");
				}
				
				//request = null;
			//}	
		}
		
		
        

		// --== resets data ==--
		private function reset() : void {
			if(VERBOSE) debug(">> reset()");
			//	______________________________________________________________
			
			_count = 0;
			//loadedItems = null;
			_queuepercentage = 0;
			queuedItems = new Array();
			itemsToInit = new Array();
			loadedItems = new Array();
			loaders = new Array();
			currItem = null;
			_currFile = null;	
			_max = 0;
			_queuepercentage = 0;
		}
		
		
		
		
		
		                                                  
		//  _   _ _____ ___ _     ____  
		// | | | |_   _|_ _| |   / ___| 
		// | | | | | |  | || |   \___ \ 
		// | |_| | | |  | || |___ ___) |
		//  \___/  |_| |___|_____|____/ 
               
		private function cacheKiller():String {
			if (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone") {
				return "";
			} else {
				return "?ck="+(new Date()).getTime().toString();
			}
		}
	}
}