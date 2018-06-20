using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UniRx.Triggers;
using UnityEngine;
using UnityEngine.UI;

namespace InputKey
{
    public class CubeBehaviourScript : MonoBehaviour
    {
        private void Start()
        {
            // @see [【UniRx】Update()タイミングのイベントをFixedUpdate()のタイミングに変換する - Qiita](https://qiita.com/toRisouP/items/aeddfec470ca6de5924a)
            var rididBody = GetComponent<Rigidbody>();

            this.UpdateAsObservable()
                .Where(_ => Input.GetKey(KeyCode.Space))
                .BatchFrame(0, FrameCountType.FixedUpdate)
                .Subscribe(_ => rididBody.AddForce(Vector3.up, ForceMode.VelocityChange));
        }
    }
}