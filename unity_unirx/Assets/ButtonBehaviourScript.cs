using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class ButtonBehaviourScript : MonoBehaviour {
    public IObservable<int> clickObservable;

    void Awake() {
        Button button = this.GetComponent<Button>();
        clickObservable = button.OnClickAsObservable()
                                .Select(_ => 1)
                                .Scan((acc, current) => acc + current);
    }

	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
