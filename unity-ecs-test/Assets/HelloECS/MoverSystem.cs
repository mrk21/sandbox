using UnityEngine;
using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Transforms;
using System;

public class MoverSystem : SystemBase
{
    protected float t = 0.0f;

    protected override void OnUpdate()
    {
        t += Time.DeltaTime;
        var tt = t;

        Entities
            .ForEach((ref Translation translation, in Mover mover) =>
            {
                translation.Value.x = (float)Math.Sin(math.radians(tt * mover.t)) * mover.amp;
            })
           .ScheduleParallel();
    }
}
