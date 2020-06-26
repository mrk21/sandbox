using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class NativePluginBehavior : MonoBehaviour
{
    [DllImport("NativePlugin")] private static extern int get_number();
    [DllImport("NativePlugin")] private static extern string get_string();
    [DllImport("NativePlugin")] private static extern void call_callback(Action<string> callback);

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log(get_number());
        Debug.Log(get_string());
        call_callback((msg) => { Debug.Log(msg); });
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
