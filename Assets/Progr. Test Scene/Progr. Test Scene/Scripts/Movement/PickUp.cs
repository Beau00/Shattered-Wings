using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUp : MonoBehaviour
{

    public bool flowerChecker;
    public RaycastHit hit;
    public GameObject flowerOne, flowerTwo, flowerThree, flowerFour, flowerFive;
    
    public GameObject pickUpPosition;
    public GameObject puzzleCollider;


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

    private void OnCollisionEnter(Collision collision)                                                                      
    {
    

        if (collision.transform.tag.Equals("Flower"))
        {
            Debug.Log("test?");
        }
    }

  
    // change w tags instead of names.
   
    void FlowerSystem(Vector3 center, float radius)
    {

        Collider[] hitColliders = Physics.OverlapSphere(center, radius);
        foreach (var hitCollider in hitColliders)
        {



            // for all flowers / bones + animation

            if (hitCollider.transform.name.Equals(flowerOne.transform.name) && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower One Check");


                flowerOne.GetComponent<Rigidbody>().useGravity = false;
                flowerOne.transform.position = pickUpPosition.transform.position;
                flowerOne.transform.parent = GameObject.Find("PickUpPosition").transform;
                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix

            }
            if (Input.GetButtonUp("E"))
            {
                flowerOne.transform.parent = null;
                flowerOne.GetComponent<Rigidbody>().useGravity = true;
            }



            if (hitCollider.transform.name == flowerTwo.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower Two Check");


                flowerTwo.GetComponent<Rigidbody>().useGravity = false;
                flowerTwo.transform.position = pickUpPosition.transform.position;
                flowerTwo.transform.parent = GameObject.Find("PickUpPosition").transform;
                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix

            }
            if (Input.GetButtonUp("E"))
            {
                flowerTwo.transform.parent = null;
                flowerTwo.GetComponent<Rigidbody>().useGravity = true;
            }


            if (hitCollider.transform.name == flowerThree.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower Two Check");


                flowerThree.GetComponent<Rigidbody>().useGravity = false;
                flowerThree.transform.position = pickUpPosition.transform.position;
                flowerThree.transform.parent = GameObject.Find("PickUpPosition").transform;
                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix

            }
            if (Input.GetButtonUp("E"))
            {
                flowerThree.transform.parent = null;
                flowerThree.GetComponent<Rigidbody>().useGravity = true;
            }


            if (hitCollider.transform.name == flowerFour.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower Two Check");


                flowerFour.GetComponent<Rigidbody>().useGravity = false;
                flowerFour.transform.position = pickUpPosition.transform.position;
                flowerFour.transform.parent = GameObject.Find("PickUpPosition").transform;

                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix

            }
            if (Input.GetButtonUp("E"))
            {
                flowerFour.transform.parent = null;
                flowerFour.GetComponent<Rigidbody>().useGravity = true;
            }


            if (hitCollider.transform.name == flowerFive.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("Flower Two Check");


                flowerFive.GetComponent<Rigidbody>().useGravity = false;
                flowerFive.transform.position = pickUpPosition.transform.position;
                flowerFive.transform.parent = GameObject.Find("PickUpPosition").transform;
                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix

            }
            if (Input.GetButtonUp("E"))
            {
                flowerFive.transform.parent = null;
                flowerFive.GetComponent<Rigidbody>().useGravity = true;
            }
        }
    }

}
