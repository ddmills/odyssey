package screens.interaction;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.TileResources;
import domain.World;
import domain.components.IsPlayer;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.events.GetInteractionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Object;
import h2d.Text;
import h2d.Tile;
import screens.listSelect.SelectableList;
import shaders.SpriteShader;

typedef ListItem =
{
	entity:Entity,
	ob:Bitmap,
	bullet:Bitmap,
	text:Text,
	isCancel:Bool,
}

class InteractionScreen extends Screen
{
	var interactor:Entity;
	var ob:Object;
	var listOb:Object;
	var list:SelectableList<ListItem>;

	var w = 8;
	var h = 12;

	public function new(interactor:Entity)
	{
		this.interactor = interactor;
		this.inputDomain = INPUT_DOMAIN_DEFAULT;

		ob = new Object();
		listOb = new Object();
		list = new SelectableList([]);
	}

	override function onEnter()
	{
		var entities = world.getEntitiesAt(interactor.pos);
		var interactables = entities.filter((e) ->
		{
			if (e.has(IsPlayer))
			{
				return false;
			}
			var evt = new GetInteractionsEvent(interactor);
			e.fireEvent(evt);

			return evt.interactions.length > 0;
		});

		var i = 0;
		var data = interactables.map((e:Entity) -> makeRow(e, i++));

		data.push(makeRow(null, i, true));

		list.setItems(data);
		ob.addChild(listOb);

		var p = interactor.pos.add(new Coordinate(1, 0, WORLD)).toScreen();
		ob.x = p.x;
		ob.y = p.y;
		renderItems();

		game.render(POPUP, ob);
	}

	override function onDestroy()
	{
		ob.remove();
	}

	override function update(frame:Frame)
	{
		handle(game.commands.next());
	}

	function renderItems()
	{
		list.data.each((li:SelectableListItem<ListItem>) ->
		{
			var col = li.isSelected ? 0xffff00 : 0xf5f5f5;
			li.item.text.color = col.toHxdColor();
			li.item.bullet.tile = li.isSelected ? TileResources.LIST_ARROW : TileResources.LIST_DASH;
			li.item.bullet.getShader(SpriteShader).primary = col.toHxdColor();
		});
	}

	function handle(command:Command)
	{
		if (command == null)
		{
			return;
		}

		switch (command.type)
		{
			case CMD_MOVE_N:
				list.up();
				renderItems();
			case CMD_MOVE_S:
				list.down();
				renderItems();
			case CMD_CANCEL:
				game.screens.pop();
			case _:
		}
	}

	private function makeRow(entity:Entity, i:Int, isCancel = false)
	{
		var tw = (game.TILE_W * game.camera.zoom).floor();
		var th = (game.TILE_H * game.camera.zoom).floor();
		var rowOb = new Bitmap(Tile.fromColor(0x242020, w * tw, th));
		rowOb.y = i * th;

		var bullet = new Bitmap(TileResources.LIST_DASH);
		bullet.addShader(new SpriteShader());
		bullet.x = 8;
		bullet.y = 8;

		var icon = new Bitmap();
		if (entity != null)
		{
			icon = entity.get(Sprite).getBitmapClone();
			icon.scale(game.camera.zoom);
			icon.getShader(SpriteShader).clearBackground = 0;
			icon.getShader(SpriteShader).outline = 0x000000.toHxdColor(0);
			icon.x = tw;
		}
		else
		{
			icon.visible = false;
		}

		var text = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		text.color = 0xf5f5f5.toHxdColor();
		text.y = 8;
		text.x = isCancel ? tw : tw + tw + 8;
		text.setScale(1);
		text.text = isCancel ? 'Cancel' : entity.get(Moniker).displayName;

		var interactive = new Interactive(w * tw, th);
		interactive.onClick = (e) ->
		{
			trace('CLICK');
		}
		interactive.onOver = (e) ->
		{
			list.selectIdx(i);
			renderItems();
		}

		rowOb.addChild(bullet);
		rowOb.addChild(icon);
		rowOb.addChild(text);
		rowOb.addChild(interactive);
		listOb.addChild(rowOb);

		return {
			ob: rowOb,
			text: text,
			bullet: bullet,
			entity: entity,
			isCancel: isCancel,
		};
	}
}
