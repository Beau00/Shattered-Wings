using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeSystem : MonoBehaviour
{
    public Material night, day, sunUp, sunDown;
    public Canvas blackOut;
    public TimeScreenUp screenTime;
   
    void Start()
    {
        RenderSettings.skybox = day;
        blackOut.enabled = false;
    }

    void Update()
    {
        
    }

    public void Night()
    {
       // remove the menu
       
        // sleeping animation

        // wait for seconds       Invoke("SetActive", 5.0f);  Invoke("SetFalse", 5.0f);     where as 5 is the numbers of seconds for the wait of active and non active.
        blackOut.enabled = true; 
        RenderSettings.skybox = night;
        // wait for seconds to delete

        //wake up animation and a new day started!
    }

    public void Day()
    {
        
        RenderSettings.skybox = day;
    }

    public void SunUp()
    {
       
        RenderSettings.skybox = sunUp;
    }

    public void SunDown()
    {
        
        RenderSettings.skybox = sunDown;
    }


}
