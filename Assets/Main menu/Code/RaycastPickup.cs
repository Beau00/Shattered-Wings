using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class RaycastPickup : MonoBehaviour
{
    public Text pickup;
    public RaycastHit hit;

    void Update()
    {
        if (Physics.Raycast(transform.position, transform.forward, out hit, 1000))
        {
            if (hit.collider.gameObject.tag == "pickupthing")
            {

                pickup.gameObject.SetActive(true);

            }

        }
        else
        {

            pickup.gameObject.SetActive(false);
        
        }
    }

}

