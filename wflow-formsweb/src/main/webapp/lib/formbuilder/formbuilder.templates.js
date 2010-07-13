/**
* Simple template system
* Usage:
* var t = new Template('<div id="div_{id}" class="{class}"></div>');
* var html = t.run({id : 'div_one', class : 'my_class'});
*/
Template = function(tpl){
    this.tpl = tpl;
    this.tokens = [];
    this.is_compiled = false;
    this.compile = function(){
        var re = /\{(\w+)\}/g;
        var tok;
        while((tok = re.exec(this.tpl)) != null) {
            this.tokens.push(tok[1]);
        }
        this.is_compiled = true;
    };
    this.run = function(json){
        if(!this.is_compiled){
            this.compile();
        }
        if(json){
            for (var jk = 0; jk < this.tokens.length; jk++){
                try{
                    var pattern = new RegExp('\{' + this.tokens[jk] + '\}', 'g');
                    if(json[this.tokens[jk]] != undefined){
                        this.tpl = this.tpl.replace(pattern, json[this.tokens[jk]]);
                    }
                }catch(err){

                }
            }
        }
        return this.tpl;
    };
};