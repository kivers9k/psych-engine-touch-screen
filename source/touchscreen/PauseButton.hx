package touchscreen;

import flixel.util.FlxSignal;
import flixel.tweens.*;

class PauseButton extends FunkinButton {
    public var onPaused:FlxSignal = new FlxSignal();

    public function new(?x:Float, ?y:Float) {
        super(x, y);

        frames = Paths.getSparrowAtlas('pauseButton', null, false);
        animation.addByIndices('idle', 'pause', [0], "", 24, false);
        animation.addByIndices('hold', 'pause', [5], "", 24, false);
        animation.addByIndices('confirm', 'pause', [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], "", 24, false);
        animation.play('idle');

        scale.set(0.8, 0.8);
        updateHitbox();

        scrollFactor.set();

        alpha = 0.5;

        var confirming:Bool = false;
        
        onDown.add(function() {
            if (confirming) return;
            animation.play('hold');
        });

        onUp.add(function() {
            if (confirming) return;
            confirming = true;
            animation.play('confirm');
            FlxTween.tween(this, {alpha: 0}, 2, {ease: FlxEase.quartOut});
        });        
        
        onOver.add(function() {
            FlxTween.tween(this, {alpha: 1}, 0.7, {ease: FlxEase.cubeOut});
        });
        
        onOut.add(function() {
            FlxTween.tween(this, {alpha: 0.5}, 0.7, {ease: FlxEase.cubeOut});
        });

        animation.onFinish.add(function(name:String) {
            if (name != 'confirm') return;
            onPaused.dispatch();
            confirming = false;
            animation.play('idle');
        });
    }
}