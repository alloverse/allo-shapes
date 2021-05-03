local ResizeableCube = require("resizeable_cube")

local client = Client(
    arg[2], 
    "allo-shapes"
)

local app = App(client)

assets = {
    quit = ui.Asset.File("images/quit.png"),
}
app.assetManager:add(assets)

local mainView = ui.Surface(ui.Bounds(0, 1.2, -2,   1, 0.5, 0.01))

mainView.grabbable = true

local titleLabel = mainView:addSubview(
  ui.Label{ bounds= ui.Bounds{size=ui.Size(1.5,0.10,0.01)}
    :move( mainView.bounds.size:getEdge("top", "center", "back") )
    :move( 0, 0.06, 0),
    text="Shape Manipulator",
    halign="center"
  }
)

local button = ui.Button(ui.Bounds(0.0, 0.05, 0.05,   0.2, 0.2, 0.1))
mainView:addSubview(button)

button.onActivated = function()
    print("Creating a Cube...")

    local cube = ResizeableCube(ui.Bounds(0, 0, -2, 1, 2, 0.3))
    cube:setColor({0.8, 0.8, 0.8, 0.5})
    mainView:addSubview(cube)
end

local quitButton = ui.Button(ui.Bounds{size=ui.Size(0.12,0.12,0.05)}:move( 0.52,0.25,0.025))
quitButton:setDefaultTexture(assets.quit)
quitButton.onActivated = function()
    app:quit()
end
mainView:addSubview(quitButton)

app.mainView = mainView
app:connect()
app:run()