// API Script for Template Assist
var hat = self.makeObject(null);
// Set up same states as AssistStats (by excluding "var", these variables will be accessible on timeline scripts!)
STATE_IDLE = 0;
STATE_JUMP = 1;
STATE_FALL = 2;
STATE_SLAM = 3;
STATE_OUTRO = 4;
var hatspawn = 0;
var SPAWN_X_DISTANCE = 0; // How far in front of player to spawn
var SPAWN_HEIGHT = 0; // How high up from player to spawn

 var meter = Sprite.create(self.getResource().getContent("flypowerMeter")); 

var meterMax = meter.totalFrames; 

// Runs on object init
function initialize(){

	// Reposition relative to the user
	Common.repositionToEntityEcb(self.getOwner(), self.flipX(SPAWN_X_DISTANCE), -SPAWN_HEIGHT);

	// Add fade in effect
	Common.startFadeIn();

	 meter.scaleX = 1;
     meter.scaleY = 1;
     meter.x = 112;
     meter.y = 10;
	 
 self.getOwner().getDamageCounterContainer().addChild(meter);
 if (Random.getInt(1,10) == 1){
 match.createProjectile(self.getResource().getContent("lollipop"), self);
  }  
}

function update(){
	//addMeter = meter.currentFrame;
	//repositioning stuff
		self.setX(self.getOwner().getX());
		self.setY(self.getOwner().getY() + self.getOwner().getEcbHeadY() -10);
	// Face the same direction as the user
	if (self.getOwner().isFacingLeft()) {
		self.faceLeft();
	}
	else {
		self.faceRight();
	}
	if (self.getOwner().getHeldControls().UP || self.getOwner().getHeldControls().JUMP) {//self.getOwner().inActionableState()
	if (self.getOwner().inActionableState() || !self.getOwner().isOnFloor()) {
		if (self.getOwner().getYSpeed() >-2 && self.inState(STATE_IDLE)) {
		self.getOwner().setYSpeed(self.getYSpeed() -2);
		meter.currentFrame = meter.currentFrame + 1;
		self.toState(STATE_JUMP);
		}
		if (self.getOwner().getYSpeed() >-2 && self.inState(STATE_JUMP)) {
		self.getOwner().setYSpeed(self.getYSpeed() -2);
		meter.currentFrame = meter.currentFrame + 1;
		}
	}
	}
	else{
    self.toState(STATE_IDLE);
	}
	//delete if a new one gets spawned
	if (self.getOwner().inState(CState.ASSIST_CALL) && self.getOwner().getCurrentFrame() == 1) {
	hatspawn = hatspawn + 1;
	}
	if (hatspawn >= 1) {
	self.toState(STATE_OUTRO);
	match.createProjectile(self.getResource().getContent("assisttemplateProjectile"), self);
	meter.destroy();
	}
	//go to outro and delete when meter is "depleted" (the animation is defilling so 0 is full and max is empty)
	if (meter.currentFrame > 99) {
	self.toState(STATE_OUTRO);
	AudioClip.play(self.getResource().getContent(("MarioPowerDown")),{volume:0.25});
	match.createProjectile(self.getResource().getContent("assisttemplateProjectile"), self);
	meter.destroy();
	}
	//destroy if foe gets koed
	if (self.getOwner().inState(CState.KO)) {
	self.toState(STATE_OUTRO);
	match.createProjectile(self.getResource().getContent("assisttemplateProjectile"), self);
	
	}
	// infinite flying power for costume palettes 
	if (self.getCostumeIndex() > 3 ) {
	meter.currentFrame = 1; // sets the meter to one every frame
	}
}
function onTeardown(){
	meter.destroy();
}
