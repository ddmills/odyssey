package screens.shooting;

import common.algorithm.Bresenham;
import common.struct.Coordinate;
import common.util.Timeout;
import core.Frame;
import core.input.Command;
import data.ColorKey;
import data.TextResources;
import data.TileResources;
import domain.GameMath;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Highlight;
import domain.components.IsDestroyed;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Sprite;
import domain.components.Visible;
import domain.components.Weapon;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import ecs.Query;
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

	var query:Query;
	var highlights:Query;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;
		super();

		inputDomain = INPUT_DOMAIN_ADVENTURE;

		targetShader = new SpriteShader(ColorKey.C_WHITE_1);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;
		ob = new h2d.Object();
		hud = new h2d.Object();
		targetBm = new Bitmap(TileResources.Get(CURSOR), ob);
		targetBm.addShader(targetShader);

		hitChanceTxt = new Text(TextResources.BIZCAT);
		hitChanceTxt.color = game.TEXT_COLOR.toHxdColor();
		hitChanceTxt.x = 16;
		hitChanceTxt.y = 16;

		hud.addChild(hitChanceTxt);

		timeout = new Timeout(.25);
		timeout.onComplete = blink;

		query = new Query({
			all: [Visible, Health, IsEnemy],
			none: [IsInventoried, IsDestroyed],
		});
		highlights = new Query({
			all: [Highlight],
		});
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

		world.updateSystems();

		highlights.each((e:Entity) ->
		{
			if (!query.has(e))
			{
				e.remove(Highlight);
			}
		});

		query.each((e:Entity) ->
		{
			if (!e.has(Highlight))
			{
				e.add(new Highlight());
			}
		});

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}

		var defender = world.getEntitiesAt(target).find((e) -> e.has(Health));

		if (defender != null && weapon != null)
		{
			var health = defender.get(Health).toString();
			var chance = (GameMath.GetHitChance(shooter, defender, weapon, true) * 100).round();
			var dist = GameMath.GetTargetDistance(shooter.pos.toIntPoint(), defender.pos.toIntPoint());
			var mod = GameMath.GetRangePenalty(shooter.pos.toIntPoint(), defender.pos.toIntPoint(), weapon.range);
			hitChanceTxt.text = '$chance% ($dist/$mod) $health';
			var pos = target.sub(new Coordinate(0, .5)).toScreen();
			hitChanceTxt.x = pos.x;
			hitChanceTxt.y = pos.y;
			hitChanceTxt.visible = true;
			var highlight = defender.get(Highlight);
			if (highlight != null)
			{
				highlight.color = ColorKey.C_RED_1;
			}
		}
		else
		{
			hitChanceTxt.visible = false;
		}

		render({
			start: start,
			end: target,
			line: Bresenham.getLine(start.toIntPoint(), target.toIntPoint()),
		});
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
		var highlights = new Query({
			all: [Highlight],
		});

		highlights.each((entity:Entity) ->
		{
			entity.remove(Highlight);
		});
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
