package screens.splash;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.util.Timeout;
import core.Frame;
import core.Screen;
import core.input.KeyCode;
import screens.loading.LoadingScreen;

class SplashScreen extends Screen
{
	var title:h2d.Text;
	var next:h2d.Text;
	var duration:Float;
	var timeout:Timeout;

	public function new(duration:Float = 3)
	{
		this.duration = duration;
		timeout = new Timeout(2);
		timeout.onComplete = timeout.reset;
	}

	override function onEnter()
	{
		title = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		title.setScale(1);
		title.text = "Odyssey";
		title.color = new h3d.Vector4(1, 1, .9, 1);

		next = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		next.setScale(1);
		next.text = "click anywhere to continue";
		next.color = new h3d.Vector4(1, 1, .9, 1);

		game.render(HUD, title);
		game.render(HUD, next);
	}

	override function update(frame:Frame)
	{
		timeout.update();
		duration -= frame.dt;

		if (duration <= 0)
		{
			okay();
			return;
		}

		title.textAlign = Center;
		title.x = camera.width / 2;
		title.y = camera.height / 2;

		next.textAlign = Center;
		next.x = camera.width / 2;
		next.y = camera.height / 2 + 128;

		var scale = timeout.progress.yoyo(EASE_IN_ELASTIC);

		title.setScale(3 + scale);
	}

	override function onMouseUp(pos:Coordinate)
	{
		okay();
	}

	override function onKeyDown(key:KeyCode)
	{
		okay();
	}

	function okay()
	{
		game.screens.set(new LoadingScreen());
	}

	override function onDestroy()
	{
		title.remove();
		next.remove();
	}
}
