import haxe.EnumTools.EnumValueTools;

class EnumValueExtensions
{
	public static function enumKeyName(e:EnumValue)
	{
		return EnumValueTools.getName(e);
	}
}
