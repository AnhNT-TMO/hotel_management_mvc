$(document).on('mouseover', '#new_review .rating .fa-star', function () {
  let rate = $(this).data('star');
  let star_dom = $(this).parent().find('.fa-star');
  star_dom.removeClass('active');
  for (let i = 0; i < rate; i++) {
    star_dom.eq(i).addClass('active');
  }
  $('#review_rating').val(rate);
});
$(document).on('turbolinks:load', function() {
  var error_explanation = $(".alert_message_devise_error");
  for (let i = 0; i < error_explanation.length; i++) {
    toastr.error(error_explanation[i].innerHTML, "", {"closeButton": true})
  }

  var error_explanation_second = $(".alert_message_devise_notice");
  for (let i = 0; i < error_explanation_second.length; i++) {
    toastr.success(error_explanation_second[i].innerHTML, "", {"closeButton": true})
  }

  $('#clear_search_button').on('click', (e) => {
    e.preventDefault();
    $('#search_by_start_date').val('');
    $('#search_by_end_date').val('');
    $('#search_created_at_eq').val('');
  });
});
