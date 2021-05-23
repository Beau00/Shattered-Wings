using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordSystem : MonoBehaviour
{
    //this script will be on the grave only

    public GameObject grave;
    public GameObject swordOne, swordTwo;
    public Transform swordOnePlacement, swordTwoPlacement;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
       
            if(collision.transform.name == swordOne.transform.name)
            {
                swordOne.transform.position = swordOnePlacement.position;
                // freeze sword position
                swordOne.transform.parent = swordOnePlacement;
                //swordOne.GetComponent<Rigidbody>().useGravity = false;
                
            }
        
            if (collision.transform.name == swordTwo.transform.name)
            {
                swordTwo.transform.position = swordTwoPlacement.position;
                // freeze sword position
                swordTwo.transform.parent = swordTwoPlacement;
               // swordTwo.GetComponent<Rigidbody>().useGravity = false;
            
                
            }
       
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
