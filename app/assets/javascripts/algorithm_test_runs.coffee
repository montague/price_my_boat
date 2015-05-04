$ ->
  $form = $('#new_algorithm_test_run')
  Utils.loaderFor($form)
  $form.on 'ajax:complete', (event, xhr, status) ->
    $('#algorithm_test_run').html(xhr.responseText)