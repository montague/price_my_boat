$ ->
  $form = $('#new_boat_listing_query')
  Utils.loaderFor($form)
  $form.on 'ajax:complete', (event, xhr, status) ->
    $('#query_result').html(xhr.responseText)
