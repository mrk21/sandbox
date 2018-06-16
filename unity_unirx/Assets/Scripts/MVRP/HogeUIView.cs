using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;
using UniRx.Triggers;

namespace MVRP
{
    public class HogeUIView : MonoBehaviour
    {
        public Text Text;
        public Slider Slider;
        public float MaxValue;

        // Use this for initialization
        private void Start()
        {
            Observable().Subscribe(v => Text.text = v.ToString());
        }

        // Update is called once per frame
        private void Update()
        {

        }

        public IObservable<float> Observable()
        {
            return Slider.OnValueChangedAsObservable()
                  .Select(ratio => MaxValue * ratio);
        }

        public float Value
        {
            get { return Slider.value * MaxValue; }
            set { Slider.value = value / MaxValue; }
        }
    }
}