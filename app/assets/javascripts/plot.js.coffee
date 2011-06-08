jQuery(document).ready ->
  $table = $('table.statements')
  $.jqplot.config.enablePlugins = true

  if $table.length > 0
    statements = jQuery.makeArray $table.find('tbody tr').map ->
      [[
        $(this).data('entered_at')
        $(this).data('balance') / 100
      ]]

    graph = $.jqplot 'plot', [ statements ],
      axes:
        xaxis:
          renderer:$.jqplot.DateAxisRenderer
          rendererOptions:
            tickRenderer: $.jqplot.CanvasAxisTickRenderer
          tickOptions:
            formatString:'%m-%d'
            textColor: "#fff"
        yaxis:
          rendererOptions:
            forceTickAt0: true

