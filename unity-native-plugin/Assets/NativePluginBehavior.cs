using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using UnityEngine;
using UniRx;
using System.Linq;
using UnityEngine.UI;

class Generator
{
    private delegate void Callback(string v);
    private delegate void Logger(string v);

    [DllImport("NativePlugin")] private static extern IntPtr Generator_new(Callback callback, Logger logger);
    [DllImport("NativePlugin")] private static extern void Generator_start(IntPtr generator);
    [DllImport("NativePlugin")] private static extern void Generator_stop(IntPtr generator);
    [DllImport("NativePlugin")] private static extern void Generator_delete(IntPtr generator);

    private IntPtr generator;
    private Callback callback;
    private Logger logger;
    public ReactiveProperty<string> OnUpdate = new ReactiveProperty<string>();

    public Generator()
    {
        callback = (v) => { OnUpdate.Value = v; };
        logger = (v) => { Debug.Log(v); };
        generator = Generator_new(callback, logger);
    }

    public void Start()
    {
        Task.Run(() =>
        {
            Generator_start(generator);
        });
    }

    public void Stop()
    {
        Generator_stop(generator);
    }

    ~Generator()
    {
        Generator_delete(generator);
    }
}


public class NativePluginBehavior : MonoBehaviour
{
    [DllImport("NativePlugin")] private static extern int get_number();
    [DllImport("NativePlugin")] private static extern string get_string();
    [DllImport("NativePlugin")] private static extern void call_callback(Action<string> callback);

    [SerializeField] private Text textField = null;
    private Generator generator;

    void Start()
    {
        Debug.Log(get_number());
        Debug.Log(get_string());
        call_callback((msg) => { Debug.Log(msg); });

        generator = new Generator();

        generator.OnUpdate
            .Subscribe((v) => { Debug.Log(v); })
            .AddTo(gameObject);

        generator.OnUpdate
            .BatchFrame(0, FrameCountType.Update)
            .Subscribe((v) => {
                textField.text = v.Last();
            })
            .AddTo(gameObject);

        generator.Start();
    }

    void OnDestroy()
    {
        generator.Stop();
    }
}
