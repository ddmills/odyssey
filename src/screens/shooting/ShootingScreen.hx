package screens.shooting;

import common.struct.Coordinate;
import common.util.Timeout;
import core.Frame;
import core.input.Command;
import data.TileResources;
import domain.components.EquipmentSlot;
import domain.components.Weapon;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import h2d.Bitmap;
import screens.cursor.CursorScreen;
import shaders.SpriteShader;

class ShootingScreen extends CursorScreen
{
	var shooter:Entity;
	var ob:h2d.Object;
	var lineOb:h2d.Object;
	var targetBm:h2d.Bitmap;
	var targetShader:SpriteShader;
	var timeout:Timeout;
	var isBlinking:Bool = false;
	var weapon(get, never):Weapon;

	var COLOR_DANGER = 0xb61111;
	// var COLOR_NEUTRAL = 0xd4d4d4;
	var COLOR_NEUTRAL = 0xc0c06b;
	var COLOR_SHROUD = 0x464646;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;
		super();

		inputDomain = INPUT_DOMAIN_ADVENTURE;

		targetShader = new SpriteShader(COLOR_NEUTRAL);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;
		ob = new h2d.Object();
		lineOb = new h2d.Object(ob);
		targetBm = new Bitmap(TileResources.CURSOR, ob);
		targetBm.addShader(targetShader);

		timeout = new Timeout(.25);
		timeout.onComplete = blink;
	}

	override function onEnter()
	{
		super.onEnter();
		game.render(OVERLAY, ob);
	}

	private function blink()
	{
		timeout.reset();
		targetBm.visible = isBlinking ? !targetBm.visible : true;
	}

	public override function update(frame:Frame)
	{
		timeout.update();
		super.update(frame);
	}

	override function render(opts:CursorRenderOpts)
	{
		var end = opts.end.toPx();
		if (end.x == targetBm.x && end.y == targetBm.y)
		{
			return;
		}

		targetBm.x = end.x;
		targetBm.y = end.y;
		targetBm.visible = true;
		timeout.reset();
		lineOb.removeChildren();

		var isBlocked = false;

		// opts.line.each((p, idx) ->
		// {
		// 	if (idx == 0 || idx == opts.line.length - 1)
		// 	{
		// 		return;
		// 	}
		// 	var w = p.asWorld();
		// 	var bm = new Bitmap(TileResources.DOT, lineOb);

		// 	var entities = world.getEntitiesAt(p);
		// 	if (entities.exists((e) -> e.has(Blocker)))
		// 	{
		// 		isBlocked = true;
		// 	}
		// 	var color = world.isVisible(w) ? COLOR_NEUTRAL : COLOR_SHROUD;
		// 	color = isBlocked ? COLOR_DANGER : color;
		// 	var shader = new SpriteShader(color);
		// 	shader.isShrouded = 0;
		// 	bm.addShader(shader);
		// 	var px = w.toPx();
		// 	bm.x = px.x;
		// 	bm.y = px.y;
		// });
	}

	override function handleInput(command:Command)
	{
		if (command.type == CMD_SHOOT)
		{
			tryShoot();
			return;
		}
		super.handleInput(command);
	}

	override function onMouseDown(pos:Coordinate)
	{
		game.commands.push({
			domain: INPUT_DOMAIN_ADVENTURE,
			type: CMD_SHOOT,
			key: KEY_F,
			shift: false,
			ctrl: false,
			alt: false,
		});
	}

	function tryShoot()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ShootEvent(target.toWorld().toIntPoint(), shooter));
	}

	public override function onDestroy()
	{
		ob.remove();
	}

	function get_weapon():Weapon
	{
		var weapons = shooter.getAll(EquipmentSlot).filter((s) ->
		{
			if (s.isEmpty || s.isExtraSlot || !s.isPrimary)
			{
				return false;
			}

			var wpn = s.content.get(Weapon);

			if (wpn == null)
			{
				return false;
			}

			return Weapons.Get(wpn.family).isRanged;
		}).map((s) -> s.content.get(Weapon));

		return weapons.first();
	}
}