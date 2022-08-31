package screens.cursor.renderer;

import common.struct.Coordinate;
import common.util.Timeout;
import core.Frame;
import core.Game;
import data.TileResources;
import domain.components.IsEnemy;
import domain.components.Moniker;
import h2d.Bitmap;
import haxe.EnumTools.EnumValueTools;
import screens.cursor.CursorScreen.CursorRenderOpts;
import shaders.SpriteShader;

class LookCursorRenderer extends CursorRenderer
{
	var ob:h2d.Object;
	var targetBm:h2d.Bitmap;
	var targetShader:SpriteShader;
	var timeout:Timeout;
	var isBlinking:Bool = false;
	var terrainText:h2d.Text;
	var targetText:h2d.Text;

	var colorEnemy = 0xd13434;
	var colorNeutral = 0x338f9b;

	public function new()
	{
		targetShader = new SpriteShader(colorNeutral);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 1;
		ob = new h2d.Object();
		targetBm = new Bitmap(TileResources.EYE_OPEN, ob);
		targetBm.addShader(targetShader);
		renderText();
		Game.instance.render(OVERLAY, ob);
		Game.instance.render(HUD, terrainText);
		timeout = new Timeout(.5);
		timeout.onComplete = blink;
	}

	private function blink()
	{
		timeout.reset();
		targetBm.visible = isBlinking ? !targetBm.visible : true;
	}

	public override function update(frame:Frame)
	{
		timeout.update();
	}

	public override function cleanup()
	{
		ob.remove();
		terrainText.remove();
	}

	public override function render(opts:CursorRenderOpts)
	{
		var end = opts.end.toPx();

		if (end.x != targetBm.x || end.y != targetBm.y)
		{
			targetBm.x = end.x;
			targetBm.y = end.y;
			targetBm.visible = true;
			timeout.reset();
		}

		targetText.visible = false;
		targetShader.primary = colorNeutral.toHxdColor();

		if (Game.instance.world.isVisible(opts.end))
		{
			terrainText.text = EnumValueTools.getName(Game.instance.world.map.getTerrain(opts.end.x, opts.end.y));
			targetBm.tile = TileResources.EYE_OPEN;
			var entities = Game.instance.world.getEntitiesAt(opts.end);
			isBlinking = entities.length > 0;
			if (entities.exists((e) -> e.has(IsEnemy)))
			{
				targetShader.primary = colorEnemy.toHxdColor();
			}

			var named = entities.find((e) -> e.has(Moniker));
			if (named != null)
			{
				var moniker = named.get(Moniker);
				targetText.text = moniker.displayName;
				var tagSpot = named.pos.floor().add(new Coordinate(1.5, 0, WORLD)).toPx();
				targetText.x = tagSpot.x;
				targetText.y = tagSpot.y;
				targetText.visible = true;
			}
		}
		else
		{
			targetBm.tile = TileResources.EYE_CLOSE;
			isBlinking = false;
		}
	}

	private function renderText()
	{
		targetText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		targetText.color = new h3d.Vector(1, 1, .9);
		targetText.x = 16;
		targetText.y = 16;
		ob.addChild(targetText);

		terrainText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		terrainText.color = new h3d.Vector(1, 1, .9);
		terrainText.x = 16;
		terrainText.y = Game.instance.window.height - 32;
	}
}
