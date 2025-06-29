// API Script for Character Template Projectile

var X_SPEED = 0; // X speed of water
var Y_SPEED = 0; // Y Speed of water

// Instance vars
var life = self.makeInt(60 * 5);
var originalOwner = null;

function initialize(){
	//self.addEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit, { persistent: true });
	//self.addEventListener(GameObjectEvent.HIT_DEALT, onHit, { persistent: true });

	self.setCostumeIndex(self.getOwner().getCostumeIndex());
	
    // Set up horizontal reflection
	Common.enableReflectionListener({ mode: "X", replaceOwner: true });

	self.setState(PState.ACTIVE);

	self.setXSpeed(X_SPEED);
	self.setYSpeed(Y_SPEED);
}

function onGroundHit(event) {
	self.removeEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit);
	self.removeEventListener(GameObjectEvent.HIT_DEALT, onHit);

	self.toState(PState.DESTROYING);
}

function onHit(event) {
	self.removeEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit);
	self.removeEventListener(GameObjectEvent.HIT_DEALT, onHit);

	self.toState(PState.DESTROYING);
}

function update() {
	if (self.getOwner().getOwner().isFacingRight()){
	self.faceRight();
	self.setY(self.getOwner().getOwner().getY() + self.getOwner().getOwner().getEcbRightHipY());
	self.setX(self.getOwner().getOwner().getX() + self.getOwner().getOwner().getEcbRightHipX() + 10);
	}
	if (self.getOwner().getOwner().isFacingLeft()){
	self.faceLeft();
	self.setY(self.getOwner().getOwner().getY() + self.getOwner().getOwner().getEcbRightHipY());
	self.setX(self.getOwner().getOwner().getX() - self.getOwner().getOwner().getEcbRightHipX() - 10);
	}
	if (self.getOwner().inState(4)){
    self.destroy();
	}
}

function onTeardown() {
	self.removeEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit);
	self.removeEventListener(GameObjectEvent.HIT_DEALT, onHit);
}