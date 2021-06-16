using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lower, low, high, higher;

    public Transform doorOneCollider, doorTwoCollider, doorThreeCollider, doorFourCollider;

    public Animator door1, door2, door3, door4;

    //public GameObject smollDoorOne, smollDoorTwo, smollDoorThree, smollDoorFour;
    public bool smolldoorOpenOne = false, smolldoorOpenTwo = false, smolldoorOpenThree = false, smolldoorOpenFour = false;
    
    public float doorRotation;
    public GameObject trofeeSoundPuzzle;

    public GameObject player;
    public float delay;
    
    // animation add && main item systemm

    // Start is called before the first frame update
    void Start()
    {
        

        lower.Stop();  
        low.Stop();
        high.Stop();   
        higher.Stop();
    }

    void Update()
    {
        Collider[] collidersOne = Physics.OverlapSphere(doorOneCollider.transform.position, 0.5f);
        foreach (Collider collider1 in collidersOne)
        {
            if (collider1.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                lower.PlayDelayed(0.5f);
                smolldoorOpenOne = true;
                delay = Time.time;
                door1.SetBool("Open", true);
                door1.SetBool("CloseOpen", true);
                door1.SetBool("OpenClose", false);

            }
            else if(smolldoorOpenOne = true && Input.GetButtonDown("F"))
            {
                lower.Stop();
                smolldoorOpenOne = false;
                delay = Time.time;
                door1.SetBool("OpenClose", true);
                door1.SetBool("CloseOpen", false);
                door1.SetBool("Open", false);
            }
        }

        Collider[] collidersTwo = Physics.OverlapSphere(doorTwoCollider.transform.position, 0.5f);
        foreach (Collider collider2 in collidersTwo)
        {
            if (collider2.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                low.PlayDelayed(0.5f);
                smolldoorOpenTwo = true;
                delay = Time.time;
                door2.SetBool("DoorOpen", true);
                door2.SetBool("DoorCloseOpen", true);
                door2.SetBool("DoorClose", false);
            }
            else if(smolldoorOpenTwo = true && Input.GetButtonDown("F"))
            {
                low.Stop();
                smolldoorOpenTwo = false;
                delay = Time.time;
                door2.SetBool("DoorClose", true);
                door2.SetBool("DoorOpen", false);
                door2.SetBool("DoorCloseOpen", false);
            }
        }

        Collider[] collidersThree = Physics.OverlapSphere(doorThreeCollider.transform.position, 0.5f);
        foreach (Collider collider3 in collidersThree )
        {
          
            if (collider3.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                high.PlayDelayed(0.5f);
                smolldoorOpenThree = true;
                delay = Time.time;
                door3.SetBool("OpenD", true);
                door3.SetBool("CloseD", false);
                door3.SetBool("CloseDOpenD", true);
            }
            else if(smolldoorOpenThree = true && Input.GetButtonDown("F"))
            {
                high.Stop();
                smolldoorOpenThree = false;
                delay = Time.time;
                
                door3.SetBool("CloseD", true);
                door3.SetBool("OpenD", false);
                door3.SetBool("CloseDOpenD", false);
            }
        }

        Collider[] collidersFour = Physics.OverlapSphere(doorFourCollider.transform.position, 0.5f);
        foreach (Collider collider4 in collidersFour)
        {
            
            if (collider4.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                higher.PlayDelayed(0.5f);
                smolldoorOpenFour = true;
                delay = Time.time;
                door4.SetBool("OpenTrue", true);
                door4.SetBool("OpenToClose", false);
                door4.SetBool("CloseToOpen", true);
            }
            else if(smolldoorOpenFour = true && Input.GetButtonDown("F"))
            {
                higher.Stop();
                smolldoorOpenFour = false;
                delay = Time.time;
                door4.SetBool("OpenToClose", true);
                door4.SetBool("OpenTrue", false) ;
                door4.SetBool("CloseToOpen", false);


            }
        }

   
    }

  
  


}
