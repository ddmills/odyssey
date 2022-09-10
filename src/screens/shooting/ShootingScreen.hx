package screens.shooting;

import common.struct.Coordinate;
import common.util.Timeout;
import core.Frame;
import core.input.Command;
import data.TextResources;
import data.TileResources;
import domain.GameMath;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Weapon;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Text;
import screens.cursor.CursorScreen;
import shaders.SpriteShader;

class ShootingScreen extends CursorScreen
{
	var shooter:Entity;
	var hud:h2d.Object;
	var ob:h2d.Object;
	var targetBm:h2d.Bitmap;
	var targetShader:SpriteShader;
	var timeout:Timeout;
	var isBlinking:Bool = false;
	var weapon(get, never):Weapon;
	var hitChanceTxt:Text;

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
		hud = new h2d.Object();
		targetBm = new Bitmap(TileResources.Get(CURSOR), ob);
		targetBm.addShader(targetShader);

		hitChanceTxt = new Text(TextResources.BIZCAT);
		hitChanceTxt.text = 'Test';
		hitChanceTxt.color = 0xf5f5f5.toHxdColor();
		hitChanceTxt.x = 16;
		hitChanceTxt.y = 16;

		hud.addChild(hitChanceTxt);

		timeout = new Timeout(.25);
		timeout.onComplete = blink;
	}

	override function onEnter()
	{
		super.onEnter();
		game.render(HUD, hud);
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

		var defender = world.getEntitiesAt(target).find((e) -> e.has(Health));

		if (defender != null)
		{
			var health = defender.get(Health).toString();
			var chance = GameMath.GetHitChance(shooter, defender, weapon, true) * 100;

			var dist = GameMath.GetTargetDistance(shooter.pos.toIntPoint(), defender.pos.toIntPoint());
			var mod = GameMath.GetRangePenalty(shooter.pos.toIntPoint(), defender.pos.toIntPoint(), weapon.range);
			hitChanceTxt.text = '$chance% ($dist/$mod) $health';
			var pos = target.sub(new Coordinate(0, .5)).toScreen();
			hitChanceTxt.x = pos.x;
			hitChanceTxt.y = pos.y;
			hitChanceTxt.visible = true;
		}
		else
		{
			hitChanceTxt.visible = false;
		}
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
	}

	override function handleInput(command:Command)
	{
		if (command.type == CMD_SHOOT)
		{
			tryShoot();
			return;
		}
		if (command.type == CMD_RELOAD)
		{
			tryReload();
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

	function tryReload()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ReloadEvent(shooter));
	}

	public override function onDestroy()
	{
		ob.remove();
		hud.remove();
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
