var DatePicker = TextField.extend({
    init : function(config){
        this.config = $.extend({
            name : 'datepicker_{id}',
            size: 10,
            customStyle: 'width:auto',
            dateFormat: 'dd-M-yy'
        }, config);
        this.config.type = "datepicker";
        this._super(this.config);
    },

    getInputTpl : function(){
        var t = new Template('<input style="width: 100%; {customStyle}" class="{cssClass}" name="{name}" {disabled} columnName="{columnName}" variableName="{variableName}" dateFormat="{dateFormat}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" inputValidation="{inputValidation}" inputValidationMessage="{inputValidationMessage}" id="{type}_{id}" type="{type}" size="{size}" value="{value}" />');
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            type : this.config.type,
            customStyle : this.config.customStyle,
            size : this.config.size,
            value : this.config.value,
            dateFormat : this.config.dateFormat,
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            inputValidation : this.config.inputValidation,
            inputValidationMessage : this.config.inputValidationMessage,
            ignoreVariableIfEmpty : this.config.ignoreVariableIfEmpty,
            id : '{id}'
        });

        return this.inputTpl;
    }
})

