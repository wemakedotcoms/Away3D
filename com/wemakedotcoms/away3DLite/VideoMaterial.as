﻿package com.wemakedotcoms.away3DLite{	import away3dlite.materials.MovieMaterial;		import flash.display.Sprite;	import flash.events.AsyncErrorEvent;	import flash.events.IOErrorEvent;	import flash.events.NetStatusEvent;	import flash.geom.Rectangle;	import flash.media.Video;	import flash.net.NetConnection;	import flash.net.NetStream;		public class VideoMaterial extends MovieMaterial	{				private var _player:Sprite;		private var _nc:NetConnection;		private var _ns:NetStream;		private var _video:Video;		private var _netClient:Object;		private var _src:String;		private var _loop:Boolean;		private var _position:Number;		private var _paused:Boolean;				public function VideoMaterial(rect:Rectangle=null, autoUpdate:Boolean=false, transparent:Boolean=false):void		{						_initPlayer();						super(_player, rect, autoUpdate, transparent);						smooth = true;					}						public function set source( src:String ):void		{						_src = src;						_initNetStream();			_initNetClient();						_ns.play( src );						_paused = false;		}				public function setVideoSize( w:Number, h:Number ):void		{						_video.width = w;			_video.height = h;						rect = new Rectangle(0, 0, w, h);					}								public function clean( ):void		{						_cleanPlayer();					}				public function pause():void		{						if(_src)			{				_position = _ns.time;				_ns.pause();				_paused = true;							}					}				public function resume():void		{						if(_src){				_ns.play(_src, _position);				_paused = false;			}					}				private function _initPlayer():void		{						_loop = true;						// Sprite being passed to the MC Mat			_player = new Sprite();						// Net connection			_nc = new NetConnection();			_nc.connect( null );						// Net Stream			_ns = new NetStream( _nc );			_netClient = new Object();						// Video Object			_video = new Video();			_player.addChild( _video );								}					private function _initNetStream():void		{						_video.attachNetStream( _ns );						// Event Handlers			_ns.addEventListener(NetStatusEvent.NET_STATUS, 	_handleNetStatus, false, 0, true);			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 	_handleAsyncError, false, 0, true);			_ns.addEventListener(IOErrorEvent.IO_ERROR,			_handleIOError,	false, 0, true);					}				private function _initNetClient():void		{						_netClient["onMetaData"]= _handleMetaData;			_netClient["onBWDone"] 	= _handleBWDone;			_netClient["close"] 	= _handleStreamClose;						_ns.client = _netClient;					}						private function _cleanPlayer():void		{						_src =  null;						_ns.close();			_video.attachNetStream( null );						_ns.removeEventListener( NetStatusEvent.NET_STATUS, 	_handleNetStatus );			_ns.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, 	_handleAsyncError );			_ns.removeEventListener( IOErrorEvent.IO_ERROR,			_handleIOError );						//_ns.client = null;						_netClient["onMetaData"]= null;			_netClient["onBWDone"] 	= null;			_netClient["close"] 	= null;					}					private function _handleNetStatus( e:NetStatusEvent ):void		{						switch (e.info.code) {				case "NetStream.Play.Stop": 					if(_loop) _ns.play(_src);										break;				case "NetStream.Play.Play":					trace(" NNetStream is Playing" );					break;				case "NetStream.Play.StreamNotFound":					trace("The file "+_src+" was not found: " + e);					break;				case "NetConnection.Connect.Success":					trace( "NetConnection.Connect.Success" );					break;			}					}				private function _handleAsyncError( e:AsyncErrorEvent ):void		{			//TODO			}				private function _handleIOError( e:IOErrorEvent ):void		{			//TODO		}				private function _handleMetaData(data:Object = null):void		{			//trace( _src + " // duration : " + data.duration + " // width : " + data.width + " // height : " + data.height + " // framerate : " + data.framerate);		}				private function _handleBWDone():void		{			//TODO		}				private function _handleStreamClose():void		{			trace("The stream was closed. Incorrect URL?");		}	}}