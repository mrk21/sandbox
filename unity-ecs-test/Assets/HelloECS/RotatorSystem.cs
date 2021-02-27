using UnityEngine;
using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Transforms;
using System;

public class RotatorSystem : SystemBase
{
    protected override void OnUpdate()
    {
        float deltaTime = Time.DeltaTime;

        Entities
            .ForEach((ref Rotation rotation, in Rotator rotator) =>
            {
                rotation.Value = math.mul(
                    math.normalize(rotation.Value),
                    quaternion.Euler(0f, math.radians(rotator.speed * deltaTime), 0f));
            })
           .ScheduleParallel();
    }
}
