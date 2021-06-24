using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadieMain1 : MonoBehaviour
{
    public Image ade;
    public GameObject aade;
    public GameObject beam;
    // Start is called before the first frame update
    void Start()
    {
        aade.SetActive(false);
    }

    public void Update()
    {
        if (beam.activeInHierarchy)
        {
            StartCoroutine(Henk());
        }
    }

    public void FadeIn()
    {
        ade.CrossFadeAlpha(1, 1, false);
    }

    IEnumerator Henk()
    {
        yield return new WaitForSeconds(2f);

        FadeIn();
        aade.SetActive(true);
    }

}
