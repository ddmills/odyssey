package common.rand;

class Perlin
{
	private var hxdPerlin:hxd.Perlin;

	public var seed:Int = 0;

	public function new(seed:Int = 0)
	{
		this.seed = seed;
		hxdPerlin = new hxd.Perlin();
		hxdPerlin.normalize = true;
	}

	public function get(x:Float, y:Float, scale:Float = 1, octaves:Int = 8)
	{
		var n = hxdPerlin.perlin(seed, x / scale, y / scale, octaves);

		return (n + 1) / 2;
	}
}
