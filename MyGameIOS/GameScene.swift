//
//  GameScene.swift
//  MyGameIOS
//
//  Created by user196253 on 4/29/22.
//

import SpriteKit

let fileName = "GameScores"
let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = docDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
var score = Int()


class GameScene : SKScene, SKPhysicsContactDelegate {
    //declared sprites
    let cell = SKSpriteNode(imageNamed: "cell.png")
    let laser = SKSpriteNode(imageNamed: "laser.png")
    let orb = SKSpriteNode(imageNamed: "orb.png")
    let virus = SKSpriteNode(imageNamed: "virus")
    let virus2 = SKSpriteNode(imageNamed: "virus")
    let virus3 = SKSpriteNode(imageNamed: "virus")
    let virus4 = SKSpriteNode(imageNamed: "virus")
    let virus5 = SKSpriteNode(imageNamed: "virus")
    //sprite category
    let virusCategory:UInt32 = 0x1<<0
    let orbCategory:UInt32 = 0x1<<1
    let cellCategory:UInt32 = 0x1<<2
    
    var virusHealth = 3
    var virus2Health = 3
    var virus3Health = 3
    var virus4Health = 3
    var virus5Health = 5
    var enemy = 5
    
    var counter = 0
    var counterValue = 60
    var counterTimer = Timer()
    var isGameOver = false
    
    var backgroundImage = SKSpriteNode(imageNamed: "sceneBackground.jpg")
    //countdown label
    var countdownLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed:"Countdown")
        label.fontSize = 30
        label.text = "Cell Destruction: "
        label.fontName = "Papyrus"
        label.fontColor = SKColor.black
        return label
    }()
    
    override func didMove(to view: SKView) {
        counter = counterValue
        //start countdown timer
        startCountdown()
        backgroundImage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        addChild(backgroundImage)
        score = 0
        //add countdown label & position
        countdownLabel.position = CGPoint(x: size.width/2, y: size.height/1.2)
        addChild(countdownLabel)
        
        //assign physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        //set pysics gravity
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9);
        //set background color
        backgroundColor = SKColor.blue
        
        //add cell and properties
        cell.position = CGPoint(x: size.width/2, y: size.height/3.5)
        addPhysicalBodyCell()
        MoveCell()
        addChild(cell)
        
        //add laser position
        laser.size = CGSize(width: 80, height: 80)
        laser.position = CGPoint(x: size.width/2, y: size.height*0.05)
        addChild(laser)
        
        //add virus physics body and move
        addPhysicsBodyVirus()
        MoveVirus()
        //add virus2 physics body and move
        addPhysicsBodyVirus2()
        MoveVirus2()
        //add virus3 physics body and move
        addPhysicsBodyVirus3()
        MoveVirus3()
        //add virus4 physics body and move
        addPhysicsBodyVirus4()
        MoveVirus4()
        //add virus4 physics body and move
        addPhysicsBodyVirus5()
        MoveVirus5()
        //add biruses to scene
        addChild(virus)
        addChild(virus2)
        addChild(virus3)
        addChild(virus4)
        addChild(virus5)
    }
    //touch function
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        //initialise touch location in scene
        let touchLocation = touch.location(in: self)
        //initialise orb object
        let orb = SKSpriteNode(imageNamed: "orb.png")
        //set orb obj properties and phys body
        orb.size = CGSize(width: 40, height: 40)
        orb.physicsBody = SKPhysicsBody(rectangleOf: orb.frame.size)
        orb.physicsBody?.isDynamic = true
        orb.physicsBody?.categoryBitMask = orbCategory
        orb.physicsBody?.contactTestBitMask = virusCategory | orbCategory |  cellCategory
        //instatiate orbj in laser position
        orb.position = laser.position
        
        //move orb obj to touch location
        let k:CGFloat=5.0
        let vector = CGVector(dx: k*(touchLocation.x-laser.position.x), dy:  k*(touchLocation.y-laser.position.y))
        let orbMove = SKAction.move(by: vector, duration: 2.0)
        let orbMoveDone = SKAction.removeFromParent()
        let sequence = SKAction.sequence([orbMove, orbMoveDone])
        
        addChild(orb)
        orb.run(sequence)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Collision")
        if contact.bodyA.node == virus || contact.bodyB.node == orb {
            if virusHealth <= 0 {
                virus.removeFromParent()
                enemy-=1
                //print(enemy)
                score+=10
                //print(score)
            }
            virusHealth-=1
            print(virusHealth)
        }
        
        if contact.bodyA.node == virus2 || contact.bodyB.node == orb {
            if virus2Health <= 0 {
                virus2.removeFromParent()
                enemy-=1
                //print(enemy)
                score+=10
                //print(score)
            }
            virus2Health-=1
            print(virus2Health)
        }
        
        if contact.bodyA.node == virus3 || contact.bodyB.node == orb {
            if virus3Health <= 0 {
                virus3.removeFromParent()
                enemy-=1
                //print(enemy)
                score+=10
                //print(score)
            }
            virus3Health-=1
            print(virus3Health)
        }
        
        if contact.bodyA.node == virus4 || contact.bodyB.node == orb {
            if virus4Health <= 0 {
                virus4.removeFromParent()
                enemy-=1
                //print(enemy)
                score+=10
                //print(score)
            }
            virus4Health-=1
            print(virus4Health)
        }
        
        if contact.bodyA.node == virus5 || contact.bodyB.node == orb {
            if virus5Health <= 0 {
                virus5.removeFromParent()
                enemy-=1
                //print(enemy)
                score+=10
                //print(score)
            }
            virus5Health-=1
            print(virus5Health)
        }
        
        if contact.bodyA.node == cell || contact.bodyB.node == orb {
            print("cell is hit")
        }
        
        if enemy == 0 {
            stopCountdown()
            DisplayGameOver()
        }
    }
    
    //move method for virus
    private func MoveVirus(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.1, y: size.height*0.5), duration: 3)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.9, y: size.height*0.5), duration: 3)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.9, y: size.height*0.5), duration: 6)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.1, y: size.height*0.5), duration: 3)
        let sequence = SKAction.sequence([action1, action2,action3,action4])
        virus.run(SKAction.repeatForever(sequence))
    }
    //move method for virus2
    private func MoveVirus2(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.2, y: size.height*0.8), duration: 5)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.2), duration: 3)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.8), duration: 3)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.2, y: size.height*0.2), duration: 5)
        let sequence = SKAction.sequence([action1, action2,action3,action4])
        virus2.run(SKAction.repeatForever(sequence))
    }
    //move method for virus3
    private func MoveVirus3(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.4), duration: 5)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.3, y: size.height*0.4), duration: 5)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.6, y: size.height*0.7), duration: 5)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.2, y: size.height*0.6), duration: 5)
        let sequence = SKAction.sequence([action1, action2,action3,action4])
        virus3.run(SKAction.repeatForever(sequence))
    }
    //move method for virus4
    private func MoveVirus4(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.7, y: size.height*0.5), duration: 8)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.6), duration: 8)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.3, y: size.height*0.8), duration: 8)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.6, y: size.height*0.9), duration: 8)
        let sequence = SKAction.sequence([action1, action2,action3,action4])
        virus4.run(SKAction.repeatForever(sequence))
    }
    //move method for virus5
    private func MoveVirus5(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.7, y: size.height*0.4), duration: 3)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.2), duration: 3)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.6, y: size.height*0.2), duration: 3)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.5, y: size.height*0.9), duration: 3)
        let sequence = SKAction.sequence([action1, action2,action3,action4])
        virus5.run(SKAction.repeatForever(sequence))
    }
    //move method cell
    private func MoveCell(){
        let action1 = SKAction.move(to: CGPoint(x: size.width*0.4, y: size.height*0.9), duration: 10)
        let action2 = SKAction.move(to: CGPoint(x: size.width*0.8, y: size.height*0.5), duration: 10)
        let action3 = SKAction.move(to: CGPoint(x: size.width*0.6, y: size.height*0.5), duration: 10)
        let action4 = SKAction.move(to: CGPoint(x: size.width*0.5, y: size.height*0.9), duration: 10)
        let sequence = SKAction.sequence([action1,action2,action3,action4])
        cell.run(SKAction.repeatForever(sequence))
    }
    //add physics body cell
    private func addPhysicalBodyCell(){
        cell.physicsBody?.categoryBitMask = cellCategory
        cell.physicsBody?.contactTestBitMask = orbCategory
        cell.physicsBody?.isDynamic = true
        cell.physicsBody = SKPhysicsBody(rectangleOf: cell.frame.size)
    }
    //add physics body virus
    private func addPhysicsBodyVirus(){
        virus.physicsBody?.categoryBitMask = virusCategory
        virus.physicsBody?.contactTestBitMask = orbCategory
        virus.physicsBody?.isDynamic = true
        virus.physicsBody = SKPhysicsBody(rectangleOf: virus.frame.size)
    }
    //add physics body virus2
    private func addPhysicsBodyVirus2(){
        virus2.physicsBody?.categoryBitMask = virusCategory
        virus2.physicsBody?.contactTestBitMask = orbCategory
        virus2.physicsBody?.isDynamic = true
        virus2.physicsBody = SKPhysicsBody(rectangleOf: virus2.frame.size)
    }
    //add physics body virus3
    private func addPhysicsBodyVirus3(){
        virus3.physicsBody?.categoryBitMask = virusCategory
        virus3.physicsBody?.contactTestBitMask = orbCategory
        virus3.physicsBody?.isDynamic = true
        virus3.physicsBody = SKPhysicsBody(rectangleOf: virus3.frame.size)
    }
    //add physics body virus4
    private func addPhysicsBodyVirus4(){
        virus4.physicsBody?.categoryBitMask = virusCategory
        virus4.physicsBody?.contactTestBitMask = orbCategory
        virus4.physicsBody?.isDynamic = true
        virus4.physicsBody = SKPhysicsBody(rectangleOf: virus4.frame.size)
    }
    //add physics body virus5
    private func addPhysicsBodyVirus5(){
        virus5.physicsBody?.categoryBitMask = virusCategory
        virus5.physicsBody?.contactTestBitMask = orbCategory
        virus5.physicsBody?.isDynamic = true
        virus5.physicsBody = SKPhysicsBody(rectangleOf: virus5.frame.size)
    }
    
    private func DisplayGameOver() {
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.scaleMode = scaleMode

        let displayGameOver = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: displayGameOver)
        }
    
    private func WriteScore() {
        
        let scoreStr = String(score)
        do {
            try scoreStr.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("failed to write to URL")
            print(error)
        }
    }
    
    func startCountdown(){
       counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopCountdown() {
        counterTimer.invalidate()
    }
    
    @objc func updateCounter() {
        
        if !isGameOver {
            counter -= 1
            countdownLabel.text = "Cell Destruction: \(counter)"
            print("\(counter)")
        }
        
        if counter == 0 || isGameOver {
            stopCountdown()
            DisplayGameOver()
           
        }
        
        
        
    }
    
}

//Game over scene class
class GameOverScene: SKScene {
    
    var gameOverLabel = SKLabelNode(text: "Game Over")
    var thankYouLabel = SKLabelNode(text: "Thank you for Playing")
    var tapToRestartLabel = SKLabelNode(text: "Tap screen to restart")
    
        override init(size: CGSize) {
            super.init(size: size)

            self.backgroundColor = SKColor.systemBlue
            
            var scoresInFile = ""
            do {
                scoresInFile = try String(contentsOf: fileURL)
            }
            catch let error as NSError {
                print("failed to read file")
                print(error)
            }
            print("scores read " + scoresInFile)
            
            let scoreLabel = SKLabelNode(text: "Score: \(score)")
            addChild(gameOverLabel)
            gameOverLabel.fontSize = 34.0
            gameOverLabel.color = SKColor.white
            gameOverLabel.fontName = "Thonburi-Bold"
            gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.2)
            
            addChild(thankYouLabel)
            thankYouLabel.fontSize = 24.0
            thankYouLabel.color = SKColor.white
            thankYouLabel.fontName = "Zapfino"
            thankYouLabel.position = CGPoint(x: size.width/2, y: size.height/1.4)
            
            addChild(tapToRestartLabel)
            tapToRestartLabel.fontSize = 30.0
            tapToRestartLabel.color = SKColor.white
            tapToRestartLabel.fontName = "Papyrus"
            tapToRestartLabel.position = CGPoint(x: size.width/2, y: size.height/4)
            
            addChild(scoreLabel)
            scoreLabel.fontSize = 30.0
            scoreLabel.color = SKColor.white
            scoreLabel.fontName = "Papyrus"
            scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            

            let displayGameScene = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameScene, transition: displayGameScene)
        
        }

}
