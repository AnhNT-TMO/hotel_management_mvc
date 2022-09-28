$(document).on('turbolinks:load', function() {
  $('#checkbox-all').on('click', () => {
    onChangeCheckBoxAll();
    onChangeMoneyItem()
  });
  var j = 0;
  while(true) {
    var checkboxItem = document.getElementById('checkbox_' + (j+1) + '_result');
    if (checkboxItem !== undefined && checkboxItem !== null) {
      $('#checkbox_' + (j+1) + '_result').on('click', () => {
        onChangeCheckBoxItem();
        onChangeMoneyItem()
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
    var checkboxItem = document.getElementById('checkbox_' + (i+1) + '_result');
    if (checkboxItem !== undefined && checkboxItem !== null) {
      if(!checkboxItem.checked) {
        document.getElementById('checkbox-all').checked = false;
        return;
      }
      i++;
    } else {
      break;
    }
  }
  document.getElementById('checkbox-all').checked = true;
}

function onChangeMoneyItem() {
  var i = 0;
  var total_price = 0;
  while(true) {
    var checkboxItem = document.getElementById('checkbox_' + (i+1) + '_result');
    if (checkboxItem !== undefined && checkboxItem !== null) {
      if(checkboxItem.checked) {
        total_price += parseInt(document.getElementById('subtotal_'+ (i+1)).getAttribute('value'));
        document.getElementById('checkbox_' + (i+1)).value = 1
      } else {
        document.getElementById('checkbox_' + (i+1)).value = 0
      }
      i++;
    } else {
      break;
    }
  }
  $('#basket-subtotal').html(total_price);
  $('#basket-total').html(total_price);
}

function onChangeCheckBoxAll() {
  var i = 0;
  while(true) {
    var checkboxItem = document.getElementById('checkbox_' + (i+1) + '_result');
    if (checkboxItem !== undefined && checkboxItem !== null) {
      checkboxItem.checked = document.getElementById('checkbox-all').checked;

      i++;
    } else {
      break;
    }
  }
}
