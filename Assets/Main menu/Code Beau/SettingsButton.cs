using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SettingsButton : MonoBehaviour
{

    public GameObject settingsCanvas;
    public GameObject menuCanvas;



    public void Settings()
    {
        settingsCanvas.SetActive(true);
        menuCanvas.SetActive(false);
    }
}
