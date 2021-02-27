using UnityEngine;
using Unity.Entities;
using Unity.Transforms;
using Unity.Rendering;

namespace Creator
{
    public class Spawner : MonoBehaviour
    {
        [SerializeField] private Mesh mesh;
        [SerializeField] private Material material;

        void Start()
        {
            EntityManager manager = World.DefaultGameObjectInjectionWorld.EntityManager;
            EntityArchetype archetype = manager.CreateArchetype(
                typeof(Translation),
                typeof(Rotation),
                typeof(Scale),
                typeof(RenderMesh),
                typeof(RenderBounds),
                typeof(LocalToWorld),
                typeof(Scaler)
                );
            Entity entity = manager.CreateEntity(archetype);

            manager.AddComponentData(entity, new Translation
            {
                Value = new Unity.Mathematics.float3(2f, 0f, 4f)
            });

            manager.AddComponentData(entity, new Scaler
            {
                Value = 2.0f,
                T = 90
            });

            manager.AddSharedComponentData(entity, new RenderMesh
            {
                mesh = mesh,
                material = material,
            });
        }
    }
}
