using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Fadie : MonoBehaviour
{
    
    public Image ade;
    public float alpha = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        ade.color = new Color(0, 0, 0, alpha) * Time.deltaTime;

        alpha++;

    }
}
