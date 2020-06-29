using UnityEngine;
using dotenv.net;
using System.Runtime.InteropServices;
using System;
using System.Threading.Tasks;
using UnityEngine.UI;
using System.Collections;
using UniRx;
using System.Linq;
using Google.Cloud.Speech.V1;

class AzureRecognizer
{
    private delegate void Callback(string v1, string v2);
    private delegate void Logger(string v);

    [DllImport("AzureSpeech")] private static extern IntPtr Recognizer_new(string key, string region, Logger logger, Callback callback);
    [DllImport("AzureSpeech")] private static extern void Recognizer_start(IntPtr recognizer);
    [DllImport("AzureSpeech")] private static extern void Recognizer_stop(IntPtr recognizer);
    [DllImport("AzureSpeech")] private static extern void Recognizer_delete(IntPtr recognizer);

    private IntPtr recognizer;
    private readonly Logger logger;
    private readonly Callback callback;
    private readonly string key;
    private readonly string region;

    public ReactiveProperty<(string, string)> OnUpdate = new ReactiveProperty<(string, string)>();

    public AzureRecognizer(string key_, string region_)
    {
        logger = (v) => { Debug.Log(v); };
        callback = (v1, v2) => { OnUpdate.Value = (v1, v2); };
        key = key_;
        region = region_;
    }

    public void Start()
    {
        recognizer = Recognizer_new(key, region, logger, callback);
        Task.Run(() =>
        {
            Recognizer_start(recognizer);
        });
    }

    public void Stop()
    {
        Recognizer_stop(recognizer);
        Recognizer_delete(recognizer);
    }
}

public class SpeechBehaviour : MonoBehaviour
{
    private SpeechClient client;
    private AzureRecognizer recognizer;

    [SerializeField] private Text recognizedText = null;
    [SerializeField] private Text translatedText = null;
    [SerializeField] private Button gcpRecognitionButton = null;
    [SerializeField] private Button azureRecognitionButton = null;

    IEnumerator Start()
    {
        DotEnv.Config(true, Application.streamingAssetsPath + "/env");
        Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", Application.streamingAssetsPath + "/credentials.json");

        yield return Application.RequestUserAuthorization(UserAuthorization.Microphone);
        if (Application.HasUserAuthorization(UserAuthorization.Microphone))
        {
            Debug.Log("Microphone found");
        }
        else
        {
            Debug.Log("Microphone not found");
        }

        //InitGCPRecognizer();
        InitAzureRecognizer();
    }

    void InitGCPRecognizer()
    {
        client = SpeechClient.Create();

        gcpRecognitionButton.OnClickAsObservable()
            .Subscribe(_ => { OnClickGCPRecognitionButton(); })
            .AddTo(gameObject);
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
        recognizer = null;
        client = null;
    }

    public void OnClickGCPRecognitionButton()
    {
        var response = client.Recognize(
            new RecognitionConfig()
            {
                Encoding = RecognitionConfig.Types.AudioEncoding.Flac,
                SampleRateHertz = 22050,
                LanguageCode = LanguageCodes.Japanese.Japan,
            },
            RecognitionAudio.FromFile(Application.streamingAssetsPath + "/test.flac")
        );
        Debug.Log(response);
    }
}
