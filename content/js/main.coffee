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

$ ->
  martinMutator = new SiteHeaderMutator '#side-header .martin', 1000, [1]
  owenMutator = new SiteHeaderMutator '#side-header .owen', 1000, [1]
  mutate = ->
    martinMutator.run()
    owenMutator.run()
  setInterval mutate, 5000