using UnityEngine;
using Google.Cloud.Speech.V1;
using dotenv.net;

public class SpeechBehaviour : MonoBehaviour
{
    private static readonly string DEMO_FILE = "test.flac";
    private SpeechClient client;

    void Start()
    {
        DotEnv.AutoConfig();
        this.client = SpeechClient.Create();
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
