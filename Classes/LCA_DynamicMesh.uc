class LCA_DynamicMesh extends Actor
	placeable;

defaultproperties
{
	DrawType=DT_StaticMesh
	RemoteRole=ROLE_SimulatedProxy
	bGameRelevant=true

	bCollideActors=True
	bCollideWorld=True
	bBlockActors=True
	bBlockKarma=True
	bBlockNonZeroExtentTraces=true
	bWorldGeometry=True
	bAcceptsProjectors=True
    bUseDynamicLights=true
}