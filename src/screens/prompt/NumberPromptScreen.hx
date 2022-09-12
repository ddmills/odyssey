package screens.prompt;

class NumberPromptScreen extends PromptScreen
{
	public var value:Int = 1;
	public var max:Int = 99999999;
	public var min:Int = 0;

	public function new()
	{
		super();
		title = 'Enter amount';
		onInputChange = (v) ->
		{
			var int = Std.parseInt(v);

			if (int == null)
			{
				if (v.length == 1 && min < 0)
				{
					if (v == '-')
					{
						return v;
					}
				}
				if (v.length == 0 || v.length == 1)
				{
					value = 0;
					return '';
				}

				return value.toString();
			}

			int = int.clamp(min, max);

			value = int;

			return value.toString();
		}
	}
}
