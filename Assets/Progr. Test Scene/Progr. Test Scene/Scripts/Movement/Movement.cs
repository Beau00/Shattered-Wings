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

  
    public RaycastHit hit;
 

    void Update()
    {
        


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

   
    
    

}





