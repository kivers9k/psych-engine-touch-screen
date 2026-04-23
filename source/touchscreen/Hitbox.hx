package touchscreen;

import openfl.geom.Matrix;
import flixel.group.FlxSpriteContainer;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.display.Shape;

class Hitbox extends FlxSpriteContainer {
    public var hitboxs:Array<FunkinButton> = [];
    public var hints:Array<FlxSprite> = [];
    
    public var hideHint(default, set):Bool = false;
    
    var hbColor:Array<FlxColor> = [
        0xffdb64c1,
        0xff00eeff,
        0xff00ff11,
        0xffff0000
    ];

    public function new() {
        super();

        var i:Int = 0;
        for (t in hbColor) {
            var width:Int = Std.int(FlxG.width / hbColor.length);
            
            var hitbox:FunkinButton = new FunkinButton(width * i, 0);
            switch (ClientPrefs.data.hitboxStyle) {
                case 'solid':
                    t.alphaFloat = 0.4;
                    hitbox.makeGraphic(width, FlxG.height, t);
                case 'gradient':
                    hitbox.loadGraphic(new HitboxGraphic(width, FlxG.height, t));
            }
            hitboxAlpha(hitbox);
            add(hitbox);
            
            var sprite = new FlxSprite(width * i, 0, new HitboxGraphic(width, FlxG.height, t, true));
            add(sprite);

            hitboxs.push(hitbox);
            hints.push(sprite);

            i ++;
        }

        scrollFactor.set();
    }

    function hitboxAlpha(hitbox:FunkinButton) {
        hitbox.alpha = 0;
        hitbox.onDown.add(()-> hitbox.alpha = 1);
        hitbox.onUp.add(()-> hitbox.alpha = 0);
        hitbox.onOver.add(()-> hitbox.alpha = 0);
        hitbox.onOut.add(()-> hitbox.alpha = 0);
    }

    private function set_hideHint(value:Bool):Bool {
        for (t in hints) {
            t.visible = value;
        }
        return value;
    }
}

class HitboxGraphic extends FlxGraphic {
    public function new(w:Int, h:Int, color:Int, ?hint:Bool = false) {
        var shape:Shape = new Shape();
        if (hint) {
            var colors:FlxColor = color;
            colors.getDarkened(0.5);

            shape.graphics.beginFill(colors, 0.7);
            shape.graphics.drawRect(0, 0, w, h);
            shape.graphics.drawRect(2, 2, w - 4, h - 4);
            shape.graphics.endFill();
        } else {
            var matrix = new Matrix();
            matrix.createGradientBox(w, h, 90);
 
            shape.graphics.beginGradientFill(LINEAR, [color, color], [0, 0.7], [0x50, 0xff], matrix);
            shape.graphics.drawRect(0, 0, w, h);
            shape.graphics.endFill();
        }

        var bd:BitmapData = new BitmapData(w, h, true, 0x0);
        bd.draw(shape);

        super('hitboxs', bd, true);
    }
}