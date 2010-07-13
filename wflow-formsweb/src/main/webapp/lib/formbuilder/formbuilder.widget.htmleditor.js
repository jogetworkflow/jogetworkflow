var HtmlEditor = TextArea.extend({
    init : function(config){
        this.config = $.extend({
            name : 'htmleditor_{id}'
        }, config);
        this.config.type = "htmleditor";
        this._super(this.config);
    }
})


