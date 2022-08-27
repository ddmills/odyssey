package data;

import h2d.Font;

class TextResources
{
	public static var BIZCAT:Font;

	public static function Init()
	{
		BIZCAT = hxd.Res.fnt.bizcat.toFont();
	}
}
