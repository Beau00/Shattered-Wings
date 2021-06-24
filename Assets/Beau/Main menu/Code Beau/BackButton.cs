using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackButton : MonoBehaviour
{

    public GameObject settingsCanvas;
    public GameObject menuCanvas;
    
    public void Button()
    {
        settingsCanvas.SetActive(false);
        menuCanvas.SetActive(true);
      
    }


}

