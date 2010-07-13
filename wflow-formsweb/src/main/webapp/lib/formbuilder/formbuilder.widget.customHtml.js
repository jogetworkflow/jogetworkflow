var CustomHtml = Widget.extend({
    init : function(config){
        this.config = $.extend({
            id : '{type}_{id}',
            type : 'customHtml',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'customHtml_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            disabled : false,
            required : false,
            inputValidation : '',
            inputValidationMessage : '',
            value : '',
            render : false
        }, config);
        this._super(this.config);
    },

    getInputTpl : function(){
        var t = null;

        if(this.config.render && this.config.value != ''){
            t = new Template('<div id="{type}_{id}">{value}</div>');
        }else{
            t = new Template('<textarea type="{type}" class="{cssClass}" name="{name}" {disabled} columnName="{columnName}" variableName="{variableName}" inputValidation="{inputValidation}" inputValidationMessage="{inputValidationMessage}" id="{type}_{id}" cols="30">{value}</textarea>');
            this.config.value = this.config.value.replace(/<\/textarea>/g, "<!--/textarea-->");
        }

        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            type : this.config.type,
            value : this.config.value,
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            inputValidation : this.config.inputValidation,
            inputValidationMessage : this.config.inputValidationMessage,
            id : '{id}'
        });

        return this.inputTpl;
    }
})
