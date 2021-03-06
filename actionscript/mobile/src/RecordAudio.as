package
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class RecordAudio extends EventDispatcher
	{
		private static var _instance:RecordAudio;
		private static var extensionContext:ExtensionContext;
		private static const EXTENSION_ID:String="com.pamakids.RecordAudio";
		
		public static function get instance():RecordAudio
		{
			if (!_instance)
			{
				_instance=new RecordAudio();
				extensionContext=ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				if (!extensionContext)
					trace("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
				else
					extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
			}
			return _instance;
		}

		/**
		 * Start Record
		 * 
		 * @savedName file name to save e.g. test.caf
		 * @formateIndex file formate index to use: 
		 * @sampleRate audio rate, default is 44100, for record voice is 8000
		 *  
		case 0: return kAudioFormatLinearPCM; break;
        case 1: return kAudioFormatAC3; break;
        case 2: return kAudioFormat60958AC3; break;
        case 3: return kAudioFormatAppleIMA4; break;
        case 4: return kAudioFormatMPEG4AAC; break;
        case 5: return kAudioFormatMPEG4CELP; break;
        case 6: return kAudioFormatMPEG4HVXC; break;
        case 7: return kAudioFormatMPEG4TwinVQ; break;
        case 8: return kAudioFormatMACE3; break;
        case 9: return kAudioFormatMACE6; break;
        case 10: return kAudioFormatULaw; break;
        case 11: return kAudioFormatALaw; break;
        case 12: return kAudioFormatQDesign; break;
        case 13: return kAudioFormatQDesign2; break;
        case 14: return kAudioFormatQUALCOMM; break;
        case 15: return kAudioFormatMPEGLayer1; break;
        case 16: return kAudioFormatMPEGLayer2; break;
        case 17: return kAudioFormatMPEGLayer3; break;
        case 18: return kAudioFormatTimeCode; break;
        case 19: return kAudioFormatMIDIStream; break;
        case 20: return kAudioFormatParameterValueStream; break;
        case 21: return kAudioFormatAppleLossless; break;
        case 22: return kAudioFormatMPEG4AAC_HE; break;
        case 23: return kAudioFormatMPEG4AAC_LD; break;
        case 24: return kAudioFormatMPEG4AAC_ELD; break;
        case 25: return kAudioFormatMPEG4AAC_ELD_SBR; break;
        case 26: return kAudioFormatMPEG4AAC_ELD_V2; break;
        case 27: return kAudioFormatMPEG4AAC_HE_V2; break;
        case 28: return kAudioFormatMPEG4AAC_Spatial; break;
        case 29: return kAudioFormatAMR; break;
        case 30: return kAudioFormatAudible; break;
        case 31: return kAudioFormatiLBC; break;
        case 32: return kAudioFormatDVIIntelIMA; break;
        case 33: return kAudioFormatMicrosoftGSM; break;
        case 34: return kAudioFormatAES3; break;
		 */
		public function startRecord(savedName:String,formatIndex:int=0, sampleRate:int=8000):void
		{
			saveName = savedName;
			if (extensionContext)
				extensionContext.call('startRecord', savedName, formatIndex.toString(), sampleRate.toString());
		}
		
		private static const stopedCallback:Dictionary = new Dictionary;;
		
		/**
		 * Stop Record
		 * 
		 * @callback return recorded file's url
		 */
		public function stopRecord(callback:Function):void
		{
			if (extensionContext)
			{
				stopedCallback["stopRecord"] = callback;
				extensionContext.call('stopRecord');	
			}
		}
		/**
		 * resume Record
		 * 
		 * @callback return recorded file's url
		 */
		public function resumeRecord():void
		{
			if (extensionContext)
			{
				extensionContext.call('resumeRecord');	
			}
		}
		/**
		 * pause Record
		 * 
		 * @callback return recorded file's url
		 */
		public function pauseRecord():void
		{
			if (extensionContext)
			{
				extensionContext.call('pauseRecord');	
			}
		}		
		/**
		 * Convert recorded audio to mp3
		 * 
		 * @callback return converted file's url
		 */
		public function toMp3(callback:Function):void
		{
			if (extensionContext)
			{
				stopedCallback["toMp3"] = callback;
				extensionContext.call('toMp3');	
			}
		}

		/**
		 * Convert recorded audio to amr
		 * 
		 * @callback return converted file's url
		 */
		public function toAmr(callback:Function):void
		{
			if(extensionContext)
			{
				stopedCallback["toAmr"] = callback;
				extensionContext.call('toAmr');
			}
		}
		
		/**
		 * Play AMR file
		 * 
		 * @path amr file path
		 * @volume amr player volume
		 * @playCompletedCallback call after amr file play completed
		 * 
		 * @callback return converted file's url
		 */
		public function playAmr(path:String, volume:Number = 1.0, playCompletedCallback:Function=null):void
		{
			if(extensionContext)
			{
				stopedCallback["playAmr"] = playCompletedCallback;
				extensionContext.call('playAmr', path, volume.toString());
			}
		}
		
		/**
		 * stop play amr
		 */
		public function stopAmr():void
		{
			if(extensionContext)
			{
				extensionContext.call('stopAmr');
			}
		}
		
		private static var saveName:String;
		
		protected static function onStatus(event:StatusEvent):void
		{
			var url:String = event.level;
//			var f:File = File.applicationDirectory;
//			if(saveName)
//			{
//				var pureName:String = saveName.replace(/\.[^\/]*$/g, "");
//			}
			if(event.code == 'stoped' && stopedCallback["stopRecord"])
			{
//				if(url.indexOf('|') != -1)
//				{
//					trace('url has problem, auto fix');
//					url = f.nativePath.replace(f.name, '')+'tmp/'+saveName;
//				}
				trace('Saved: '+url);
				stopedCallback["stopRecord"](url);
				stopedCallback["stopRecord"] = null;
			}else if(event.code == 'mp3_converted' && stopedCallback["toMp3"])
			{
				
//				url = f.nativePath.replace(f.name, '')+'tmp/'+pureName+'.mp3';
				stopedCallback["toMp3"](url);
				stopedCallback["toMp3"]=null;
			}else if(event.code == 'amrConverted' && stopedCallback["toAmr"]){
//				url = f.nativePath.replace(f.name, '')+'tmp/'+pureName+'.amr';
				stopedCallback["toAmr"](url);
				stopedCallback["toAmr"]=null;
			}else if(event.code == 'amrPlayCompleted' && stopedCallback["playAmr"]){
				stopedCallback["playAmr"]();
				stopedCallback["playAmr"]=null;
			}
				
		}
	}

}