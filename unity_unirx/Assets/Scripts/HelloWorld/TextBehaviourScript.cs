using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

namespace HelloWorld
{
    public class TextBehaviourScript : MonoBehaviour
    {
        public GameObject button;
        private Text text;

        void Awake()
        {
            text = GetComponent<Text>();
        }

        // Use this for initialization
        void Start()
        {
            IObservable<int> clickObservable = button.GetComponent<ButtonBehaviourScript>()
                                                     .clickObservable;
            clickObservable.Where(v => v % 2 == 0)
                           .Subscribe(count => { text.text = String.Format("{0}", count); });
        }

        // Update is called once per frame
        void Update()
        {

        }
    }
}