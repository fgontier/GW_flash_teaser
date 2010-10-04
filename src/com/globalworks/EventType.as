package com.globalworks 
{
	import flash.events.Event;

	public class EventType extends Event {

  		public var arg:*;

  		public function EventType(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ... a:*) {
   			super(type, bubbles, cancelable);
   			arg = a;
   		}
		
		override public function clone():Event{
			return new EventType(type, bubbles, cancelable, arg);
		};
	}
}