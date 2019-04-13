-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

math.randomseed(os.time())

local maxBubbleCount = 3
local bubbleCounter = 0
methods = {}

function getRandX()
    return math.random(0, display.contentWidth)
end

function getRandY()
    return math.random(0, display.contentHeight)
end

local function bind(f, p1, p2, p3, p4, p5)
    return function()
        return f(p1, p2, p3, p4, p5)
    end
end

local function randomMoving(target)
    transition.moveTo(target, { x = getRandX(), y = getRandY(), time = 2000 })
end

local function setBackground()
    local bg = display.newImageRect("background.png", 360, 570)
    bg.anchorX = display.screenOriginX
    bg.anchorY = display.screenOriginY
    bg.width = display.contentWidth
    bg.height = display.contentHeight
end

local function setBackgroundPaint()
    local bg = display.newRect(0, 0, 10, 10)
    bg.anchorX = display.screenOriginX
    bg.anchorY = display.screenOriginY
    bg.width = display.contentWidth
    bg.height = display.contentHeight
    local paint = { 78 / 255, 127 / 255, 194 / 255 }
    bg.fill = paint
end

local function spriteListener(event)
    local thisSprite = event.target
    if (event.phase == "ended") then
        bubbleCounter = bubbleCounter - 1
        display.remove(thisSprite)
    end
end

local function endingAnimationAndRemove(target)
    target:setSequence("explode")
    target:play()
    target:addEventListener("sprite", spriteListener)
end

local function touchListener(event)
    if (event.phase == "ended") then
        event.target:removeEventListener("touch", touchListener)
        endingAnimationAndRemove(event.target)
    end
end

local sheetOptions = {
    width = 100,
    height = 100,
    numFrames = 49,
    sheetContentWidth = 700,
    sheetContentHeight = 700
}

local sequences_bubble = {
    -- consecutive frames sequence
    {
        name = "iddle",
        start = 20,
        count = 9,
        time = 600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "explode",
        start = 29,
        count = 20,
        time = 1200,
        loopCount = 1,
        loopDirection = "forward"
    },
}

local sheet_bubble = graphics.newImageSheet("6_flamelash_spritesheet.png", sheetOptions)

local function createBubbleWithXY(x, y)
    local bubble = display.newSprite(sheet_bubble, sequences_bubble)
    bubble.x = x
    bubble.y = y
    bubble:setSequence("iddle")
    bubble:play()
    bubbleCounter = bubbleCounter + 1
    methods[bubbleCounter] = bind(randomMoving, bubble)
    bubble:addEventListener("touch", touchListener)
end

local function createBubbleWithXYSimpleBubble(x, y)
    local bubble = display.newCircle(x, y, 10, 10)
    bubble.path.radius = 10
    local paint = { 212 / 255, 85 / 255, 0 / 255 }
    bubble.fill = paint
    bubbleCounter = bubbleCounter + 1
    bubble:addEventListener("touch", touchListener)
end

setBackground()

local function spawnBubble()
    local randX = getRandX()
    local randY = getRandY()
    createBubbleWithXY(randX, randY)
end

local function executeMoveTo()
    for _, f in ipairs(methods) do
        f()
    end
end

local function gameLoop()
    if (bubbleCounter < maxBubbleCount) then
        spawnBubble()
    end
    executeMoveTo()
end

gameLoopTimer = timer.performWithDelay(1000, gameLoop, 0)