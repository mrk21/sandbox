using Google.Cloud.Speech.V1;
using System;

namespace GoogleCloudSamples
{
    public class QuickStart
    {
        public static string DEMO_FILE = "../../../test.flac";

        public static void Main(string[] args)
        {
            Console.OutputEncoding = new System.Text.UTF8Encoding();
            var speech = SpeechClient.Create();
            var response = speech.Recognize(
                new RecognitionConfig()
                {
                    Encoding = RecognitionConfig.Types.AudioEncoding.Flac,
                    SampleRateHertz = 22050,
                    LanguageCode = LanguageCodes.Japanese.Japan,
                },
                RecognitionAudio.FromFile(DEMO_FILE)
            );
            System.Console.WriteLine(response);
        }
    }
}