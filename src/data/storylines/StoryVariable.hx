package data.storylines;

class StoryVariable
{
	public var key:String;
	public var isParameter:Bool;

	public function new(key:String, isParameter:Bool = false)
	{
		this.key = key;
		this.isParameter = isParameter;
	}

	public function initialize(storyline:Storyline):Bool
	{
		if (isParameter)
		{
			return tryPopulate(storyline);
		}

		return true;
	}

	public function tryPopulate(storyline:Storyline):Bool
	{
		return false;
	}
}
