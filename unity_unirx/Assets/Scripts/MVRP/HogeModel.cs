using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UniRx.Triggers;

namespace MVRP
{
    public class HogeModel
    {
        public ReactiveProperty<int> Value;

        public HogeModel() {
            Value = new ReactiveProperty<int>(0);
        }
    }
}