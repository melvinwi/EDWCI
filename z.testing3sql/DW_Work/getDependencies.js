
var fs = require('fs');



var files = fs.readdirSync('.');

for (var i=0; i<files.length; i++) {
	var item = files[i];

	if (item.substring(item.length-4, item.length).toLowerCase()=='.sql') {
		process(item);
	}
}





function process(filename) {

	console.log('\n\n\nTRANSFORM: '+filename);

	var file = fs.readFileSync(filename).toString();


	var parts = file.split('DW_Staging');

	var tables = new Array();

	for (var i=0; i<parts.length; i++) {
		var item = parts[i];

		tables[tables.length] = item.substring(0, item.indexOf(' ')).replace('].[orion].', '').replace('USE', '').trim();

	}


	//tables = tables.unique();

	console.log(tables);


}


Array.prototype.contains = function(v) {
    for(var i = 0; i < this.length; i++) {
        if(this[i] === v) return true;
    }
    return false;
};


Array.prototype.unique = function() {
    var arr = [];
    for(var i = 0; i < this.length; i++) {
        if(!arr.contains(this[i])) {
            arr.push(this[i]);
        }
    }
    return arr; 
}
