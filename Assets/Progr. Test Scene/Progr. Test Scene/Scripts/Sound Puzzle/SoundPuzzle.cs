using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lower, low, high, higher;

    public GameObject smollDoorOne, smollDoorTwo, smollDoorThree, smollDoorFour;
    public bool smolldoorOpenOne, smolldoorOpenTwo, smolldoorOpenThree, smolldoorOpenFour;
    public float doorRotation;
    public GameObject trofeeSoundPuzzle;

    public GameObject player;
    public bool playerCheck1 = false, playerCheck2 = false, playerCheck3 = false, playerCheck4 = false;

    public float xOne = 10, xTwo = 10, xThree = 10, xFour = 10;
    
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
                Debug.Log("you have entered the radius of door 1");
                
                lower.PlayDelayed(1);
                smolldoorOpenOne = true;
            }
        }

        Collider[] collidersTwo = Physics.OverlapSphere(smollDoorTwo.transform.position, 1f);
        foreach (Collider collider2 in collidersTwo)
        {
           
            if (collider2.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("you have entered the radius of door 2");
                
                low.PlayDelayed(1);
                smolldoorOpenTwo = true;
            }
        }

        Collider[] collidersThree = Physics.OverlapSphere(smollDoorThree.transform.position, 1f);
        foreach (Collider collider3 in collidersThree )
        {
          
            if (collider3.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("you have entered the radius of door 3");
                
                high.PlayDelayed(1);
                smolldoorOpenThree = true;
            }
        }

        Collider[] collidersFour = Physics.OverlapSphere(smollDoorFour.transform.position, 1f);
        foreach (Collider collider4 in collidersFour)
        {
            
            if (collider4.transform.name == player.transform.name && Input.GetButtonDown("E"))
            {
                Debug.Log("you have entered the radius of door 4");
                
                higher.PlayDelayed(1);
                smolldoorOpenFour = true;
            }
        }

    

        if (smolldoorOpenOne)
        {
            smollDoorOne.transform.Rotate(new Vector3(xOne, 0, 0));
            
        }
        if (smolldoorOpenTwo)
        {
            smollDoorTwo.transform.Rotate(new Vector3(xTwo, 0, 0));
            
        }
        if (smolldoorOpenThree)
        {
            
            if (smollDoorThree.transform.rotation != new Quaternion(40f,0,0,1.0f))
            {
                smollDoorThree.transform.Rotate(new Vector3(xThree, 0, 0) );
            }
           
        }
        if (smolldoorOpenFour)
        {
            smollDoorFour.transform.Rotate(new Vector3(xThree, 0, 0) );
            
          
        }
        Debug.Log(smollDoorThree.transform.rotation);
    }

  
  


}
