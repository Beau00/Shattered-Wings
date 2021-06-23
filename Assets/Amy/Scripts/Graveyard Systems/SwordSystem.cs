using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordSystem : MonoBehaviour
{
    public static int count = 0;
    public GameObject sword1, sword2, sword3;
    public Transform swordPos1, swordPos2, swordPos3;
    bool swordAdded = false, swordtwoAdded = false, swordthreeadded = false;
    public GameObject animSwordOne, animSwordTwo, animSwordThree;
    bool one = false, two = false, three = false;
    public AudioSource graveOpen, swordIn1, swordIn2, swordIn3;
    public Animator altaarThree, swordOne, swordTwo, swordThree;
    public GameObject skull;
    public GameObject stepCollider;
    public GameObject mt;
    bool playSound = true;

    private void Start()
    {
        graveOpen.Stop();
        skull.SetActive(false);
        animSwordOne.SetActive(false);
        animSwordTwo.SetActive(false);
        animSwordThree.SetActive(false);
        swordIn1.Stop();
        swordIn2.Stop();
        swordIn3.Stop();
        stepCollider.SetActive(false);
    }

    private void Update()
    {
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y, gameObject.transform.position.z), 3f);
        foreach (Collider collider in colliders)
        {
            if (collider.transform.name.ToString() == "Sword1" )
            {
                Debug.Log("sword1");
                if (sword1 != PickUp.heldItem)
                {
                    swordIn1.PlayDelayed(0.8f);
                    sword1.tag = mt.tag;
                    swordAdded = true;
                }
            }
            if (collider.transform.name.ToString() == "Sword2")
            {
                Debug.Log("sword2");
                if (sword2 != PickUp.heldItem)
                {
                    swordIn2.PlayDelayed(0.8f);
                    sword2.tag = mt.tag;
                    swordtwoAdded = true;
                    
                }
            }
            if (collider.transform.name.ToString() == "Sword3" )
            {
                Debug.Log("sword3");
                if (sword3 != PickUp.heldItem)
                {
                    swordIn3.PlayDelayed(0.8f);
                    sword3.tag = mt.tag;
                    swordthreeadded = true;
                }
            }
        }
      
        if (swordAdded)
        {
            sword1.transform.position = swordPos1.position;
            sword1.transform.rotation = swordPos1.rotation;
            sword1.SetActive(false);
            animSwordOne.SetActive(true);
            swordOne.SetBool("SwordOneCheck", true);
           
            one = true;
        }
        if (swordtwoAdded)
        {
            sword2.transform.position = swordPos2.position;
            sword2.transform.rotation = swordPos2.rotation;
            sword2.SetActive(false);
            animSwordTwo.SetActive(true);
            swordTwo.SetBool("SwordTwoCheck", true);
            
            two = true;
        }
        if (swordthreeadded)
        {
            sword3.transform.position = swordPos3.position;
            sword3.transform.rotation = swordPos3.rotation;
            sword3.SetActive(false);
            animSwordThree.SetActive(true);
            swordThree.SetBool("SwordThreeCheck", true);
          
            three = true;
        }
        if (one && two && three && playSound)
        {
            playSound = false;
            
            Debug.Log("bitchezzz");
            skull.SetActive(true);
            StartCoroutine(DelayedAnimation());       
        }
        else if ((!one || !two || !three) && !playSound)
        {
            playSound = true;
        }

       
        IEnumerator DelayedAnimation()
        {
            yield return new WaitForSeconds(5);
            graveOpen.Play();
            stepCollider.SetActive(true);
            altaarThree.SetBool("GraveOpen", true);
            

        }
    }
}

