using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class fadieout : MonoBehaviour
{
    public Image ade;
    public GameObject fadOut;
    
    // Start is called before the first frame update
    public void Start()
    {

        
        FadeOut();
        
    }

    public void FadeOut()
    {
        
        fadOut.SetActive(true);
        ade.CrossFadeAlpha(0, 1, true);
        

    }

   
}
