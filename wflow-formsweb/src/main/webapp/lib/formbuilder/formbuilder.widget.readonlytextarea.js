var ReadOnlyTextArea = TextArea.extend({
    init : function(config){
        this.config = $.extend({
            name : 'readonlytextarea_{id}',
            customStyle: 'background:#efefef',
            disabled: true
        }, config);
        this.config.type = "readonlytextarea";
        this._super(this.config);
    }
})
