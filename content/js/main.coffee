###
Author: Martin Owen
###

randomInt = (lower, upper=0) ->
  start = Math.random()
  if not lower?
    [lower, upper] = [0, lower]
  if lower > upper
    [lower, upper] = [upper, lower]
  return Math.floor(start * (upper - lower + 1) + lower)

class SiteHeaderMutator
  constructor: (@siteHeaderSelector, @mutationDuration, @staticLetters) ->
    $(@siteHeaderSelector).lettering()
    @letterCount = $(@siteHeaderSelector).text().length
    @letterIsMutating = []
    for i in [0..@letterCount]
      @letterIsMutating[i] = false

  run: ->
    for i in [1...@letterCount]
      @toggleLetterMutation(i) if randomInt(0,1) is 1

  toggleLetterMutation: (i) ->
    @properties = {}

    if @letterIsMutating[i-1] or i in @staticLetters
      return

    $letter = $(@siteHeaderSelector).find('.char' + i)

    @toggleFontSize $letter

    @letterIsMutating[i-1] = true
    callback = do (i) =>
      @letterIsMutating[i-1] = false
    $letter.animate @properties, @mutationDuration, 'swing', callback

  toggleFontSize: ($letter) ->
    minFontSize = '30px'
    maxFontSize = '50px'

    if $letter.css('font-size') is maxFontSize
      @properties['font-size'] = minFontSize
    else
      @properties['font-size'] = maxFontSize

  revert: ->
    for i in [1...@letterCount]
      $letter = $(@siteHeaderSelector).find('.char' + i)
      callback = do (i) =>
        @letterIsMutating[i-1] = false
      $letter.animate { 'font-size': '40px' }, @mutationDuration, 'swing', callback

$ ->
  articleHeadingMutator = new SiteHeaderMutator '#main article header h1', 1000, [1]
  callback = ->
    now = new Date()
    seconds = now.getSeconds()
    if seconds % 20 is 0
      articleHeadingMutator.run()
    else if seconds + 1 % 20 is 0
      articleHeadingMutator.revert()
  setInterval callback, 5000