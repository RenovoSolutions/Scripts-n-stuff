function saveAsCSV() {
  // Get the sheet name
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetName();
  
  // Add csv extension to sheet name
  fileName = sheet + ".csv";
  
  // Convert the data to csv format
  var csvFile = convertRangeToCsvFile_(fileName, sheet);
  
  // Delete the old doc
  deleteDocByName(fileName);
  
  // Create the new doc
  DriveApp.createFile(fileName, csvFile);
}

function convertRangeToCsvFile_(csvFileName, sheet) {
  // get available data range in the spreadsheet
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getSheets()[0];
  var activeRange = sheet.getDataRange();
  try {
    var data = activeRange.getValues();
    var csvFile = undefined;

    // loop through the data in the range and build a string with the csv data
    if (data.length > 1) {
      var csv = "";
      for (var row = 0; row < data.length; row++) {
        for (var col = 0; col < data[row].length; col++) {
          if (data[row][col].toString().indexOf(",") != -1) {
            data[row][col] = "\"" + data[row][col] + "\"";
          }
        }

        // join each row's columns
        // add a carriage return to end of each row, except for the last one
        if (row < data.length-1) {
          csv += data[row].join(",") + "\r\n";
        }
        else {
          csv += data[row];
        }
      }
      csvFile = csv;
    }
    return csvFile;
  }
  catch(err) {
    Logger.log(err);
    Browser.msgBox(err);
  }
}

function deleteDocByName(fileName) {
  var docs = DriveApp.getFilesByName(fileName)
  while (docs.hasNext()) {
    file = docs.next();
    file.setTrashed(true);
  }
}