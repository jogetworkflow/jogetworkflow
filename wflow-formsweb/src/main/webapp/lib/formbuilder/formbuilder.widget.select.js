var Select = Widget.extend({
    init : function(config, gridNumber){
        this.config = $.extend({
            id : '{type}_{id}',
            type : 'select',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'select_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            ignoreVariableIfEmpty : 'false',
            disabled : false,
            required : false,
            value : '',
            options : null,
            disableControl : false,
            formVariableId : '',
            idExtend : ''
        }, config);
        if(gridNumber >= 0){
            this.config.idExtend = '_' + gridNumber;
        }else{
            this.config.idExtend = this.config.id.substring(this.config.id.lastIndexOf('_'));
        }
        this._super(this.config);
    },

    /*
    addOption : function(ask, config){
        if(ask == true){
            config.text = prompt(gettext('option_prompt'));
            if(!config.text){
                return;
            }
            config.value = config.text;
            config.selected = true;
        }else{
            config = $.extend({
                value : '',
                text  : '',
                selected : false
            }, config)
        }

        $('#' + this.config.type + '_' + id).addOption(config.value, config.text, config.selected);
    },

    removeOption : function(){
        $('#' + this.config.type + '_' + this.id + ' option:selected').remove();
    },
    */

    getInputTpl : function(){
        var control = '';
        if(!this.config.disabled && !this.config.disableControl){
            control = '&nbsp;<p class="formbuilder_widget_control"><a title="' + gettext('clic_opt_del_t') + '" href="#" onclick="formbuilder_option_del(\'{type}_{id}{idExtend}\');return false"><img src="' + fb_lib_path + 'img/delete.png"/>'+gettext('clic_option_del')+'</a><br />'
            control += '<a title="' + gettext('clic_opt_add_t') + '" href="#" onclick="formbuilder_keyValuePair_init(\'{type}_{id}{idExtend}\',\'' + gettext('clic_opt_add_t') + '\', \'formbuilder_option_add\');return false;"><img src="' + fb_lib_path + 'img/add.png"/>'+gettext('clic_option_add')+'</a></p>';
        }

        var baseString = '<select {disabled} class="{cssClass}" name="{name}" columnName="{columnName}" variableName="{variableName}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" formVariableId="{formVariableId}" id="{type}_{id}{idExtend}">';
        if(this.config.options){
            $.each(this.config.options, function(k, v){
                baseString += '<option value="' + v.value + '">' + v.label + '</option>';
            });
        }
        baseString += '</select>';

        var t = new Template(baseString + control);
        this.inputTpl = t.run({
            cssClass : this.cssClass,
            name : this.config.name,
            columnName : this.config.columnName,
            variableName : this.config.variableName,
            ignoreVariableIfEmpty : this.config.ignoreVariableIfEmpty,
            formVariableId : this.config.formVariableId,
            type : this.config.type,
            disabled : (this.config.disabled) ? 'disabled="disabled"' : '',
            id : '{id}',
            idExtend : this.config.idExtend
        });

        return this.inputTpl;
    }
})


