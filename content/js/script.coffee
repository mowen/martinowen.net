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
    if @letterIsMutating[i-1] or i in @staticLetters
      return

    $letter = $(@siteHeaderSelector).find('.char' + i)

    if $letter.css('font-size') is '70px'
      properties = { 'font-size': '50px' }
    else
      properties = { 'font-size': '70px' }

    @letterIsMutating[i-1] = true
    callback = do (i) =>
      @letterIsMutating[i-1] = false
    $letter.animate properties, @mutationDuration, 'swing', callback

$ ->
  siteHeaderMutator = new SiteHeaderMutator '#site-header a', 1000, [1,8]
  mutate = ->
    siteHeaderMutator.run()
  setInterval mutate, 5000