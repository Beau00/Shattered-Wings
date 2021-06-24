using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EndOutro : MonoBehaviour
{
    public void Start()
    {
        StartCoroutine(Outro());
    }

    IEnumerator Outro()
    {
        yield return new WaitForSeconds(11f);
        print(123);
        SceneManager.LoadScene(0);
    }
}
