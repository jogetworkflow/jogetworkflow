var HiddenField = TextField.extend({
    init : function(config){
        this.config = $.extend({
            name : 'hidden_{id}',
            size: 20,
            customStyle: 'width:auto',
            label: 'Hidden Field',
            description: ''
        }, config);
        this.config.type = "hiddenfield";
        this._super(this.config);
    }
})

