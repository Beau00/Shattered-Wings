using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lower, low, high, higher;
    public Animator doors; // door animator;
    public GameObject smollDoorOne, smollDoorTwo, smollDoorThree, smollDoorFour;
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
        Collider[] collidersOne = Physics.OverlapSphere(smollDoorOne.transform.position, 1f);
        foreach (Collider collider1 in collidersOne)
        {
            if (collider1.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                lower.PlayDelayed(0.5f);
                smolldoorOpenOne = true;
                delay = Time.time;
                doors.SetBool("door1open", true);
            }
            else if(smolldoorOpenOne = true && Input.GetButtonDown("F"))
            {
                lower.Stop();
                smolldoorOpenOne = false;
                delay = Time.time;
                doors.SetBool("door1close", true);
            }
        }

        Collider[] collidersTwo = Physics.OverlapSphere(smollDoorTwo.transform.position, 1f);
        foreach (Collider collider2 in collidersTwo)
        {
            if (collider2.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                low.PlayDelayed(0.5f);
                smolldoorOpenTwo = true;
                delay = Time.time;
                doors.SetBool("door2open", true);
            }
            else if(smolldoorOpenTwo = true && Input.GetButtonDown("F"))
            {
                low.Stop();
                smolldoorOpenTwo = false;
                delay = Time.time;
                doors.SetBool("door2close", true);
            }
        }

        Collider[] collidersThree = Physics.OverlapSphere(smollDoorThree.transform.position, 1f);
        foreach (Collider collider3 in collidersThree )
        {
          
            if (collider3.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                high.PlayDelayed(0.5f);
                smolldoorOpenThree = true;
                delay = Time.time;
                doors.SetBool("door3open", true);
            }
            else if(smolldoorOpenThree = true && Input.GetButtonDown("F"))
            {
                high.Stop();
                smolldoorOpenThree = false;
                delay = Time.time;
                doors.SetBool("door3close", true);
            }
        }

        Collider[] collidersFour = Physics.OverlapSphere(smollDoorFour.transform.position, 1f);
        foreach (Collider collider4 in collidersFour)
        {
            
            if (collider4.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                higher.PlayDelayed(0.5f);
                smolldoorOpenFour = true;
                delay = Time.time;
                doors.SetBool("door4open", true);
            }
            else if(smolldoorOpenFour = true && Input.GetButtonDown("F"))
            {
                higher.Stop();
                smolldoorOpenFour = false;
                delay = Time.time;
                doors.SetBool("door4close", true);
            }
        }

   
    }

  
  


}
