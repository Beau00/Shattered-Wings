using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RaycastScript : MonoBehaviour
{

    public GameObject bunca;
  
    public RaycastHit hit;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetButtonDown("Fire1"))
        {
            if (Physics.Raycast(bunca.transform.position, bunca.transform.forward, out hit, 30f))
            {
                Debug.Log("it workey");

            }
        }
    }
}
