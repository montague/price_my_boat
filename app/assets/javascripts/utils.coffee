window.Utils =
  # uses jquery-ujs custom ajax events
  # see https://github.com/rails/jquery-ujs/wiki/ajax
  loaderFor: ($form) ->
    $img = $('<img/>').attr('src', image_path('loader.gif'))
    if $form.find($img).size() == 0
      $img.hide()
      $form.append($img)
    $form
      .on 'ajax:send', ->
        $img.show()
      .on 'ajax:complete', ->
        $img.hide()
