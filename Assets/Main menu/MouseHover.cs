using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MouseHover : MonoBehaviour
{
    public Image underline;
    
    public void Start()
    {
        underline.gameObject.SetActive(false);
    }

    public void OnMouseEnter()
    {
        underline.gameObject.SetActive(true);
    }



    public void OnMouseExit()
    {
        underline.gameObject.SetActive(false);
    }



}
