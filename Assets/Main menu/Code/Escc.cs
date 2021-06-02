using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Escc : MonoBehaviour
{
    public GameObject pauseCanvas;
    public bool gameIsPaused = false;


    // Update is called once per frame
    void Update()
    {
        
        if (Input.GetButtonDown("Cancel"))
        {
           
            if (gameIsPaused == false)
            {
                gameIsPaused = true;
                pauseCanvas.SetActive(true);
                Time.timeScale = 0f;
            }else
            {
                gameIsPaused = false;
                pauseCanvas.SetActive(false);
                Time.timeScale = 1f;
            }
            
        }


        
        
    
    }

}
