/**
* Core
*/

var counterRows = 0;
var fieldsetMode = "normal";

function getNewId(){
    return counterRows++;
};

function getSequenceRowId(sequenceNumber){
    unset_current_row();
    var rowId = '';
    var counter = 0;
    $.each($('#formbuilder_widgets_area .formbuilder_row'), function(k, v){
        if(v.id.indexOf('subform') == -1){
            if(counter == sequenceNumber){
                rowId = v.id;
            }
            counter++;
        }
    });
    return rowId;
};

var fb_controls = {
        save        : gettext('save')
    ,   preview     : gettext('preview')
    ,   mobilePreview     : gettext('mobilePreview')
    //,   undo        : gettext('undo')
    //,   html        : gettext('html')
    //,   exit        : gettext('exit')
    };

var fb_widgets  = {
        fieldset    : gettext('fieldset')
    ,   text        : gettext('text')
    ,   readonlytext: gettext('readonlytext')
    ,   textarea    : gettext('textarea')
    ,   readonlytextarea: gettext('readonlytextarea')
    ,   select      : gettext('select')
    ,   datepicker  : gettext('datepicker')
    ,   checkbox    : gettext('checkbox')
    ,   radio       : gettext('radio')
    ,   htmleditor  : gettext('htmleditor')
    ,   subform     : gettext('subform')
    ,   file        : gettext('file')
    ,   grid        : gettext('grid')
    ,   hiddenfield : gettext('hiddenfield')
    ,   customHtml  : gettext('customHtml')
    };

/**
* Start the interface
*/
function formbuilder_start(fb_div){
    if(!fb_div){
        $('body').append('<div id="formbuilder_main"></div>');
        fb_div = "#formbuilder_main";
    } else { // Clear the module
        $(fb_div).html('');
    }
    formbuilder_draw_controls(fb_div);

    //content container top
    $(fb_div).append('<div style="margin-top: 20px"></div>');
    $(fb_div).append('<div style="background:url(' + contextPath + 'lib/img/container_top.gif) repeat-x; height: 8px;">' +
                     '    <div style="float: left"><img src="' + contextPath + 'lib/img/container_top_left.gif" height="8" width="8" align="left"/></div>' +
                     '    <div style="float: right"><img src="' + contextPath + 'lib/img/container_top_right.gif" height="8" width="8" align="right"/></div>' +
                     '</div>');
    $(fb_div).append('<div id="content_container"></div>');

    formbuilder_draw_fieldset_mode('#content_container');
    //formbuilder_draw_flash(fb_div);
    formbuilder_draw_widget_area('#content_container');
    formbuilder_draw_widget_list(fb_div);
    formbuilder_draw_property(fb_div);

    //footer
    $("#content_container").append('<div style="clear:both"></div>');
    $(fb_div).append('<div>' +
                     '    <div style="float: left"><img src="' + contextPath + 'lib/img/container_bottom_left.gif" height="58" width="8" align="left"/></div>' +
                     '    <div id="footer">' +
                     '        <font color="#3a3a3a"></font>' +
                     '    </div>' +
                     '    <div style="float: right"><img src="' + contextPath + 'lib/img/container_bottom_right.gif" height="58" width="8" align="right"/></div>' +
                     '</div>');

    formbuilder_load(fb_div);
};

/**
* Load a generated form
*/
function formbuilder_load(fb_div, view){
    $.get(fb_loadform_ep + '&rnd=' + new Date().valueOf().toString(), function(data){
        if(data == ''){
            $.unblockUI();
        } else {
            try{
                data = eval('(' + data + ')');
                flash_message(gettext('msg_ok_load'));
                formbuilder_parse(data, view);
                if(view && view == true){
                    if(numOfSubForm == 0){
                        formbuilder_form_export(fb_div, null, view);
                    }
                }
            }catch(err){
                if(view && view == true){
                    $(fb_div).html(gettext('msg_err_loading'));
                }
                $.unblockUI();
            }
        }
    });

};

function formbuilder_load_subformAsLink(formId, title, disabled, sequenceNumber, isFromParentProcess, fieldsetId, row_id){
    $.getJSON(fb_loadsubform_ep + formId, function(data){

        if( typeof(data) == 'object' && data.fieldsets != undefined){

            tb_remove();

            //cast 'disabled' to boolean
            if(disabled && disabled == 'true'){
                disabled = true;
            }else{
                disabled = false;
            }

            if(isFromParentProcess == null){
                isFromParentProcess = false;
            }

            var subform = null;
            if(title)
                subform = new SubForm({title: title, formId: formId, sequenceNumber: sequenceNumber, mode: "link", isFromParentProcess: isFromParentProcess});
            else
                subform = new SubForm({title: 'Sub Form Title ' + gettext('clic_to_edit'), formId: formId, sequenceNumber: sequenceNumber, mode: "link", isFromParentProcess: isFromParentProcess});
            subform.config.disabled = disabled;
            subform.config['row_id'] = row_id;

            if (fieldsetId) {
                unset_current_fieldset();
                unset_current_row();
                set_current_fieldset('#' + fieldsetId);
            }
            var id = formbuilder_widget_base(subform);
            $("#row_" + id).addClass("subform_background");
            if (disabled) {
                formbuilder_row_disable("#row_" + id);
            }
            if(sequenceNumber >= 0){
                //move subform to the correct order
                subform     = $("#row_" + id);
                var rowToChange = $("#" + getSequenceRowId(sequenceNumber));
                rowToChange.before(subform);
            }
        }
        subformLoadComplete();
    });
}

function formbuilder_load_subform(formId, title, disabled, sequenceNumber, isFromParentProcess, fieldsetId, row_id){
    var activityId = "";
    if(currentActivityId){
        activityId += "?activityId=" + currentActivityId;
    }

    $.getJSON(fb_loadsubform_ep + formId + activityId, function(data){
            if( typeof(data) == 'object' && data.fieldsets != undefined){
                tb_remove();

                //cast 'disabled' to boolean
                if(disabled && disabled == 'true'){
                    disabled = true;
                }else{
                    disabled = false;
                }

                if(isFromParentProcess == null){
                    isFromParentProcess = false;
                }

                var id;

                var subform = null;
                if(title)
                    subform = new SubForm({title: title, formId: formId, sequenceNumber: sequenceNumber, isFromParentProcess: isFromParentProcess});
                else
                    subform = new SubForm({title: 'Sub Form Title ' + gettext('clic_to_edit'), formId: formId, sequenceNumber: sequenceNumber, isFromParentProcess: isFromParentProcess});
                subform.config.disabled = disabled;
                subform.controls = new Array();

                $.each(data.fieldsets, function (k , v){
                    //check if the feldset only contain subform, skip it
                    var onlySubform = true;
                    $.each(v.widgets, function (k , v){
                        if(v.type != 'subform'){
                            onlySubform = false;
                        }
                    });
                    if(onlySubform){
                        return;
                    }

                    var fieldsetStart = {
                        label: v.label,
                        config: {
                            type: 'fieldset-start'
                        }
                    }
                    subform.addControl(fieldsetStart);

                    $.each(v.widgets, function (k , v){
                        switch(v.type){
                            case 'select':
                                v.controls[0].disableControl = true;
                                subform.addControl(new Select(v.controls[0]));
                            break;
                            case 'radio':
                                v.controls[0].disableControl = true;
                                var radioButton = new RadioButton(v.controls[0]);

                                if(v.controls.length > 0){
                                    $.each(v.controls, function(k, v){
                                         radioButton.addControl(v);
                                    });
                                }

                                subform.addControl(radioButton);
                            break;
                            case 'checkbox':
                                v.controls[0].disableControl = true;
                                var checkbox = new Checkbox(v.controls[0]);

                                if(v.controls.length > 0){
                                    $.each(v.controls, function(k, v){
                                         checkbox.addControl(v);
                                    });
                                }

                                subform.addControl(checkbox);
                            break;
                            case 'text':
                                subform.addControl(new TextField(v.controls[0]));
                            break;
                            case 'readonlytext':
                                subform.addControl(new ReadOnlyTextField(v.controls[0]));
                            break;
                            case 'file':
                                subform.addControl(new FileUpload(v.controls[0]));
                            break;
                            case 'textarea':
                                subform.addControl(new TextArea(v.controls[0]));
                            break;
                            case 'readonlytextarea':
                                subform.addControl(new ReadOnlyTextArea(v.controls[0]));
                            break;
                            case 'htmleditor':
                                subform.addControl(new HtmlEditor(v.controls[0]));
                            break;
                            case 'hiddenfield':
                                subform.addControl(new HiddenField(v.controls[0]));
                            break;
                            case 'datepicker':
                                subform.addControl(new DatePicker(v.controls[0]));
                            break;
                            case 'customHtml':
                                v.controls[0].render = true;
                                subform.addControl(new CustomHtml(v.controls[0]));
                            break;
                            case 'grid':
                                var disableControl = true;
                                v.controls[0].disableControl = disableControl;
                                v.controls[0].disableChildControl = disableControl;
                                v.controls[0].columnLabelEditable = false;
                                subform.addControl(new Grid(v.controls[0]));
                            break;
                            case 'subform':
                                //formbuilder_load_subform(v.controls[0].formId, v.controls[0].title);
                            break;
                        }
                    });

                    var fieldsetEnd = {
                        label: v.label,
                        config: {
                            type: 'fieldset-end'
                        }
                    }
                    subform.addControl(fieldsetEnd);
                });

                if (fieldsetId) {
                    unset_current_fieldset();
                    unset_current_row();
                    set_current_fieldset('#' + fieldsetId);
                }
                subform.config['row_id'] = row_id;
                id = formbuilder_widget_base(subform);
                $("#row_" + id).addClass("subform_background");
                if (disabled) {
                    formbuilder_row_disable("#row_" + id);
                    formbuilder_row_disable("#row_" + id); // WORKAROUND: for now, repeated function call needed to disable fields in disabled subform.
                }
                //convert to htmleditor
                initWymEditor("#htmleditor_" + id);

                if(sequenceNumber >= 0){
                    //move subform to the correct order
                    subform     = $("#row_" + id);
                    var rowToChange = $("#" + getSequenceRowId(sequenceNumber));
                    rowToChange.before(subform);
                }
                subformLoadComplete(formId, isFromParentProcess);
            }else{
                subformLoadComplete();
            }
    });
}

function formbuilder_parse(data, view){
    var sequenceNumber = 0;

    $( '#formbuilder_widgets_area h2').html(data.title);
    $( '#formbuilder_widgets_area .formbuilder_fieldset').remove();
    $( '#counter_rows').val(0);
    $.each(data.fieldsets, function (k , v){
        setFieldsetMode(v.fieldsetMode);
        formbuilder_widget_fieldset(v.label, v.id);
        var currentFieldsetId = v.id;
        $.each(v.widgets, function (k , v){

            //remove name prefix
            var regex = /c_/;
            $.each(v.controls, function (i, c){
                if(c.name) {
                    c.name = c.name.replace(regex, '');
                }
                v.controls[0]['row_id'] = v.id;
            });

            switch(v.type){
                case 'select':
                    formbuilder_widget_select(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'datepicker':
                    formbuilder_widget_datepicker(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'radio':
                    formbuilder_widget_radio(v.controls);
                    sequenceNumber++;
                break;
                case 'checkbox':
                    formbuilder_widget_checkbox(v.controls);
                    sequenceNumber++;
                break;
                case 'text':
                    formbuilder_widget_text(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'readonlytext':
                    formbuilder_widget_readonlytext(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'file':
                    formbuilder_widget_file(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'textarea':
                    formbuilder_widget_textarea(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'readonlytextarea':
                    formbuilder_widget_readonlytextarea(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'hiddenfield':
                    formbuilder_widget_hiddenfield(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'customHtml':
                    if(view)
                        v.controls[0].render = true;
                    formbuilder_widget_customHtml(v.controls[0]);
                    sequenceNumber++;
                break;
                case 'htmleditor':
                    formbuilder_widget_htmleditor(v.controls[0], view);
                    sequenceNumber++;
                break;
                case 'subform':
                    if(v.controls[0].mode == "link")
                        formbuilder_load_subformAsLink(v.controls[0].formId, v.controls[0].title, v.controls[0].disabled, sequenceNumber, v.controls[0].isFromParentProcess, currentFieldsetId,v.controls[0]['row_id']);
                    else if(v.controls[0].mode == "normal")
                        formbuilder_load_subform(v.controls[0].formId, v.controls[0].title, v.controls[0].disabled, sequenceNumber, v.controls[0].isFromParentProcess, currentFieldsetId,v.controls[0]['row_id']);
                    sequenceNumber++;
                break;
                case 'grid':
                    var disableControl = true;
                    if(view)
                        disableControl = false;
                    v.controls[0].disableControl = disableControl;
                    formbuilder_widget_base(new Grid(v.controls[0]));
                    sequenceNumber++;
                break;
            }
        });
    });

    if(!view && numOfSubForm == 0){
        $.unblockUI();
    }

    set_editable();
};

function initWymEditor(element){
    $(element).wymeditor({
        postInit: function(wym) {
            $(wym._box).find(wym._options.containersSelector).remove();
            $(wym._box).find(wym._options.classesSelector).remove();
            $(wym._box).find('.wym_area_right').remove();
            $(wym._box).find('.wym_area_main').css("width", "100%");
        }
    });
}

function initDataInsertionPoint(){
    $.each($('#formbuilder_export select, #formbuilder_export input, #formbuilder_export textarea'), function(i, v){
        if($(v).attr('name') != '' && !/hiddenfield/.test(v.id)){
            //console.log($(v).attr('id'), ' - ', $(v).attr('name'), ' - ', $(v).attr('type'));
            if($(v).attr('type')){
                if($(v).attr('type') == 'radio'){
                    $(v).parent().html($(v).parent().html().replace(/<input([^<]+)value="([^"]+)"([^<]+)type="radio">/g, '<input #radio.' + $(v).attr('name') + '.$2# type="radio" value="$2"$1$3/>'));
                }else if($(v).attr('type') == 'checkbox'){
                    $(v).parent().html($(v).parent().html().replace(/<input([^<]+)value="([^"]+)"([^<]+)type="checkbox">/g, '<input #checkbox.' + $(v).attr('name') + '.$2# type="checkbox" value="$2"$1$3/>'));
                }else if($(v).attr('type') == 'select-one'){
                    $(v).html($(v).html().replace(/<option value="([^"]+)">([^\/]*)<\/option>/g, '<option #select.' + $(v).attr('name') + '.$1# value="$1">$2</option>'));
                }else if($(v).attr('type') == 'textarea' && !$(v).attr('rowid')){
                    if($(v).val() == ''){
                        $(v).attr('defaultValue', '#input.' + $(v).attr('name') + '#');
                    }

                //}else if($(v).attr('type') == 'file'){

                }else{
                    if($(v).val() == ''){
                        if($(v).attr('variableName') != '')
                            $(v).attr('defaultValue', '#input.' + $(v).attr('name') + '.' + $(v).attr('variableName') + '#');
                        else
                            $(v).attr('defaultValue', '#input.' + $(v).attr('name') + '#');
                    }
                }
            }
        }
    });
}

function formbuilder_save(fb_div){

    formbuilder_form_export(fb_div);
    var json = formbuilder_json(fb_div);

    initKeyValuePair();
    initHiddenField();
    removeEmptyLabel();
    removeSubformShowHideButton();
    initDataInsertionPoint();
    removeMobileUnsupportElement();

    $.post(fb_saveform_ep, { id: currentFormId, data: json, html: $('#formbuilder_export').html()});
    alert(gettext('msg_save'));
    flash_message(gettext('msg_save'));
    $('#formbuilder_export').remove();
};


/**
* save the form
*/
/*
function formbuilder_save(fb_div){
    formbuilder_form_export(fb_div);
    var json = formbuilder_json(fb_div);
    $.post(fb_saveform_ep, { id: currentFormId, data: json});
    //flash_message(gettext('msg_save'));
    alert("Form saved");
};
*/

/**
* Serialize to json
*/
function formbuilder_json(fb_div){
    var obj = {title : $(fb_div + ' #formbuilder_export h2').html(), fieldsets : []};
    $.each($(fb_div + ' #formbuilder_widgets_area .formbuilder_fieldset'), function(fk, fv){
        var rows = [];
        $.each($(fb_div + ' #formbuilder_widgets_area #' + fv.id + ' .formbuilder_row'), function(k, v){

            if(v.id.indexOf('subform') == -1){
                var row_id = v.id.match(/row_(\d+)/)[1];
                var row = {
                        id          : v.id.replace(/_ex_/g , '')
                    ,   controls    : []
                };

                $.each($('#row_' + row_id), function(wk, wv){
                    //if is subform
                    if($(wv).attr('class').indexOf('formbuilder_subform') != -1){
                        var title               = $($('#row_' + row_id + ' .subform_header .formbuilder_editable')[0]).html();
                        var formId              = $($('#row_' + row_id + ' .formbuilder_row')[0]).attr('formid');
                        var mode                = $($('#row_' + row_id + ' .formbuilder_row')[0]).attr('mode');
                        var isFromParentProcess = $($('#row_' + row_id + ' .formbuilder_row')[0]).attr('isFromParentProcess');
                        var disabled            = $($('#row_' + row_id + ' .formbuilder_row')[0]).attr('isDisabled');

                        row.type = 'subform';
                        var control = {
                            title               : title,
                            formId              : formId,
                            mode                : mode,
                            isFromParentProcess : isFromParentProcess,
                            disabled            : disabled
                        };
                        row.controls.push(control);
                    }else{
                        //check if it's Grid
                        if($('#row_' + row_id + ' .gridTable').length > 0){
                            row.type = 'grid';
                            var control = {
                                      label       : $('#label_' + row_id ).html()
                                  ,   description : $('#description_' + row_id ).html()
                                  ,   columns     : []
                            };

                            $.each($('#row_' + row_id + ' .gridTable .formbuilder_widget'), function(i, wv){
                                //get column label
                                var columnLabel = $($('#row_' + row_id + ' .gridTable thead th .label')[i]).html()

                                var type = wv.id.match(/^([a-zA-Z]+)_.*/)[1];
                                var column = {
                                        id      : wv.id.replace(/_ex_/g , '')
                                    ,   name    : $(wv).attr("name")
                                    ,   type    : type
                                    ,   value   : $('#' + wv.id).val()
                                    ,   label   : columnLabel
                                    ,   formVariableId : $(wv).attr("formVariableId")
                                };

                                if(type == 'select'){
                                    column.options = [];
                                    $.each($('#' + wv.id + ' option'), function(k, v){
                                        column.options.push({value : v.value, label : v.text, selected : v.selected});
                                    });
                                }

                                control.columns.push(column);
                            });

                            row.controls.push(control);
                        }else{
                          // Switch on widget type
                          $.each($('#row_' + row_id + ' .formbuilder_widget'), function(wk, wv){
                              var type = wv.id.match(/^([a-zA-Z]+)_.*/)[1];
                              // Avoid counter
                              if(type != 'counter'){
                                  row.type = type;
                              }
                              var control = {
                                      id      : wv.id.replace(/_ex_/g , '')
                                  ,   required    : ($('#row_' + row_id + ' .formbuilder_required_marker').length > 0)
                                  ,   label       : $('#label_' + row_id ).html()
                                  ,   description : $('#description_' + row_id ).html()
                                  ,   name    : $(wv).attr("name")
                                  ,   type    : type
                                  ,   value   : $('#' + wv.id).val()
                                  ,   columnName : $(wv).attr("columnname")
                                  ,   variableName : $(wv).attr("variablename")
                                  ,   formVariableId : $(wv).attr("formVariableId")
                                  ,   inputValidation : $(wv).attr("inputValidation")
                                  ,   inputValidationMessage : $(wv).attr("inputValidationMessage")
                                  ,   ignoreVariableIfEmpty : $(wv).attr("ignoreVariableIfEmpty")
                                  ,   dateFormat : $(wv).attr("dateFormat")
                                  ,   deliminator : $(wv).attr("deliminator")
                              };
                              switch(type){
                                  case 'select' :
                                      control.options = [];
                                      $.each($('#' + wv.id + ' option'), function(k, v){
                                          control.options.push({value : v.value, label : v.text, selected : v.selected});
                                      });
                                  break;
                                  case 'checkbox' :
                                      var div_id = wv.id.match(/(checkbox_\d+_\d+)/)[1];
                                      control.checkboxLabel = $('#checkbox_div_' + div_id + ' .checkbox_label').html();
                                      control.checked = v.checked;
                                  break;
                                  case 'radio' :
                                      var div_id = wv.id.match(/(radio_\d+_\d+)/)[1];
                                      control.radioLabel = $('#radio_div_' + div_id + ' .radio_label').html();
                                      control.checked = v.checked;
                                  break;
                                  default:
                                  // Do nothing
                              }
                              row.controls.push(control);
                          });//end #row_{id} .formbuilder_widget loop
                        }//end grid checking
                    }//end else
                    rows.push(row);
                });//end #row_{id} loop
            }
        });
        var fieldset = {
                id           : fv.id.replace(/_ex_/g , '')
            ,   fieldsetMode : fieldsetMode
            ,   label        : $('#' + fv.id + ' legend .formbuilder_editable').html()
            ,   widgets      : rows
        };
        obj.fieldsets.push(fieldset);
    });

    return $.toJSON(obj);
};

function formbuilder_preview(fb_div){
    //formbuilder_save(fb_div);
    window.open(contextPath + 'web/formbuilder/view/' + currentFormId + '?preview=true')
};

function formbuilder_mobilePreview(fb_div){
    window.open(contextPath + 'web/formbuilder/mobileView/' + currentFormId + '?preview=true')
};

function formbuilder_html(fb_div){
    formbuilder_form_export(fb_div, true);
    var url = "#TB_inline?height=400&width=600&inlineId=formbuilder_export&modal=false";
    var caption = gettext('htmlpreview');
    tb_show(caption, url, null);
};


function formbuilder_form_export(fb_div, html, view){
    $('.editable').submit();
    $(fb_div).append('<div id="formbuilder_export" style="display:none"></div>');

    //for firefox
    if(/id="/.test($('#formbuilder_widgets_area').html())){
        $('#formbuilder_export').html($('#formbuilder_widgets_area').html().replace(/id="/g, 'id="_ex_'));
    }else
        $('#formbuilder_export').html($('#formbuilder_widgets_area').html().replace(/id=/g, 'id=_ex_'));

    //re-init html editor
    $.each($('textarea'), function(i, v){
        if(/_ex_htmleditor/.test(v.id)){
            initWymEditor(v);
        }
    });

    $('#formbuilder_export .formbuilder_widget_control').remove();
    $('.current_row').removeClass('current_row');

    $('#formbuilder_export').wrap('<form id="formbuilder_export_form" name="formbuilder_export_form" action="' + contextPath + 'web/formbuilder/submit" method="post" enctype="multipart/form-data" onsubmit="return false"></form>');


    //var button = '<input type="button" onclick="performValidation()" value="Validate">'
    //var button = '';
    //$('#formbuilder_export_form').append(button);

    //if is for viewing
    if(view){
       $('#formbuilder_export').show();
       $('#formbuilder_widgets_area').remove();

       loadFormVariable(function(){
           //Load subform data
           for(i=0;i<getSubFormDataList.length;i++){
               getFormData(getSubFormDataList[i].formId, getSubFormDataList[i].isFromParentProcess, getSubFormDataList[i].skipDataLoading);
           }
           getFormData();
       });

       //reattach datepicker as the id has already changed to "_ex_xxx"
       removeDatePicker();
       initDatePicker();
       initKeyValuePair();
       initTab();
       initHiddenField();
       removeEmptyLabel();
       removeLabelTitle();
    }
};

function removeSubformShowHideButton(){
    $('#formbuilder_export .hideShowButton').remove();
}

function removeMobileUnsupportElement(){
    //remove subform
    $('#formbuilder_export .formbuilder_subform').remove();

    //remove grid
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container table.gridTable').parent("div").parent("div").remove();

    //remove html editor
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container div.wym_box').parent("div").parent("div").remove();

    //remove datepicker icon
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container img.ui-datepicker-trigger').remove();
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container input.hasDatepicker').each(function(){
        var format = $(this).attr("dateformat");
        $(this).parent("div").append(" (format: "+format+")");
    });

    //remove custom html's textarea
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container textarea').each(function(){
        var id = $(this).attr("id");
        if(/_ex_customHtml/.test(id)){
            $(this).parent("div").append($(this).val());
            $(this).remove();
        }
    });

    //remove highlight class
    $('#formbuilder_export .highlight').each(function(){
        $(this).removeClass("highlight");
    });

    //remove file upload field
    $('#formbuilder_export .formbuilder_row .formbuilder_widget_container input[type="file"]').parent("div").parent("div").remove();
}

function removeLabelTitle(){
    $.each($('.formbuilder_label .label, .formbuilder_label .description, .formbuilder_widget_container .radio_label, .formbuilder_widget_container .checkbox_label'), function(i, v){
        $(v).removeAttr('title');
    });
}

function removeEmptyLabel(){
    $.each($('#formbuilder_export .formbuilder_label .label, #formbuilder_export .formbuilder_label .description'), function(i, v){
        if($(v).text() == '_'){
            $(v).text('');
        }
    });

    if($('#formbuilder_export .formbuilder_title').text() == "_"){
        $('#formbuilder_export .formbuilder_title').text('');
    }
}

function formbuilder_exit(fb_div){
    if(window.opener){
        window.close(this);
    } else {
        history.back();
    }
};

/**
* Flash effect
*/
function flash(e, delay){
    $(e).fadeIn('fast').fadeTo(delay, 1).fadeOut('slow');
};

/**
* Flash message
*/
function flash_message(message, delay){
    /*
    if(!delay){
        delay = 1000;
    }
    $('#formbuilder_flash_message').html(message);
    flash('#formbuilder_flash_message', delay);
    */
    //$.jGrowl(message);

};
/**
* Interface drawing functions
*/
function formbuilder_draw_controls(fb_div){
    $(fb_div).append('<div id="formbuilder_controls" style="display:none"></div>');
    $.each(fb_controls, function(i, n) {
        //$('#formbuilder_controls').append('<a href="javascript:formbuilder_' + i + '(\''+fb_div+'\')" title="' + n + '" class="formbuilder_controls">' + n + '</a>');
        $('#formbuilder_controls').append('<button onclick="javascript:formbuilder_' + i + '(\''+fb_div+'\')" title="' + n + '" class="formbuilder_controls">' + n + '</a>');
    });
    $('#formbuilder_controls').fadeIn('slow');
};

function formbuilder_draw_fieldset_mode(fb_div){
    $(fb_div).append('<div id="formbuilder_fieldset_mode"><span><label>' + gettext('fieldset_mode') + '&nbsp;</label></span><span><input type="radio" name="fieldsetMode" id="fieldsetMode_normal" onclick="setFieldsetMode(\'normal\')">&nbsp;' + gettext('fieldset_mode_normal') + '&nbsp&nbsp&nbsp&nbsp</span><span><input type="radio" name="fieldsetMode" id="fieldsetMode_tab" onclick="setFieldsetMode(\'tab\')">&nbsp;' + gettext('fieldset_mode_tab') + '</span></div>')
};

function formbuilder_draw_widget_area(div){
    $(div).append('<div id="formbuilder_widgets_area" style="display:none"><h2 class="formbuilder_editable formbuilder_title">' + gettext('formtitle') + ' ' + gettext('clic_to_edit') + '</h2><div id="formbuilder_rows"></div>');
    $('#formbuilder_widgets_area').fadeIn('slow');
    $('#formbuilder_widgets_area').append('<p class="formbuilder_required"><span class="formbuilder_required_marker">*</span> ' + gettext('required_lab') + '<input type="hidden" id="counter_rows" value="0" />' + '<input type="hidden" id="counter_fieldset" value="0" /></p>');
    formbuilder_widget_fieldset();
    set_editable();
};

function formbuilder_draw_widget_list(fb_div){
    $("#content_container").append('<div id="formbuilder_widgets_list" style="display:none; top:0px"><h2>'+ gettext('elements') +'</h2><ul></ul><p>' + gettext('msg_help') + '</p></div>');
    $.each(fb_widgets, function(i, n) {
        $('#formbuilder_widgets_list ul').append('<li><a onclick="javascript:formbuilder_widget_' + i + '()" title="'+gettext('element_add_new') +' ' + n + '" class="formbuilder_widgets"><img src="' + contextPath + 'lib/img/widget/' + i + '.png"> ' + n + '</a></li>');
    });
    $('#formbuilder_widgets_list').fadeIn('slow' , function(){flash_message(gettext('msg_widget_clic'), 3000)});

    //init scroll follow for widget list
    $('#formbuilder_widgets_list').scrollFollow();
};

function formbuilder_draw_property(fb_div){
    $('#formbuilder_property').Draggable({
            zIndex: 	60,
            ghosting:	true,
            opacity: 	0.7,
            handle:	'#formbuilder_property_handle'
    });
    $("#formbuilder_property").hide();
    $('#formbuilder_property_close').click(function(){
        $("#formbuilder_property").hide();
    });

    $('#formbuilder_property_save').click(function(){
        var regex = new RegExp('^[0-9a-zA-Z_]+$');
        var value = $("#formbuilder_property_form #name").attr('value');

        if(regex.test(value)){
            $.each($('.current_row input[@type!="hidden"], .current_row textarea, .current_row select'), function(k, v) {
                $(v).attr('name', $("#formbuilder_property_form #name").attr('value'));
                $(v).attr('tableName', $("#formbuilder_property_form #tableName").attr('value'));
                $(v).attr('columnName', '');
                $(v).attr('variableName', $("#formbuilder_property_form #variableName").attr('value'));
                $(v).attr('inputValidation', $("#formbuilder_property_form #inputValidation").attr('value'));
                $(v).attr('inputValidationMessage', $("#formbuilder_property_form #inputValidationMessage").attr('value'));
                $(v).attr('ignoreVariableIfEmpty', $("#formbuilder_property_form #ignoreVariableIfEmpty").attr('checked'));
                $(v).attr('dateFormat', $("#formbuilder_property_form #dateFormat").attr('value'));
                $(v).attr('deliminator', $("#formbuilder_property_form #deliminator").attr('value'));
                initDatePicker();

                var e = document.getElementById("formVariableId");
                if(e.options.length > 0)
                    $(v).attr('formVariableId', e.options[0].value);
                else
                    $(v).attr('formVariableId', '');
            });

            $("#formbuilder_property").hide();
        }else{
            alert(gettext('name_validation'));
        }
    });
};

function formbuilder_draw_flash(fb_div){
    $("#content_container").append('<div id="formbuilder_flash_message" style="display:none"></div>');
};

function formbuilder_row_moveup(rowid){
    if($(rowid).prev('.formbuilder_row')){
        var prev = $(rowid).prev('.formbuilder_row');
        prev.slideUp('fast', function(){
            prev.remove();
            $(rowid).after(prev);
            prev.slideDown('fast', function(){
                //reattach listener
                var rowid = prev.attr('id');
                var id = rowid.replace(/^row_/, '');
                prev.bind('click', function(e){
                    set_current_row('#' + rowid);
                    if(e.target.id != 'img_edit')
                        $("#formbuilder_property").hide();
                });

                //edit button
                var widgetType = $('#formbuilder_row_edit_' + id).attr("widgetType");
                $('#formbuilder_row_edit_' + id).bind('click', function(e){
                    formbuilder_row_edit('#' + rowid, e, widgetType);
                });

                prev.hover(
                    function(){
                        $('#' + rowid).addClass('highlight');
                    },
                    function(){
                        $('#' + rowid).removeClass('highlight');
                    }
                );
            });
        });
    }
};

function formbuilder_row_movedown(rowid){
    if($(rowid).next('.formbuilder_row')){
        var next = $(rowid).next('.formbuilder_row');
        next.slideUp('fast', function(){
            next.remove();
            $(rowid).before(next);
            next.slideDown('fast', function(){
                //reattach listener
                var rowid = next.attr('id');
                var id = rowid.replace(/^row_/, '');
                next.bind('click', function(e){
                    set_current_row('#' + rowid);
                    if(e.target.id != 'img_edit')
                        $("#formbuilder_property").hide();
                });

                //edit button
                var widgetType = $('#formbuilder_row_edit_' + id).attr("widgetType");
                $('#formbuilder_row_edit_' + id).bind('click', function(e){
                    formbuilder_row_edit('#' + rowid, e, widgetType);
                });

                next.hover(
                    function(){
                        $('#' + rowid).addClass('highlight');
                    },
                    function(){
                        $('#' + rowid).removeClass('highlight');
                    }
                );
            });
        });
    }
};

function formbuilder_row_del(rowid){
    $(rowid).fadeOut('slow', function(){$(rowid).remove();});
};

function formbuilder_row_disable(rowid){
    var disable = false;
    //for subform only
    var id = rowid.replace(/^#row_/, '');
    var subformRow = $('#subform_row_' + id + '_1');
    var parent = subformRow.parent().get(0);
    $.each($(parent).children('.formbuilder_row'), function(k, v) {
        if($(v).attr('isDisabled') == 'true'){
            $(v).attr('isDisabled', 'false');
            $(v).removeClass('subform_disabled');
            $(rowid).removeClass('subform_disabled');
        }else{
            disable = true;
            $(v).attr('isDisabled', 'true');
            $(v).addClass('subform_disabled');
            $(rowid).addClass('subform_disabled');
        }
    });

    $.each($(rowid + ' input[@type!="hidden"], ' + rowid + ' textarea, ' + rowid + ' select'), function(k, v) {
        v.disabled = disable;
    });
};

function formbuilder_row_edit(rowid, e, widgetType){
    $.each($('#formbuilder_property_form .formbuilder_property_row'), function(i, v){
        $(v).show();
    })

    //hide input field according to widgetType
    switch(widgetType){
        case 'text':
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'readonlytext':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'textarea':
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'readonlytextarea':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'htmleditor':
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'file':
            $("#formbuilder_property_form #propertyVariableName").hide();
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'customHtml':
            $("#formbuilder_property_form #propertyVariableName").hide();
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'grid':
            $("#formbuilder_property_form #propertyVariableName").hide();
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'select':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'radio':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'datepicker':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        case 'checkbox':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyVariableName").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            break;
        case 'hiddenfield':
            $("#formbuilder_property_form #propertyInputValidation").hide();
            $("#formbuilder_property_form #propertyInputValidationMessage").hide();
            $("#formbuilder_property_form #propertyFormVariableId").hide();
            $("#formbuilder_property_form #propertyDateFormat").hide();
            $("#formbuilder_property_form #propertyDeliminator").hide();
            break;
        default:
            break;
    }

    $.each($(rowid + ' input[@type!="hidden"].formbuilder_widget, ' + rowid + ' textarea.formbuilder_widget, ' + rowid + ' select.formbuilder_widget'), function(k, v) {
        $("#formbuilder_property_form #name").attr('value', $(v).attr('name'));
        $("#formbuilder_property_form #columnName").attr('value', $(v).attr('columnName'));
        $("#formbuilder_property_form #variableName").attr('value', $(v).attr('variableName'));
        $("#formbuilder_property_form #inputValidation").attr('value', $(v).attr('inputValidation'));
        $("#formbuilder_property_form #inputValidationMessage").attr('value', $(v).attr('inputValidationMessage'));
        $("#formbuilder_property_form #ignoreVariableIfEmpty").attr('checked', ($(v).attr('ignoreVariableIfEmpty') == undefined || $(v).attr('ignoreVariableIfEmpty') == 'false') ? false : $(v).attr('ignoreVariableIfEmpty'));
        $("#formbuilder_property_form #dateFormat").attr('value', $(v).attr('dateFormat'));
        $("#formbuilder_property_form #deliminator").attr('value', $(v).attr('deliminator'));
        setFormVariable($(v).attr('formVariableId'));
    });

    $("#formbuilder_property").css("left", e.pageX);
    $("#formbuilder_property").css("top", e.pageY);
    $("#formbuilder_property").show();
};

function formbuilder_fieldset_del(rowid){
    // Confirm if not empty
    if($(rowid + ' .formbuilder_row').length == 0
    || confirm(gettext('msg_confirm_fs_del'))) {
        $(rowid).fadeOut('slow', function(){$(rowid).remove();});
    }
};


function set_editable(){
    //console.log('set_editable start');
    $('.formbuilder_editable').editable(function(value, settings){return value ? value : '_';}, {
         type      : 'text',
         //cancel    : 'Annulla',
         //submit    : 'Ok',
         tooltip   : gettext('clic_to_edit') ,
         select    : true ,
         style     : 'inherit',
         cssclass  : 'inherit',
         onblur    : 'submit',
         rows      : 3,
         width     : 'auto',
         minwidth  : 150
    });
    //console.log('set_editable end');
    //$("#row_" + id ).fadeIn("slow");

    $(".formbuilder_editable").mouseover(function() {
        $(this).css({textDecoration: 'underline'});
    });
    $(".formbuilder_editable").mouseout(function() {
        $(this).css({textDecoration: 'none'});
    });

};


function unset_current_row(){
    $.each($(".current_row .formbuilder_widget_control a"), function(i, v){
        $(v).hide();
    });
    if($('#formbuilder_widgets_area .current_row').length){
        $.each($('#formbuilder_widgets_area .current_row'), function(k, v){
            $(v).removeClass('current_row');
        });
    }
}

function set_current_row(e){
    unset_current_fieldset();
    unset_current_row();
    $(e).toggleClass('current_row');
    $.each($(".current_row .formbuilder_widget_control a"), function(i, v){
        $(v).show();
    });
}

function get_current_row(){
    if($('#formbuilder_widgets_area .current_row').length){
        return $('#formbuilder_widgets_area .current_row')[0];
    }
    return null;
}

function unset_current_fieldset(){
    $.each($('#formbuilder_widgets_area fieldset'), function(i, v){
        $(v).removeClass('current_fieldset');
    })
}

function set_current_fieldset(e){
    unset_current_row();

    $.each($('#formbuilder_widgets_area fieldset'), function(i, v){
        $(v).removeClass('current_fieldset');
    })

    $(e).addClass('current_fieldset');
}

function get_current_fieldset(){
    if($('#formbuilder_widgets_area .current_fieldset').length){
        return $('#formbuilder_widgets_area .current_fieldset')[0];
    }
    if($('#formbuilder_widgets_area .current_row').length){
        return $('#formbuilder_widgets_area .current_row')[0].parent;
    }
    if($('#formbuilder_widgets_area fieldset').length){
        return $('#formbuilder_widgets_area fieldset')[$('#formbuilder_widgets_area fieldset').length -1];
    }
    return null;
}


/**
* Fieldset
*/
function formbuilder_widget_fieldset(label, fieldsetId){

    var id = parseInt($('#counter_fieldset').val());

    if(fieldsetId){

        var regex = /[^_]+_/;
        var tempId = parseInt(fieldsetId.replace(regex, ''));

        if(tempId >= id){
            $('#counter_fieldset').val(tempId + 1);
        }

        id = "fieldset_" + tempId;
    }else{
        $('#counter_fieldset').val(id + 1);
        id = "fieldset_" + id;
    }

    if(!label){
        label = gettext('fieldset_legend') + ' ' + gettext('clic_to_edit');
    }

    $('#formbuilder_widgets_area #formbuilder_rows').append('<fieldset id="' + id + '" class="formbuilder_fieldset"><legend class="formbuilder_legend"><span class="formbuilder_widget_control"><a title="'+gettext('clic_del_row')+'" href="#" onclick="formbuilder_fieldset_del(\'#' + id +  '\');return false"><img src="' + fb_lib_path + 'img/delete.png"/></a></span><span class="formbuilder_editable">' + label + '</span></legend></fieldset>');

    if(fieldsetMode == 'tab'){
        $('#' + id).addClass('tab');
        $('#' + id + " legend").addClass('tabTitle');
    }
    unset_current_row();
    set_editable();

    set_current_fieldset('#' + id);
    $('#' + id).bind('click', function(e){
        if(e.target.className.indexOf('formbuilder_fieldset') != -1 ){
            set_current_fieldset('#' + this.id);
        }
    });
}

/**
* Widgets
*/
//function formbuilder_widget_base(input_tpl, widget_type, no_required, label, description, required, isSubform){
function formbuilder_widget_base(widget){
    var id = parseInt($('#counter_rows').val());
    var widgetId = widget.config['row_id'];

    if(widgetId){

        var regex = /[^_]+_/;
        var tempId = parseInt(widgetId.replace(regex, ''));

        if(tempId >= id){
            $('#counter_rows').val(tempId + 1);
        }

        id = tempId;
    }else{
        $('#counter_rows').val(id + 1);
    }

    var required = widget.config.required;

    var inside = widget.getHtml(id);

    // Get current row
    if(get_current_row()){
        $(get_current_row()).after(inside);
    } else if ( get_current_fieldset()){
        $(get_current_fieldset()).append(inside);
    } else {
        flash(gettext('msg_err_insert'));
        return null;
    }
    $('#row_' + id).bind('click', function(e){
        set_current_row('#' + this.id);
        if(e.target.id != 'img_edit')
            $("#formbuilder_property").hide();
    });

    //edit button
    $('#formbuilder_row_edit_' + id).attr("widgetType", widget.config.type);
    $('#formbuilder_row_edit_' + id).bind('click', function(e){
	    formbuilder_row_edit('#row_' + id, e, widget.config.type);
    });

    $('#row_' + id).hover(
        function(){
            $('#' + this.id).addClass('highlight');
        },
        function(){
            $('#' + this.id).removeClass('highlight');
        }
    );

    set_current_row('#row_' + id);

    set_editable();
    if(required){
        formbuilder_widgets_switch_required('#row_' + id);
    }

    return id;
};

function formbuilder_widget_subform(){
    tb_show("Form List", contextPath + "web/formbuilder/list?keepThis=true&TB_iframe=true&height=500&width=700", null);
}

function formbuilder_widget_htmleditor(config, view){
    /*
    if(!label){
        label = gettext('name') + ' ' + gettext('clic_to_edit');
    }
    if(!description){
        description = gettext('description') + ' ' + gettext('clic_to_edit');
    }
    var value = controls ? controls[0].value : '';
    var name = controls ? controls[0].name : 'text_{id}';
    var columnName = controls ? controls[0].columnName : 'columnName_{id}';
    var variableName = controls ? controls[0].variableName : '';*/
    var id = formbuilder_widget_base(new HtmlEditor(config));
    //var id = formbuilder_widget_base('<textarea class="formbuilder_widget" name="' + name + '" columnName="' + columnName + '" variableName="' + variableName + '" id="htmleditor_{id}" cols="30">' + value + '</textarea>', 'htmleditor', false, label, description, required);

    if(view == undefined){
        initWymEditor("#htmleditor_" + id);
    }
}

function formbuilder_widget_text(config){
    formbuilder_widget_base(new TextField(config));
};

function formbuilder_widget_readonlytext(config){
    formbuilder_widget_base(new ReadOnlyTextField(config));
};

function formbuilder_widget_hiddenfield(config){
    formbuilder_widget_base(new HiddenField(config));
};

function formbuilder_widget_file(config){
    formbuilder_widget_base(new FileUpload(config));
};

function formbuilder_widget_customHtml(config){
    var id = formbuilder_widget_base(new CustomHtml(config));
};

function formbuilder_widget_textarea(config){
    formbuilder_widget_base(new TextArea(config));
};

function formbuilder_widget_readonlytextarea(config){
    formbuilder_widget_base(new ReadOnlyTextArea(config));
};

function formbuilder_widget_datepicker(config){
    formbuilder_widget_base(new DatePicker(config));
    initDatePicker();
};

function formbuilder_widget_select(config){
    var id = formbuilder_widget_base(new Select(config));

    if(!config || !config.options){
        //$('#select_' + id).addOption('', gettext('clic_opt_chs'));
        $('#select_' + id).addOption('', '');
    }
};

function formbuilder_option_add(id, value, text, checked){

    if(!(value || text)){
        var valueText = $('#formbuilder_keyValuePair_' + id + '_value').val();
        var labelText = $('#formbuilder_keyValuePair_' + id + '_label').val();

        if(!(valueText || labelText)){
            return;
        }else if(valueText && labelText){
            value = valueText + '|' + labelText;
        }else if(valueText){
             value = valueText;
        }else{
             value = labelText;
        }
        text = value;
    }
    if(checked){
        checked = true;
    }
    if($('#' + id).containsOption(value)) {
        alert(gettext('option_not_uniq'));
        return;
    }
    $('#' + id).addOption(value, text, checked);

    tb_remove();

    $("#formbuilder_keyValuePair").html("");
};

function formbuilder_option_del(id){
    if($('#' + id + ' option:selected') && $('#' + id + ' option:selected').val()){
        $('#' + id + ' option:selected').remove();
    } else {
        flash_message(gettext('msg_err_del_opt'));
    }
};

function formbuilder_widget_checkbox(controls){
    var config = {};
    if(controls)
        config = controls[0];

    var id = formbuilder_widget_base(new Checkbox(config));

    if(controls && controls.length > 0){
        $.each(controls, function(k, v){
             formbuilder_checkbox_add(id, v.checkboxLabel, v.checked, v.name, v.columnName, v.formVariableId, v.deliminator);
        });
    } else {
        formbuilder_checkbox_add(id, gettext('name') + ' ' + gettext('clic_to_edit'));
    }
};

function formbuilder_checkbox_add(row_id, label, checked, name, columnName, formVariableId, deliminator){
    if(!label){
        var valueText = $('#formbuilder_keyValuePair_' + row_id + '_value').val();
        var labelText = $('#formbuilder_keyValuePair_' + row_id + '_label').val();

        if(!(valueText || labelText)){
            return;
        }else if(valueText && labelText){
            label = valueText + '|' + labelText;
        }else if(valueText){
            label = valueText;
        }else{
            label = labelText;
        }

        tb_remove();

        $("#formbuilder_keyValuePair").html("");
    }
    if(!name){
        if($('#row_'+row_id).find('input[type=checkbox]').length > 0){
            name = $('#row_'+row_id).find('input[type=checkbox]').attr('name');
            columnName = $('#row_'+row_id).find('input[type=checkbox]').attr('columnname');
            formVariableId = $('#row_'+row_id).find('input[type=checkbox]').attr('formvariableid');
            deliminator = $('#row_'+row_id).find('input[type=checkbox]').attr('deliminator');
        }else{
            name = 'checkbox_' + row_id;
        }
    }
    if(!columnName){
        columnName = 'columnName_' + row_id;
    }
    if(!formVariableId){
        formVariableId = '';
    }
    if(!deliminator){
        deliminator = '|';
    }
    var cb_counter = $('#counter_checkbox_' + row_id).val();
    $('#counter_checkbox_' + row_id).val(++cb_counter);
    var currentValue = $('#counter2_checkbox_' + row_id).val();
    $('#counter2_checkbox_' + row_id).val(++currentValue);
    var cb_id      = 'checkbox_' + row_id + '_' + cb_counter;
    var cb_control = '<div id="checkbox_div_{id}"><input class="formbuilder_widget" name="{name}" columnName="{columnName}" formVariableId="{formVariableId}" value="{label}" deliminator="{deliminator}" id="checkbox_{id}" type="checkbox" ' + (checked ? 'checked="checked"' : '') + '/>&nbsp;<span class="checkbox_label" onclick="formbuilder_keyValuePair_init(\'checkbox_{id}\',\''+ gettext('clic_edit') +'\',\'formbuilder_keyValuePair_edit_save\');return false;">{label}</span><p class="formbuilder_widget_control">&nbsp;<a title="' + gettext('clic_cb_del_t') + '" href="#" onclick="formbuilder_checkbox_del(\'#checkbox_div_{id}\', \'#row_{row_id}\');return false"><img src="' + fb_lib_path + 'img/delete.png"/>' + gettext('clic_cb_del') + '</a></p></div>';
    var t = new Template(cb_control);
    $('#row_' + row_id + ' .formbuilder_checkbox_control').before(t.run({id : cb_id, label: label, row_id: row_id, name: name, columnName: columnName, formVariableId: formVariableId, deliminator: deliminator}));
    set_editable();
    check_required('#row_' + row_id);
};

function formbuilder_checkbox_del(cb_id, row_id){
    var counterId = row_id.replace(/^#row_/, '');
    var currentValue = $('#counter2_checkbox_' + counterId).val();

    if(currentValue == 1){
        alert("Must have at least one checkbox");
    }else{
        $('#counter2_checkbox_' + counterId).val(--currentValue);
        formbuilder_row_del(cb_id);
        check_required(row_id);
    }
};


function formbuilder_widget_radio(controls){
    var config = {};
    if(controls)
        config = controls[0];

    var id = formbuilder_widget_base(new RadioButton(config));

    if(controls && controls.length > 0){
        $.each(controls, function(k, v){
             formbuilder_radio_add(id, v.radioLabel, v.checked, v.name, v.columnName, v.formVariableId, v.variableName, v.ignoreVariableIfEmpty);
        });
    }else
        formbuilder_radio_add(id, gettext('name') + ' ' + gettext('clic_to_edit'));
};

function formbuilder_radio_add(row_id, label, checked, name, columnName, formVariableId, variableName, ignoreVariableIfEmpty){
    if(!label){
        var valueText = $('#formbuilder_keyValuePair_' + row_id + '_value').val();
        var labelText = $('#formbuilder_keyValuePair_' + row_id + '_label').val();

        if(!(valueText || labelText)){
            return;
        }else if(valueText && labelText){
            label = valueText + '|' + labelText;
        }else if(valueText){
            label = valueText;
        }else{
            label = labelText;
        }

        tb_remove();

        $("#formbuilder_keyValuePair").html("");
    }

    if(!name){
        if($('#row_'+row_id).find('input[type=radio]').length > 0){
            name = $('#row_'+row_id).find('input[type=radio]').attr('name');
            columnName = $('#row_'+row_id).find('input[type=radio]').attr('columnname');
            formVariableId = $('#row_'+row_id).find('input[type=radio]').attr('formvariableid');
            variableName = $('#row_'+row_id).find('input[type=radio]').attr('variablename');
            ignoreVariableIfEmpty = $('#row_'+row_id).find('input[type=radio]').attr('ignorevariableifempty');
        }else{
            name = 'radio_' + row_id;
        }
    }
    if(!columnName){
        columnName = 'columnName_' + row_id;
    }
    if(!formVariableId){
        formVariableId = '';
    }
    if(!variableName){
        variableName = '';
    }
    if(!ignoreVariableIfEmpty){
        ignoreVariableIfEmpty = '';
    }
    var cb_counter = $('#counter_radio_' + row_id).val();
    $('#counter_radio_' + row_id).val(++cb_counter);
    var cb_id      = 'radio_' + row_id + '_' + cb_counter;
    var currentValue = $('#counter2_radio_' + row_id).val();
    $('#counter2_radio_' + row_id).val(++currentValue);
    var cb_control = '<div id="radio_div_{id}"><input  class="formbuilder_widget" name="{name}" columnName="{columnName}" formVariableId="{formVariableId}" variableName="{variableName}" ignoreVariableIfEmpty="{ignoreVariableIfEmpty}" value="{label}" id="{id}" type="radio"' + (checked ? 'checked="checked"' : '') + '/>&nbsp;<span class="radio_label" onclick="formbuilder_keyValuePair_init(\'{id}\',\''+ gettext('clic_edit') +'\',\'formbuilder_keyValuePair_edit_save\');return false;">{label}</span><p class="formbuilder_widget_control">&nbsp;<a title="' + gettext('clic_radio_del_t') + '" href="#" onclick="formbuilder_radio_del(\'#radio_div_{id}\', \'#row_{row_id}\');return false"><img src="' + fb_lib_path + 'img/delete.png"/>' + gettext('clic_radio_del') + '</a></p></div>';
    var t = new Template(cb_control);
    $('#row_' + row_id + ' .formbuilder_radio_control').before(t.run({id : cb_id, row_id: row_id, label: label, name: name, columnName: columnName, formVariableId: formVariableId, variableName: variableName, ignoreVariableIfEmpty: ignoreVariableIfEmpty}));
    set_editable();
    check_required('#row_' + row_id);
};

function formbuilder_radio_del(cb_id, row_id){
    var counterId = row_id.replace(/^#row_/, '');
    var currentValue = $('#counter2_radio_' + counterId).val();

    if(currentValue == 1){
        alert("Must have at least one radio button");
    }else{
        $('#counter2_radio_' + counterId).val(--currentValue);
        formbuilder_row_del(cb_id);
        check_required(row_id);
    }
};

function formbuilder_keyValuePair_init(id, caption, action){
    var delim = '|';
    var text = '';

    if(action == 'formbuilder_keyValuePair_edit_save'){
         text = $("#"+id).val();
    }

    var label = text;
    var value = '';

    if (text.indexOf(delim) != -1){
        var tempText = text.split("|");
        value = tempText[0];
        label = tempText[1];
    }
    var popupForm = '<p>'+gettext('clic_option_value')+' : <input id="formbuilder_keyValuePair_'+id+'_value" type="text" value="'+value+'"></p><p>'+gettext('clic_option_label')+' : <input id="formbuilder_keyValuePair_'+id+'_label" type="text" value="'+label+'"></p><p><input type="button" onclick="'+action+'(\''+id+'\');return false" value="'+gettext('save')+'"></p>';

    $("#formbuilder_keyValuePair").html(popupForm);

    tb_show(caption, "#TB_inline?height=150&width=300&inlineId=formbuilder_keyValuePair", null);
};

function formbuilder_keyValuePair_edit_save(id){
    var delim = '|';
    var label = '';

    var labelText = $('#formbuilder_keyValuePair_' + id + '_label').val();
    var valueText = $('#formbuilder_keyValuePair_' + id + '_value').val();

    if(!(valueText || labelText)){
        return;
    }else if(valueText && labelText){
        label = valueText + delim + labelText;
    }else if(valueText){
        label = valueText;
    }else{
        label = labelText;
    }

    tb_remove();

    $("#formbuilder_keyValuePair").html("");

    $("#"+id).val(label);
    $("#"+id).next().text(label);

};

function formbuilder_widgets_switch_required(row_id){
    $.each($(row_id + ' input[@type!="hidden"] , ' + row_id + ' textarea, ' + row_id + ' select'), function(k, v){
        $(v).toggleClass('{required:true}');
    });
    if($(row_id + ' .formbuilder_required_marker').length){
        $(row_id + ' .formbuilder_required_marker').remove();
        //flash_message(gettext('msg_not_required'), 1);
    } else {
        $(row_id + ' .label').after('<span class="formbuilder_required_marker">*</span>');
        //flash_message(gettext('msg_is_required'), 1);
    }
};

function formbuilder_show_hide_subform(subformHeaderId){
    if($("#" + subformHeaderId).length == 0)
        $("#_ex_" + subformHeaderId).next().slideToggle('fast');
    else
        $("#" + subformHeaderId).next().slideToggle('fast');
}

function check_required(row_id){
    if($(row_id + ' .formbuilder_required_marker').length){
        $.each($(row_id + ' input[@type!="hidden"], ' + row_id + ' textarea, ' + row_id + ' select'), function(k, v){
            $(v).addClass('{required:true}');
        });
    }
};

function formbuilder_widget_grid(){
    //init grid modal window content
    var e = document.getElementById('gridColumn');
    e.selectedIndex = 0;
    $('#columns').html('');

    var url = "#TB_inline?height=400&width=700&inlineId=formbuilder_grid";
    var caption = gettext('grid');
    tb_show(caption, url, null);
}

function formbuilder_grid_add_row(id){

    var rowId = new Date().valueOf().toString();
    var html = '<tr id="' + rowId + '">';
    var n;

    var fromDataLoading = false;

    var selectorString = '';
    //if come from data loading
    if(/^_ex_/.test(id)){
        fromDataLoading = true;
        selectorString = '#' + id;
    //if come from normal add button
    }else{
        selectorString = '#_ex_' + id;
    }

    $(selectorString + ' .grid_header td').each(function(i, col){
        var id = $($(col).html()).attr('id');
        var name = $($(col).html()).attr('name');

        if(i == 0){
            n = parseInt($('#_ex_' + name + "_row").val());
            $('#_ex_' + name + "_row").val(n + 1);
        }
        var newId = "_ex_" + name + "_" + n;
        if(/^_ex_/.test(id)){
            html += '<td>';
            html += $(col).html().replace(/id=/, ' rowId="'+newId+'" id=');
            html += '</td>';
        }
    });

    var control = '&nbsp;<p class="formbuilder_widget_control2"><a title="' + gettext('clic_opt_del_t') + '" href="#" onclick="formbuilder_grid_del_row(' + rowId + ');return false"><img src="' + fb_lib_path + 'img/delete.png"/>'+gettext('clic_option_del')+'</a>';
    if($(selectorString).parent().parent().attr("isdisabled") == 'true'){
        control = '';
    }
    html += '<td>' + control + '</td>';
    html += '</tr>';
    $(selectorString).append(html);

    //clear the data that copy over from the default row
    $('#' + rowId + ' td').find('input, texxtarea').val('');
    $('#' + rowId + ' td').find('textarea').text('');
    $('#' + rowId + ' td').find('select option:first').attr('selected', 'true');

    //TEMP
    /*
    $(selectorString + ' tr').mouseover(function(){
        $(this).css('background', '#e5e5e5');
    });

    $(selectorString + ' tr').mouseout(function(){
        $(this).css('background', '#fff');
    });
    */
    //TEMP
}

function formbuilder_grid_del_row(gridRowId){
    $('#' + gridRowId).remove();
}
function initKeyValuePair(){

    var delim = '|';
    $.each($('#formbuilder_export select'), function(i, v){
        for(i=0; i<v.options.length; i++){
            if(v.options[i].value.indexOf(delim) != -1){
                var keyVal = v.options[i].value.split(delim);
                $(v.options[i]).attr('value', keyVal[0]);
                $(v.options[i]).text(keyVal[1]);
            }
        }
    })
    $.each($('#formbuilder_export input[type="checkbox"]'), function(i, v){
        if(v.value.indexOf(delim) != -1){
            var keyVal = v.value.split(delim);
            $(v).attr('value', keyVal[0]);
            $(v).next().html(keyVal[1]);
        }
    })
    $.each($('#formbuilder_export input[type="radio"]'), function(i, v){
        if(v.value.indexOf(delim) != -1){
            var keyVal = v.value.split(delim);
            $(v).attr('value', keyVal[0]);
            $(v).next().html(keyVal[1]);
        }
    })
}

function initFieldsetOverlay(){
    /*
    $.each($('fieldset'), function(i, v){
        $(document.createElement('div'))
                  .width($(v).width())
                  .height($(v).height())
                  .css({backgroundColor:'white', opacity:0.4, position:'absolute',left:0, top:0})
                  .prependTo($(v))
        $(v).css('position','relative');
    })
    */
   $('.formbuilder_widget_control2').remove();
   $('#formbuilder_main img.ui-datepicker-trigger').remove();
   $('#formbuilder_main input, #formbuilder_main textarea, #formbuilder_main select').attr('disabled', true);
}

function initHiddenField(){
    $.each($('#formbuilder_export input'), function(i, v){
        if(/hiddenfield/.test(v.id)){
            $(v).parent().parent().css('display', 'none');
        }
    });
}

function initTab(){
    $('#formbuilder_export #_ex_formbuilder_rows').prepend('<ul id="tablist" class="tablist"></ul>');

    var index = 0;
    $.each($('fieldset.tab'), function(i, v){
        var listId = 'tab_' + index;
        var tabTitle = $(v).find('legend.tabTitle span').html();

        $('#tablist').append('<li id="' + listId + '">' + tabTitle + '</li>');

        $('#' + listId).click(function(){
            $('#tablist li').removeClass("active");
            $('fieldset.tab').removeClass("active");
            $(this).addClass('active');
            $(v).addClass('active');
        });
        index++;
    });

    $('#tablist li:first').addClass("active");
    $('fieldset.tab:first').addClass("active");
};

function setFieldsetMode(mode){
    fieldsetMode = mode;
    $('#fieldsetMode_' + mode).attr("checked", true);
};
