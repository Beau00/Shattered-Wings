using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUp : MonoBehaviour
{
    public List<GameObject> items = new List<GameObject>();
    
    public RaycastHit hit;
    private GameObject heldItem;
    public bool helditembool;
    public GameObject pickUpPosition;

    public float delay;
    


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 center1 = gameObject.transform.position;
        float radius1 = 2;

        Pickup(center1, radius1);
        heldItem.transform.position = pickUpPosition.transform.position;
        heldItem.transform.rotation = gameObject.transform.rotation;

        foreach (GameObject obj in items)
        {
            if (!obj.Equals(heldItem))
            {
                obj.GetComponent<Rigidbody>().useGravity = true;
            }
        }
    }


  
    // change w tags instead of names.
   
    void Pickup(Vector3 center, float radius)
    {

        Collider[] hitColliders = Physics.OverlapSphere(center, radius);
        foreach (var hitCollider in hitColliders)
        {

            if (hitCollider.transform.tag.Equals("Item") && Input.GetButtonDown("E") && !helditembool && Time.time - delay > 0.5f)
            {
                if (!items.Contains(hitCollider.gameObject))
                {
                    items.Add(hitCollider.gameObject);
                }
                helditembool = true;
                heldItem = hitCollider.gameObject;
                //heldItem.GetComponent<Rigidbody>().useGravity = false;
                heldItem.transform.position = pickUpPosition.transform.position;
                delay = Time.time;

                // flowerOneRB.constraints = RigidbodyConstraints.FreezePosition; // doesnt update. fix
            }
            if (Input.GetButtonDown("E") && helditembool && Time.time - delay > 0.5f)
            {
                helditembool = false;
                heldItem = null;
                
                heldItem.GetComponent<Rigidbody>().useGravity = true;
                delay = Time.time;
            }

        }
    }

}
