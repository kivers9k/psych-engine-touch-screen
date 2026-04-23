package touchscreen;

import flixel.util.FlxSignal;
import flixel.tweens.*;

class BackButton extends FunkinButton {
    public var onConfirmStart:FlxSignal = new FlxSignal();
    public var onConfirmEnd:FlxSignal = new FlxSignal();
    
    var confirming:Bool = false;
    
    public function new(?X:Float, ?Y:Float) {
        super(X, Y);

        frames = Paths.getSparrowAtlas('backButton', null, false);
        animation.addByIndices('idle', 'back', [0], "", 24, false);
        animation.addByIndices('hold', 'back', [5], "", 24, false);
        animation.addByIndices('confirm', 'back', [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], "", 24, false);
        animation.play("idle");

        scale.set(0.7, 0.7);
        updateHitbox();

        scrollFactor.set();

        alpha = 0.5;

        onDown.add(playHoldAnimation);
        onUp.add(playConfirmAnimation);
        onOver.add(playHoldAnimation);
        onOut.add(playIdleAnimation);
    }

    function playIdleAnimation() {
        if (confirming) return;

        animation.play('idle');
        FlxTween.tween(this, {alpha: 0.5}, 0.7, {ease: FlxEase.cubeOut});
    }

    function playHoldAnimation() {
        if (confirming) return;
        
        animation.play('hold');
        FlxTween.tween(this, {alpha: 1}, 0.7, {ease: FlxEase.cubeOut});
    }

    function playConfirmAnimation() {
        if (confirming) {
            return;
        }

        confirming = true;
        
        animation.play('confirm');
        onConfirmStart.dispatch();

        animation.onFinish.addOnce(function(name:String) {
            if (name != 'confirm') return;
            onConfirmEnd.dispatch();
            confirming = false;
        });    
    }
}