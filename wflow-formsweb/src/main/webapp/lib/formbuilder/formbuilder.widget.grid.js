var Grid = Widget.extend({
    init : function(config){
        this.config = $.extend({
            type : 'grid',
            label : gettext('name') + ' ' + gettext('clic_to_edit'),
            description : gettext('description') + ' ' + gettext('clic_to_edit'),
            name : 'grid_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            disabled : false,
            required : false,
            value : '',
            columns : [],
            columnLabelEditable : true,
            disableControl : false,
            disableChildControl : false
        }, config);

        this._super(this.config);

        var thisObject = this;
        if(this.config.columns.length > 0){
            var columns = [];
            $.each(this.config.columns, function(i, col){
                thisObject.config.name = col.name;
                col.disableControl = thisObject.config.disableChildControl;
                switch(col.type){
                    case 'text':
                        columns.push({ widget: new TextField({id: col.id, name: col.name, size: 4}), label: (col.label)?col.label:gettext('clic_to_edit')});
                        break;
                    case 'textarea':
                        columns.push({ widget: new TextArea({id: col.id, name: col.name}), label: (col.label)?col.label:gettext('clic_to_edit')});
                        break;
                    case 'select':
                        columns.push({ widget : new Select(col), label: (col.label)?col.label:gettext('clic_to_edit')});
                        break;
                    default:
                        break;
                }
            });
            this.config.columns = columns;
        }
    },

    addColumn : function(widget, label){
        widget.config.name = this.config.name;
        this.config.columns.push({ label: (label) ? label : gettext('clic_to_edit'), widget: widget});
    },

    getInputTpl : function(){
        var thisObject = this;

        var baseString = '<input type="hidden" name="' + this.config.name + '_col" value="' + this.config.columns.length + '">';
        baseString += '<input type="hidden" id="' + this.config.name + '_row" name="' + this.config.name + '_row" value="1">';
        //baseString += '<table class="gridTable grid_{id}" id="grid_{id}">';
        baseString += '<table class="gridTable grid_{id}" id="' + this.config.name + '_grid_{id}">';

        //column label
        baseString += '<thead>';
        $.each(this.config.columns, function(i, col){
            var editable = '';
            if(thisObject.config.columnLabelEditable){
                editable = 'formbuilder_editable';
            }

            baseString += '<th><b class="label ' + editable + '">';
            baseString += col.label;
            baseString += '</b></th>';
        })
        baseString += '</thead>';

        baseString += '<tr class="grid_header">';
        $.each(this.config.columns, function(i, col){
            col.widget.config.disabled = thisObject.config.disabled;
            baseString += '<td>';
            baseString += col.widget.getInputTpl().replace(/id=/, ' rowId="'+thisObject.config.name+'_0" id=');
            baseString += '&nbsp;&nbsp;</td>';
        });
        baseString += '</tr>';


        baseString += '</table>';

        var control = '';
        if(!this.config.disableControl)
            control = '&nbsp;<p class="formbuilder_widget_control2"><a title="' + gettext('clic_opt_add_t') + '" href="#" onclick="formbuilder_grid_add_row(\'' + this.config.name + '_grid_{id}\');return false"><img src="' + fb_lib_path + 'img/add.png"/>'+gettext('clic_option_add')+'</a>';
        baseString += control;
        this.inputTpl = baseString;

        return this.inputTpl;
    }
})

