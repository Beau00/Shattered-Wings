using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordSystem : MonoBehaviour
{
    public static int count = 0;
    public GameObject sword1, sword2;
    public Transform swordPos1, swordPos2;
    public bool swordAdded = false, swordtwoAdded = false;
    public GameObject graveRoof;
    public ParticleSystem test;

    public GameObject skull;

    private void Start()
    {
        skull.SetActive(false);
    }



    private void Update()
    {
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y, gameObject.transform.position.z), 1f);
        foreach (Collider collider in colliders)
        {

            if (collider.transform.name.ToString() == "sword1" || swordAdded)
            {
                Debug.Log("sword1");
                if (sword1 != PickUp.heldItem)
                {
                    sword1.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                    swordAdded = true;
                }
            }


            if (collider.transform.name.ToString() == "sword2" || swordtwoAdded)
            {
                Debug.Log("sword2");
                if (sword2 != PickUp.heldItem)
                {
                    sword2.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                    swordtwoAdded = true;
                }
            }

          


        }

        if (swordAdded && swordtwoAdded )
        {
            skull.SetActive(true);
            graveRoof.transform.rotation = Quaternion.Euler(0, 45, 0) ;
           
        }

        if (swordAdded)
        {
            sword1.transform.position = swordPos1.position;
            sword1.transform.rotation = swordPos1.rotation;
        }


        if (swordtwoAdded)
        {
            sword2.transform.position = swordPos2.position;
            sword2.transform.rotation = swordPos2.rotation;
        }

        



    }
}

