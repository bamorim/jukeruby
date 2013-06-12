window.check_status = ->
  $.getJSON "/api/v1/now_playing", (data, status, jqxhr) ->
    if data.status == "PLAYING"
      $(".now-playing").show()
      $(".now-playing h3").html(data.current_music)
    else
      $(".now-playing").hide()

$ ->
  window.setInterval window.check_status, 10000
  $(document).on "click", ".add-link", (e) ->
    e.preventDefault()
    $.post "/api/v1/playlist", {path: $(this).attr("data-path")}, ->
      history.back()
    , "json"
    false