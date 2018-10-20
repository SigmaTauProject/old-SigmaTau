module galactic_.logic_world_.entity_;

import std.experimental.logger;
import cst_;
import std.algorithm;

import galactic_.flat_world_	.entity_	: FlatEntity = Entity	;

enum EntityType {
	starSystem	,
	sun	,
	planet	,
	asteroid	,
	ship	,
}


interface  EntityMaster {
	void onNestedAddedFlatEntity(FlatEntity);
	void onNestedRemovedFlatEntity(FlatEntity);
}


abstract class Entity : EntityMaster{
	abstract @property EntityType type();
	this() {
		this([0,0],0);
	}
	this(float[2] pos, float ori) {
		this.pos	= pos	;
		this.ori	= ori	;
	}
	void update() {
		foreach (entity; nestedEntities) 
			entity.update;
	}
	private Entity[]	_nestedEntities	= [];
	private FlatEntity[]	_nestedFlatEntities	= [];
	@property Entity[] nestedEntities() {
		return _nestedEntities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	@property FlatEntity[] nestedFlatEntities() {
		return _nestedFlatEntities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	void addEntity(E)(E entity) if(!isAbstractClass!E) {
		entity.master = this;
		_nestedEntities~=entity;
		static if (is(E:FlatEntity)) {
			_nestedFlatEntities ~= entity;
			onNestedAddedFlatENtity(entity);
		}
	}
	void removeEntity(E)(E entity) if(!isAbstractClass!E) {
		_nestedEntities = _nestedEntities.remove(_nestedEntities.countUntil(entity));
		static if (is(E:FlatEntity)) {
			_nestedFlatEntities = _nestedFlatEntities.remove(_nestedFlatEntities.countUntil(entity));
			onNestedRemovedFlatENtity(entity);
		}
		entity.master = null;
	}
	
	EntityMaster	master	;// Set by master's addEntity;
	
	public {
		/*	Called when entity is added to world.
			A Call to this function will propagate through nestedEntities.
			Sets `inWorld` on each entity in the tree.
			Passes flat entities to the now know world.
		*/
		void addedToWorld() {
			assert(!(master is null));
			this.inWorld = true;
			nestedFlatEntities.each!(a=>master.onNestedAddedFlatEntity(a));
			nestedEntities.each!(a=>a.addedToWorld);
		}
		/*	Called when entity is removed from world.
			A Call to this function will propagate through nestedEntities.
			Sets `inWorld` on each entity in the tree.
			Tells the now known world remove flat entities.
		*/
		void removedFromWorld() {
			assert(!(master is null));
			nestedFlatEntities.each!(a=>master.onNestedRemovedFlatEntity(a));
			nestedEntities.each!(a=>a.removedFromWorld);
			this.inWorld = false;
		}
		/*	Call with propagate through the masters.
			Used to inform world when a flat entity is added.
			Is called whenever an entity is added (using `addEntity`).
				Is also called when entity tree  is added to world because
				world will not have recieved past calls.
		*/
		void onNestedAddedFlatEntity(FlatEntity entity) {
			if (!(master is null)) {
				master.onNestedAddedFlatEntity(entity);
			} 
		}
		/*	Call with propagate through the masters.
			Used to inform world when a flat entity is removed.
			Is called whenever an entity is removed (using `removeEntity`).
				Is also called when entity tree is removed to world so
				world does not keep old removed entities.
		*/
		void onNestedRemovedFlatEntity(FlatEntity entity) {
			master.onNestedRemovedFlatEntity(entity);
		}
	}
	
	float[2]	pos	;
	float	ori	;
			
	bool	inWorld	= false	; // Changed in `world.addEntity` and `.removeEntity`
}
private abstract
class PhysicEntity : Entity {
	this() {
		super();
	}
	this(float[2] pos,float ori, float[2] vel,float anv,) {
		super(pos,ori);
		this.vel	= vel	;
		this.anv	= anv	;
	}
	override void update() {
		super.update;
	}
	
	float[2]	vel	;
	float	anv	;
}


class StarSystem : Entity {
	override @property EntityType type() {return EntityType.starSystem;}
	this() {
		super();
	}
	this(float[2] pos, float ori) {
		super(pos,ori);
	}
	override void update() {
		super.update;
	}
}


private abstract
class Orbiting : Entity {
	this() {
		super();
	}
	this(float[2] pos, float ori) {
		super(pos,ori);
	}
	override void update() {
		super.update;
	}
}

class Sun : Orbiting,FlatEntity {
	override @property EntityType type() {return EntityType.sun;}
	this() {
		super();
	}
	this(float[2] pos, float ori) {
		super(pos,ori);
	}
	override void update() {
		super.update;
	}
	
	float[2]	getPos	() { return pos	; }
	float	getOri	() { return ori	; }
	bool	getInWorld	() { return inWorld	; }
}
class Planet : Orbiting,FlatEntity {
	override @property EntityType type() {return EntityType.planet;}
	this() {
		super();
	}
	this(float[2] pos, float ori) {
		super(pos,ori);
	}
	override void update() {
		super.update;
	}
	
	float[2]	getPos	() { return pos;	}
	float	getOri	() { return ori;	}
	bool	getInWorld	() { return inWorld	; }
}




class Asteroid : PhysicEntity,FlatEntity {
	override @property EntityType type() {return EntityType.asteroid;}
	this() {
		super();
	}
	this(float[2] pos,float ori, float[2] vel,float anv,) {
		super(pos,ori,vel,anv);
	}
	override void update() {
		super.update;
	}
	
	float[2]	getPos	() { return pos;	}
	float	getOri	() { return ori;	}
	bool	getInWorld	() { return inWorld	; }
}
class Ship : PhysicEntity,FlatEntity {
	override @property EntityType type() {return EntityType.ship;}
	this() {
		super();
	}
	this(float[2] pos,float ori, float[2] vel,float anv,) {
		super(pos,ori,vel,anv);
	}
	override void update() {
		super.update;
	}
	
	float[2]	getPos	() { return pos;	}
	float	getOri	() { return ori;	}
	bool	getInWorld	() { return inWorld	; }
}
