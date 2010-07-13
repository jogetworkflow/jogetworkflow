var TextArea = Widget.extend({
    init : function(config){
        this.config = $.extend({
            id : '{type}_{id}',
            type : 'textarea',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'textarea_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            disabled : false,
            required : false,
            inputValidation : '',
            inputValidationMessage : '',
            customStyle : '',
            value : ''
        }, config);
        this._super(this.config);
    },

    getInputTpl : function(){
        var t = new Template('<textarea type="{type}" class="{cssClass}" style="{customStyle}" name="{name}" {disabled} columnName="{columnName}" variableName="{variableName}" inputValidation="{inputValidation}" inputValidationMessage="{inputValidationMessage}" id="{type}_{id}" cols="30">{value}</textarea>');
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            customStyle : this.config.customStyle,
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
