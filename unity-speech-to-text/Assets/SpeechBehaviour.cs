using UnityEngine;
using Google.Cloud.Speech.V1;
using dotenv.net;
using System.Runtime.InteropServices;
using System;
using System.Threading.Tasks;
using UnityEngine.UI;

class AzureRecognizer
{
    [DllImport("AzureSpeech")] private static extern IntPtr Recognizer_new(string key, string region, Action<string> logger);
    [DllImport("AzureSpeech")] private static extern void Recognizer_recognize(IntPtr recognizer, Action<string, string> callback);
    [DllImport("AzureSpeech")] private static extern void Recognizer_delete(IntPtr recognizer);
    private IntPtr recognizer;
    private Boolean isRunning;

    public AzureRecognizer()
    {
        var key = Environment.GetEnvironmentVariable("AZURE_SBSCRIPTION_KEY");
        var region = Environment.GetEnvironmentVariable("AZURE_REGION");
        recognizer = Recognizer_new(key, region, (msg) => { Debug.Log(msg); });
    }

    public void Start(Action<string, string> callback)
    {
        isRunning = true;
        Task.Run(() =>
        {
            while (isRunning) Recognizer_recognize(recognizer, callback);
        });
    }

    public void Stop()
    {
        isRunning = false;
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

    private string recognizedText_ = "";
    private string translatedText_ = "";

    void Start()
    {
        DotEnv.AutoConfig();
        
        client = SpeechClient.Create();
        recognizer = new AzureRecognizer();
        recognizer.Start((recognizedText, translatedText) => {
            Debug.Log("#################");
            this.recognizedText_ = recognizedText;
            this.translatedText_ = translatedText;
        });
    }

    void Update()
    {
        recognizedText.text = recognizedText_;
        translatedText.text = translatedText_;
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
