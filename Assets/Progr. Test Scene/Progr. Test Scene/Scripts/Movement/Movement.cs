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

    void Update()
    {
        //TestFunctionForFlowers(customCenter, customRadius);
        //flowerChecker = CheckCloseToTag("F1", 1);


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
        // -----------------------------------------------------------------------------------------------------------------------    Flower System
       // FlowerSystem();
    }

    private void OnCollisionEnter(Collision collision)
    {
        timesJumped = 0;
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


    public void FlowerSystem()
    {
        //actual function for flower system, for testing
    }



    //test 2
    /*
    bool CheckCloseToTag(string tag, float minimumDistance)
    {
        GameObject[] goWithTag = GameObject.FindGameObjectsWithTag(tag);
        for (int i = 0; i<goWithTag.Length; ++i)
        {
            if (Vector3.Distance(transform.position, goWithTag[i].transform.position) <= minimumDistance) 
            return true;
            Debug.Log("true");
        }
        Debug.Log("false");
        return false;
    }

    */




}










    /*
     * 
    


                                // test 1
    public float customRadius = 2;
    public Vector3 customCenter;
    public GameObject flowerOne;
   

    public void TestFunctionForFlowers(Vector3 center, float radius)
    {
        Collider[] hitColliders = Physics.OverlapSphere(center, radius);
        customCenter = center;
        customRadius = radius;

        Debug.Log(radius);

        int i = 0;
        while (i < hitColliders.Length)
        {
            //it checks all instead of the shit in the radius
            Debug.Log(tag);
            if (hitColliders[i].transform.tag == "F1" || hitColliders[i].transform.tag == flowerOne.transform.tag) // it doesnt return the tag (i think)    de == werkt niet why
            { // here is F1 flower one, F2 flower 2 etc,

                Debug.Log(tag);   // untagged?
                if (Input.GetButtonDown("E"))
                {
                    // animator.SetTrigger();      pickup animation

                    Debug.Log("it workey");
                }            
            }

            if (hitColliders[i].tag == "F2")
            {

            }
            if (hitColliders[i].tag == "F3")
            {

            } // etc.

                i++;
             
        }
         
    }
    */




