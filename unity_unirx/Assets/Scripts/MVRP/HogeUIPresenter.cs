using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;
using UniRx.Triggers;

namespace MVRP
{
    public class HogeUIPresenter : MonoBehaviour
    {
        private HogeUIView view;
        private HogeModel model;

        public GameObject RootModelObject;
        public GameObject ViewObject;

        private void Awake()
        {
        }

        // Use this for initialization
        private void Start()
        {
            model = RootModelObject.GetComponent<RootModel>().Hoge;
            view = ViewObject.GetComponent<HogeUIView>();

            view.Observable()
                 .Subscribe(v => model.Value.Value = (int)v);


            model.Value
                 .Subscribe(v => view.Value = v);
        }

        // Update is called once per frame
        private void Update()
        {

        }
    }
}