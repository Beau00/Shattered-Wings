using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TimeScreenUp : MonoBehaviour
{
    public bool gameIsPaused = false;
    public GameObject timeMenu;
    public GameObject timeMenuUI;
    public Camera fpcam;

    private void Start()
    {
        timeMenu.SetActive(false);

    }

    void Update()
    {
        if (Input.GetButtonDown("Cancel"))
        {
            if (gameIsPaused)
            {
                Resume();
            }
            else
            {
                Pause();

            }
        }


    }

    public void Resume()
    {
        Cursor.lockState = CursorLockMode.Locked;
        timeMenu.SetActive(false);
        timeMenuUI.SetActive(false);
        Time.timeScale = 1f;
        gameIsPaused = false;
    }
    public void Pause()
    {
        timeMenuUI.SetActive(true);
        timeMenu.SetActive(true);
        Time.timeScale = 0f;
        gameIsPaused = true;
        Cursor.lockState = CursorLockMode.None;
    }

  

}
