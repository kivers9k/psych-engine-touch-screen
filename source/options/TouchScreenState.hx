package options;

class TouchScreenState extends BaseOptionsMenu {
    public function new() {
        title = 'Touch Screen';
		rpcTitle = 'Screen Touch Settings Menu'; //for Discord Rich Presence

        var option:Option = new Option('Touch Screen Mode',
			'If checked, you can use touch screen mode on touch screen pc now',
			'touchScreen',
			'bool'
		);
		addOption(option);

        var option:Option = new Option('Hide Hint',
			'If checked, hitboxs hint is hidden',
			'hideHint',
			'bool'
		);
		addOption(option);

		var option:Option = new Option('Hitbox Style:',
			'Choose hitbox style you perfer',
			'hitboxStyle',
			'string',
			['solid', 'gradient']
		);
		addOption(option);

        super();
    }
}