// https://www.websudoku.com/?select=1&level=1

var table = new Array();
for (var i = 0; i < 9; i++) {
	var row = new Array();
	for (var j = 0; j < 9; j++) {
		var el = document.getElementById('f'+i+j);
		if( el['value'] !== '' ){
			row.push( el.value );
		}else{
			row.push( null );
		}
	}
	table.push( row );	
}

console.log(JSON.stringify(table));