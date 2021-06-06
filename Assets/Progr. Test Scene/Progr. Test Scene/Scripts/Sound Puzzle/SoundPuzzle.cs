using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lower, low, high, higher;
    public Animator doors;
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

            if (collider1.transform.name == player.transform.name && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                lower.PlayDelayed(0.5f);
                smolldoorOpenOne = true;
                delay = Time.time;
            }
            else if(smolldoorOpenOne = true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {
                lower.Stop();
                smolldoorOpenOne = false;
                delay = Time.time;
            }
        }

        Collider[] collidersTwo = Physics.OverlapSphere(smollDoorTwo.transform.position, 1f);
        foreach (Collider collider2 in collidersTwo)
        {
           
            if (collider2.transform.name == player.transform.name && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                low.PlayDelayed(0.5f);
                smolldoorOpenTwo = true;
                delay = Time.time;
            }
            else if(smolldoorOpenTwo = true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {
                low.Stop();
                smolldoorOpenTwo = false;
                delay = Time.time;
            }
        }

        Collider[] collidersThree = Physics.OverlapSphere(smollDoorThree.transform.position, 1f);
        foreach (Collider collider3 in collidersThree )
        {
          
            if (collider3.transform.name == player.transform.name && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                high.PlayDelayed(0.5f);
                smolldoorOpenThree = true;
                delay = Time.time;
            }
            else if(smolldoorOpenThree = true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {
                high.Stop();
                smolldoorOpenThree = false;
                delay = Time.time;
            }
        }

        Collider[] collidersFour = Physics.OverlapSphere(smollDoorFour.transform.position, 1f);
        foreach (Collider collider4 in collidersFour)
        {
            
            if (collider4.transform.name == player.transform.name && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                higher.PlayDelayed(0.5f);
                smolldoorOpenFour = true;
                delay = Time.time;
            }
            else if(smolldoorOpenFour = true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {
                higher.Stop();
                smolldoorOpenFour = false;
                delay = Time.time;
            }
        }

   
    }

  
  


}
