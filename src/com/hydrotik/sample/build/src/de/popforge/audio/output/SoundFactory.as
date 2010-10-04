/*
Copyright(C) 2007 Andre Michelle and Joa Ebert

PopForge is an ActionScript3 code sandbox developed by Andre Michelle and Joa Ebert
http://sandbox.popforge.de

This file is part of PopforgeAS3Audio.

PopforgeAS3Audio is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

PopforgeAS3Audio is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>
*/
package de.popforge.audio.output {
	import flash.events.ProgressEvent;		import flash.display.Loader;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * The class SoundFactory provides creating a valid
	 * flash.media.Sound object by passing either a
	 * custom Array with de.popforge.audio.output.Sample
	 * entries or by passing an uncompressed PCM ByteArray.
	 * 
	 * @author Andre Michelle
	 */
	public class SoundFactory
	{
		/**
		 * Creates a flash.media.Sound object from dynamic audio material
		 * 
		 * @param samples An Array of Samples (de.popforge.audio.output.Sample)
		 * @param channels Mono(1) or Stereo(2)
		 * @param bits 8bit(8) or 16bit(16)
		 * @param rate SamplingRate 5512Hz, 11025Hz, 22050Hz, 44100Hz
		 * @param onComplete Function, that will be called after the Sound object is created. The signature must accept the Sound object as a parameter!
		 * 
		 * @see http://livedocs.adobe.com/flex/2/langref/flash/media/Sound.html flash.media.Sound
		 */
		
		static public var s: ByteArray = null;
		//static public var loader:Loader = null;
		static public var onComplete:Function;		
		//static public var testSound:Sound = null;
		//static public var sounds:Array = new Array();
		
		static public function fromArray( samples: Array, channels: uint, bits: uint, rate: uint, onComplete: Function, onProgress:Function = null): void
		{
			var bytes: ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			var i: int;
			var s: Sample;
			var l: Number;
			var r: Number;
			
			var _numSamples: int = samples.length;
			
			switch( channels )
			{
				case Audio.MONO:

					if( bits == Audio.BIT16 )
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							
							if( l < -1 ) bytes.writeShort( -0x7fff );
							else if( l > 1 ) bytes.writeShort( 0x7fff );
							else bytes.writeShort( l * 0x7fff );
							
							s.left = s.right = 0;
						}
					}
					else
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							
							if( l < -1 ) bytes.writeByte( 0 );
							else if( l > 1 ) bytes.writeByte( 0xff );
							else bytes.writeByte( 0x80 + l * 0x7f );
							
							s.left = s.right = 0;
						}
					}
					break;
					
				case Audio.STEREO:

					if( bits == Audio.BIT16 )
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							r = s.right;
							
							if( l < -1 ) bytes.writeShort( -0x7fff );
							else if( l > 1 ) bytes.writeShort( 0x7fff );
							else bytes.writeShort( l * 0x7fff );
			
							if( r < -1 ) bytes.writeShort( -0x7fff );
							else if( r > 1 ) bytes.writeShort( 0x7fff );
							else bytes.writeShort( r * 0x7fff );
							
							s.left = s.right = 0;
						}
					}
					else
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							r = s.right;
							
							if( l < -1 ) bytes.writeByte( 0 );
							else if( l > 1 ) bytes.writeByte( 0xff );
							else bytes.writeByte( 0x80 + l * 0x7f );
							if( r < -1 ) bytes.writeByte( 0 );
							else if( r > 1 ) bytes.writeByte( 0xff );
							else bytes.writeByte( 0x80 + r * 0x7f );
							
							s.left = s.right = 0;
						}
					}
					break;
			}
			
			SoundFactory.fromByteArray( bytes, channels, bits, rate, onComplete, onProgress);
		}

		static public function createResources():void
		{
			s = new ByteArray();
			s.writeByte(0x46); s.writeByte(0x57); s.writeByte(0x53); s.writeByte(0x09); s.writeByte(0x28); s.writeByte(0x02); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x78); s.writeByte(0x00); s.writeByte(0x04); s.writeByte(0xe2); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x0e); s.writeByte(0xa6); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x18); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x44); s.writeByte(0x11); s.writeByte(0x09); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x44); s.writeByte(0x10); s.writeByte(0xe8); s.writeByte(0x03); s.writeByte(0x3c); s.writeByte(0x00); s.writeByte(0x43); s.writeByte(0x02); s.writeByte(0x86); s.writeByte(0x9c); s.writeByte(0xa7); s.writeByte(0x5a); s.writeByte(0x0a); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x02); s.writeByte(0x00); s.writeByte(0x5c); s.writeByte(0x30); s.writeByte(0x02); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0xd1); s.writeByte(0x4f); s.writeByte(0x2d); s.writeByte(0x96); s.writeByte(0x0c); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0xce); s.writeByte(0x0a); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x50); s.writeByte(0x72); s.writeByte(0x6f); s.writeByte(0x76); s.writeByte(0x69); s.writeByte(0x64); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x00); s.writeByte(0x0a); s.writeByte(0x0e); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x65); s.writeByte(0x6d); s.writeByte(0x70); s.writeByte(0x74); s.writeByte(0x79); s.writeByte(0x00); s.writeByte(0xbf); s.writeByte(0x14); s.writeByte(0xa4); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x66); s.writeByte(0x72); s.writeByte(0x61); s.writeByte(0x6d); s.writeByte(0x65); s.writeByte(0x31); s.writeByte(0x00); s.writeByte(0x10); s.writeByte(0x00); s.writeByte(0x2e); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x0f); s.writeByte(0x00); s.writeByte(0x0d); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x50); s.writeByte(0x72); s.writeByte(0x6f); s.writeByte(0x76); s.writeByte(0x69); s.writeByte(0x64); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x0d); s.writeByte(0x66); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x73); s.writeByte(0x68); s.writeByte(0x2e); s.writeByte(0x64); s.writeByte(0x69); s.writeByte(0x73); s.writeByte(0x70); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x79); s.writeByte(0x06); s.writeByte(0x53); s.writeByte(0x70); s.writeByte(0x72); s.writeByte(0x69); s.writeByte(0x74); s.writeByte(0x65); s.writeByte(0x05); s.writeByte(0x73); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x09); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x49); s.writeByte(0x74); s.writeByte(0x65); s.writeByte(0x6d); s.writeByte(0x0b); s.writeByte(0x66); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x73); s.writeByte(0x68); s.writeByte(0x2e); s.writeByte(0x6d); s.writeByte(0x65); s.writeByte(0x64); s.writeByte(0x69); s.writeByte(0x61); s.writeByte(0x05); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x06); s.writeByte(0x4f); s.writeByte(0x62); s.writeByte(0x6a); s.writeByte(0x65); s.writeByte(0x63); s.writeByte(0x74); s.writeByte(0x0c); s.writeByte(0x66); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x73); s.writeByte(0x68); s.writeByte(0x2e); s.writeByte(0x65); s.writeByte(0x76); s.writeByte(0x65); s.writeByte(0x6e); s.writeByte(0x74); s.writeByte(0x73); s.writeByte(0x0f); s.writeByte(0x45); s.writeByte(0x76); s.writeByte(0x65); s.writeByte(0x6e); s.writeByte(0x74); s.writeByte(0x44); s.writeByte(0x69); s.writeByte(0x73); s.writeByte(0x70); s.writeByte(0x61); s.writeByte(0x74); s.writeByte(0x63); s.writeByte(0x68); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x0d); s.writeByte(0x44); s.writeByte(0x69); s.writeByte(0x73); s.writeByte(0x70); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x79); s.writeByte(0x4f); s.writeByte(0x62); s.writeByte(0x6a); s.writeByte(0x65); s.writeByte(0x63); s.writeByte(0x74); s.writeByte(0x11); s.writeByte(0x49); s.writeByte(0x6e); s.writeByte(0x74); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x61); s.writeByte(0x63); s.writeByte(0x74); s.writeByte(0x69); s.writeByte(0x76); s.writeByte(0x65); s.writeByte(0x4f); s.writeByte(0x62); s.writeByte(0x6a); s.writeByte(0x65); s.writeByte(0x63); s.writeByte(0x74); s.writeByte(0x16); s.writeByte(0x44); s.writeByte(0x69); s.writeByte(0x73); s.writeByte(0x70); s.writeByte(0x6c); s.writeByte(0x61); s.writeByte(0x79); s.writeByte(0x4f); s.writeByte(0x62); s.writeByte(0x6a); s.writeByte(0x65); s.writeByte(0x63); s.writeByte(0x74); s.writeByte(0x43); s.writeByte(0x6f); s.writeByte(0x6e); s.writeByte(0x74); s.writeByte(0x61); s.writeByte(0x69); s.writeByte(0x6e); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x08); s.writeByte(0x16); s.writeByte(0x01); s.writeByte(0x16); s.writeByte(0x03); s.writeByte(0x18); s.writeByte(0x02); s.writeByte(0x05); s.writeByte(0x00); s.writeByte(0x16); s.writeByte(0x07); s.writeByte(0x18); s.writeByte(0x06); s.writeByte(0x16); s.writeByte(0x0a); s.writeByte(0x02); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x0c); s.writeByte(0x07); s.writeByte(0x01); s.writeByte(0x02); s.writeByte(0x07); s.writeByte(0x02); s.writeByte(0x04); s.writeByte(0x07); s.writeByte(0x04); s.writeByte(0x05); s.writeByte(0x07); s.writeByte(0x01); s.writeByte(0x06); s.writeByte(0x07); s.writeByte(0x05); s.writeByte(0x08); s.writeByte(0x07); s.writeByte(0x01); s.writeByte(0x09); s.writeByte(0x07); s.writeByte(0x07); s.writeByte(0x0b); s.writeByte(0x07); s.writeByte(0x02); s.writeByte(0x0c); s.writeByte(0x07); s.writeByte(0x02); s.writeByte(0x0d); s.writeByte(0x07); s.writeByte(0x02); s.writeByte(0x0e); s.writeByte(0x09); s.writeByte(0x06); s.writeByte(0x01); s.writeByte(0x06); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x02); s.writeByte(0x01); s.writeByte(0x02); s.writeByte(0x09); s.writeByte(0x03); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x03); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x04); s.writeByte(0x00); s.writeByte(0x04); s.writeByte(0x05); s.writeByte(0x09); s.writeByte(0x06); s.writeByte(0x00); s.writeByte(0x04); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x03); s.writeByte(0x00); s.writeByte(0x02); s.writeByte(0x02); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x04); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x05); s.writeByte(0x01); s.writeByte(0x04); s.writeByte(0x04); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x06); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x08); s.writeByte(0x09); s.writeByte(0x03); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x09); s.writeByte(0x0a); s.writeByte(0x06); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0xd0); s.writeByte(0x49); s.writeByte(0x00); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x02); s.writeByte(0x02); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x08); s.writeByte(0x23); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0x65); s.writeByte(0x00); s.writeByte(0x60); s.writeByte(0x06); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x07); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x08); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x09); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x0a); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x02); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x02); s.writeByte(0x58); s.writeByte(0x00); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x68); s.writeByte(0x01); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x03); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x05); s.writeByte(0x06); s.writeByte(0x03); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x04); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x06); s.writeByte(0x07); s.writeByte(0x06); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0xd0); s.writeByte(0x49); s.writeByte(0x00); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x05); s.writeByte(0x02); s.writeByte(0x01); s.writeByte(0x01); s.writeByte(0x05); s.writeByte(0x17); s.writeByte(0xd0); s.writeByte(0x30); s.writeByte(0x5d); s.writeByte(0x0b); s.writeByte(0x60); s.writeByte(0x06); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x07); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x05); s.writeByte(0x30); s.writeByte(0x60); s.writeByte(0x05); s.writeByte(0x58); s.writeByte(0x01); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x1d); s.writeByte(0x68); s.writeByte(0x04); s.writeByte(0x47); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x1e); s.writeByte(0x13); s.writeByte(0x02); s.writeByte(0x00); s.writeByte(0x01); s.writeByte(0x00); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x49); s.writeByte(0x74); s.writeByte(0x65); s.writeByte(0x6d); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x00); s.writeByte(0x53); s.writeByte(0x6f); s.writeByte(0x75); s.writeByte(0x6e); s.writeByte(0x64); s.writeByte(0x50); s.writeByte(0x72); s.writeByte(0x6f); s.writeByte(0x76); s.writeByte(0x69); s.writeByte(0x64); s.writeByte(0x65); s.writeByte(0x72); s.writeByte(0x00);
		}
		
		/**
		 * Creates a flash.media.Sound object from dynamic audio material
		 * 
		 * @param samples A uncompressed PCM ByteArray
		 * @param channels Mono(1) or Stereo(2)
		 * @param bits 8bit(8) or 16bit(16)
		 * @param rate SamplingRate 5512Hz, 11025Hz, 22050Hz, 44100Hz
		 * @param onComplete Function, that will be called after the Sound object is created. The signature must accept the Sound object as a parameter!
		 * 
		 * @see http://livedocs.adobe.com/flex/2/langref/flash/media/Sound.html flash.media.Sound
		 */
		static public function fromByteArray( bytes: ByteArray, channels: uint, bits: uint, rate: uint, onComplete: Function , onProgress:Function = null): void
		{
			SoundFactory.onComplete = onComplete;
			Audio.checkAll( channels, bits, rate );

			//-- get naked swf bytearray
			var swf: ByteArray = new ByteArray();
			if (s == null) createResources();
			swf.writeBytes(s);
			swf.endian = Endian.LITTLE_ENDIAN;
			swf.position = swf.length;

			//-- write define sound tag header
			swf.writeShort( 0x3bf );
			swf.writeUnsignedInt( bytes.length + 7 );

			//-- assemble audio property byte (uncompressed little endian)
			var byte2: uint = 3 << 4;
	
			switch( rate )
			{
				case 44100: byte2 |= 0xc; break;
				case 22050: byte2 |= 0x8; break;
				case 11025:	byte2 |= 0x4; break;
			}

			var numSamples: int = bytes.length;
			
			if( channels == 2 )
			{
				byte2 |= 1;
				numSamples >>= 1;
			}
			
			if( bits == 16 )
			{
				byte2 |= 2;
				numSamples >>= 1;
			}
	
			//-- write define sound tag
			swf.writeShort( 1 );
			swf.writeByte( byte2 );
			swf.writeUnsignedInt( numSamples );
			swf.writeBytes( bytes );

			//-- write eof tag in swf stream
			swf.writeShort( 1 << 6 );
			
			//-- overwrite swf length
			swf.position = 4;
			swf.writeUnsignedInt( swf.length );
			swf.position = 0;
			
			if (loader != null)
			{
				loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onSWFLoaded );
				try 
				{ 
					loader.close(); 
				} 
				catch (err:Error)
				{
					trace("Error closing loader");
				}
			}
			
			var onSWFLoaded: Function = function( event: Event ): void
			{
				var s:Sound = Sound( new ( loader.contentLoaderInfo.applicationDomain.getDefinition( "SoundItem" ) as Class )() );
				onComplete( s );
				loader.unload();
			};
			
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onSWFLoaded );
			if(onProgress != null) loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			loader.loadBytes( swf);
		}
	}
}