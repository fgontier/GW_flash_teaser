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
	import flash.events.TimerEvent;	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.display.BitmapData;	
	import flash.geom.Matrix;		
	import flash.utils.getTimer;	
	import flash.system.Capabilities;	
	import flash.utils.Timer;
	import com.hydrotik.utils.QueueLoaderEvent;	
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.events.NetStatusEvent;	
	
	[Event(name="ITEM_START", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="ITEM_PROGRESS", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="ITEM_COMPLETE", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="ITEM_ERROR", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="QUEUE_START", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="QUEUE_PROGRESS", type="com.hydrotik.utils.QueueLoaderEvent")]

	[Event(name="QUEUE_COMPLETE", type="com.hydrotik.utils.QueueLoaderEvent")]
	
	public class QueueLoader implements IEventDispatcher {
		
		public static const VERSION : String = "QueueLoader 3.0.31";

		public static const AUTHOR : String = "Donovan Adams - donovan[(at)]hydrotik.com based on as2 version by Felix Raab - f.raab[(at)]betriebsraum.de";

		public static var VERBOSE : Boolean = true;

		public static var VERBOSE_BANDWITH:Boolean = false;

		public static const FILE_IMAGE : int = 1;

		public static const FILE_SWF : int = 2;

		public static const FILE_AUDIO : int = 3;

		public static const FILE_CSS : int = 4;

		public static const FILE_XML : int = 5;
		
		public static const FILE_FLV : int = 6;
		
		public static const FILE_QUEUE : int = 7;

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

		private var _setMIMEType : Boolean;

		private var _w : int;

		private var _h : int;

		private var _bmFrames : int;

		private var _bmArray : Array;

		private var _currFrame : int = 1;

		private var debug : Function;

		private var _framerate : Number ;
		
		private var _bandwidth : Number = 0;
		
		private var _prevBytes : Number = 0;
		
		private var _prevSyncPoint : Number = 0;
		
		private var _totalBytes:Number = 0;
		
		private var _bwTimer : Timer;
		
		private var _currBytes : Number = 0;
		
		private var _latency : Number = 0;
		
		private var _bwCount : Number = 0;
		
		private var _pakSent : Array;
		
		private var _pakRecv : Array;
		
		private var _cumLatency : Number = 0;
		
		private var _sent : Number = 0;
		
		private var _prevNow : Number = 0;
		
		private var _nowStart : Number = 0;
		
		private var _bwChecking : Boolean;
		
		private var _nc:NetConnection;
        
        private var _ns:NetStream;
        
		/**
		 * QueueLoader AS 3
		 *
		 * @author: Donovan Adams, E-Mail: donovan[(at)]hydrotik.com, url: http://www.hydrotik.com/<br>
		 * @author: Project home: <a href="http://code.google.com/p/queueloader-as3/" target="blank">QueueLoader on Google Code</a><br><br>
		 * @author: Based on Felix Raab's QueueLoader for AS2, E-Mail: f.raab[(at)]betriebsraum.de, url: http://www.betriebsraum.de<br><br>
		 * @author	Project contributors: Justin Winter - justinlevi[(at)]gmail.com, Carlos Ulloa, Jesse Graupmann | www.justgooddesign.com | www.jessegraupmann.com
		 * @version: 3.0.31
		 *
		 * @description QueueLoader is an open source linear asset loading tool with progress monitoring. It's largely used to load a sequence of images or a set of external assets in one step. Please contact me if you make updates or enhancements to this file. If you use QueueLoader, I'd love to hear about it. Special thanks to Felix Raab for the original AS2 version! Please contact me if you find any errors or bugs in the class or documentation or if you would like to contribute.
		 *
		 * @todo: Bandwith decimal bug
		 * @todo: Add video events
		 *
		 * @history <a href="http://code.google.com/p/queueloader-as3/wiki/ChangeLog" target="blank">Up-To-Date Change Log Information here</a>
		 *
		 * @example Go to <a href="http://code.google.com/p/queueloader-as3/wiki/QueueLoaderGuide" target="blank">QueueLoader Guide on Google Code</a> for more usage info. This example shows how to use QueueLoader in a basic application:
		<code>
		import com.hydrotik.utils.QueueLoader;
		import com.hydrotik.utils.QueueLoaderEvent;
							
							
		//Instantiate the QueueLoader
		var _oLoader:QueueLoader = new QueueLoader();
							
		//Run a loop that loads 3 images from the flashassets/images/slideshow folder
		var image:Sprite = new Sprite();
		addChild(image);
		//Add a load item to the loader
		_oLoader.addItem(prefix("") + "flashassets/images/slideshow/1.jpg", image, {title:"Image"});
							
		//Add event listeners to the loader
		_oLoader.addEventListener(QueueLoaderEvent.QUEUE_START, onQueueStart, false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.ITEM_START, onItemStart, false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.ITEM_PROGRESS, onItemProgress, false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.ITEM_COMPLETE, onItemComplete,false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.ITEM_ERROR, onItemError,false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, onQueueProgress, false, 0, true);
		_oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueComplete,false, 0, true);
							
		//Run the loader
		_oLoader.execute();
							
		//Listener functions
		function onQueueStart(event:QueueLoaderEvent):void {
			trace(">> "+event.type);
		}
							
		function onItemStart(event:QueueLoaderEvent):void {
			trace("\t>> "+event.type, "item title: "+event.title);
		}
							
		function onItemProgress(event:QueueLoaderEvent):void {
			trace("\t>> "+event.type+": "+[" percentage: "+event.percentage]);
		}
							
		function onQueueProgress(event:QueueLoaderEvent):void {
			trace("\t>> "+event.type+": "+[" queuepercentage: "+event.queuepercentage]);
		}
							
		function onItemComplete(event:QueueLoaderEvent):void {
			trace("\t>> name: "+event.type + " event:" + event.type+" - "+["target: "+event.targ, "w: "+event.width, "h: "+event.height]+"\n");
		}
							
		function onItemError(event:QueueLoaderEvent):void {
			trace("\n>>"+event.type+"\n");
		}
							
		function onQueueComplete(event:QueueLoaderEvent):void {
			trace("** "+event.type);
		}
		</code>
		 */  
		/**
		 * @param	ignoreErrors:Boolean false for stopping the queue on an error, true for ignoring errors.
		 * @param	loaderContext:Allows access of a loaded SWF's class references
		 * @param	setMIMEType:Allows manual setting of mime types for queue items		 
		 * @return	void
		 * @description Contructor for QueueLoader
		 */
		public function QueueLoader(ignoreErrors : Boolean = false, loaderContext : LoaderContext = null, setMIMEType : Boolean = false, bandwidthMonitoring:Boolean = false) {
			dispatcher = new EventDispatcher(this);
			debug = trace;
			debug("============== new QueueLoader() version:"+VERSION + " - publish: "+(new Date()).toString());
			reset();
			_loaderContext = loaderContext;
			_loader = new Loader();
			loadedItems = new Array();
			_bmArray = new Array();
			_ignoreErrors = ignoreErrors;
			_setMIMEType = setMIMEType;
			_bwChecking = bandwidthMonitoring;
			if(_bwChecking ) _bwTimer = new Timer(1000);
			_pakSent = new Array();
			_pakRecv = new Array();
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
		 */
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
		}
		//	______________________________________________________________

		/**
		 * @description Executes the loading sequence
		 * @return	void
		 */
		public function execute() : void {
			if(VERBOSE) debug(">> execute()");
			isStarted = true;
			isLoading = true;
			isStopped = false;
			_max = queuedItems.length;
			_prevSyncPoint = getTimer();	
			if(_bwChecking ) _bwTimer.addEventListener(TimerEvent.TIMER, checkBandwidth);
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
			var i : int;
			for(i = 0;i < loadedItems.length;i++) {
				if(VERBOSE) debug("\t>> dispose() "+loadedItems[i]);
				loadedItems[i].loaderInfo.loader.unload();
				loadedItems[i] = null;
			}
			for (i = 0;i < _bmArray.length; i++) {
				_bmArray[i].dispose();
				_bmArray[i] = null;
			}
			_bmArray = null;
			_loader = null;
			if(_ns != null){
				_ns.close();
				_ns = null;
			}
			if(_nc != null){
				_nc.close();
				_nc = null;
			}
			if(VERBOSE) debug(">> dispose()");
			_bandwidth = _totalBytes = _max = _currFrame = _prevBytes = _currBytes = 0;
			if(_bwChecking ) _bwTimer.removeEventListener(TimerEvent.TIMER, checkBandwidth);
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
			dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		}

		private function ioErrorHandler(event : IOErrorEvent) : void {
			if(event.text != "") {
				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "io error: " + event.text + " could not be loaded into " + currItem.targ.name, _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
				if(_ignoreErrors) {
					loadedItems.push(currItem.targ);	
					_count++;
					isQueueComplete();
				}
			}
		}

		private function openHandler(event : Event) : void {
			if (isStarted) {
				_cumLatency = 1;
				_sent = 0;
				if(_bwChecking ) _nowStart = (new Date()).getTime()/1;
				if(_bwChecking ) _bwTimer.start();
				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_START, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, 0, 0, 0, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
				isStarted = false;		
			}
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_START, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
				
		}

		private function progressHandler(event : ProgressEvent) : void { 
			if (isLoading) {
				_queuepercentage = (((_count * (100 / (_max))) + ((event.bytesLoaded / event.bytesTotal) * (100 / (_max)))) * .01);
				_currBytes = event.bytesLoaded + _totalBytes;

				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_PROGRESS, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, event.bytesLoaded, event.bytesTotal, event.bytesLoaded / event.bytesTotal, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_PROGRESS, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, event.bytesLoaded, event.bytesTotal, event.bytesLoaded / event.bytesTotal, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
				
				if(event.bytesLoaded / event.bytesTotal == 1){
					_totalBytes += event.bytesLoaded;
				}
			}
		}
		
		
		//	Jesse -------------------------------------------------------
		private function itemErrorHandler(event:QueueLoaderEvent):void {
			ioErrorHandler ( new IOErrorEvent (IOErrorEvent.IO_ERROR, event.bubbles, event.cancelable, event.message) );
		}

		private function queueProgressHandler(event:QueueLoaderEvent):void {
			progressHandler ( new ProgressEvent (ProgressEvent.PROGRESS, event.bubbles, event.cancelable, event.bytesLoaded, event.bytesTotal ) );
		}
		
		private function queueCompleteHandler(event:QueueLoaderEvent):void {
			completeHandler ( new Event (Event.COMPLETE, event.bubbles, event.cancelable ) );
		}
		//	______________________________________________________________
		
		
		
		private function completeHandler(event : Event = null) : void {
			if(isLoading && !isStopped) {
				if(_currType == FILE_XML) _currFile = event.target.data;
				if(_currType == FILE_CSS) _currFile = event.target.data;
				if(_currType == FILE_FLV) _currFile = _ns;
				
				var checkSyncPoint : Boolean = false;
				
				if(_currType == FILE_IMAGE || _currType == FILE_SWF) {
					loadedItems.push(event.target.loader.content);
					_currFile = event.target.loader.content;
					_w = event.target.width;
					_h = event.target.height;
					if(_currType == FILE_SWF && currItem.info.drawFrames) {
						_currFile.stop();
						checkSyncPoint = true;
						drawSWFFrames();
					}
				}
				if(!checkSyncPoint) completeInit();
			}
		}

		private function completeInit() : void {
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_COMPLETE, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 100, _queuepercentage, _w, _h, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
			_count++;
			isQueueComplete();
		}

		//--== checks for completion ==--
		private function isQueueComplete() : void {
			if (!isStopped) {		
				if (queuedItems.length == 0) {
					if(_bwChecking ) _bwTimer.stop();
					dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_COMPLETE, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
					isLoading = false;
							//reset()
				} else {
					loadNextItem();
				}			
			}
		}

		private function loadNextItem() : void {		
			currItem = queuedItems.shift();		
			if (!isStopped) {				
				_currType = 0;
				if(_setMIMEType) {
					if(currItem.info.mimeType != undefined) {
						_currType = currItem.info.mimeType;
					}else {
						dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "QueueLoader error: " + currItem.info.title + " setMIMEType is set to true and no mime type for this item has been specified (example: QueueLoader.FILE_XML)", _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
					}
				}else {
					if(currItem.url.match(".jpg") != null) _currType = FILE_IMAGE;
					if(currItem.url.match(".gif") != null) _currType = FILE_IMAGE;
					if(currItem.url.match(".png") != null) _currType = FILE_IMAGE;
					if(currItem.url.match(".swf") != null) _currType = FILE_SWF;
					if(currItem.url.match(".mp3") != null) _currType = FILE_AUDIO;
					if(currItem.url.match(".mp4") != null) _currType = FILE_AUDIO;
					if(currItem.url.match(".css") != null) _currType = FILE_CSS;
					if(currItem.url.match(".xml") != null) _currType = FILE_XML;
					if(currItem.url.match(".flv") != null) _currType = FILE_FLV;
				}
				
				if(currItem.info.cacheKiller != undefined && currItem.info.cacheKiller){
					currItem.url = currItem.url + cacheKiller();
				}
				
				
				var request : URLRequest = new URLRequest(currItem.url);
				if(VERBOSE) debug(">> loadNextItem() loading: " + _currType);
				switch (_currType) {
					case FILE_IMAGE:
						if (currItem.targ == undefined) {	
							dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "QueueLoader error: " + currItem.info.title + " could not be loaded into " + currItem.targ.name + "/" + currItem.targ.name, _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
						} else {
							_loader = new Loader();
							configureListeners(_loader.contentLoaderInfo);
							_loader.load(request, _loaderContext);
							currItem.targ.addChild(_loader);
						}
						break;
					case FILE_SWF:
						if (currItem.targ == undefined) {	
							dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_ERROR, currItem.targ, _currFile, currItem.url, currItem.info.title, _currType, 0, 0, 0, _queuepercentage, 0, 0, "QueueLoader error: " + currItem.info.title + " could not be loaded into " + currItem.targ.name + "/" + currItem.targ.name, _count, queuedItems.length, _max, _bmArray, currItem.info.dataObj, _bandwidth));
						} else {
							_loader = new Loader();
							configureListeners(_loader.contentLoaderInfo);
							_loader.load(request, _loaderContext);
							currItem.targ.addChild(_loader);
						}
						break;
					case FILE_AUDIO:
						currItem.targ.addEventListener(Event.COMPLETE, completeHandler);
						currItem.targ.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						currItem.targ.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						currItem.targ.load(request);
						break;
					case FILE_XML:
						_loader = new URLLoader();
						_loader.addEventListener(Event.COMPLETE, completeHandler);
						_loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						_loader.load(request);
						break;
					case FILE_CSS:
						_loader = new URLLoader();
						_loader.addEventListener(Event.COMPLETE, completeHandler);
						_loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						_loader.load(request);
						break;
					case FILE_FLV:
						_nc = new NetConnection();
						_nc.connect(null);
						_ns = new NetStream(_nc);
						currItem.targ.attachNetStream(_ns);
						_ns.play(currItem.url);
						_ns.addEventListener(NetStatusEvent.NET_STATUS, netstat);
						
						var netClient:Object = new Object();
						//TODO Add meta data event
						netClient.onMetaData = function(meta:Object):void {
						        if(VERBOSE) debug(meta.duration);
						};
						 
						_ns.client = netClient;
						break;
						
					//	Jesse -------------------------------------------------------
					case FILE_QUEUE:
						_loader = null;
						var q:QueueLoader = currItem.targ as QueueLoader;
						q.addEventListener(QueueLoaderEvent.ITEM_ERROR, itemErrorHandler,false, 0, true);
						q.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, queueProgressHandler, false, 0, true);
						q.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, queueCompleteHandler,false, 0, true);
						q.execute();
						break;
					//	______________________________________________________________		
					
					default:
						if(VERBOSE) debug(">> loadNextItem() NO TYPE DETECTED!");
				}
					//request = null;
			}	
		}
		
		//TODO clean up and move to special features
		private function netstat(event:NetStatusEvent):void{
			if(VERBOSE) debug(event.info.code);
			completeHandler();
			//TODO Track events
			 switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    //connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + currItem.url);
                    break;
            }
		}
		
		
        
        

		// --== resets data ==--
		private function reset() : void {
			if(VERBOSE) debug(">> reset()");
			if(_ns != null) _ns.close();
			//	Jesse -------------------------------------------------------
			if ( _currType == FILE_QUEUE ){
				if ( currItem.targ != null ) currItem.targ.stop();
			}
			//	______________________________________________________________
			
			_count = 0;
			//loadedItems = null;
			_queuepercentage = 0;
			queuedItems = new Array();
			itemsToInit = new Array();
			loadedItems = new Array();
			_bmArray = null;
			currItem = null;
			_currFile = null;	
			_max = 0;
			_queuepercentage = 0;
			_currFrame = 1;
		}
		
		
		
		
		
		
		
		// ____  ____  _____ ____ ___    _    _     
		/// ___||  _ \| ____/ ___|_ _|  / \  | |    
		//\___ \| |_) |  _|| |    | |  / _ \ | |    
		// ___) |  __/| |__| |___ | | / ___ \| |___ 
		//|____/|_|   |_____\____|___/_/   \_\_____|
		//                                          
		// _____ _____    _  _____ _   _ ____  _____ ____  
		//|  ___| ____|  / \|_   _| | | |  _ \| ____/ ___| 
		//| |_  |  _|   / _ \ | | | | | | |_) |  _| \___ \ 
		//|  _| | |___ / ___ \| | | |_| |  _ <| |___ ___) |
		//|_|   |_____/_/   \_\_|  \___/|_| \_\_____|____/ 
                                                 
		
		//TODO Optomization
		private function drawSWFFrames() : void {
			if(VERBOSE) debug(">> drawSWFFrames() args: " + _currFile);
			_bmArray = new Array();
			_bmFrames = _currFile.totalFrames;
			_currFile.stop();
			//drawFrame(item);
			_framerate = _currFile.stage.frameRate;
			_currFile.stage.frameRate = 10;
			_currFile.addEventListener(Event.ENTER_FRAME, drawFrame);
			trace(_currFile.stage.frameRate);
		}

		private function drawFrame(event : Event) : void {
			if(VERBOSE) debug("\t>> drawFrame() args: " + [_currFile, _currFrame, _bmFrames]);
			_currFrame = _currFile.currentFrame;
			var bd : BitmapData = new BitmapData(_currFile.width, _currFile.height, false, 0xFFFF0000);
			bd.draw(_currFile, new Matrix(), null, null, null, true);
			_bmArray.push(bd);
			
			if(_currFrame == _bmFrames) {
				_currFile.removeEventListener(Event.ENTER_FRAME, drawFrame);
				_currFile.stage.frameRate = _framerate;
				completeInit();
			}else {
				_currFile.gotoAndStop(_currFrame + 1);
			}
		}
		
		//TODO Latency functionality
		private function checkBandwidth(event:TimerEvent):void{
			var now:Number = (new Date()).getTime()/1;
			_pakRecv[_bwCount] = now;
			
			var deltaTime:Number = getTimer() - _prevSyncPoint;
			var deltaBytes:Number = _currBytes - _prevBytes;
			_bwCount++;
			
			if (_bwCount == 1) {
				_latency = Math.min(deltaTime, 800);
				_latency = Math.max(_latency, 10);
			}
			
			if ( _bwCount == 2 && (deltaTime<2000)){
				_pakSent[_sent++] = now;
				_cumLatency++;
			}else if ( _latency >= 100 ) {
				if (  _pakRecv[1] - _pakRecv[0] > 1000 )
				{
					_latency = 100;
				}
				
				var deltaLatency:Number = ((now - _nowStart) - (_latency * _cumLatency) )/1000;
				if ( deltaTime <= 0 ) deltaTime = (now - _nowStart)/1000;
			}
			//_bandwidth = ((_currBytes - _prevBytes) / 1024) / ((getTimer() - _prevSyncPoint)/1000);
			_bandwidth = round(deltaBytes/1024, .0001);
			
			
			if(VERBOSE_BANDWITH) debug("\n\n=====================================");
			
			var bwOutput:String = "\t current bytes loaded: "+[(_currBytes/1024)]+"\n";
			bwOutput += "\t bandwidth: "+[_bandwidth]+" KB/s\n";
			bwOutput += "\t delta time: "+[deltaTime]+"\n";
			bwOutput += "\t latency: "+[_latency]+"\n";
			bwOutput += "\t delta latency: "+[deltaLatency]+"\n";
			bwOutput += "\t timer: "+[getTimer()]+"\n";
			
			if(VERBOSE_BANDWITH) debug(bwOutput);
			if(VERBOSE_BANDWITH) debug("=====================================\n\n");
			
			_prevBytes = _currBytes;
			_prevSyncPoint = getTimer();
			_prevNow = now;
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
		
		private function round(nNumber:Number, decimal:Number = 1):Number {
			return (new int(nNumber / decimal)) * decimal;
		}
	}
}