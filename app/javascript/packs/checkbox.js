$(document).on('turbolinks:load', function() {
  $('#checkbox-all').on('click', () => {
    onChangeCheckBoxAll();
  });
  var j = 0;
  while(true) {
    var checkboxItem = document.getElementById("checkbox_" + (j+1) + "_result");
    if (checkboxItem !== undefined && checkboxItem !== null) {
      $("#checkbox_" + (j+1) + "_result").on('click', () => {
        onChangeCheckBoxItem();
      });
      j++;
    } else {
      break;
    }
  }
  $('#submitButtonCheckbox').on('click', () => {
    confirm('Are you sure about that')
  });
});

function onChangeCheckBoxItem() {
  var i = 0;
  while(true) {
    var checkboxItem = document.getElementById("checkbox_" + (i+1) + "_result");
    if (checkboxItem !== undefined && checkboxItem !== null) {
      if(!checkboxItem.checked) {
        document.getElementById("checkbox-all").checked = false;
        return;
      }
      i++;
    } else {
      break;
    }
  }
  document.getElementById("checkbox-all").checked = true;
}

function onChangeCheckBoxAll() {
  var i = 0;
  while(true) {
    var checkboxItem = document.getElementById("checkbox_" + (i+1) + "_result");
    if (checkboxItem !== undefined && checkboxItem !== null) {
      checkboxItem.checked = document.getElementById("checkbox-all").checked;

      i++;
    } else {
      break;
    }
  }
}
