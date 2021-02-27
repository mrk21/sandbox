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

            var renderMesh = new RenderMesh
            {
                mesh = mesh,
                material = material,
            };

            var rand = new System.Random();

            for (int x = -5; x <= 5; x++)
            {
                for (int y = -5; y <= 5; y++)
                {
                    for (int z = -5; z <= 5; z++)
                    {
                        Entity entity = manager.CreateEntity(archetype);

                        manager.AddComponentData(entity, new Translation
                        {
                            Value = new Unity.Mathematics.float3(x, y, z)
                        });

                        manager.AddComponentData(entity, new Scaler
                        {
                            Value = (float)rand.NextDouble() + 1.0f,
                            T = rand.Next(0, 360)
                        });

                        manager.AddSharedComponentData(entity, renderMesh);
                    }
                }
            }
        }
    }
}
