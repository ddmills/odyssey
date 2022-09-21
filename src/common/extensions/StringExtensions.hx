package common.extensions;

class StringExtensions
{
	static public inline function pad(s:String, length:Int, ?ch:String = ' '):String
	{
		return StringTools.rpad(s, ch, length);
	}

	static public inline function lpad(s:String, length:Int, ?ch:String = ' '):String
	{
		return StringTools.lpad(s, ch, length);
	}
}
