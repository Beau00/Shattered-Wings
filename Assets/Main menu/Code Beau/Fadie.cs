using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Fadie : MonoBehaviour
{
    
    public Image ade;
    public bool startEnd;
    public GameObject image;
    public float time;

    public void Start()
    {
        image.SetActive(true);
        ade.canvasRenderer.SetAlpha(0f);
        
    }


    
    public void FadeIn()
    {
        ade.CrossFadeAlpha(1, 1, false);
        startEnd = true;
        StartCoroutine(Henk());
    }

    public void FadeOut()
    {
        ade.CrossFadeAlpha(0, 1, false);
    }

   IEnumerator Henk()
    {
        yield return new WaitForSeconds(1f);

        SceneManager.LoadScene(1);

    }








}

