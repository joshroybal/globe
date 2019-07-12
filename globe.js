function localeString(x, sep, grp) {
   var sx = (''+x).split('.'), s = '', i, j;
   sep || (sep = ','); // default seperator
   grp || grp === 0 || (grp = 3); // default grouping
   i = sx[0].length;
   while (i > grp) {
      j = i - grp;
      s = sep + sx[0].slice(j, i) + s;
      i = j;
   }
   s = sx[0].slice(0, i) + s;
   sx[0] = s;
   return sx.join('.');
}

function AddStyle()
{
   var stylesheet = document.getElementById("styleinfo");
   stylesheet.innerHTML = "<link rel='stylesheet' media='all' type='text/css' href='/includes/gradienttable.css'/>";

   var table = document.getElementById("my_table");
   table.classList.add("gradienttable-mini");

   for (var i = 1, row; row = table.rows[i]; i++) {
      // iterate through rows
      // rows would be accessed using the "row" variable assigned in the for loop
      for (var j = 0, col; col = row.cells[j]; j++) {
         //iterate through columns
         //columns would be accessed using the "col" variable assigned in the for loop
         if ( isNaN(col.innerHTML) ) {
            col.outerHTML = "<td style='text-align:left;'>" + col.innerHTML + "</td>";
         } else {
            col.outerHTML = "<td style='text-align:right;'>" + localeString(col.innerHTML) + "</td>";
         }
      }
   }
}
window.onload = AddStyle;
