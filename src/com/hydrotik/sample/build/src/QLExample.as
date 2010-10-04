package {
	import flash.display.Shape;	
	import flash.system.Capabilities;	
	import flash.text.TextField;	
	
	import com.hydrotik.queueloader.QueueLoaderEvent;	
	import com.hydrotik.queueloader.QueueLoader;	

	import flash.system.ApplicationDomain;	
	import flash.system.LoaderContext;	
	import flash.display.Sprite;	
	/**	 * @author Donovan Adams | Hydrotik | http://blog.hydrotik.com	 */	public class QLExample extends Sprite {

		private var _itemprogbg : Shape;
		
		private var _itemprog : Shape;
		
		private var _queueprogbg : Shape;
		
		private var _queueprog : Shape;

		public function QLExample() {
			_itemprogbg = createBar(0x333333, .3, 10, 200);
			addChild(_itemprogbg);
			_itemprogbg.width = 150;
			
			_itemprog = createBar(0x333333, 1, 10, 200);
			addChild(_itemprog);
			
			_queueprogbg = createBar(0x333333, .3, 10, 250);
			addChild(_queueprogbg);
			_queueprogbg.width = 150;
			
			_queueprog = createBar(0x333333, 1, 10, 250);
			addChild(_queueprog);

			var imageContainer : Sprite = new Sprite();
			addChild(imageContainer);
			imageContainer.x = imageContainer.y = 25;

			var addedDefinitions : LoaderContext = new LoaderContext();
			addedDefinitions.applicationDomain = ApplicationDomain.currentDomain;
			var _oLoader : QueueLoader = new QueueLoader(false, addedDefinitions, true, "testQueue");

			var startX : int = 0;
			var startY : int = 0;

			for (var i : int = 0;i < 3; i++) {
				var img : Sprite = new Sprite();
				img.name = "image_" + i;
				img.x = startX;
				img.y = startY;
				img.scaleX = img.scaleY = .075;
				imageContainer.addChild(img);
				_oLoader.addItem(prefix("") + "flashassets/images/slideshow/" + (i + 1).toString() + ".jpg", img, {title:"Image " + i});
				if (startX > 250) {
					startX = startX + 50;
					startY = startY + 100;
				} else {
					startX = startX + 150;
				}
			}

			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_START, onQueueStart, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_START, onItemStart, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_PROGRESS, onItemProgress, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_COMPLETE, onItemComplete, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_ERROR, onItemError, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, onQueueProgress, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueComplete, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_HTTP_STATUS, onHTTPError, false, 0, true);
			
			_oLoader.execute();
		}

		private function onQueueStart(event : QueueLoaderEvent) : void {
			trace("** " + event.type);
		}

		private function onItemStart(event : QueueLoaderEvent) : void {
			trace("\t>> " + event.type, "item title: " + event.title);
		}

		private function onItemProgress(event : QueueLoaderEvent) : void {
			_itemprog.width = 150 * event.percentage;
			TextField(this.getChildByName("item_txt")).text = "LOADING " + event.title.toUpperCase() + ": " + Math.round((event.percentage * 100)).toString() + "% COMPLETE";
		}

		private function onQueueProgress(event : QueueLoaderEvent) : void {
			_queueprog.width = 150 * event.queuepercentage;
			TextField(this.getChildByName("queue_txt")).text = "QUEUE: " + Math.round((event.queuepercentage * 100)).toString() + "% COMPLETE";
		}

		private function onItemComplete(event : QueueLoaderEvent) : void {
			trace("\t>> " + event.type, "item title: " + event.title);
		}

		private function onItemError(event : QueueLoaderEvent) : void {
			trace("\n>>" + event.message + "\n");
		}

		private function onHTTPError(event : QueueLoaderEvent) : void {
			//trace("\n\t\t>>"+event.message+"\n");
		}

		private function onQueueComplete(event : QueueLoaderEvent) : void {
			trace("** " + event.type);
		}

		private function prefix(serverPath : String) : String {
			var playerType : String = Capabilities.playerType;
			if (playerType == "External" || playerType == "StandAlone") {
				return "../";
			} else {
				return serverPath;
			}
		}
		
		private function createBar(color:uint, alpha:Number, x:int, y:int):Shape {
			var s:Shape = new Shape();
			s.graphics.beginFill(color, alpha);
			s.graphics.drawRect(0, 0, 1, 2);
			s.graphics.endFill();
			s.x = x;
			s.y = y;
			return s;
		}
	}}