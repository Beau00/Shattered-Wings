using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainAltaar : MonoBehaviour
{
    public GameObject altaar1, altaar2, altaar3;
    public Transform altaar1pos, altaar2pos, altaar3pos;
    public bool axeAdd = false, bookAdd = false, skullAdd = false;
    public bool oneInPos = false, twoInPos = false, threeInPos = false;
 
    private void Start()
    {

    }

    void Update()
    {
        // same sysyem as altaar1 
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y + 1f, gameObject.transform.position.z), 2f);
        foreach (Collider collider in colliders)
        {
            if (collider.transform.name.ToString() == "FullAxe" || axeAdd)
            {
                altaar1.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                altaar1.transform.position = altaar1pos.position;
                altaar1.transform.rotation = altaar1pos.rotation;
                oneInPos = true;
            }

            if (collider.transform.name.ToString() == "Book" || bookAdd)
            {
                altaar2.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                altaar2.transform.position = altaar2pos.position;
                altaar2.transform.rotation = altaar2pos.rotation;
                twoInPos = true;
            }

            if (collider.transform.name.ToString() == "Skull" || skullAdd)
            {
                altaar3.tag = UnityEditorInternal.InternalEditorUtility.tags[0];
                altaar3.transform.position = altaar3pos.position;
                altaar3.transform.rotation = altaar3pos.rotation;
                threeInPos = true;
            }
        }

        if(oneInPos && twoInPos && threeInPos)
        {
            //play animation, lighting effect and beam.
            Debug.Log("Main Altaar Finished");
            
        }
    }
}
