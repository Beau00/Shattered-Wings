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

    public IEnumerator Night()
    {
        yield return new WaitForSeconds(2f);
        RenderSettings.skybox = night;
    }

    public IEnumerator Day()
    {
        yield return new WaitForSeconds(2f);
        RenderSettings.skybox = day;
    }

    public IEnumerator SunUp()
    {
        yield return new WaitForSeconds(2f);
        RenderSettings.skybox = sunUp;
    }

    public IEnumerator SunDown()
    {
        yield return new WaitForSeconds(2f);
        RenderSettings.skybox = sunDown;
    }


}
