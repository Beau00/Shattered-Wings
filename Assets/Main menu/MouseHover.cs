using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MouseHover : MonoBehaviour
{
    public GameObject underline;


    public void Start()
    {
        underline.SetActive(false);
    }

    public void OnMouseEnter()
    {
        underline.SetActive(true);
    }

    public void OnMouseExit()
    {
        underline.SetActive(false);
    }


}
