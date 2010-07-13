var FileUpload = TextField.extend({
    init : function(config){
        this.config = $.extend({
            name : 'file_{id}',
            size: 20,
            customStyle: 'width:auto'
        }, config);
        this.config.type = "file";
        this._super(this.config);
    }
})

