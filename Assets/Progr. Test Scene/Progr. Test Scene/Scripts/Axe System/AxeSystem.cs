using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AxeSystem : MonoBehaviour
{
    public static int count = 0;
    public GameObject axeHead1, axeHead2, axeHandle;
    public Transform axeHeadPositionOne, axeHeadPositionTwo, axeHandlePosition;
    public bool axeHead1Added = false, axeHead2Added = false, axeHandleAdded = false;
    public ParticleSystem test;
    public GameObject fullAxe;

    private void Start()
    {
        fullAxe.SetActive(false);
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
                        axeHead1.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                        axeHead1Added = true;
                    }
                }
            
                if (collider.transform.name.ToString() == "AxeHeadTwo" || axeHead2Added)
                {
                    Debug.Log("axe head two on position");
                    if (axeHead2 != PickUp.heldItem)
                    {
                        axeHead2.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                        axeHead2Added = true;
                    }
                }
            
                if (collider.transform.name.ToString() == "AxeHandle" || axeHandleAdded)
                {
                    Debug.Log("axe handle on position");
                    if (axeHandle != PickUp.heldItem)
                    {
                        axeHandle.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                        axeHandleAdded = true;
                    }
                }           
        }

        if (axeHead1Added && axeHead2Added && axeHandleAdded)
        { 
            fullAxe.SetActive(true);
            axeHandle.SetActive(false);
            axeHead1.SetActive(false);
            axeHead2.SetActive(false);
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
    }
}
