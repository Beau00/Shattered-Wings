using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Escc : MonoBehaviour
{
    public GameObject pauseCanvas;
    public bool gameIsPaused = false;
    public GameObject setttingCanvas;

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
                AudioListener.volume =0;
                Cursor.lockState = CursorLockMode.None;
            }
            else
            {
                gameIsPaused = false;
                pauseCanvas.SetActive(false);
                Time.timeScale = 1f;
                AudioListener.volume = 1;
                Cursor.lockState = CursorLockMode.Locked;
                setttingCanvas.SetActive(false);

            }
            
        }

     



}
    public void Resumebutton()
    {
        pauseCanvas.SetActive(false);
        Time.timeScale = 1f;
        AudioListener.volume = 1;
        Cursor.lockState = CursorLockMode.Locked;
    }

}
