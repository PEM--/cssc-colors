# Forked from the amazing color theme = https =//github.com/mrmrs/colors
# Cool Colors
CSSC.aqua = '#7FDBFF'
CSSC.blue = '#0074D9'
CSSC.lime = '#01FF70'
CSSC.navy = '#001F3F'
CSSC.teal = '#39CCCC'
CSSC.olive = '#3D9970'
CSSC.green = '#2ECC40'

# Warm Colors
CSSC.red = '#FF4136'
CSSC.maroon = '#85144B'
CSSC.orange = '#FF851B'
CSSC.purple = '#B10DC9'
CSSC.yellow = '#FFDC00'
CSSC.fuchsia = '#F012BE'

# Gray Scale Colors
CSSC.gray = '#AAAAAA'
CSSC.white = '#FFFFFF'
CSSC.black = '#111111'
CSSC.silver = '#DDDDDD'

###
CSSC.Clr: Color manipulations.
@example
  c = new CSSC.Clr
###
class CSSC.Clr
  ###
  C-tor creating a color.
  @param  {Object} val  Can be:
    * `undefined`: RGBA are [0,0,0,1].
    * `String`: An hex string like '#FF4136'.
    * `Array`:
      * [`String`, A] with an hex string like '#FF4136' and A in [0..1].
      * [R, G, B] or [R, G, B, A] with R, G, B in [0..255].
      * ['hsl', H, S, L] or ['hsl', H, S, L, A] with H, S, L in [0..1].
  @return {CSSC.Clr} A color object.
  ###
  constructor: (val) ->
    @_a = 1
    unless val?
      @_r = @_g = @_b = 0
    else if typeof val is 'string'
      [@_r, @_g, @_b] = (parseInt str, 16 \
        for str in (val.substr 1).match /.{2}/g)
    else if val.length is 2
      [@_r, @_g, @_b] = (parseInt str, 16 \
        for str in (val[0].substr 1).match /.{2}/g)
      @_a = val[1]
    else if val.length is 3
      [@_r, @_g, @_b] = val
    else if val.length is 4 and typeof val[0] is 'number'
      [@_r, @_g, @_b, @_a] = val
    else if val[0] is 'hsl' and val.length is 4
      [dummy, @_h, @_s, @_l] = val
    else if val[0] is 'hsl' and val.length is 5
      [dummy, @_h, @_s, @_l, @_a] = val

  ###
  Getter
  @param {String} str A color component: 'r', 'g', 'b', 'h', 's', 'l' or 'a'
  @return {Number} The value of the component.
  ###
  get: (str) ->
    # Make conversion if hasn't been done before
    switch str
      when 'r', 'g', 'b'
        console.log 'converting RGB'
        [@_r, @_g, @_b] = (CSSC.Clr.hsl2Rgb @_h, @_s, @_l) unless @_r?
      when 'h', 's', 'l'
        console.log 'converting HSL'
        [@_h, @_s, @_l] = (CSSC.Clr.rgb2Hsl @_r, @_g, @_b) unless @_h?
    @["_#{str}"]

  ###
  Setter
  @param {String} str A color component: 'r', 'g', 'b', 'h', 's', 'l' or 'a'
  @param {Number} val Value set on the chosen component.
  ###
  set: (str, val) ->
    # Destroy former conversion if it is available
    switch str
      when 'r', 'g', 'b'
        [@_h, @_s, @_l] = [undefined, undefined, undefined]
      when 'h', 's', 'l'
        [@_r, @_g, @_b] = [undefined, undefined, undefined]
    @["_#{str}"] = val

  ###
  Transform to String.
  @return {String} An hex string like '#FF4136'.
  ###
  toString: ->
    # Make conversion to RGB if it hasn't done it before
    [@_r, @_g, @_b] = (CSSC.Clr.hsl2Rgb @_h, @_s, @_l) unless @_r?
    padded = (val) ->
      str = (Number val).toString 16
      return str if str.length is 2
      "0#{str}"
    "##{padded @_r}#{padded @_g}#{padded @_b}"

  ###
  Transform to a RGBA String.
  @return {String} A string as 'rgb(r,b,g,a)'.
  ###
  rgba: ->
    # Make conversion to RGB if it hasn't done it before
    [@_r, @_g, @_b] = (CSSC.Clr.hsl2Rgb @_h, @_s, @_l) unless @_r?
    "rgba(#{@_r},#{@_g},#{@_b},#{@_a})"

  ###
  Transform to a HSL String.
  @return {String} A string as 'hsl(h,s,l)'.
  ###
  hsl: ->
    # Make conversion to HSL if it hasn't done it before
    [@_h, @_s, @_l] = (CSSC.Clr.rgb2Hsl @_r, @_g, @_b) unless @_h?
    "hsl(#{360*@_h},#{100*@_s}%,#{100*@_l}%)"

  ###
  Transform to a HSLA String.
  @return {String} A string as 'hsl(h,s,l,a)'.
  ###
  hsla: ->
    # Make conversion to HSL if it hasn't done it before
    [@_h, @_s, @_l] = (CSSC.Clr.rgb2Hsl @_r, @_g, @_b) unless @_h?
    "hsla(#{360*@_h},#{100*@_s}%,#{100*@_l}%,#{@_a})"

  ###
  Static chromatic conversion HSL to RGB.
  @param {Number} h Hue in [0..1].
  @param {Number} s Saturation in [0..1].
  @param {Number} l Lightness in [0..1].
  @return {Array} [R, G, B] with R, G, and B in [0..255].
  ###
  @hsl2Rgb: (h, s, l) ->
    return [(Math.round l*255),(Math.round l*255),(Math.round l*255)] if s is 0
    return [0, 0, 0] if l is 0
    hue2Rgb = (p, q, t) ->
      if t < 0 then t += 1
      if t > 1 then t -= 1
      if t < 1/6 then return p + (q - p) * 6 * t
      if t < 1/2 then return q
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6
      p
    q = if l < 0.5 then l * (1 + s) else l + s - l * s
    p = 2 * l - q
    r = hue2Rgb p, q, h + 1/3
    g = hue2Rgb p, q, h
    b = hue2Rgb p, q, h - 1/3
    [(Math.round r*255), (Math.round g*255), (Math.round b*255)]

  ###
  Static chromatic conversion RGB to HSL.
  @param {Number} r R in [0..255].
  @param {Number} g G in [0..255].
  @param {Number} b B in [0..255].
  @return {Array} [h, s, l] with h, s, and l in [0..1].
  ###
  @rgb2Hsl: (r, g, b) ->
    r /= 255
    g /= 255
    b /= 255
    max = Math.max r, g, b
    min = Math.min r, g, b
    l = (max + min)/2
    return [0, 0, l] if max = min
    d = max - min
    s = if l > 0.5 then d / (2 - max - min) else d / (max + min)
    switch max
      when r then h = (g - b) / d + (g < b ? 6 : 0)
      when g then h = (b - r) / d + 2
      when b then h = (r - g) / d + 4
    h /= 6
    [h, s, l]
