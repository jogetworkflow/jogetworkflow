var Checkbox = Widget.extend({
    init: function(config){
        this.config = $.extend({
            type : 'checkbox',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'checkbox_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            disabled : false,
            required : false,
            value : '',
            controls : [],
            formVariableId : '',
            disableControl : false,
            deliminator : '|'
        }, config);
        this._super(this.config);
    },

    addControl : function(control){
        this.config.controls.push(control);
    },

    getInputTpl: function(){
        var baseString = '';
        var thisObject = this;
        if(this.config.controls && this.config.controls.length > 0){
            $.each(this.config.controls, function(i, v){
                if(!thisObject.config.disabled && !thisObject.config.disableControl){
                    baseString += '<div id="checkbox_div_{id}"><input {disabled} class="formbuilder_widget" name="{name}" formVariableId="{formVariableId}" columnName="{columnName}" value="' + v.checkboxLabel + '" id="checkbox_{id}" deliminator="{deliminator}" type="checkbox"/>&nbsp;<span class="checkbox_label" onclick="formbuilder_keyValuePair_init(\'{id}\',\''+ gettext('clic_edit') +'\',\'formbuilder_keyValuePair_edit_save\');return false;">' + v.checkboxLabel + '</span><p class="formbuilder_widget_control">&nbsp;<a title="' + gettext('clic_cb_del_t') + '" href="#" onclick="formbuilder_checkbox_del(\'#checkbox_div_{id}\', \'#row_{row_id}\');return false"><img src="' + fb_lib_path + 'img/delete.png"/>' + gettext('clic_cb_del') + '</a></p></div>';
                }else{
                    baseString += '<div id="checkbox_div_{id}"><input {disabled} class="formbuilder_widget" name="{name}" formVariableId="{formVariableId}" columnName="{columnName}" value="' + v.checkboxLabel + '" id="checkbox_{id}" deliminator="{deliminator}" type="checkbox"/>&nbsp;<span class="checkbox_label">' + v.checkboxLabel + '</span></div>';
                }
            })
        }

        if(!this.config.disabled && !this.config.disableControl){
            baseString += '<p class="formbuilder_widget_control formbuilder_checkbox_control"><a title="' + gettext('clic_cb_add_t') + '" href="#" onclick="formbuilder_keyValuePair_init(\'{id}\',\'' + gettext('clic_cb_add_t') + '\', \'formbuilder_checkbox_add\');return false;"><img src="' + fb_lib_path + 'img/add.png"/>' + gettext('clic_cb_add') + '</a></p><input type="hidden" name="counter_checkbox_{id}" id="counter_checkbox_{id}" value="0" /><input type="hidden" name="counter2_checkbox_{id}" id="counter2_checkbox_{id}" value="0" />';
        }
        var t = new Template(baseString);
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            label : this.config.label,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            formVariableId : this.config.formVariableId,
            type : this.config.type,
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            id : '{id}',
            deliminator : this.config.deliminator
        });

        return this.inputTpl;
    }
})


