jQuery(document).ready ->
  format_date = (value) ->
    if value instanceof Date
      $.datepicker.formatDate('yy-mm-dd', value)
    else
      value

  parse_date = (string) ->
    if string instanceof Date
      string
    else
      new Date(string)
      
  $('form.statement_search').each ->
    $form = $(this)
    $after  = $('#statement_search_before')
    $before = $('#statement_search_after')

    $after.closest('div').hide()
    $before.closest('div').hide()

    $slider = $form.find('.before-after:first')
    $slider.dateRangeSlider
      bounds:
        min: parse_date($slider.data('min'))
        max: parse_date($slider.data('max'))
      defaultValues:
        min: parse_date($after.val())
        max: parse_date($before.val())
      valueLabels: "show"

    $slider.bind 'valuesChanging', (event, ui) ->
      $after.val format_date(ui.values.max)
      $before.val format_date(ui.values.min)

    #$slider.slider
    #  range: true
    #  min: $slider.data('min')
    #  max: $slider.data('max')
    #  values: [ $after.val(), $before.val() ]
    #  slide: (event, ui) ->
    #    $after.val( ui.values[0] )
    #    $before.val( ui.values[1] )


