//
//  GameScene.swift
//  MyFirstGame
//
//  Created by Zachary Vargas on 4/2/16.
//  Copyright (c) 2016 Zach Vargas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var currentLevel = 0
    var pCounter = pCount()
    var cCounter = cCount()
    var currentLevelData:NSDictionary
    var levels:Levels
    var Scene:SKSpriteNode
    var man:SKSpriteNode
    var levelNPC:SKSpriteNode
    var label:SKLabelNode
    var runningManTextures = [SKTexture]()
    var manLeft = false
    var manRight = false
    var stageMaxRight:CGFloat = 0
    var stageMaxLeft:CGFloat = 0
    var manSpeed:CGFloat = 5
    
    override func didMoveToView(view: SKView) {
        stageMaxRight = 250
        stageMaxLeft = -stageMaxRight
        loadLevel()
    }
    
    func loadLevel() {
        currentLevelData = levels.data[currentLevel]
        loadScene()
        loadNPC()
        loadMan()
        loadText()
    }
    
    struct pCount {
        private(set) var partyCount: Int
        init(partyCount: Int = 0){
            self.partyCount = partyCount
        }
        mutating func increment() {
            partyCount += 1
        }
    }
    
    struct cCount {
        private(set) var classCount: Int
        init(classCount: Int = 0){
            self.classCount = classCount
        }
        mutating func increment() {
            classCount += 1
        }
    }
    
    func loadText() {
        let labelInfo = currentLevelData["Text"]! as! String
        label.text = labelInfo
        label.fontName = "AmericanTypewriter-CondensedBold"
        label.fontSize = 16
        label.fontColor = SKColor.whiteColor()
        label.name = "label"
        label.position.y = 150
        label.position.x = 0
        label.zPosition = 4.0
        scene?.addChild(label)
    }
    
    func loadScene() {
        let SceneNum = currentLevelData["Scene"]! as! String
        Scene = SKSpriteNode(imageNamed: "Scene_\(SceneNum)")
        Scene.name = "Scene"
        Scene.zPosition = 1.0
        scene?.addChild(Scene)
    }
    
    func loadNPC() {
        let levelNPCInfo = currentLevelData["NPC"]! as! String
        levelNPC = SKSpriteNode(imageNamed: levelNPCInfo)
        levelNPC.name = "level_npc"
        levelNPC.position.y = -70
        levelNPC.position.x = 200
        levelNPC.zPosition = 2.0
        scene?.addChild(levelNPC)
    }
    
    func loadMan(){
        loadManTextures()
        man.position.y = -90
        man.position.x = -200
        man.zPosition = 3.0
        addChild(man)
    }
    
    func loadManTextures(){
        let mainCharacterRun = SKTextureAtlas(named: "MCRun")
        for i in 0...1{
            let textureName = "MainCharacter_\(i)"
            let temp =  mainCharacterRun.textureNamed(textureName)
            runningManTextures.append(temp)
        }
    }
    
    func moveMan(direction: String) {
        if direction == "left" {
            manLeft = true
            man.xScale = -1
            manRight = false
            runMan()
        } else {
            manRight = true
            man.xScale = 1
            manLeft = false
            runMan()
        }
        
    }
    
    func runMan(){
        man.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningManTextures, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if event?.allTouches()!.count == 1 {
            let location = touches.first!.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if location.x > 0 {
                moveMan("right")
            } else {
                moveMan("left")
            }
            if (currentLevel == 1 && node.name == "label") {
                pCounter.increment()
                if pCounter.partyCount + cCounter.classCount >= 5 && pCounter.partyCount >= 3{
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 3
                    loadLevel()
                } else if pCounter.partyCount + cCounter.classCount >= 5 && cCounter.classCount >= 3{
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 4
                    loadLevel()
                } else {
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 0
                    loadLevel()
                }
            }
            if (currentLevel == 2 && node.name == "label") {
                cCounter.increment()
                if pCounter.partyCount + cCounter.classCount >= 5 && pCounter.partyCount >= 3{
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 3
                    loadLevel()
                } else if pCounter.partyCount + cCounter.classCount >= 5 && cCounter.classCount >= 3{
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 4
                    loadLevel()
                } else {
                    cleanScreen()
                    man.removeFromParent()
                    currentLevel = 0
                    loadLevel()
                }
            }
        }
    }
    
    func cancelMoves() {
        manLeft = false
        manRight = false
        man.removeAllActions()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelMoves()
    }
    
    override init(size: CGSize) {
        self.currentLevel = 0
        self.currentLevelData = [:]
        self.levels = Levels()
        self.Scene = SKSpriteNode()
        self.man = SKSpriteNode(texture: SKTexture(imageNamed: "MainCharacter_0"))
        self.man.name = "man"
        self.levelNPC = SKSpriteNode()
        self.label = SKLabelNode()
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cleanScreen() {
        Scene.removeFromParent()
        levelNPC.removeFromParent()
        label.removeFromParent()
    }
    
    func nextScreen(level:Int) -> Bool{
        if level >= 0 && level < 3 && level < levels.data.count {
            currentLevel = level
            currentLevelData = levels.data[currentLevel]
            cleanScreen()
            loadScene()
            loadNPC()
            loadText()
            return true
        }
        return false
    }
  
    func updateManPosition(){
        if man.position.x < stageMaxLeft {
            if currentLevel < 3 && nextScreen(currentLevel - 1) {
                    man.position.x = stageMaxRight
            }
            if manLeft {
                return
            }
        }
        if man.position.x > stageMaxRight {
            if nextScreen(currentLevel + 1) {
                man.position.x = stageMaxLeft
            }
            if manRight {
                return
            }
        }
        if manLeft {
            man.position.x -= manSpeed
        } else if manRight {
            man.position.x += manSpeed
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        updateManPosition()
    }
}
