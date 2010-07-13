var Widget = Class.extend({
    inputTpl : '',
    config : '',
    cssClass : 'formbuilder_widget',

    //constructor
    init : function(config){
        this.config = $.extend({
            editable : true,
            deletable : true,
            noRequired : false
        }, config);
    },

    //abstract method
    getInputTpl : function(){},

    getHtml : function(id){

        if(this.config.type == 'subform'){
            return this.getSubFormHtml(id)
        }else if(this.config.type == 'grid' || this.config.type == 'customHtml'){
            return this.getExpandHtml(id);
        }else{
            return this.getNormalHtml(id);
        }
    },

    getExpandHtml : function(id){
        var baseString = '';

        baseString = '<div id="row_{id}" class="formbuilder_row">';
            baseString += '<div class="formbuilder_widget_control">';
                //delete
                if(this.config.deletable){
                    baseString += '<a title="' + gettext('clic_del_row')+'" href="#" onclick="formbuilder_row_del(\'#row_{id}\');return false">';
                    baseString += '<img src="' + fb_lib_path + 'img/delete.png"/></a>';
                }

                //required
                baseString += (this.config.noRequired ? '' : '&nbsp;<a title="'+gettext('clic_set_req')+'" href="#" onclick="formbuilder_widgets_switch_required(\'#row_{id}\', \'#{widget_type}_{id}\');return false"><img src="' + fb_lib_path + 'img/star.png"/></a>');

                //edit
                if(this.config.editable){
                    baseString += '<a title="' + gettext('clic_edit_row')+'" id="formbuilder_row_edit_{id}" style="cursor: hand">';
                    baseString += '<img id="img_edit" src="' + fb_lib_path + 'img/edit.png"/></a>';
                }

                //moving
                baseString += '<a title="' + gettext('clic_moveup_row')+'" id="formbuilder_row_moveup_{id}" href="#" onclick="formbuilder_row_moveup(\'#row_{id}\');return false">';
                baseString += '<img id="img_moveup" src="' + fb_lib_path + 'img/arrow_up.png"/></a>';

                baseString += '<a title="' + gettext('clic_movedown_row')+'" id="formbuilder_row_movedown_{id}" href="#" onclick="formbuilder_row_movedown(\'#row_{id}\');return false">';
                baseString += '<img id="img_movedown" src="' + fb_lib_path + 'img/arrow_down.png"/></a>';
            baseString += '</div>';

            baseString += '<div class="formbuilder_label" style="text-align: left">';
                baseString += '<p for="{widget_type}_{id}" id="label_{id}" class="label formbuilder_editable">{label}</p>';
                baseString += '<p id="description_{id}" class="description formbuilder_editable">{description}</p>';
            baseString += '</div><br>';

            baseString += '<div class="formbuilder_widget_container" style="width: 94%">';
                baseString += this.getInputTpl();
            baseString += '</div>';
            baseString += '<div class="formbuilder_row_end"></div>';
        baseString += '</div>';

        var t = new Template(baseString);
        var html = t.run({
            id: id,
            widget_type: this.config.type,
            label: this.config.label,
            description: this.config.description
        });

        return html;
    },

    getNormalHtml : function(id){
        var baseString = '';

        baseString = '<div id="row_{id}" class="formbuilder_row">';
            baseString += '<div class="formbuilder_widget_control">';
                //delete
                if(this.config.deletable){
                    baseString += '<a title="' + gettext('clic_del_row')+'" href="#" onclick="formbuilder_row_del(\'#row_{id}\');return false">';
                    baseString += '<img src="' + fb_lib_path + 'img/delete.png"/></a>';
                }

                //required
                baseString += (this.config.noRequired ? '' : '&nbsp;<a title="'+gettext('clic_set_req')+'" href="#" onclick="formbuilder_widgets_switch_required(\'#row_{id}\', \'#{widget_type}_{id}\');return false"><img src="' + fb_lib_path + 'img/star.png"/></a>');

                //edit
                if(this.config.editable){
                    baseString += '<a title="' + gettext('clic_edit_row')+'" id="formbuilder_row_edit_{id}" style="cursor: hand">';
                    baseString += '<img id="img_edit" src="' + fb_lib_path + 'img/edit.png"/></a>';
                }

                //moving
                baseString += '<a title="' + gettext('clic_moveup_row')+'" id="formbuilder_row_moveup_{id}" href="#" onclick="formbuilder_row_moveup(\'#row_{id}\');return false">';
                baseString += '<img id="img_moveup" src="' + fb_lib_path + 'img/arrow_up.png"/></a>';

                baseString += '<a title="' + gettext('clic_movedown_row')+'" id="formbuilder_row_movedown_{id}" href="#" onclick="formbuilder_row_movedown(\'#row_{id}\');return false">';
                baseString += '<img id="img_movedown" src="' + fb_lib_path + 'img/arrow_down.png"/></a>';
            baseString += '</div>';

            baseString += '<div class="formbuilder_label">';
                baseString += '<p for="{widget_type}_{id}" id="label_{id}" class="label formbuilder_editable">{label}</p>';
                baseString += '<p id="description_{id}" class="description formbuilder_editable">{description}</p>';
            baseString += '</div>';

            baseString += '<div class="formbuilder_widget_container">';
                baseString += this.getInputTpl();
            baseString += '</div>';
            baseString += '<div class="formbuilder_row_end"></div>';
        baseString += '</div>';

        var t = new Template(baseString);
        var html = t.run({
            id: id,
            widget_type: this.config.type,
            label: this.config.label,
            description: this.config.description
        });

        return html;
    },

    getSubFormHtml : function(id){
        var baseString = '';

        baseString = '<div id="row_{id}" class="formbuilder_row formbuilder_subform">';
            baseString += '<div class="formbuilder_widget_control">';
                //delete
                if(this.config.deletable){
                    baseString += '<a title="' + gettext('clic_del_row')+'" href="#" onclick="formbuilder_row_del(\'#row_{id}\');return false">';
                    baseString += '<img src="' + fb_lib_path + 'img/delete.png"/></a>';
                }

                //disable
                baseString += '<a title="' + gettext('clic_disable_row')+'" href="#" onclick="formbuilder_row_disable(\'#row_{id}\');return false">';
                baseString += '<img src="' + fb_lib_path + 'img/stop.png"/></a>';

                //moving
                baseString += '<a title="' + gettext('clic_moveup_row')+'" id="formbuilder_row_moveup_{id}" href="#" onclick="formbuilder_row_moveup(\'#row_{id}\');return false">';
                baseString += '<img id="img_moveup" src="' + fb_lib_path + 'img/arrow_up.png"/></a>';

                baseString += '<a title="' + gettext('clic_movedown_row')+'" id="formbuilder_row_movedown_{id}" href="#" onclick="formbuilder_row_movedown(\'#row_{id}\');return false">';
                baseString += '<img id="img_movedown" src="' + fb_lib_path + 'img/arrow_down.png"/></a>';
            baseString += '</div>';

            baseString += '<div class="formbuilder_widget_container" style="width: 94%">';
                baseString += this.getInputTpl();
            baseString += '</div>';
            baseString += '<div class="formbuilder_row_end"></div>';
        baseString += '</div>';

        var t = new Template(baseString);
        var html = t.run({
            id: id
        });

        return html;
    }
})