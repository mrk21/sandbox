using Unity.Entities;

[GenerateAuthoringComponent]
public struct Mover : IComponentData
{
    public float amp;
    public float t;
}
