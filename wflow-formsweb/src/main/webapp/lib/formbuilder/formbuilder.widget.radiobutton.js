var RadioButton = Widget.extend({
    init : function(config){
        this.config = $.extend({
            type : 'radio',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'radio_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            ignoreVariableIfEmpty : 'false',
            disabled : false,
            required : false,
            value : '',
            controls : [],
            disableControl : false,
            formVariableId : ''
        }, config);
        this._super(this.config);
    },

    addControl : function(control){
        this.config.controls.push(control);
    },

    getInputTpl : function(){
        var baseString = '';
        var thisObject = this;
        if(this.config.controls && this.config.controls.length > 0){
            $.each(this.config.controls, function(i, v){
                if(!thisObject.config.disabled && !thisObject.config.disableControl){
                    baseString += '<div id="radio_div_{id}"><input {disabled} class="{cssClass}" name="{name}" formVariableId="{formVariableId}" variableName="{variableName}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" columnName="{columnName}" value="' + v.radioLabel + '" id="{id}" type="radio"/>&nbsp;<span class="radio_label" onclick="formbuilder_keyValuePair_init(\'{id}\',\''+ gettext('clic_edit') +'\',\'formbuilder_keyValuePair_edit_save\');return false;">' + v.radioLabel + '</span><p class="formbuilder_widget_control">&nbsp;<a title="' + gettext('clic_radio_del_t') + '" href="#" onclick="formbuilder_radio_del(\'#radio_div_{id}\', \'#row_{row_id}\');return false"><img src="' + fb_lib_path + 'img/delete.png"/>' + gettext('clic_radio_del') + '</a></p></div>';
                }else{
                    baseString += '<div id="radio_div_{id}"><input {disabled} class="{cssClass}" name="{name}" formVariableId="{formVariableId}" variableName="{variableName}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" columnName="{columnName}" value="' + v.radioLabel + '" id="{id}" type="radio"/>&nbsp;<span class="radio_label">' + v.radioLabel + '</span></div>';
                }
            })
        }

        if(!this.config.disabled && !this.config.disableControl){
            baseString += '<p class="formbuilder_widget_control formbuilder_radio_control"><a title="' + gettext('clic_radio_add_t') + '" href="#" onclick="formbuilder_keyValuePair_init(\'{id}\',\'' + gettext('clic_radio_add_t') + '\', \'formbuilder_radio_add\');return false;"><img src="' + fb_lib_path + 'img/add.png"/>' + gettext('clic_radio_add') + '</a></p><input type="hidden" name="counter_radio_{id}" id="counter_radio_{id}" value="0" /><input type="hidden" name="counter2_radio_{id}" id="counter2_radio_{id}" value="0" />';
        }

        var t = new Template(baseString);
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            label : this.config.label,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            ignoreVariableIfEmpty : this.config.ignoreVariableIfEmpty,
            formVariableId : this.config.formVariableId,
            type : this.config.type,
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            id : '{id}'
        });

        return this.inputTpl;
    }
})


