package com.hydrotik.go {
	import org.goasap.interfaces.IManageable;	

	import flash.utils.Dictionary;

	import org.goasap.interfaces.ILiveManager;		

	/**	 * @author Donovan Adams | Hydrotik | http://blog.hydrotik.com	 */	public class PV3DRenderManager implements ILiveManager {

		private static var _viewport : *;

		private static var _camera : *;

		private static var _scene : *;

		private static var _renderer : *;

		private static var _lookAtTarget : *;

		protected var handlers : Dictionary = new Dictionary(false);

		public function reserve(handler : IManageable) : void {
			var pvProps : Object = (handler as IRenderable).getRenderer();
			for (var prop:String in pvProps) {
				if (prop == "viewport") _viewport = pvProps[prop];
				else if (prop == "camera") _camera = pvProps[prop];
				else if (prop == "scene") _scene = pvProps[prop];
				else if (prop == "renderer") _renderer = pvProps[prop];
				else if (prop == "lookAtTarget") _lookAtTarget = pvProps[prop];
			}
		}

		public function release(handler : IManageable) : void {
		}

		public function onUpdate(pulseInterval : int, handlers : Array, currentTime : Number) : void {
			if(_renderer != null) _renderer.renderScene(_scene,_camera,_viewport);
			if(_lookAtTarget != null) _camera.lookAt(_lookAtTarget);
		}
	}
}