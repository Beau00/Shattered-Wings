using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Fadie : MonoBehaviour
{
    
    public Image ade;
    public GameObject image;
    
   

    public void Start()
    {
        image.SetActive(true);
        ade.canvasRenderer.SetAlpha(0f);
        
    }


    
    public void FadeIn()
    {
        ade.CrossFadeAlpha(1, 1, false);
        StartCoroutine(Henk());
        
    }

  
   IEnumerator Henk()
    {
        yield return new WaitForSeconds(3f);

        SceneManager.LoadScene(1);

    }








}

