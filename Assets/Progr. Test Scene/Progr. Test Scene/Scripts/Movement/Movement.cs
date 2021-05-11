using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    //movement variables
    public Animator animator;
    public bool canjump = true;
    public float h;
    public float v;
    public Vector3 move;
    public float moveSpeed;
    public Vector3 jump;
    public int maxJump;
    public int timesJumped;
    public bool running = false;
    public bool noWalking;

   

    //flower system variables

    public bool flowerChecker;
    public RaycastHit hit;
    public GameObject flowerOne, flowerTwo, flowerThree, flowerFour, flowerFive;
    public Rigidbody flowerOneRB, flowerTwoRB, flowerThreeRB, flowerFourRB, flowerFiveRB;
    public GameObject pickUpPosition;
    public GameObject puzzleCollider;


    void Update()
    {
        Vector3 center1 = gameObject.transform.position;
        float radius1 = 2;

        FlowerSystem(center1, radius1);


        if (running)
        {
            Running();
        }
        else
        {
            Walking();
        }
        if (Input.GetButtonDown("Jump"))
        {
            Jump();
        }
        if (Input.GetButtonDown("Left Shift"))
        {
            running = true;
        }
        if (Input.GetButtonUp("Left Shift"))
        {
            running = false;
        }
      
      
    }

    private void OnCollisionEnter(Collision collision)                                                                      // on collision enter
    {
        timesJumped = 0;
        
        if (collision.transform.tag.Equals("Flower"))
        {
            Debug.Log("test?");
        }
    }

    public void Jump()
    {
        if (timesJumped < maxJump)
        {
            timesJumped++;
            GetComponent<Rigidbody>().velocity = jump;
        }
    }

    public void Running()
    {
        // animator.SetTrigger();   running
        h = Input.GetAxis("Horizontal");
        v = Input.GetAxis("Vertical");
        move.x = h;
        move.z = v;
        GetComponent<Transform>().Translate(move * Time.deltaTime * moveSpeed * 3f);
    }

    public void Walking()
    {
        // animator.SetTrigger();        walking
        h = Input.GetAxis("Horizontal");
        v = Input.GetAxis("Vertical");
        move.x = h;
        move.z = v;
        GetComponent<Transform>().Translate(move * Time.deltaTime * moveSpeed);
        noWalking = false;
    }

    public void Sleep()
    {
        //if(Input.GetButtonDown(sleepbutton))
        noWalking = true;
    }

   
    void FlowerSystem(Vector3 center, float radius)
    {
       
        Collider[] hitColliders = Physics.OverlapSphere(center, radius);
        foreach (var hitCollider in hitColliders)
        {

                

            // for all flowers / bones + animation

             if (hitCollider.transform.name == flowerOne.transform.name && Input.GetButtonDown("E"))
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





