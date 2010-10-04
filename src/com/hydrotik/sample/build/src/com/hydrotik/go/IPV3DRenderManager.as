package com.hydrotik.go {
	import org.goasap.interfaces.ILiveManager;			/**	 * @author Donovan Adams | Hydrotik | http://blog.hydrotik.com	 */	public interface IPV3DRenderManager extends ILiveManager {
		
		function reserve(handler : IRenderable) : void;
		
		function release(handler : IRenderable) : void;
		
		function onUpdate(pulseInterval : int, handlers : Array, currentTime : Number) : void;	}}