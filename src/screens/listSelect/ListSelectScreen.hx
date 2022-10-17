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
	?getIcon:() -> Bitmap,
	?detail:String,
	onSelect:() -> Void,
}

typedef ListRow =
{
	ob:Bitmap,
	bullet:Bitmap,
	text:Text,
	detail:Text,
	data:ListItem,
	isCancel:Bool,
}

class ListSelectScreen extends Screen
{
	private var _pos:Coordinate;
	var w = 24;

	var ob:Object;
	var listOb:Object;
	var items:Array<ListItem>;
	var list:SelectableList<ListRow>;

	private var _cancelText:String;
	var cancelText(get, set):String;
	var includeCancel:Bool = true;

	public var title(get, set):String;

	private var _targetPos:Null<Coordinate>;
	var targetOb:Bitmap;
	var titleOb:Text;
	var cancelRow:ListRow;

	public var onCancel:() -> Void;
	public var pos(get, set):Coordinate;
	public var targetPos(get, set):Null<Coordinate>;

	public function new(items:Array<ListItem>)
	{
		this.items = items;
		ob = new Object();
		listOb = new Object();
		listOb.y = 16;
		list = new SelectableList([]);
		onCancel = () -> game.screens.pop();
		_pos = new Coordinate(16, 16, SCREEN);

		var titleBkg = new Bitmap(Tile.fromColor(game.CLEAR_COLOR, w * game.TILE_W, game.TILE_H));
		ob.addChild(titleBkg);

		titleOb = new Text(TextResources.BIZCAT);
		titleOb.color = game.TEXT_COLOR.toHxdColor();
		titleOb.text = 'Select';

		_cancelText = 'Cancel';

		ob.addChild(titleOb);

		targetOb = new Bitmap(TileResources.Get(CURSOR), ob);
		var shader = new SpriteShader(Game.instance.TEXT_COLOR_FOCUS);
		shader.isShrouded = 0;
		shader.clearBackground = 0;
		targetOb.addShader(shader);
		targetOb.visible = false;

		game.render(OVERLAY, targetOb);
	};

	function setItems(items:Array<ListItem>)
	{
		this.items = items;
		listOb.removeChildren();
		var i = 0;
		var rows = items.map((d) -> makeRow(d, i++));

		if (includeCancel)
		{
			cancelRow = makeRow({
				title: _cancelText,
				onSelect: doCancel,
			}, i, true);
			rows.push(cancelRow);
		}

		list.setItems(rows);

		updateRows();
	}

	override function onEnter()
	{
		setItems(items);
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
			var col = li.isSelected ? game.TEXT_COLOR_FOCUS : game.TEXT_COLOR;
			li.item.text.color = col.toHxdColor();
			li.item.detail.color = col.toHxdColor();
			li.item.bullet.tile = li.isSelected ? TileResources.Get(LIST_ARROW) : TileResources.Get(LIST_DASH);
			li.item.bullet.getShader(SpriteShader).primary = col.toHxdColor();
		});
	}

	function makeRow(item:ListItem, idx:Int, isCancel = false):ListRow
	{
		var tw = game.TILE_W * 2;
		var th = game.TILE_H * 2;
		var fontHeight = 16;
		var fontOffset = ((th - fontHeight) / 2).floor();
		var left = 0;
		var rowOb = new Bitmap(Tile.fromColor(game.CLEAR_COLOR, w * game.TILE_W, th));
		rowOb.y = idx * th;
		listOb.addChild(rowOb);

		var bullet = new Bitmap(TileResources.Get(LIST_DASH));
		bullet.addShader(new SpriteShader());
		bullet.x = left;
		bullet.y = fontOffset;
		left += game.TILE_W;
		rowOb.addChild(bullet);

		if (item.getIcon != null)
		{
			var icon = item.getIcon();
			icon.x = left;
			icon.y = 0;
			icon.scale(2);
			left += tw;
			rowOb.addChild(icon);
		}

		var text = new Text(TextResources.BIZCAT);
		text.color = game.TEXT_COLOR.toHxdColor();
		left += 8;
		text.y = fontOffset;
		text.x = left;
		text.setScale(1);
		text.text = item.title;
		rowOb.addChild(text);

		var detail = new Text(TextResources.BIZCAT);
		detail.color = game.TEXT_COLOR.toHxdColor();
		left += game.TILE_W * 12;
		detail.y = fontOffset;
		detail.x = left;
		detail.setScale(1);
		detail.text = item.detail == null ? '' : item.detail;
		rowOb.addChild(detail);

		var interactive = new Interactive(w * game.TILE_W, th);
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
		rowOb.addChild(interactive);

		return {
			ob: rowOb,
			text: text,
			detail: detail,
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

	function get_title():String
	{
		return titleOb.text;
	}

	function set_title(value:String):String
	{
		return titleOb.text = value;
	}

	function get_cancelText():String
	{
		return _cancelText;
	}

	function set_cancelText(value:String):String
	{
		_cancelText = value;

		if (cancelRow != null)
		{
			cancelRow.text.text = _cancelText;
		}

		return value;
	}
}
