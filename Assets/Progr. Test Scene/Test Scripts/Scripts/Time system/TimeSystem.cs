using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeSystem : MonoBehaviour
{
    public Material night;
    public Material day;
    public Material sunUp;
    public Material sunDown;
   
    void Start()
    {
        RenderSettings.skybox = day;
    }

    void Update()
    {
        
    }

    public void Night()
    {
        RenderSettings.skybox = night;
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
