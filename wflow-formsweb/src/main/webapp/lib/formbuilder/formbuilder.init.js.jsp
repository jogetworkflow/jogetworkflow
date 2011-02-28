<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

/**
* Main
*/
var fb_compressed      = false;
var contextPath        = '${pageContext.request.contextPath}/';
var processRequesterId = '<c:out value="${param.processRequesterId}" escapeXml="true"/>';
var currentProcessId   = '<c:out value="${param.processId}" escapeXml="true"/>';
var currentFormId      = '<c:out value="${param.id}" escapeXml="true"/>';
var currentActivityId  = '<c:out value="${param.activityId}" escapeXml="true"/>';
var view               = false;
var overlay            = false;
var fileBaseLink       = '${pageContext.request.contextPath}/web/formbuilder/file/get';
var fb_lib_path        = '${pageContext.request.contextPath}/lib/';
var fb_lang_path       = '${pageContext.request.contextPath}/lib/formbuilder/lang/';
var fb_lang_avail      = ['en']; // Available languages, first is default

var fb_css_path        = '${pageContext.request.contextPath}/lib/css/';
var fb_jquery_plugins  = [ // List of jquery lib and plugins to be loaded at startup
                          'jquery.jeditable.js',
                          'jquery.selectboxes.js',
                          'jquery.thickbox.js',
                          'jquery.metadata.js',
                          'jquery.json.js',
                          'interface.js',
                          'wymeditor/jquery.wymeditor.pack.js',
                          'jquery.maskedInput.js',
                          'jquery.blockUI.js',
                          'jquery.scrollfollow.js',
                          'jquery.form.js',
                          'jquery.ajaxfileupload.js'
                         ];
var fb_css             = ['thickbox.css']; // List of css to load
var fb_loadform_ep     = '${pageContext.request.contextPath}/web/formbuilder/json/getFormData/<c:out value="${param.id}?activityId=${param.activityId}" escapeXml="true"/>&view=${param.view}';
var fb_loadsubform_ep  = '${pageContext.request.contextPath}/web/formbuilder/json/getSubForm/';
var fb_saveform_ep     = '${pageContext.request.contextPath}/web/formbuilder/admin/json/save';
var fb_formbuilder_mod = ['formbuilder.core.js', 'formbuilder.templates.js'];
var fb_formbuilder_widget = [
                             'formbuilder.class.js',
                             'formbuilder.widget.js',
                             'formbuilder.widget.textfield.js',
                             'formbuilder.widget.readonlytextfield.js',
                             'formbuilder.widget.textarea.js',
                             'formbuilder.widget.readonlytextarea.js',
                             'formbuilder.widget.htmleditor.js',
                             'formbuilder.widget.fileupload.js',
                             'formbuilder.widget.select.js',
                             'formbuilder.widget.subform.js',
                             'formbuilder.widget.grid.js',
                             'formbuilder.widget.radiobutton.js',
                             'formbuilder.widget.checkbox.js',
                             'formbuilder.widget.datepicker.js',
                             'formbuilder.widget.hiddenfield.js',
                             'formbuilder.widget.customHtml.js'
                            ];
var fb_current_row     = null;
var customHtmlIds = [];

<c:if test="${param.view == 'true'}">
    view = true;
</c:if>
<c:if test="${!empty param.numOfSubForm}">
    var numOfSubForm = <c:out value="${param.numOfSubForm}" escapeXml="true"/>;

    //number of subforms plus itself
    var numOfGetData = <c:out value="${param.numOfSubForm}" escapeXml="true"/> + 1;
</c:if>
<c:if test="${empty param.numOfSubForm}">
    var numOfSubForm = 0;
    var numOfGetData = 1;
</c:if>
var subFormCounter = 0;
var getDataCounter = 0;

var getSubFormDataList = new Array();

/**
* Function to load js scripts on demand
*/
function js_load(script_url){
    document.write('<script type="text/javascript" src="'+script_url+'"></script>');
}

function css_load(css_url){
    document.write('<link rel="stylesheet" href="'+css_url+'" type="text/css" media="screen" />');
}

/**
* Load required jquery plugins
*/
for (var i = 0; i < fb_jquery_plugins.length; i++){
    js_load( fb_lib_path + 'jquery/'  + (fb_compressed ? 'compressed/' : '') + fb_jquery_plugins[i] );
}

/**
* Load language file
*/
var fb_useragent_lang = (navigator.language ? navigator.language /* Mozilla */ : navigator.userLanguage /* IE */).substr(0, 2);

var fb_user_lang = fb_lang_avail[0];

for(var i = 0; i < fb_lang_avail.length; i++){
    if(fb_lang_avail[i] == fb_useragent_lang){
        fb_user_lang = fb_useragent_lang;
    }
}
js_load("${pageContext.request.contextPath}/web/formbuilder/message");

function gettext(key){
    if(key == 'clic_to_edit'){
        <c:if test="${param.view == 'true'}">
            return '';
        </c:if>
    }
    return fb_lang[key] ? fb_lang[key] : 'No translation for ' + key;
};

/**
* For datepicker widget
*/
js_load("${pageContext.request.contextPath}/js/jquery/ui/packed/jquery.ui.all.packed.js");
js_load("${pageContext.request.contextPath}/js/jquery/ui/ui.core.js");
js_load("${pageContext.request.contextPath}/js/json/ui.js");
css_load("${pageContext.request.contextPath}/js/jquery/themes/themeroller/jquery-ui-themeroller.css");

/**
* Load required formbuilder modules
*/
for (var i = 0; i < fb_formbuilder_mod.length; i++){
    js_load( fb_lib_path + 'formbuilder/' + (fb_compressed ? 'compressed/' : '') + fb_formbuilder_mod[i] );
}

/**
* Load required formbuilder widget
*/
for (var i = 0; i < fb_formbuilder_widget.length; i++){
    js_load( fb_lib_path + 'formbuilder/' + (fb_compressed ? 'compressed/' : '') + fb_formbuilder_widget[i] );
}

/**
* Load required css
*/
for (var i = 0; i < fb_css.length; i++){
    css_load( fb_css_path + fb_css[i] );
}

//for form viewing submission
function appendHiddenFields(){
    $('#formbuilder_export_form').append('<input type="hidden" name="id" value="' + currentFormId + '">');
    $('#formbuilder_export_form').append('<input type="hidden" id="processId" name="processId" value="<c:out value="${param.processId}" escapeXml="true"/>">');
    $('#formbuilder_export_form').append('<input type="hidden" id="processDefId" name="processDefId" value="<c:out value="${param.processDefId}" escapeXml="true"/>">');
    $('#formbuilder_export_form').append('<input type="hidden" id="activityId" name="activityId" value="<c:out value="${param.activityId}" escapeXml="true"/>">');
    $('#formbuilder_export_form').append('<input type="hidden" id="version" name="version" value="<c:out value="${param.version}" escapeXml="true"/>">');
    $('#formbuilder_export_form').append('<input type="hidden" id="username" name="username" value="<c:out value="${param.username}" escapeXml="true"/>">');
    $('#formbuilder_export_form').append('<input type="hidden" id="parentProcessId" name="parentProcessId" value="<c:out value="${param.parentProcessId}" escapeXml="true"/>">');
    $.unblockUI(null, setWymEditorHtml);
}

//for retrieveing form data
//if 'formId' is not null, it's for subform
function getFormData(formId, isFromParentProcess, skipDataLoading){
    var currentUsername = "<c:out value="${param.username}" escapeXml="true"/>";

    if(skipDataLoading == undefined || !skipDataLoading){
        var thisFormId = '<c:out value="${param.id}" escapeXml="true"/>';

        var thisProcessId = '<c:out value="${param.processId}" escapeXml="true"/>';
        if(isFromParentProcess && isFromParentProcess == 'true'){
            thisProcessId = processRequesterId;
        }

        if(!formId)
            var url = contextPath + 'web/formbuilder/json/getData?id=<c:out value="${param.id}" escapeXml="true"/>&processId=' + thisProcessId + '&activityId=<c:out value="${param.activityId}" escapeXml="true"/>';
        else{
            thisFormId = formId;
            var url = contextPath + 'web/formbuilder/json/getData?id=' + formId + '&processId=' + thisProcessId + '&activityId=<c:out value="${param.activityId}" escapeXml="true"/>';
        }
        url += '&rnd' + new Date().valueOf().toString();

        var loadedGridId = "";
        $.getJSON(url, function(json){

            if( typeof(json) != 'object' || /^Error/.test(json)){
                alert(data);
                return;
            }

            var elements = null;

            if(formId){
                elements = $('#_ex_subform_content_'+formId).find('select, input, textarea');
            }else{
                $('#_ex_formbuilder_rows fieldset').children('div').each(function(i){
                    if(/^_ex_row_/.test($(this).attr('id'))){
                        if(!$(this).hasClass('formbuilder_subform')){
                            if(elements == null){
                                elements = $.merge([], $(this).find('select, input, textarea'));
                            }else{
                                elements = $.merge(elements, $(this).find('select, input, textarea'));
                            }
                        }
                    }
                });
            }

            if(elements != null){
                $.each(elements, function(i, v){
                    //do not load data for hiddenfield
                    if(!/hiddenfield/.test(v.id)){
                        $.each(json.data, function(pName, pVal){
                            //remove form field prefix
                            pName = pName.replace(/^c_/, '');

                            if(pName == $(v).attr('name') || (pName.replace(/^var_/, '') == $(v).attr('variablename'))){
                                if($(v).attr('type')){
                                    if($(v).attr('type') == 'radio'){
                                        $.each($('input[@name="' + $(v).attr('name') + '"]'), function(index, radio){
                                            if($(radio).attr('value') == pVal){
                                                $(radio).attr('checked', 'yes')
                                            }
                                        });
                                    }else if($(v).attr('type') == 'checkbox'){
                                        //checkbox value deliminator = |
                                        var vals = pVal.split("|");
                                        $.each(vals, function(valIndex, val){
                                            $.each($('input[@name="' + $(v).attr('name') + '"]'), function(index, checkbox){
                                                if($(checkbox).attr('value') == val){
                                                    $(checkbox).attr('checked', 'yes')
                                                }
                                            });
                                        });
                                    }else if(($(v).attr('type') == 'textarea' || $(v).attr('type') == 'readonlytextarea' || $(v).attr('type') == 'customHtml' || $(v).attr('type') == 'htmleditor') && !$(v).attr('rowid')){
                                        if(pVal instanceof Object){
                                            var baseString = '';
                                            $.each(pVal, function(i, val){
                                                //remove first & last double quote
                                                val = val.replace(/^"/, '');
                                                val = val.replace(/"$/, '');
                                                var temp = val.split('"|"');
                                                baseString += temp + "\n";
                                            })
                                            $(v).val(baseString);
                                        }else{
                                            $(v).val(pVal);
                                        }
                                    }else if($(v).attr('type') == 'file'){
                                        var widgetContainer = $(v).parent().get(0);
                                        var divId = v.id + "_" + v.name + "_fileDownload";
                                        var fileLink = '<a href="' + fileBaseLink + '?fileName=' + encodeURI(pVal) + '&processId=<c:out value="${param.processId}" escapeXml="true"/>">';
                                        if($('#' + divId).length == 0){
                                            var baseString = '<div id="' + divId + '">uploaded file: ' + fileLink + pVal + '</a></div>';
                                            $(widgetContainer).append(baseString);
                                        }else{
                                            $('#' + divId).html('uploaded file: ' + fileLink + pVal);
                                        }
                                    }else{
                                        //if it's grid data
                                        if(pVal instanceof Object){
                                            //check if it's for other input fields first
                                            /*if($('input[@name="' + pName + '"]').length == 1){
                                                var finalValue = "";
                                                $.each(pVal, function(i, val){
                                                    val = val.replace(/^"/, '');
                                                    val = val.replace(/"$/, '');
                                                    var temp = val.split('"|"');
                                                    for(j in temp){
                                                        finalValue += temp[j];
                                                        if(j != temp.length - 1)
                                                            finalValue += ',';
                                                    }
                                                });

                                                $(v).attr("value", finalValue);
                                            }else{*/

                                                if($(v).parent().get(0).tagName == 'TD'){

                                                    //get corresponding grid table row id
                                                    var gridTable = $(v).parents().get(3);
                                                    var id = $(gridTable).attr('id');
                                                    //var m = /grid_(\d)+$/.exec(id);
                                                    //id = m[1];
                                                    if(loadedGridId.indexOf(id + "|") == -1){
                                                        var rowsData = [];
                                                        $.each(pVal, function(i, val){
                                                            //remove first & last double quote
                                                            val = val.replace(/^"/, '');
                                                            val = val.replace(/"$/, '');
                                                            var temp = val.split('"|"');
                                                            rowsData.push(temp);
                                                            if(i != 0)
                                                                formbuilder_grid_add_row(id);
                                                        })

                                                        //insert data into grid
                                                        for(var j=0; j<rowsData.length; j++){
                                                            //console.log('*[rowid="_ex_' + pName + '_' + j + '"]');
                                                            //for firefox
                                                            var selector = '*[rowid="_ex_' + pName + '_' + j + '"]';
                                                            $.each($(selector), function(i, v){
                                                                $(v).val(rowsData[j][i]);
                                                            })

                                                            //for IE (temp. hack)
                                                            if(j == 0){
                                                                var selector = '*[rowid="' + pName + '_' + j + '"]';
                                                                $.each($(selector), function(i, v){
                                                                    $(v).val(rowsData[j][i]);
                                                                })
                                                            }
                                                        }

                                                        loadedGridId += id + "|";
                                                    }
                                                //}
                                            }
                                        }else{
                                            $(v).attr("value", pVal);
                                        }
                                    }
                                }else{

                                    $(v).attr("value", pVal);
                                }
                            }
                        });
                    }
                });
            }

            //to make sure all forms/subforms finish loading data before appending hidden fields
            //or else they will got overwridden
            getDataCounter++;

            if(getDataCounter == numOfGetData){
                initCustomHtml();
                appendHiddenFields();

                if(overlay)
                    initFieldsetOverlay();
            }
        });
    }else{
        getDataCounter++;

        if(getDataCounter == numOfGetData){
            initCustomHtml();
            appendHiddenFields();

            if(overlay)
                initFieldsetOverlay();
        }
    }

}

function setWymEditorHtml(){
    $.each($('textarea'), function(i, v){
        if(/_ex_htmleditor/.test($(v).attr('id'))){
            $.each(WYMeditor.INSTANCES, function(i, w){
                if($(w._element).attr('id') == $(v).attr('id')){
                    w.html($(v).val());
                }
            })
        }
    })
}

function initCustomHtml(){
    /*
    $.each($('.formbuilder_customHtml'), function(i, v){
        var html = $(v).html();
        html = html.replace(/id=\"_ex_/g, 'id="');
        $(v).html(html);
    })
    */
    $.each($('#formbuilder_export textarea'), function(i, v){
        if($(v).attr('id').indexOf('customHtml') != -1){
            var customHtmlContent = $(v).val().replace(/<!--\/textarea-->/g, "</textarea>");
            $(v).parent().html("<div id=\"" + $(v).attr('id') + "\">" + customHtmlContent + "</div>");
        }
    })

    //perform custom javascript after loading the form (if any)
    if(typeof formbuilderOnReady == 'function'){
       formbuilderOnReady();
    }
};

function loadFormVariable(callback){
    try{
        var url = contextPath + 'web/formbuilder/getFormVariable?formVariableId=';

        var loadedInputName = '';

        if($('*[formvariableid]').length == 0){
            if(callback){
                callback();
            }
            return;
        }

        var formVariableCounter = $('*[formvariableid]').length;

        $.each($('*[formvariableid]'), function(i, v){
            var formVariableId = $(v).attr('formvariableid');
            if(formVariableId.indexOf('_ex_') != -1)
                formVariableId = formVariableId.replace(/_ex_/, '');

            if(formVariableId != 'undefined' && formVariableId != ''){

                var id = v.id;
                $(v).html('');

                $.getJSON(url + formVariableId, function(json){
                    //if(loadedInputName.indexOf(v.name + '|') == -1){
                        var formbuilderWidgetContainer = null;
                        if(v.type == 'radio' || v.type == 'checkbox'){
                            formbuilderWidgetContainer = $(v).parents().get(1);
                            $(formbuilderWidgetContainer).html('');
                        }

                        for(key in json.data){
                            if(v.type == 'radio'){
                                var baseString = '<div id="{id}"><input {disabled} class="{cssClass}" name="{name}" columnName="{columnName}" value="{value}" id="checkbox_{id}" type="radio"/>&nbsp;<span class="radio_label">{label}</span></div>';
                                var t = new Template(baseString);
                                var val = t.run({
                                    id: v.id,
                                    name: v.name,
                                    cssClass: $(v).attr('class'),
                                    columnName: $(v).attr('columnName'),
                                    value: key,
                                    label: json.data[key],
                                    disabled : (v.disabled) ? 'disabled="disabled"' : ''
                                });
                                $(formbuilderWidgetContainer).append(val);
                            }else if(v.type == 'checkbox'){
                                var baseString = '<div id="{id}"><input {disabled} class="{cssClass}" name="{name}" columnName="{columnName}" value="{value}" id="checkbox_{id}" type="checkbox"/>&nbsp;<span class="checkbox_label">{label}</span></div>';
                                var t = new Template(baseString);
                                var val = t.run({
                                    id: v.id,
                                    name: v.name,
                                    cssClass: $(v).attr('class'),
                                    columnName: $(v).attr('columnName'),
                                    value: key,
                                    label: json.data[key],
                                    disabled : (v.disabled) ? 'disabled="disabled"' : ''
                                });
                                $(formbuilderWidgetContainer).append(val);
                            }else{
                                $(v).append('<option value="' + key + '">' + json.data[key] + '</option>');
                            }
                        }
                        loadedInputName += v.name + '|';

                        formVariableCounter--;
                        if(formVariableCounter == 0){
                            if(callback){
                                callback();
                            }
                        }
                    //}
                });//end getJSON
            }else{
                formVariableCounter--;
                if(formVariableCounter == 0){
                    if(callback){
                        callback();
                    }
                }
            }
        });
    }catch(err){
        if(callback){
            callback();
        }
    }
}

function submitForm(redirection, callback, isDraft){
    var validationPass = false;

    if(isDraft){
        validationPass = true;
    }else{
        validationPass = performValidation();
    }

    if(validationPass){
        $.each(WYMeditor.INSTANCES, function(i, v){
            v.update();
        })

        var form = $('#formbuilder_export_form');
        var fileIdList = [];
        $.each($('input[@type=file]'), function(i, v){
            if($(v).val() != '')
                fileIdList.push(v.id);
        })

        if(fileIdList.length == 0){
            var form = $('#formbuilder_export_form');
            $.post(form.attr('action'), form.serialize(), function(response){
                submitFormSuccess(redirection, callback, response);
            });

        }else{
            $.ajaxFileUpload({
                url: form.attr('action') + '?' + form.serialize(),
                secureuri: false,
                fileElementId: fileIdList,
                dataType: 'json',
                success: function (response, status){
                    submitFormSuccess(redirection, callback, response);
                },
                error: function (response, status, e){
                    submitFormSuccess(redirection, callback, response);
                    return false;
                }
            });
        }
    }else{
        //perform custom on validation failed event
        if(typeof formbuilderOnValidationFailed == 'function'){
            formbuilderOnValidationFailed();
        }
    }
}

function submitFormSuccess(redirection, callback, response){
    var showSavedAlert = true;

    //perform custom on submit success event
    if(typeof formbuilderOnSubmitSuccess == 'function'){
        showSavedAlert = false;
        formbuilderOnSubmitSuccess(response);
    }

    if(redirection && redirection != 'true')
        document.location.href = redirection;
    else if(callback){
        callback(response);
    }else if(showSavedAlert){
        alert(gettext('msg_form_saved'));
    }
}

function resetForm(redirection){
    $("#formbuilder_export_form").clearForm();
    if(redirection && redirection != 'true')
        document.location.href = redirection;
}

function performValidation(){
    $.each($('.validation-error-message'), function(i, v){
        $(v).remove();
    });

    var containError = false;
    var focus = false;

    //perform custom validation (if any)
    if(typeof formbuilderCustomValidation == 'function'){
        containError = formbuilderCustomValidation();
    }

    //check required fields
    $.each($('#formbuilder_export_form input[@type="text"], #formbuilder_export_form textarea, #formbuilder_export_form select'), function(i, v){
        if($(v).attr('class').indexOf('{required:true}') != -1){
            var val = $(v).val();
            var name = $(v).attr('name');
            if(v.id.indexOf('optionAdd') == -1 && val == ''){
                $(v).after('<div class="validation-error-message" style="color: red;">' + gettext('val_required') + '</div>');
                containError = true;
            }
        }
        gettext('val_required');
    });

    var form = $('#formbuilder_export_form');
    var serialize = form.serialize();
    var serialize = '&' + serialize;
    var checkedElement = '';
    $.each($('#formbuilder_export_form input[@type="radio"], #formbuilder_export_form input[@type="checkbox"]'), function(i, v){
        if($(v).attr('class').indexOf('{required:true}') != -1){
            var name = $(v).attr('name');
            if(checkedElement.indexOf('|' + name) == -1){
                checkedElement += '|' + name;
                if(serialize.indexOf('&' + name) == -1){
                    $(v).parent().parent().append('<div class="validation-error-message" style="color: red;">' + gettext('val_required') + '</div>');
                    containError = true;
                }
            }
        }
    });

    //check custom validation
    if(!containError){
        $.each($('#formbuilder_export_form input[@type="text"] ,#formbuilder_export_form textarea'), function(i, v){
            if($(v).attr('inputValidation') != undefined && $(v).attr('inputValidation') != ''){
                var regex = new RegExp('^'+$(v).attr('inputValidation')+'$');
                var msg = $(v).attr('inputValidationMessage');
                var value = $(v).val();

                if(!regex.exec(value)){
                    if(msg == '')
                        msg = 'validation failed';

                    $(v).after('<div class="validation-error-message" style="color: red;">' + msg + '</div>');
                    containError = true;

                    //first input with error gets focus
                    if(!focus){
                        v.focus();
                        focus = true;
                    }
                }
            }
        })
    }

    if(containError){
        if($('#generalErrorMessage').length == 0)
            $('#formbuilder_export').append('<h3 id="generalErrorMessage" style="color:red; margin: 5px 0 5px 0"><b>' + gettext('msg_error_in_form') + '</b></h3>');
    }

    return !containError;
}

//to make sure every subform is completely loaded before exporting
function subformLoadComplete(subFormId, isFromParentProcess){

    //get data for subform
    if(subFormId != undefined && isFromParentProcess != undefined){
        var temp = new Object();
        temp.formId = subFormId;
        temp.isFromParentProcess = isFromParentProcess;
        temp.skipDataLoading = false;
        getSubFormDataList[getSubFormDataList.length] = temp;
    }else{
        //skip Data loading
        var temp = new Object();
        temp.formId = subFormId;
        temp.isFromParentProcess = isFromParentProcess;
        temp.skipDataLoading = true;
        getSubFormDataList[getSubFormDataList.length] = temp;
    }

    subFormCounter++;
    if(subFormCounter == numOfSubForm)
        formbuilder_form_export('#formbuilder_main', null, true);
}

/**
* Initialize all datepicker widget
*/
function initDatePicker(){
    $.each($('input'), function(i, v){
        if(v.id.indexOf("datepicker") != -1){
            if($(v).attr("disabled") == false){
                $("#" + v.id).datepicker({showOn: 'button', buttonImage: contextPath + 'lib/img/calendar.png', buttonImageOnly: true, dateFormat: $(v).attr('dateFormat'), yearRange: '-100:+100'});
            }
        }
    });
}

/**
* Remove all datepicker widget
*/
function removeDatePicker(){
    $.each($('input'), function(i, v){
        if(v.id.indexOf("datepicker") != -1){
            $.datepicker._destroyDatepicker(v);
        }
    });
}

/**
* Start the interface
*/
$(document).ready(function(){
        $.blockUI.defaults.css.top = '50px';
        $.blockUI({ message: '<h1 style="font-size: 12pt; padding: 1em">' + gettext('msg_loading') + '</h1>' });
    <c:if test="${param.view != 'true'}">
        //form edit
        formbuilder_start('#formbuilder_main');
        initDatePicker();
    </c:if>
    <c:if test="${param.view == 'true'}">
        <c:if test="${param.overlay == 'true'}">
            overlay = true;
        </c:if>

        //form view
        var fb_div = '#formbuilder_main';
        $(fb_div).html('');
        formbuilder_draw_widget_area(fb_div);
        formbuilder_load(fb_div, true);
        $(fb_div).css("width", "auto");
    </c:if>


});