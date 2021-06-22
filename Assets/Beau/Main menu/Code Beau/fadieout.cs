using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class fadieout : MonoBehaviour
{
    public Image ade;
    // Start is called before the first frame update
    void Start()
    {
        
        FadeOut();
    }

    public void FadeOut()
    {
        ade.CrossFadeAlpha(0, 2, false);
    }

}
