class Main extends hxd.App {
	var navigator:h2d.Bitmap;
	var ship:h2d.Bitmap;
	var square:h2d.Bitmap;
	var squareDirX = 1;
	var fui:h2d.Flow;

	var blurFilter = new h2d.filter.Blur(25, 2, 1);
	var glowFilter = new h2d.filter.Glow(255, 1, 25, 1, 10, true);

	override function init() {
		fui = new h2d.Flow(s2d);
		fui.x = 300;
		fui.layout = Vertical;
		fui.verticalSpacing = 5;
		fui.padding = 10;

		// web safe
		hxd.Res.initEmbed();

		var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello Gamedev!";

		ship = new h2d.Bitmap(hxd.Res.player.toTile());
		ship.x = 100;
		ship.y = 100;
		ship.blendMode = h2d.BlendMode.Add;
		s2d.add(ship, 0);

		navigator = new h2d.Bitmap(hxd.Res.navigator.toTile());
		navigator.x = 132;
		navigator.y = 132;
		navigator.tile.dx = -32;
		navigator.tile.dy = -32;
		navigator.blendMode = h2d.BlendMode.Add;
		s2d.add(navigator, 0);

		square = new h2d.Bitmap(hxd.Res.square.toTile());
		square.x = 32;
		square.y = 132;
		square.tile.dx = -32;
		square.tile.dy = -32;
		square.blendMode = h2d.BlendMode.Add;
		s2d.add(square, 0);

		var bloomFilter = new h2d.filter.Bloom(100, 2, 10);

		s2d.blendMode = h2d.BlendMode.AlphaMultiply;
		var g = new h2d.Graphics(s2d);
		g.filter = new h2d.filter.Group([blurFilter, glowFilter]);
		g.blendMode = h2d.BlendMode.Screen;

		g.lineStyle(4, 199, .7);
		g.moveTo(250, 250);
		g.lineTo(350, 350);
		g.lineStyle(4, 197, .8);
		g.moveTo(350, 250);
		g.lineTo(250, 350);

		g.lineStyle(4, 199, .7);
		g.moveTo(300, 250);
		g.lineTo(300, 350);
		g.lineStyle(4, 197, .8);
		g.moveTo(250, 300);
		g.lineTo(350, 300);

		g.endFill();

		addSlider("Blur Radius", function() return blurFilter.radius, function(s) blurFilter.radius = s, 0, 50);
		addSlider("Blur Gain", function() return blurFilter.gain, function(s) blurFilter.gain = s, 0, 1);
		addSlider("Blur Quality", function() return blurFilter.quality, function(s) blurFilter.quality = s, 0, 50);
		addSlider("Blur Linear", function() return blurFilter.linear, function(s) blurFilter.linear = s, 0, 50);

		addSlider("Glow Color", function() return glowFilter.color, function(s) glowFilter.color = Std.int(s), 0, 255);
		addSlider("Glow Alpha", function() return glowFilter.alpha, function(s) glowFilter.alpha = s, 0, 1);
		addSlider("Glow Rasdius", function() return glowFilter.radius, function(s) glowFilter.radius = s, 0, 50);
		addSlider("Glow Quality", function() return glowFilter.quality, function(s) glowFilter.quality = s, 0, 50);
	}

	override function update(dt:Float) {
		square.rotation += 0.05;
		square.x += 1 * squareDirX;

		if (square.x >= 235) {
			squareDirX = -squareDirX;
		} else if (square.x <= 31) {
			squareDirX = -squareDirX;
		}

		navigator.rotation += 0.025;
	}

	static function main() {
		new Main();
	}

	function getFont() {
		return hxd.res.DefaultFont.get();
	}

	function addSlider(label:String, get:Void->Float, set:Float->Void, min:Float = 0., max:Float = 1.) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(getFont(), f);
		tf.text = label;
		tf.maxWidth = 70;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(getFont(), f);

		tf.text = "" + hxd.Math.fmt(sli.value);

		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};

		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);

			if (Math.isNaN(v)) {
				return;
			}

			sli.value = v;
			set(v);
		};

		return sli;
	}
}
