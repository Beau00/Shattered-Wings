using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUp : MonoBehaviour
{
    public List<GameObject> items = new List<GameObject>();
    
    public RaycastHit hit;
    public static GameObject heldItem;
    public bool helditembool;
    public GameObject pickUpPosition;
    public AudioSource pickup, pickdown;
    public float delay;
    private void Start()
    {
        pickup.Stop();
        pickdown.Stop();
    }
    // Update is called once per frame
    void Update()
    {
        Vector3 center1 = gameObject.transform.position;
        float radius1 = 2;
        Pickup(center1, radius1);
        if (heldItem != null) 
        {
            heldItem.transform.position = pickUpPosition.transform.position;
            heldItem.transform.rotation = gameObject.transform.rotation;
        }
        foreach (GameObject obj in items)
        {
            if (!obj.Equals(heldItem))
            {
                obj.GetComponent<Rigidbody>().useGravity = true;
            }
        }
    }

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
                pickup.Play();
                heldItem.transform.position = pickUpPosition.transform.position;
                delay = Time.time;
                
            }
            if (Input.GetButtonDown("E") && helditembool && Time.time - delay > 0.5f)
            {
                helditembool = false;
                heldItem.GetComponent<Rigidbody>().useGravity = true;
                heldItem = null; 
                delay = Time.time;
                pickdown.Play();
            }

        }
    }

}
