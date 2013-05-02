###
Author: Martin Owen
###

$ ->
  options =
    in:
      effect: 'tada'
      shuffle: true
    out:
      effect: 'tada'
      shuffle: true
    loop: true
  $('#main article header h1').textillate options
