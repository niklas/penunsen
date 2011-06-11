jQuery(document).ready ->
  $('form.statement_search').bind 'modified', ->
      $form = $(this)
      $.ajax
        url: $form.attr('action')
        data: $form.serialize()
        dataType: 'script'


