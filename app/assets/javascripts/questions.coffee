# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide();
    $('form#edit-question').show()

PrivatePub.subscribe "/questions", (data, channel) ->
  question = $.parseJSON(data['question'])
  $('.questions').append('<h4><a href="/questions/' + question.id + '">' + question.title + '</a></h4>')