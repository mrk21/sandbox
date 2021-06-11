using UnityEngine;
using Unity.Entities;

namespace Creator
{
    struct Scaler : IComponentData
    {
        public float Value;
        public float T;
    }
}
