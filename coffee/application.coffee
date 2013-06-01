window.check_status = ->
  $.getJSON "/now_playing.json", (data, status, jqxhr) ->
    if data.status == "PLAYING"
      $(".now-playing").show()
      $(".now-playing h3").html(data.current_music)
    else
      $(".now-playing").hide()

$ ->
  window.setInterval window.check_status, 10000
  $(document).on "click", ".add-link", (e) ->
    e.preventDefault()
    $.getJSON $(this).attr("href"), (data, status, jqxhr) ->
      if data.status == "ok"
        history.back()
      else
        alert "Aconteceu um erro inesperado!"
    false