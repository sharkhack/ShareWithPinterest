//  Created by Azer Bulbul on 12/29/13.
//  Copyright (c) 2013 Azer Bulbul. All rights reserved.
package com.azer.sharewithpinterest
{
	import flash.external.ExtensionContext;

	public class PinIt
	{
		
		private static var _instance : PinIt;
		private static var ext:ExtensionContext = null;
		
		public function PinIt()
		{
			if (!_instance)
			{
				if(ext == null){
					ext = ExtensionContext.createExtensionContext("com.azer.iospinterest",null);
					
				}
				_instance = this;
			}
		}
		
		public static function getInstance() : PinIt
		{
			return _instance ? _instance : new PinIt();
		}
		
		
		/**
		 * initClientId
		 * @param clientId is your pinterest app id - create on "https://developers.pinterest.com/manage/"
		 * @return true/false If pinning is possible via the Pin It SDK on the device.
		 * @author Azer BULBUL https://github.com/sharkhack
		 * */
		public function initClientId(clientId:String):Boolean{
			return Boolean(ext.call( "pinterestInitialize",clientId));
		}
		
		/**
		 * createPin
		 * 
		 * @param imageURL URL of the image to pin.
 		 * @param sourceURL The source page of the image.
 		 * @param descriptionText The pin's description.
		 *
		 * @author Azer BULBUL https://github.com/sharkhack
		 * */
		public function createPin(imageURL:String, sourceURL:String, descriptionText:String=""):void{
			ext.call( "createPin",imageURL,sourceURL,descriptionText);
		}
		
		
	}
}