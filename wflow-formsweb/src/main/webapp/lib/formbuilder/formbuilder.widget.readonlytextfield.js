var ReadOnlyTextField = TextField.extend({
    init : function(config){
        this.config = $.extend({
            name : 'readonlytext_{id}',
            customStyle: 'width:100%;background:#efefef',
            readonly: true
        }, config);
        this.config.type = "readonlytext";
        this._super(this.config);
    }
})

