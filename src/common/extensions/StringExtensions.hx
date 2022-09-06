package common.extensions;

class StringExtensions
{
	static public inline function pad(s:String, length:Int, ?ch:String = ' '):String
	{
		return StringTools.rpad(s, ch, length);
	}
}
