using UnityEngine;
using Google.Cloud.Speech.V1;
using dotenv.net;
using System.Runtime.InteropServices;
using System;
using System.Threading.Tasks;
using UnityEngine.UI;
using System.Collections;
using UniRx;
using System.Linq;

class AzureRecognizer
{
    private delegate void Callback(string v1, string v2);
    private delegate void Logger(string v);

    [DllImport("AzureSpeech")] private static extern IntPtr Recognizer_new(string key, string region, Logger logger, Callback callback);
    [DllImport("AzureSpeech")] private static extern void Recognizer_start(IntPtr recognizer);
    [DllImport("AzureSpeech")] private static extern void Recognizer_stop(IntPtr recognizer);
    [DllImport("AzureSpeech")] private static extern void Recognizer_delete(IntPtr recognizer);
    private IntPtr recognizer;
    private Logger logger;
    private Callback callback;
    public ReactiveProperty<(string, string)> OnUpdate = new ReactiveProperty<(string, string)>();

    public AzureRecognizer(string key, string region)
    {
        logger = (v) => { Debug.Log(v); };
        callback = (v1, v2) => { OnUpdate.Value = (v1, v2); };
        recognizer = Recognizer_new(key, region, logger, callback);
    }

    public void Start()
    {
        Task.Run(() =>
        {
            Recognizer_start(recognizer);
        });
    }

    public void Stop()
    {
        Recognizer_stop(recognizer);
    }

    ~AzureRecognizer()
    {
        Recognizer_delete(recognizer);
    }
}

public class SpeechBehaviour : MonoBehaviour
{
    private static readonly string DEMO_FILE = "test.flac";
    private SpeechClient client;
    private AzureRecognizer recognizer;

    [SerializeField] private Text recognizedText = null;
    [SerializeField] private Text translatedText = null;

    IEnumerator Start()
    {
        DotEnv.AutoConfig();
        
        yield return Application.RequestUserAuthorization(UserAuthorization.Microphone);
        if (Application.HasUserAuthorization(UserAuthorization.Microphone))
        {
            Debug.Log("Microphone found");
        }
        else
        {
            Debug.Log("Microphone not found");
        }

        InitGCPRecognizer();
        InitAzureRecognizer();
    }

    void InitGCPRecognizer()
    {
        client = SpeechClient.Create();
    }

    void InitAzureRecognizer()
    {
        recognizer = new AzureRecognizer(
            Environment.GetEnvironmentVariable("AZURE_SBSCRIPTION_KEY"),
            Environment.GetEnvironmentVariable("AZURE_REGION")
        );

        recognizer.OnUpdate
            .Subscribe((v) => { Debug.Log(v.Item1 + " -> " + v.Item2); })
            .AddTo(gameObject);

        recognizer.OnUpdate
            .BatchFrame(0, FrameCountType.Update)
            .Subscribe((v) => {
                recognizedText.text = v.Last().Item1;
                translatedText.text = v.Last().Item2;
            })
            .AddTo(gameObject);

        recognizer.Start();
    }

    void OnDestroy()
    {
        recognizer.Stop();
    }

    public void OnClickButton()
    {
        var response = client.Recognize(
            new RecognitionConfig()
            {
                Encoding = RecognitionConfig.Types.AudioEncoding.Flac,
                SampleRateHertz = 22050,
                LanguageCode = LanguageCodes.Japanese.Japan,
            },
            RecognitionAudio.FromFile(DEMO_FILE)
        );
        Debug.Log(response);
    }
}
