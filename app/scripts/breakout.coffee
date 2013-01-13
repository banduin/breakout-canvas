define [
    'game'
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
], (Game, Paddle, Ball, Block) ->
    class Breakout extends Game
        init: ->
            @blockRows = 5
            @blockCols = 15
            @blocks = []
            @resetLevel()

        resetLevel: ->
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * Block.texture.width
                    y = 20 + rows * Block.texture.height
                    @blocks.push new Block x, y
            @resetPaddle()

        resetPaddle: ->
            @paddle = new Paddle @canvas.width / 2, @canvas.height - 20
            ballX = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @running = false

        update: ->
            @paddle.x = @mouse.x - Paddle.texture.width / 2

            if @paddle.x < 0
                @paddle.x = 0
            if @paddle.x > @canvas.width - Paddle.texture.width
                @paddle.x = @canvas.width - Paddle.texture.width

            if not @running
                @ball.x = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
                if @mouse.leftButton
                    @running = true
                    @ball.launch()
                else
                    return

            @ball.x += @ball.speed.x
            @ball.y += @ball.speed.y

            if @ball.y < 0
                @ball.speed.y *= -1
            if @ball.x < 0 or @ball.x > @canvas.width - Ball.texture.width
                @ball.speed.x *= -1
            if @ball.y > @canvas.height
                @resetPaddle()
                return

            if @ball.intersects @paddle
                @ball.speed.y *= -1
                @ball.speed.x = ((@ball.x + Ball.texture.width / 2) - (@paddle.x + Paddle.texture.width / 2)) / 3

        draw: ->
            @ctx.fillStyle = 'rgb(100, 149, 237)'
            @ctx.fillRect 0, 0, @canvas.width, @canvas.height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)
