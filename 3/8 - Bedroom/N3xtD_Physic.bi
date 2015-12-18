' wrap physic

Extern "c"

' ------------------------------------------------------------------------------------------------------------------------
'- Global
' ------------------------------------------------------------------------------------------------------------------------
 declare Sub _SolverModelPhysic(byval  mode as Integer=1)
 declare Sub _PlatformArchitecturePhysic(byval  mode as Integer=0)
 declare Sub _FrictionModelPhysic(byval  model as Integer=0)
 declare Sub _DestroyAllBodies()

 declare Sub _FreePhysic()
 declare Sub _InitPhysic()
 declare Sub _UpdatePhysic(byval tTimer as Single=60.0)
 declare Sub _SetWorldSize(byval minx as single, byval miny as single, byval minz as single, byval maxx as single, byval maxy as single, byval maxz as Single)
 declare Sub _GravityForce(byval x as single, byval y as single, byval z as Single)
 declare Sub _TimerUpdatePhysic(byval tTimer as Single = 60.0)

' ------------------------------------------------------------------------------------------------------------------------
'- RIGID BODY
' ------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateBody(byval ent As EntityNode, byval typeForm as Integer=BOX_PRIMITIVE , byval dynamique As UByte=True, byval mass as single=1.0, byval vx as single=0, byval vy as single=0, byval vz as Single=0)As NBody
 declare Function _CreateTerrainBody(byval terrain As TerrainNode, byval tType as Integer=HEIGHTFIELD_METHOD)As NBody
 declare Function _CreateBodyStaticElement(byval ent As EntityNode, byval typeForm as Integer=BOX_PRIMITIVE, byval vx as single=0, byval vy as single=0, byval vz as Single=0)As NBody
 declare Function _CreateBodyBatchElement(byval ent As EntityNode, byval typeForm as Integer=BOX_PRIMITIVE, byval vx as single=0, byval vy as single=0, byval vz as Single=0)As NBody
 declare Sub _BodyRestoreCallbacks(byval node as EntityNode) 
 declare Sub _FreeBody(byval node as EntityNode)
 declare Sub _MatrixBody(byval node as EntityNode, byval mat As any Ptr)
 declare Sub _MomentOfInertiaBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single) 
 declare Sub _MassCenterBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _BodyCentreOfMass(byval node as EntityNode, byval mass_center as any ptr) 
 declare Sub _MassBody(byval node as EntityNode,  byval mass as Single)
 declare Sub _LinearDampingBody(byval node as EntityNode, byval value as Single)
 declare Sub _BodyMomentOfInertia(byval node as EntityNode, byval res as any Ptr) 
 declare Sub _FreezeBody(byval node as EntityNode,  byval value As UByte)
 declare Function _BodyFreeze(byval node as EntityNode)As Integer
 declare Function _BodyMass(byval node as EntityNode)As Single
 declare Sub _AddForceBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _ForceBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _AddDirectForceBody(byval body As NBody, byval x as single, byval y as single, byval z as Single)
 declare Sub _DirectForceBody(byval body As NBody, byval x as single, byval y as single, byval z as Single)
 declare Sub _AddForceContinuousBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single) 
 declare Sub _AddTorqueBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _TorqueBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _OmegaBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single) 
 declare Sub _VelocityBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single) 
 declare Sub _CalculateMomentOfInertiaBody(byval node as EntityNode) 
 declare Sub _BodyOmega(byval node as EntityNode, byval omega as any Ptr) 
 declare Sub _AngularDampingBody(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)
 declare Sub _BodyVelocity(byval node as EntityNode, byval velocity as any Ptr) 
 declare Sub _ContinuousCollisionModeBody(byval node as EntityNode,  byval value As UByte) 
 declare Function _BodyContinuousCollisionMode(byval node as EntityNode) As Integer
 declare Sub _BodyPosition(byval node as EntityNode, byval Pos as any Ptr) 
 declare Sub _BodyRotation(byval node as EntityNode, byval rot as any Ptr) 
 declare Sub _PulseBody(byval node as EntityNode, byval delta_velocityx as single, byval delta_velocityy as single, byval delta_velocityz as single, byval impulse_centerx as single=0,  byval impulse_centery as single=0,  byval impulse_centerz as Single=0)
 declare Sub _CollisionBody(byval node as EntityNode, byval newCollision as any Ptr) 
 declare Function _BodyNode(byval node as EntityNode) As EntityNode
 declare Sub _ApplyForceAndTorqueBody(byval node as EntityNode, byval callback as any Ptr)
 declare Function _BodyCollideBody(byval node as EntityNode)As Any Ptr
 declare Function _BodyNumCollideBody(byval node as EntityNode)As integer
 declare Sub _CalculateAABBBody(byval node as EntityNode, byval box as any Ptr) 
 declare Sub _MatrixRecursiveBody(byval node as EntityNode, byval matrix as any Ptr)
 declare Sub _JointRecursiveCollisionBody(byval node as EntityNode, byval state as Integer)
 declare Function _BodySleepState(byval node as EntityNode)As Integer
 declare Function _BodyAutoSleep(byval node as EntityNode)As Integer
 declare Sub _AutoSleepBody(byval node as EntityNode, byval state as integer)
 declare Function _BodyCollision(byval node as EntityNode)As Any Ptr
 declare Function _BodyJointRecursiveCollision(byval node as EntityNode)As Integer 
 declare Sub _BodyMatrix(byval node as EntityNode, byval matrix as any Ptr) 
 declare Sub _BodyForce(byval node as EntityNode, byval force as any Ptr) 
 declare Sub _BodyTorque(byval node as EntityNode, byval torque as any Ptr) 
 declare Function _BodyLinearDamping(byval node as EntityNode) As Single
 declare Sub _BodyAngularDamping(byval node as EntityNode, byval tt as any Ptr) 
 declare Sub _BodyAABB(byval node as EntityNode, byval p0 as any ptr, byval p1 as any Ptr)
 declare Sub _BouyancyMaterial(byval node as EntityNode, byval pmaterial As NMaterialPair )
 declare Sub _BouyancyParameter(byval fluiddensity as single=0.2, byval gx as single=0, byval gy as single=-10.0, byval gz as Single=0)
 declare Sub _AsTriggerVolume(byval node as EntityNode, byval trigger as Integer )

' ------------------------------------------------------------------------------------------------------------------------
'- COLLIDE INSTRUCTIONS
' ------------------------------------------------------------------------------------------------------------------------
 declare Sub _FreeNodeCollide(byval node as EntityNode)
 declare Sub _CreateNodeCollide(byval node as EntityNode, byval typeForm as integer, byval tType as Integer,  byval vx as single=0, byval vy as single=0, byval vz as Single=0)
 declare Sub _CreateTerrainCollide(byval terrain As TerrainNode, byval tType as Integer)
 declare Sub _CreateHeightFieldTerrainCollide(byval terrain As TerrainNode, byval tType as Integer)
 declare Function _NodeCollide(byval entA As EntityNode, byval entB As EntityNode)As integer
 declare Function _NodeCollideAll(byval node as EntityNode)As Integer
 declare Function _CollidePointDistance(byval node as EntityNode, byval x as single, byval y as single, byval z as Single)As Integer
 declare Function _CollideRayCast(byval node as EntityNode, byval x as single, byval y as single, byval z as single, byval dx as single, byval dy as single, byval dz as Single, byval tType as Integer=1)As Single
 declare Function _CollideRayCastAll( byval x as single, byval y as single, byval z as single, byval dx as single, byval dy as single, byval dz as Single, byval tType as Integer, byval dist as any Ptr)As EntityNode
 declare Sub _CollidePoint(byval tri as any Ptr,  byval index as Integer)
 declare Sub _CollideNormal(byval tri as any ptr,  byval index as Integer)
 declare Function _CollideNode(byval index as Integer=0)As EntityNode

' ------------------------------------------------------------------------------------------------------------------------
'- MATERIAL
' ------------------------------------------------------------------------------------------------------------------------
 declare Function _CreatePhysicMaterial()As Integer
 declare Function _CreatePhysicMaterialPair(byval  mat1 as integer, byval  mat2 as Integer, byval elasticity as single, byval frictionstatic as single, byval frictiondynamic as single, byval softness as Single) As NMaterialPair' Return *NMaterialPair
 declare Sub _ElasticityPhysicMaterial(byval pr as NMaterialPair , byval Val as Single)
 declare Sub _FrictionPhysicMaterial(byval pr as NMaterialPair, byval valstatic as single,  byval valdynamic as Single)
 declare Sub _SoftnessPhysicMaterial(byval pr as NMaterialPair,  byval vVal as Single)
 declare Sub _GroupPhysicMaterialBody(byval node as EntityNode,  byval mat as Integer)
 declare Function _BodyPhysicMaterialGroup(byval node as EntityNode)As Integer
 declare Sub _CollidablePhysicMaterial(byval pr as NMaterialPair,  byval state as Integer)
 declare Sub _CollisionMemPhysicMaterial(byval pr as NMaterialPair, byval flag As UByte=True)
 
' ------------------------------------------------------------------------------------------------------------------------
'- JOINTS
' ------------------------------------------------------------------------------------------------------------------------
 declare Sub _FreeJoint(byval joint as NJoint)
 declare Function _CreateBallJoint(byval child as EntityNode, byval parent as EntityNode ,  byval x as single,  byval y as single,  byval z as Single)As NJoint
 declare Sub _BallSetConeLimits(byval ball As NJoint,  byval x as single,  byval y as single,  byval z as single,  byval maxConeAngle as single,  byval maxTwistAngle as Single)
 declare Function _CreateHingeJoint(byval child as EntityNode,byval parent as EntityNode, byval x as single,  byval y as single,  byval z as single, byval dirx as single,  byval diry as single,  byval dirz as Single)As NJoint
 declare Function _CreateSliderJoint(byval child as EntityNode, byval parent as EntityNode, byval x as single,  byval y as single,  byval z as single, byval dirx as single,  byval diry as single,  byval dirz as Single)As NJoint
 declare Function _CreateCorkScrewJoint(byval child as EntityNode, byval parent as EntityNode, byval x as single,  byval y as single,  byval z as single, byval dirx as single,  byval diry as single,  byval dirz as Single)As NJoint
 declare Function _CreateUniversalJoint(byval child as EntityNode, byval parent as EntityNode, byval x as single,  byval y as single,  byval z as single, byval dirx as single,  byval diry as single,  byval dirz as single, byval diox as single,  byval dioy as single,  byval dioz as Single)As NJoint
 declare Function _CreateUpVectorJoint(byval node as EntityNode, byval x as single,  byval y as single,  byval z as Single)As NJoint
 declare Function _CreateUserJoint(byval child as EntityNode, byval parent as EntityNode,  byval maxDOF as Integer, byval callback as any Ptr)As NJoint
 declare Function _JointCollisionState(byval joint as NJoint)As integer
 declare Sub _CollisionStateJoint(byval joint as NJoint,  byval state as Integer)
 declare Function _JointStiffness(byval joint as NJoint)As Single
 declare Sub _StiffnessJoint(byval joint as NJoint,  byval state as Single)
 declare Sub _UserCallbackBallJoint(byval joint as NJoint,  byval callback as any Ptr)
 declare Sub _BallJointAngle(byval joint as NJoint, byval angle as any Ptr)
 declare Sub _BallJointOmega(byval joint as NJoint, byval angle as any Ptr)
 declare Sub _BallJointForce(byval joint as NJoint, byval force as any Ptr)
 declare Sub _UserCallbackHingeJoint(byval joint as NJoint,  byval callback as any Ptr)
 declare Function _HingeJointAngle(byval joint as NJoint)As Single
 declare Function _HingeJointOmega(byval joint as NJoint)As Single
 declare Sub _HingeJointForce(byval joint as NJoint, byval force as any Ptr)
 declare Sub _UserCallbackSliderJoint(byval joint as NJoint,  byval callback as any Ptr)
 declare Sub _SliderJointForce(byval joint as NJoint, byval force as any Ptr)
 declare Function _SliderJointPosit(byval joint as NJoint)As Single
 declare Function _SliderJointVeloc(byval joint as NJoint)As Single
 declare Sub _UserCallbackCorkscrewJoint(byval joint as NJoint,  byval callback as any Ptr)
 declare Function _CorkscrewJointPosit(byval joint as NJoint)As Single
 declare Function _CorkscrewJointAngle(byval joint as NJoint)As Single
 declare Function _CorkscrewJointVeloc(byval joint as NJoint)As Single
 declare Function _CorkscrewJointOmega(byval joint as NJoint)As Single
 declare Sub _CorkscrewJointForce(byval joint as NJoint, byval force as any Ptr)
 declare Sub _UserCallbackUniversalJoint(byval joint as NJoint,  byval callback as any Ptr)
 declare Function _UniversalJointAngle0(byval joint as NJoint)As Single
 declare Function _UniversalJointAngle1(byval joint as NJoint)As Single
 declare Function _UniversalJointOmega0(byval joint as NJoint)As Single
 declare Function _UniversalJointOmega1(byval joint as NJoint)As Single
 declare Sub _UniversalJointForce(byval joint as NJoint, byval force as any Ptr)
 declare Sub _UpVectorGetPin(byval joint as NJoint, byval pin as any Ptr)
 declare Sub _SetPinUpVector(byval joint as NJoint, byval pin as any Ptr)
 declare Sub _AddLinearRowUserJoint(byval joint as NJoint, byval pivot0 as any ptr, byval pivot1 as any ptr, byval dDir as any Ptr)
 declare Sub _AddAngularRowUserJoint(byval joint as NJoint,  byval relativeAngle as Single,  byval dDir as any Ptr)
 declare Sub _AddGeneralRowUserJoint(byval joint as NJoint,  byval jacobian0 as any ptr,  byval jacobian1 as any Ptr)
 declare Sub _RowMinimumFrictionUserJoint(byval joint as NJoint, byval  friction as Single)
 declare Sub _RowMaximumFrictionUserJoint(byval joint as NJoint, byval friction as Single)
 declare Sub _RowAccelerationUserJoint(byval joint as NJoint,  byval acceleration as Single)
 declare Sub _RowSpringDamperAccelerationUserJoint(byval joint as NJoint, byval  springK as single, byval springD as Single)
 declare Sub _RowStiffnessUserJoint(byval joint as NJoint,  byval stiffness as Single)
 declare Function _UserJointRowForce(byval joint As NJoint,  byval row as Integer)As Single

' ------------------------------------------------------------------------------------------------------------------------
'- MATERIAL IN CALLBACK
' ------------------------------------------------------------------------------------------------------------------------
 declare Sub _PhysicMaterialEventCallBack(byval pr as NMaterialPair, byval materialCallBack as any Ptr)
 declare Sub _PhysicMaterialCallBackAABBOverlap(byval pr as NMaterialPair, byval materialCallBack as any Ptr)
 declare Function _PhysicMaterialPairUserData(byval material as NPMaterial)As Any ptr
 declare Function _PhysicMaterialContactFaceAttribute(byval material as NPMaterial)As Integer
 declare Function _PhysicMaterialBodyCollisionID(byval material as NPMaterial, byval node as EntityNode)As Integer
 declare Function _PhysicMaterialContactNormalSpeed(byval material as NPMaterial)As Single
 declare Sub _PhysicMaterialContactForce(byval material as NPMaterial, byval force as any Ptr)
 declare Sub _PhysicMaterialContactPositionAndNormal(byval material as NPMaterial, byval posit as any ptr,  byval normal as any Ptr)
 declare Sub _PhysicMaterialContactTangentDirections(byval material as NPMaterial, byval dir0 as any ptr, byval dir1 as any ptr)
 declare Function _PhysicMaterialContactTangentSpeed(byval material as NPMaterial,  byval index as Integer)As Single
 declare Sub _ContactSoftnessPhysicMaterial(byval material as NPMaterial,  byval softness as Single)
 declare Sub _ContactElasticityPhysicMaterial(byval material as NPMaterial,  byval restitution as Single)
 declare Sub _ContactFrictionStatePhysicMaterial(byval material as NPMaterial,  byval state as integer,  byval index as Integer)
 declare Sub _ContactFrictionCoefPhysicMaterial(byval material as NPMaterial,  byval staticFrictionCoef as single,  byval kineticFrictionCoef as Single,  byval index as Integer)
 declare Sub _ContactNormalAccelerationPhysicMaterial(byval material as NPMaterial,  byval accel as Single)
 declare Sub _ContactNormalDirectionPhysicMaterial(byval material as NPMaterial, byval directionVector as any Ptr)
 declare Sub _ContactTangentAccelerationPhysicMaterial(byval material as NPMaterial,  byval accel as single,  byval index as Integer)
 declare Sub _ContactRotateTangentDirectionsPhysicMaterial(byval material as NPMaterial, byval directionVector as any Ptr) 
 
 
End Extern

