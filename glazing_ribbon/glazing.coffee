class Particle

  constructor: (W, H) ->

    #location on the canvas
    @location = x: Math.random() * W, y: Math.random() * H
    #radius - lets make this 0
    @radius = 0
    #speed
    @speed = 3
    #steering angle in degrees range = 0 to 360
    @angle = Math.random() * 360
    #colors
    r = Math.round Math.random() * 255
    g = Math.round Math.random() * 255
    b = Math.round Math.random() * 255
    a = Math.random()
    @rgba = "rgba(#{r}, #{g}, #{b}, #{a})"

window.onload = ->
  canvas = document.getElementById "canvas"
  ctx = canvas.getContext "2d"
  
  W = window.innerWidth
  H = window.innerHeight
  canvas.width = W
  canvas.height = H
  
  #Lets make some particles
  particles = (new Particle(W, H) for [0..25])
  
  #Lets draw the particles
  draw = ->
    #re-paint the BG
    #Lets fill the canvas black
    #reduce opacity of bg fill.
    #blending time
    ctx.globalCompositeOperation = "source-over"
    ctx.fillStyle = "rgba(0, 0, 0, 0.02)"
    ctx.fillRect 0, 0, W, H
    ctx.globalCompositeOperation = "lighter"
    
    for p in particles
      ctx.fillStyle = "white"
      ctx.fillRect p.location.x, p.location.y, p.radius, p.radius
      
      #Lets move the particles
      #So we basically created a set of particles moving in random direction
      #at the same speed
      #Time to add ribbon effect
      for p2 in particles
        #calculating distance of particle with all other particles
        yd = p2.location.y - p.location.y
        xd = p2.location.x - p.location.x
        distance = Math.sqrt xd*xd + yd*yd
        #draw a line between both particles if they are in 200px range
        if distance < 200
          ctx.beginPath()
          ctx.lineWidth = 1
          ctx.moveTo p.location.x, p.location.y
          ctx.lineTo p2.location.x, p2.location.y
          ctx.strokeStyle = p.rgba
          ctx.stroke()
          #The ribbons appear now.
      
      #We are using simple vectors here
      #New x = old x + speed * cos(angle)
      p.location.x = p.location.x + p.speed * Math.cos p.angle * Math.PI/180
      #New y = old y + speed * sin(angle)
      p.location.y = p.location.y + p.speed * Math.sin p.angle * Math.PI/180
      #You can read about vectors here:
      #http://physics.about.com/od/mathematics/a/VectorMath.htm
      
      p.location.x = W if p.location.x < 0
      p.location.x = 0 if p.location.x > W
      p.location.y = H if p.location.y < 0
      p.location.y = 0 if p.location.y > H
  
    window.requestAnimFrame draw
    
  window.requestAnimFrame draw
  
window.requestAnimFrame =
  window.requestAnimationFrame ?
  window.webkitRequestAnimationFrame ?
  window.mozRequestAnimationFrame ?
  window.oRequestAnimationFrame ?
  window.msRequestAnimationFrame ?
  (callback) -> window.setTimeout callback, 1000/60
