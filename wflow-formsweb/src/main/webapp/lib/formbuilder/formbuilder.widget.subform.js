var SubForm = Widget.extend({
    controls : new Array(),
    controlsCount : 0,

    init : function(config){
        this.config = $.extend({
            title : '',
            formId : '',
            type : 'subform',
            name : 'subform_{id}',
            columnName : 'columnName_{id}',
            variableName : '',
            isFromParentProcess : false,
            disabled : false,
            required : false,
            value : '',
            sequenceNumber: -1,
            mode: 'normal'
        }, config);
        this._super(this.config);
    },

    addControl : function(widget){
        widget.config.disabled = this.config.disabled;
        this.controls[this.controlsCount] = widget;
        this.controlsCount++;
    },

    getInputTpl : function(){
        var html = '';
        var thisObject = this;

        if(this.config.mode == 'normal'){
            $.each(this.controls, function(i, widget){
                var baseString = '';

                if(widget.config.type == 'fieldset-start'){
                    baseString += '<fieldset id="fieldset_{id}" class="formbuilder_subform_fieldset"><legend class="formbuilder_legend">' + widget.label + '</legend>';
                }else if(widget.config.type == 'fieldset-end'){
                    baseString += '</fieldset>';
                }else{
                    baseString += '<div id="subform_row_{id}" class="formbuilder_row" formId="{formId}" mode="{mode}" isFromParentProcess="{isFromParentProcess}" isDisabled="{disabled}">';
                    baseString += '<div class="formbuilder_widget_control">';
                    baseString += '</div>';

                    if(widget.config.type == 'grid' || widget.config.type == 'customHtml'){
                        baseString += '<div class="formbuilder_label" style="text-align: left">';
                        baseString += '<p for="{widget_type}_{id}" id="label_{id}" class="label">{label}</p>';
                        baseString += '<p id="description_{id}" class="description">{description}</p>';
                        baseString += '</div>';
                        baseString += '<div class="formbuilder_widget_container" style="width: 94%">';
                        baseString += widget.getInputTpl();
                        baseString += '</div>';
                        baseString += '<div class="formbuilder_row_end"></div>';
                        baseString += '</div>';

                    }else{
                        baseString += '<div class="formbuilder_label">';
                        baseString += '<p for="{widget_type}_{id}" id="label_{id}" class="label">{label}</p>';
                        baseString += '<p id="description_{id}" class="description">{description}</p>';
                        baseString += '</div>';
                        baseString += '<div class="formbuilder_widget_container">';
                        baseString += widget.getInputTpl();
                        baseString += '</div>';
                        baseString += '<div class="formbuilder_row_end"></div>';
                        baseString += '</div>';
                    }

                }

                var t = new Template(baseString);
                html += t.run({
                    id: '{subFormId}_'+i,
                    widget_type: widget.config.type,
                    label: widget.config.label,
                    description: widget.config.description,
                    formId: thisObject.config.formId,
                    mode: thisObject.config.mode,
                    isFromParentProcess : thisObject.config.isFromParentProcess,
                    disabled: thisObject.config.disabled
                });
            });
            var t = new Template(html);
            html = t.run({
                subFormId: '{id}'
            });
        }else if(this.config.mode == 'link'){
            var processId = currentProcessId;
            if(thisObject.config.isFromParentProcess == 'true'){
                processId = processRequesterId;
            }

            var baseString = '<div id="subform_row_{id}" class="formbuilder_row" formId="{formId}" mode="{mode}" isFromParentProcess="{isFromParentProcess}" isDisabled="{disabled}">';
            baseString += '<div class="subformLink"><a target="_blank" href="' + contextPath + 'web/formbuilder/view/' + this.config.formId + '?&overlay=true&processId=' + processId + '">Click here to view Sub Form</a></div>';
            baseString += '</div>';
            var t = new Template(baseString);
            html = t.run({
                id: '{id}',
                formId: thisObject.config.formId,
                mode: thisObject.config.mode,
                isFromParentProcess : thisObject.config.isFromParentProcess,
                disabled: thisObject.config.disabled
            });

        }

        //append sub form header
        var hideShowControl = '&nbsp;<button class="hideShowButton" type="button" onclick="formbuilder_show_hide_subform(\'subform_header_{id}\')">hide/show</button>'

        var header = '<div id="subform_header_{id}" class="subform_header"><span class="formbuilder_editable">' + this.config.title + '</span>' + hideShowControl + '</div>';

        //wrapper div
        var wrapperStart = '<div><div id="subform_content_' + this.config.formId + '" class="subform_content">';
        var wrapperEnd   = '</div></div>';

        return header + wrapperStart + html + wrapperEnd;
    }
})

