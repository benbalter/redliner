# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

//= require jquery
//= require jquery-ui
//= require rangy-official/rangy-core
//= require hallo/dist/hallo
//= require showdown/compressed/showdown
//= require to-markdown/dist/to-markdown

jQuery ($) ->
  converter = new Showdown.converter();

  # Convert Markdown to HTML
  $('#editor').html converter.makeHtml($("#contents").text())

  # Init editor
  $('.editable').hallo({
    plugins:
      halloformat: {}
      halloheadings: {}
      hallolists: {}
      halloreundo: {}
    toolbar: "halloToolbarFixed"
  })

  $('.editable').bind 'hallomodified', (event, data) ->
    md = toMarkdown(data.content)
    $("#contents").text(md)
