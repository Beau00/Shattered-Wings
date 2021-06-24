using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameEnd : MonoBehaviour
{
    public Image ade;
    public GameObject image;

    public void Outro()
    {
        StartCoroutine(FadeIn());
    }
    IEnumerator FadeIn()
    {
        yield return new WaitForSeconds(6f);
        image.SetActive(true);
        ade.CrossFadeAlpha(1, 1, false);
        StartCoroutine(OutroStart());
    }

    IEnumerator OutroStart()
    {
        yield return new WaitForSeconds(2f);
        SceneManager.LoadScene(3);
    }
}
