using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class fadieout2 : MonoBehaviour
{
    public Image ade;
    
    
    // Start is called before the first frame update
    public void Start()
    {

        
        FadeOut();

    }

    public void FadeOut()
    {
        
        ade.CrossFadeAlpha(0, 1, false);
    }
}
