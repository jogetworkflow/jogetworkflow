<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.form.util.FormUtil"%>

<%
    String rightToLeft = FormUtil.getSystemSetupValue("rightToLeft");
    pageContext.setAttribute("rightToLeft", rightToLeft);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" debug="true">

<head>
  <title><fmt:message key="formbuilder.form_builder"/> - ${name}</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <!--<script language="javascript" type="text/javascript" src="lib/firebug/firebug.js"></script>-->

  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/lib/css/formbuilder.css">

  <c:if test="${rightToLeft == 'true'}">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/lib/css/formbuilder_rtl.css">
  </c:if>

  <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/lib/jquery/jquery-1.2.6.min.js" ></script>
  <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/lib/formbuilder/formbuilder.init.js.jsp?id=${id}" ></script>

<script type="text/javascript">
    window.onbeforeunload = warning;

    function warning(){
        return "<fmt:message key="formbuilder.msg_closing"/>";
    }

    $(document).keydown(function(e){
        if(e.which == 27 && $("#formbuilder_property").css('display')=='block') {  // escape
            $("#formbuilder_property").hide();
        }
    });
</script>

</head>
<body>
    <div id="formbuilder_main">
      <img src="lib/img/loadingAnimation.gif" alt="alt" width="208" height="13" />
    </div>

    <div id="formbuilder_property">
      <div id="formbuilder_property_handle">
        <h3><fmt:message key="formbuilder.advanced_properties"/></h3>
      </div>
      <div id="formbuilder_property_content">
        <form id="formbuilder_property_form" method="post" action="save_settings.php">
          <div id="propertyName" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.name"/> </p>
            <input type="text" name="name" id="name" value="" />
          </div>
          <div id="propertyInputValidation" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.input_validation"/></p>
            <select name="inputValidation" id="inputValidation">
                <option value=""><fmt:message key="formbuilder.none"/></option>
                <option value="[a-zA-Z0-9]+"><fmt:message key="formbuilder.alpha_numeric"/></option>
                <option value="[0-9]+"><fmt:message key="formbuilder.numeric_only"/></option>
                <option value="[a-zA-Z]+"><fmt:message key="formbuilder.alphabet_only"/></option>
            </select>
          </div>
          <div id="propertyInputValidationMessage" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.input_validation_message"/></p>
            <input type="text" name="inputValidationMessage" id="inputValidationMessage" value="" />
          </div>
          <div id="propertyDateFormat" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.date_format"/> </p>
            <input type="text" name="dateFormat" id="dateFormat" value="" />
          </div>
          <div id="propertyDeliminator" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.deliminator"/> </p>
            <input type="text" name="deliminator" id="deliminator" value="" />
          </div>
          <div id="propertyVariableName" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.workflow_variable_name"/> </p>
            <input type="text" name="variableName" id="variableName" value="" /><br>
            <input type="checkbox" name="ignoreVariableIfEmpty" id="ignoreVariableIfEmpty" value="" /> <fmt:message key="formbuilder.ignore_if_empty"/>
          </div>
          <div id="propertyFormVariableId" class="formbuilder_property_row">
            <p><fmt:message key="formbuilder.form_variable"/> </p>
            <select multiple="true" size="1" name="formVariableId" id="formVariableId" style="width: 50%"></select>
            <br>
            <input type="button" name="selectFormVariabe" id="selectForVariable" value="<fmt:message key="formbuilder.btn_select"/>" onclick="selectFormVariable()"/>
            <input type="button" name="removeFormVariabe" id="removeForVariable" value="<fmt:message key="formbuilder.remove"/>" onclick="removeFormVariable()"/>
          </div>

        </form>
      </div>
      <div style="border-top: 1px solid #000;"></div>
      <br>
      <input type="button" id="formbuilder_property_save" name="submit" value="<fmt:message key="formbuilder.done"/>" />
      <input type="button" id="formbuilder_property_close" name="cancel" value="<fmt:message key="formbuilder.cancel"/>" />
      <br><br>
    </div>

    <div id="formbuilder_grid" style="display: none">
          <div id="formbuilder_grid_row">
            <p><h2><fmt:message key="formbuilder.number_of_columns"/></h2></p><br>
            <select id="gridColumn" name="column" onchange="changeColumn(this.options[this.selectedIndex].value)">
                <option value="0"><fmt:message key="formbuilder.please_select"/></option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
          </div>
          <div style="border-top: 1px dotted silver; margin-top:8px"></div>
          <div id="formbuilder_grid_row">
              <p><h2></h2></p>
            <div id="columns"></div>
          </div>
          <input type="button" id="formbuilder_grid_ok" onclick="gridSave()" name="ok" value="<fmt:message key="formbuilder.ok"/>" />
          <input type="button" id="formbuilder_grid_cancel" onclick="tb_remove()" name="cancel" value="<fmt:message key="formbuilder.cancel"/>" />
    </div>

    <div id="formbuilder_keyValuePair" style="display: none"></div>

<script type="text/javascript">
    function setFormVariable(id){
        if(id!=null){
            $('#formVariableId').html('');
            tb_remove();
            var url = contextPath + 'web/formbuilder/variable/getName/' + id;
            $.getJSON(url, function(json){
                $('#formVariableId').html('<option value="' + id + '">' + json.data + '</option>');
            })
        }
    }

    function selectFormVariable(){
        tb_show("Form Variable List", contextPath + "web/formbuilder/variable/list?keepThis=true&TB_iframe=true&height=500&width=700", null);
    }

    function removeFormVariable(){
        $('#formVariableId').html('');
    }

    function gridSave(){
        var e = document.getElementById("gridColumn");
        var count = e.options[e.selectedIndex].value;

        if(count == 0){
            tb_remove();
            return;
        }

        var grid = new Grid({disableControl: true});
        var cont = true;

        loop:
        for(i=0; i<count; i++){
            e = document.getElementById("columnType_" + i);
            var type = e.options[e.selectedIndex].value;
            switch(type){
                case 'text':
                    grid.addColumn(new TextField());
                    break;
                case 'textarea':
                    grid.addColumn(new TextArea());
                    break;
                case 'select':
                    grid.addColumn(new Select(null, i));
                    break;
                default:
                    alert('<fmt:message key="formbuilder.msg_select_type"/> ' + (i+1));
                    e.focus();
                    cont = false
                    break loop;
            }
        }

        if(cont){
            tb_remove();
            formbuilder_widget_base(grid);
        }
    }

    function changeColumn(n){
        $('#columns').html('');
        for(i=0; i<n; i++){
            var baseString = '';
            baseString += '<div id="column_' + i + '">';
            baseString += '<fmt:message key="formbuilder.column"/> ' + (i+1) + ' :';
            baseString += '<select id="columnType_' + i + '" name="type">';
            baseString += '<option value=""><fmt:message key="formbuilder.please_select"/></option>';
            baseString += '<option value="text"><fmt:message key="formbuilder.text"/></option>';
            baseString += '<option value="textarea"><fmt:message key="formbuilder.textarea"/></option>';
            baseString += '<option value="select"><fmt:message key="formbuilder.select"/></option>';
            baseString += '</select>';
            baseString += '</div>';

            $('#columns').append(baseString);
            $('#columns').append('<div style="border-top: 1px dotted silver; margin-top:8px; margin-bottom:8px"></div>');
        }
    }
</script>

</body>
</html> 