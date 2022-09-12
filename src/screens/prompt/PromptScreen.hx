package screens.prompt;

import core.Frame;
import core.Screen;
import core.input.Command;
import data.TextResources;
import data.TileResources;
import h2d.Bitmap;
import h2d.Object;
import h2d.Text;
import h2d.TextInput;
import h2d.Tile;
import screens.elements.Button;

typedef Objects =
{
	root:Object,
	bkg:Bitmap,
	title:Text,
	input:TextInput,
	accept:Button,
	cancel:Button,
}

enum PromptFocus
{
	INPUT;
	ACCEPT;
	CANCEL;
	NONE;
}

class PromptScreen extends Screen
{
	var obs:Objects;

	public var maxTextLength:Int = 14;
	public var onInputChange:(value:String) -> String;
	public var title(get, set):String;

	var BKG_FOCUS = 0x424346;
	var BKG_UNFOCUS = 0x2B2C2E;

	var focus:PromptFocus;

	public function new()
	{
		var root = new Object();
		// var w = ((maxTextLength / 2).ciel() + 1) * game.TILE_W;
		var w = game.TILE_W * 24;
		root.x = game.TILE_W;
		root.y = game.TILE_H;

		var bkg = new Bitmap(Tile.fromColor(game.CLEAR_COLOR, w, game.TILE_H * 6));

		var titleOb = new Text(TextResources.BIZCAT);
		titleOb.color = game.TEXT_COLOR.toHxdColor();
		titleOb.text = 'Input';
		titleOb.x = 0;
		titleOb.y = 0;

		var input = new TextInput(TextResources.BIZCAT);

		var inputBkg = new Bitmap(Tile.fromColor(0x424346, w, game.TILE_H * 1));
		inputBkg.y = game.TILE_H * 2;
		inputBkg.x = 0;

		input.textColor = game.TEXT_COLOR;
		input.text = '';
		input.cursorTile = TileResources.Get(TEXT_CURSOR);
		input.y = game.TILE_H * 2;
		input.x = game.TILE_W_HALF;
		input.inputWidth = w;
		input.onChange = onChange;

		input.onFocus = (_) ->
		{
			focus = INPUT;
			input.textColor = game.TEXT_COLOR_FOCUS;
			inputBkg.tile = Tile.fromColor(BKG_FOCUS, w, game.TILE_H * 1);
			input.cursorIndex = input.text.length;
		}
		input.onFocusLost = (_) ->
		{
			focus = NONE;
			input.textColor = game.TEXT_COLOR;
			inputBkg.tile = Tile.fromColor(BKG_UNFOCUS, w, game.TILE_H * 1);
		}

		var accept = new Button(TextResources.BIZCAT);
		accept.text = 'Accept';
		accept.color = game.TEXT_COLOR;
		accept.focusColor = game.TEXT_COLOR_FOCUS;
		accept.y = game.TILE_H * 4;
		accept.width = w;
		accept.onClick = (_) -> onAccept(obs.input.text);
		accept.onFocus = (_) -> focus = ACCEPT;
		accept.onFocusLost = (_) -> focus = NONE;

		var cancel = new Button(TextResources.BIZCAT);
		cancel.text = 'Cancel';
		cancel.color = game.TEXT_COLOR;
		cancel.focusColor = game.TEXT_COLOR_FOCUS;
		cancel.y = game.TILE_H * 5;
		cancel.width = w;
		cancel.onClick = (_) -> onCancel();
		cancel.onFocus = (_) -> focus = CANCEL;
		cancel.onFocusLost = (_) -> focus = NONE;

		root.addChild(bkg);
		root.addChild(titleOb);
		root.addChild(inputBkg);
		root.addChild(input);
		root.addChild(accept);
		root.addChild(cancel);

		obs = {
			root: root,
			bkg: bkg,
			title: titleOb,
			input: input,
			accept: accept,
			cancel: cancel,
		}
		game.render(HUD, root);
	}

	override function update(frame:Frame)
	{
		handleCmd(game.commands.next());
	}

	function handleCmd(command:Command)
	{
		if (command == null)
		{
			return;
		}

		if (command.type == CMD_CYCLE_INPUT || command.type == CMD_MOVE_S)
		{
			switch focus
			{
				case INPUT:
					obs.accept.focus();
				case ACCEPT:
					obs.cancel.focus();
				case CANCEL:
					obs.input.focus();
				case NONE:
					obs.input.focus();
			}
		}

		if (command.type == CMD_CYCLE_INPUT_REVERSE || command.type == CMD_MOVE_N)
		{
			switch focus
			{
				case INPUT:
					obs.cancel.focus();
				case ACCEPT:
					obs.input.focus();
				case CANCEL:
					obs.accept.focus();
				case NONE:
					obs.input.focus();
			}
		}

		if (command.type == CMD_CANCEL)
		{
			obs.cancel.focus();
			onCancel();
		}

		if (command.type == CMD_CONFIRM)
		{
			if (focus == INPUT)
			{
				obs.accept.focus();
			}
			if (focus == ACCEPT)
			{
				onAccept(obs.input.text);
			}
			if (focus == CANCEL)
			{
				onCancel();
			}
		}
	}

	function onChange()
	{
		var value = obs.input.text;

		if (value.length > maxTextLength)
		{
			trace(value, value.length);
			value = value.substr(0, maxTextLength);

			obs.input.text = value;
		}

		if (onInputChange != null)
		{
			obs.input.text = onInputChange(value);
			obs.input.cursorIndex = obs.input.text.length;
		}
	}

	override function onEnter()
	{
		obs.root.visible = true;
		obs.input.focus();
	}

	override function onSuspend()
	{
		obs.root.visible = false;
	}

	function get_title():String
	{
		return obs.title.text;
	}

	function set_title(value:String):String
	{
		return obs.title.text = value;
	}

	public dynamic function onAccept(value:String) {}

	public dynamic function onCancel()
	{
		game.screens.pop();
	}

	override function onDestroy()
	{
		obs.root.remove();
	}
}
