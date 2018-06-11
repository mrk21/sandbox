using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UniRx.Triggers;
using UnityEngine;
using UnityEngine.UI;

namespace InputKey
{
    public class TextBehaviourScript : MonoBehaviour
    {
        void Awake()
        {
            var text = this.GetComponent<Text>();
            this.UpdateAsObservable()
                .Subscribe(key => text.text = "");
            this.UpdateAsObservable()
                .Where(_ => Input.GetKey(KeyCode.A))
                .Subscribe(key => text.text = "'A' key is pressing!");
        }

        // Use this for initialization
        void Start()
        {
            
        }

        // Update is called once per frame
        void Update()
        {

        }
    }
}