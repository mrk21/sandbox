using UnityEngine;
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;

namespace Creator {
    public class ScalerSystem : SystemBase
    {
        float rad = 0.0f;

        protected override void OnUpdate()
        {
            rad = (rad + math.radians(Time.DeltaTime)) % (2*math.PI);
            var r = rad;

            Entities
                .ForEach((ref Scale scale, in Scaler scaler) =>
                {
                    scale.Value = scaler.Value * Mathf.Sin(r * scaler.T);
                })
               .ScheduleParallel();
        }
    }
}
