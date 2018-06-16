using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UniRx;
using UniRx.Triggers;

namespace MVRP
{
    public class RootModel : MonoBehaviour
    {
        [SerializeField]
        public int HogeValue;

        public HogeModel Hoge;

        private void Awake()
        {
            Hoge = new HogeModel();
        }

        // Use this for initialization
        private void Start()
        {
            this.FixedUpdateAsObservable()
                .Select(_ => HogeValue)
                .DistinctUntilChanged()
                .Subscribe(v => Hoge.Value.Value = v);

            Hoge.Value
                .DistinctUntilChanged()
                .Subscribe(v => HogeValue = v);
        }

        // Update is called once per frame
        private void Update()
        {

        }
    }
}