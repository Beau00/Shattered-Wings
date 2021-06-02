using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUp : MonoBehaviour
{

    public bool flowerChecker;
    public RaycastHit hit;
    public GameObject axe1, axe2, axe3;
    
    public GameObject pickUpPosition;
    


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 center1 = gameObject.transform.position;
        float radius1 = 2;

        FlowerSystem(center1, radius1);

    }


  
    // change w tags instead of names.
   
    void FlowerSystem(Vector3 center, float radius)
    {

        Collider[] hitColliders = Physics.OverlapSphere(center, radius);
        foreach (var hitCollider in hitColliders)
        {

            if (hitCollider.transform.tag.Equals("item") && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower One Check");

                axe1.GetComponent<Rigidbody>().useGravity = false;
                axe1.transform.position = pickUpPosition.transform.position;
                axe1.transform.parent = GameObject.Find("PickUpPosition").transform;
                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix
            }
            if (Input.GetButtonUp("E"))
            {
                axe1.transform.parent = null;
                axe1.GetComponent<Rigidbody>().useGravity = true;
            }
            
        }
    }

}
