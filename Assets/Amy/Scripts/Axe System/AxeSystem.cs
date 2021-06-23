using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AxeSystem : MonoBehaviour
{
    public static int count = 0;
    public GameObject axeHead1, axeHead2, axeHandle;
    public Transform axeHeadPositionOne, axeHeadPositionTwo, axeHandlePosition;
    public bool axeHead1Added = false, axeHead2Added = false, axeHandleAdded = false;

    public GameObject particle;

    public GameObject fullAxe;
    public AudioSource axeFixy;
    public GameObject mt;
    bool playSound = true;

    private void Start()
    {
        particle.SetActive(false);
        fullAxe.SetActive(false);
        axeFixy.Stop();
    }

    private void Update()
    {
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y + 1f, gameObject.transform.position.z), 2f);
        foreach (Collider collider in colliders)
        {        
                if (collider.transform.name.ToString() == "AxeHeadOne" || axeHead1Added)
                {
                    Debug.Log("axe head one on position");
                    if (axeHead1 != PickUp.heldItem)
                    {
                        axeHead1.tag = mt.tag;
                        axeHead1Added = true;
                    }
                }
            
                if (collider.transform.name.ToString() == "AxeHeadTwo" || axeHead2Added)
                {
                    Debug.Log("axe head two on position");
                    if (axeHead2 != PickUp.heldItem)
                    {
                        axeHead2.tag = mt.tag;
                        axeHead2Added = true;
                    }
                }
            
                if (collider.transform.name.ToString() == "AxeHandle" || axeHandleAdded)
                {
                    Debug.Log("axe handle on position");
                    if (axeHandle != PickUp.heldItem)
                    {
                        axeHandle.tag = mt.tag;
                        axeHandleAdded = true;
                    }
                }           
        }

        if (axeHead1Added && axeHead2Added && axeHandleAdded && playSound)
        {
            StartCoroutine(particleDestroy());
            
            axeFixy.Play();
            fullAxe.SetActive(true);
            axeHandle.SetActive(false);
            axeHead1.SetActive(false);
            axeHead2.SetActive(false);
            playSound = false;
            
            
        }else if((!axeHandleAdded || !axeHead2Added || !axeHead1Added) && !playSound)
        {
            playSound = true;
        }
        if (axeHead1Added)
        {
            axeHead1.transform.position = axeHeadPositionOne.position;
            axeHead1.transform.rotation = axeHeadPositionOne.rotation;
        }
        if (axeHead2Added)
        {
            axeHead2.transform.position = axeHeadPositionTwo.position;
            axeHead2.transform.rotation = axeHeadPositionTwo.rotation;
        }
        if (axeHandleAdded)
        {
            axeHandle.transform.position = axeHandlePosition.position;
            axeHandle.transform.rotation = axeHeadPositionOne.rotation;
        }

        IEnumerator particleDestroy()
        {
            particle.SetActive(true);
            yield return new WaitForSeconds(2f);
            Destroy(particle);
        }
    }
}
