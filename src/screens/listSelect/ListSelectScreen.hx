package screens.listSelect;

import common.struct.Coordinate;
import core.Frame;
import core.Game;
import core.Screen;
import core.input.Command;
import data.TextResources;
import data.TileResources;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Object;
import h2d.Text;
import h2d.Tile;
import screens.listSelect.SelectableList.SelectableListItem;
import shaders.SpriteShader;

typedef ListItem =
{
	title:String,
	getIcon:() -> Null<Bitmap>,
	onSelect:() -> Void,
}

typedef ListRow =
{
	ob:Bitmap,
	bullet:Bitmap,
	text:Text,
	data:ListItem,
	isCancel:Bool,
}

class ListSelectScreen extends Screen
{
	private var _pos:Coordinate;
	var ob:Object;
	var listOb:Object;
	var items:Array<ListItem>;
	var list:SelectableList<ListRow>;

	var cancelText:String = 'Cancel';
	var includeCancel:Bool = true;

	var _targetPos:Null<Coordinate>;
	var targetOb:Bitmap;

	public var onCancel:() -> Void;
	public var pos(get, set):Coordinate;
	public var targetPos(get, set):Null<Coordinate>;

	public function new(items:Array<ListItem>)
	{
		this.items = items;
		ob = new Object();
		listOb = new Object();
		list = new SelectableList([]);
		onCancel = () -> game.screens.pop();
		_pos = new Coordinate(16, 16, SCREEN);

		targetOb = new Bitmap(TileResources.CURSOR, ob);
		var shader = new SpriteShader(0xd4d4d4);
		shader.isShrouded = 0;
		shader.clearBackground = 0;
		targetOb.addShader(shader);
		targetOb.visible = false;

		game.render(OVERLAY, targetOb);
	};

	override function onEnter()
	{
		var i = 0;
		var rows = items.map((d) -> makeRow(d, i++));

		if (includeCancel)
		{
			rows.push(makeRow({
				title: cancelText,
				onSelect: doCancel,
				getIcon: () -> null,
			}, i, true));
		}

		list.setItems(rows);

		updateRows();

		ob.addChild(listOb);

		ob.x = pos.x;
		ob.y = pos.y;

		game.render(POPUP, ob);
	}

	override function update(frame:Frame)
	{
		ob.x = pos.x;
		ob.y = pos.y;
		handleCmd(game.commands.next());
	}

	function handleCmd(command:Command)
	{
		if (command == null)
		{
			return;
		}

		switch (command.type)
		{
			case CMD_MOVE_N:
				list.up();
				updateRows();
			case CMD_MOVE_S:
				list.down();
				updateRows();
			case CMD_WAIT:
			case CMD_CONFIRM:
				onConfirm();
			case CMD_CANCEL:
				doCancel();
			case _:
		}
	}

	function doCancel()
	{
		onCancel();
	}

	function doSelect()
	{
		list.selected.data.onSelect();
	}

	function onConfirm()
	{
		if (list.selected.isCancel)
		{
			doCancel();
		}
		else
		{
			doSelect();
		}
	}

	function updateRows()
	{
		list.data.each((li:SelectableListItem<ListRow>) ->
		{
			var col = li.isSelected ? 0xffff00 : 0xf5f5f5;
			li.item.text.color = col.toHxdColor();
			li.item.bullet.tile = li.isSelected ? TileResources.LIST_ARROW : TileResources.LIST_DASH;
			li.item.bullet.getShader(SpriteShader).primary = col.toHxdColor();
		});
	}

	function makeRow(item:ListItem, idx:Int, isCancel = false):ListRow
	{
		var w = 8;
		var tw = game.TILE_W;
		var th = game.TILE_H;
		var left = 0;
		var rowOb = new Bitmap(Tile.fromColor(Game.instance.CLEAR_COLOR, w * tw, th));
		rowOb.y = idx * th;

		var bullet = new Bitmap(TileResources.LIST_DASH);
		bullet.addShader(new SpriteShader());
		bullet.x = left;
		bullet.y = 0;
		left += tw;

		var icon = item.getIcon();
		if (icon != null)
		{
			icon.x = left + 8;
			icon.y = 0;
			left += 8 + tw;
			rowOb.addChild(icon);
		}

		var text = new Text(TextResources.BIZCAT);
		text.color = 0xf5f5f5.toHxdColor();
		left += 8;
		text.y = 0;
		text.x = left;
		text.setScale(1);
		text.text = item.title;

		var interactive = new Interactive(w * tw, th);
		interactive.onClick = (e) ->
		{
			list.selectIdx(idx);
			updateRows();
			onConfirm();
		}
		interactive.onOver = (e) ->
		{
			list.selectIdx(idx);
			updateRows();
		}

		rowOb.addChild(bullet);

		rowOb.addChild(text);
		rowOb.addChild(interactive);
		listOb.addChild(rowOb);

		return {
			ob: rowOb,
			text: text,
			bullet: bullet,
			isCancel: isCancel,
			data: item,
		};
	}

	override function onDestroy()
	{
		ob.remove();
		targetOb.remove();
	}

	override function onSuspend()
	{
		ob.visible = false;
	}

	override function onResume()
	{
		ob.visible = true;
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var s = value.toScreen();

		ob.x = s.x;
		ob.y = s.y;

		return s;
	}

	inline function get_pos():Coordinate
	{
		return _pos;
	}

	function get_targetPos():Null<Coordinate>
	{
		return _targetPos;
	}

	function set_targetPos(value:Null<Coordinate>):Null<Coordinate>
	{
		if (value != null)
		{
			var p = value.toWorld().floor().toPx();
			targetOb.visible = true;
			targetOb.x = p.x;
			targetOb.y = p.y;
		}
		else
		{
			targetOb.visible = false;
		}
		return _targetPos = value;
	}
}
