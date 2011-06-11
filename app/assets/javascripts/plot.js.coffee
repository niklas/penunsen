jQuery(document).ready ->
  $('#plot').each ->
    $plot = $(this)

    $source = $('#table')

    table = ->
      $source.find('table.statements')

    if table().length == 0
      alert("no table with statements found")

    parsedBalances = ->
      $.makeArray table().find('tr[data-balance][data-entered-at]').map ->
        [[
          new Date( $(this).data('entered-at') )
          $(this).data('balance') / 100
        ]]

    plot = null

    plotAll = ->
      plot = $.plot $plot,
        [
          data: parsedBalances()
          points:
            show: 'yes'
          lines:
            show: 'yes'
        ],
        xaxis:
          mode: 'time'
          timeformat: '%y-%0m-%0d'

    $source.bind 'updated', plotAll

    plotAll()
