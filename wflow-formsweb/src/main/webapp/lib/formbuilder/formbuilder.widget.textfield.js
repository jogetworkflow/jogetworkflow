var TextField = Widget.extend({
    init : function(config){
        this.config = $.extend({
            id : '{type}_{id}',
            type : 'text',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'text_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            disabled : false,
            required : false,
            value : '',
            inputValidation : '',
            inputValidationMessage : '',
            ignoreVariableIfEmpty : 'false',
            customStyle : '',
            size : 50
        }, config);
        this._super(this.config);
    },

    getInputTpl : function(){
        var t = new Template('<input style="width: 100%; {customStyle}" class="{cssClass}" name="{name}" {readonly} {disabled} columnName="{columnName}" variableName="{variableName}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" inputValidation="{inputValidation}" inputValidationMessage="{inputValidationMessage}" id="{type}_{id}" type="{type}" size="{size}" value="{value}" />');
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            type : this.config.type,
            customStyle : this.config.customStyle,
            size : this.config.size,
            value : this.config.value,
            readonly: (this.config.readonly) ? 'readonly="true"' : '',
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            inputValidation : this.config.inputValidation,
            inputValidationMessage : this.config.inputValidationMessage,
            ignoreVariableIfEmpty : this.config.ignoreVariableIfEmpty,
            id : '{id}'
        });

        return this.inputTpl;
    }
})
