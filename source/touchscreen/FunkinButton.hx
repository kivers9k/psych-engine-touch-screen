package touchscreen;

import flixel.util.FlxSignal;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.IFlxInput;
import flixel.input.FlxInput;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

enum abstract ButtonStatus(Int) to Int {
    var NORMAL = 0;
    var HIGHLIGHT = 1;
    var PRESSED = 2;
}

class FunkinButton extends FlxSprite {
    public var pressed(get, never):Bool;
    public var released(get, never):Bool;
    public var justPressed(get, never):Bool;
    public var justReleased(get, never):Bool;
    
    public var onDown:FlxSignal = new FlxSignal();
    public var onUp:FlxSignal = new FlxSignal();
    public var onOver:FlxSignal = new FlxSignal();
    public var onOut:FlxSignal = new FlxSignal();

    var status:ButtonStatus;

    var input:FlxInput<Int>;
    var currentInput:IFlxInput;

    public function new(?x:Float, ?y:Float) {
        super(x, y);

        makeGraphic(80, 20, 0xff808080);
        scrollFactor.set();

        input = new FlxInput(0);
    }

    override public function destroy() {
        input = null;
        currentInput = null;

        super.destroy();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (visible) {
            var overlapFound = checkMouseOverlap();
            if (!overlapFound) {
                overlapFound = checkTouchOverlap();
            }

            if (currentInput != null && currentInput.justReleased && overlapFound) {
                onUpHandler();
            }

            if (status != NORMAL && (!overlapFound || currentInput != null && currentInput.justReleased)) {
                onOutHandler();
            }
        }

        input.update();
    }

    function checkMouseOverlap():Bool {
        var overlap = false;

        for (cam in getCameras()) {
            var mouse = FlxMouseButton.getByID(FlxMouseButtonID.LEFT);
            if (overlapsPoint(FlxG.mouse.getWorldPosition(cam, _point), true, cam)) {
                inputState(mouse);
                overlap = true;
            }
        }

        return overlap;
    }

    function checkTouchOverlap():Bool {
        var overlap = false;

        for (cam in getCameras()) {
            for (touch in FlxG.touches.list) {
                if (overlapsPoint(touch.getWorldPosition(cam, _point), true, cam)) {
                    inputState(touch);
                    overlap = true;
                }
            }
        }

        return overlap;
    }

    function inputState(inputs:IFlxInput) {
        if (inputs.justPressed) {
            currentInput = inputs;
            onDownHandler();
        } else if (status == NORMAL) {
            if (inputs.pressed) {
                onDownHandler();
            } else {
                onOverHandler();
            }
        }
    }

    function onDownHandler() {
        status = PRESSED;
        input.press();
        onDown.dispatch();
    }

    function onUpHandler() {
        status = HIGHLIGHT;
        input.release();
        currentInput = null;
        onUp.dispatch();
    }

    function onOverHandler() {
        status = HIGHLIGHT;
        onOver.dispatch();
    }

    function onOutHandler() {
        status = NORMAL;
        input.release();
        onOut.dispatch();
    }

    inline function get_pressed():Bool {
        return input.pressed;
    }

    inline function get_released():Bool {
        return input.released;
    }

    inline function get_justPressed():Bool {
        return input.justPressed;
    }

    inline function get_justReleased():Bool {
        return input.justReleased;
    }
}