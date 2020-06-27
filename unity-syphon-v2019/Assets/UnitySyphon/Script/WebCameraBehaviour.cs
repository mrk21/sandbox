using System.Collections;
using System.Linq;
using UnityEngine;

namespace UnitySyphon
{
    public class WebCameraBehaviour : MonoBehaviour
    {
        IEnumerator Start()
        {
            yield return Application.RequestUserAuthorization(UserAuthorization.WebCam);
            if (Application.HasUserAuthorization(UserAuthorization.WebCam))
            {
                Debug.Log("webcam found");
                StartWebcam();
            }
            else
            {
                Debug.Log("webcam not found");
            }
        }

        void StartWebcam()
        {
            var userCameraDevices = WebCamTexture.devices.ToList();
            userCameraDevices.ForEach((v) => { Debug.Log(v.name); });
            var camera = userCameraDevices.Where((v) => v.name == "USB_Camera").First();
            var webCamTexture = new WebCamTexture(camera.name, 1920 / 3, 1080 / 3, 30);
            GetComponent<Renderer>().material.mainTexture = webCamTexture;
            webCamTexture.Play();
        }
    }
}
