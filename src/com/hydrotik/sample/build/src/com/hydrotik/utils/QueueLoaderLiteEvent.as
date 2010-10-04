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
	import flash.events.Event;

	/**
	 * Custom Event Class for QueueLoaderLite
	 */
	public class QueueLoaderLiteEvent extends Event {

		// Event types
		public static var ITEM_START : String = "itemStart";

		public static var ITEM_PROGRESS : String = "itemProgress";

		public static var ITEM_COMPLETE : String = "itemComplete";

		public static var ITEM_ERROR : String = "itemError";

		public static var QUEUE_START : String = "queueStart";

		public static var QUEUE_PROGRESS : String = "queueProgress";

		public static var QUEUE_COMPLETE : String = "queueComplete";

		// Public properties
		public var targ : *;

		public var title : String = "";

		public var fileType : int;

		public var file : *;

		public var path : String;

		public var bytesLoaded : Number = -1;

		public var bytesTotal : Number = -1;	

		public var percentage : Number = 0;

		public var queuepercentage : Number = 0;

		public var count : int;	

		public var length : int;

		public var max : int;

		public var width : Number;

		public var height : Number;

		public var message : String = "";

		public var dataObj : Object = null;

		public function QueueLoaderLiteEvent( type : String, targ : *, file : *, path : String = "",  title : String = "", fileType : int = 1, bytesLoaded : Number = -1, bytesTotal : Number = -1, percentage : Number = -1, queuepercentage : Number = 0, width : Number = 0, height : Number = 0, message : String = "", count : int = 0, length : int = 0, max : int = 0, dataObj : Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.targ = targ;
			this.file = file;
			this.path = path;
			this.title = title;
			this.fileType = fileType;
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			this.percentage = percentage;
			this.queuepercentage = queuepercentage;
			this.count = count;
			this.length = length;
			this.max = max;
			this.width = width;
			this.height = height;
			this.message = message;
			this.dataObj = dataObj;
		}
	}
}