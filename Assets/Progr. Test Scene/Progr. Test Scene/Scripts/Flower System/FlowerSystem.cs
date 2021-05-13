using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlowerSystem : MonoBehaviour
{

    public static int count = 0;
    bool added = false;

  
    public GameObject tabletRuinOne;

    private void Start()
    {
        tabletRuinOne.SetActive(false);
    }



    private void Update()
    {
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y+1f, gameObject.transform.position.z), gameObject.transform.localScale.x/2f);
        bool inThis = false;
        foreach (Collider collider in colliders)
        {
            if (gameObject.transform.name == "collision1")
            {
                if (collider.name.ToString() == "Flower1")
                {
                    inThis = true;
                }  
            }
            else if (gameObject.transform.name == "collision2")
            {
                if (collider.name.ToString() == "Flower2")
                {
                    inThis = true;
                }
            }
            else if (gameObject.transform.name == "collision3")
            {
                if (collider.name.ToString() == "Flower3")
                {
                    inThis = true;
                }
            }
            else if (gameObject.transform.name == "collision4")
            {
                if (collider.name.ToString() == "Flower4")
                {
                    inThis = true;
                }
            }
            else if (gameObject.transform.name == "collision5")
            {
                if (collider.name.ToString() == "Flower5")
                {
                    inThis = true;
                }
            }
        }


        if (added && !inThis)
        {
            count--;
            added = false;
        }
        else if (!added && inThis)
        {
            count++;
            added = true;
        }


        Debug.Log(count);
    }
}


// 5 colliders, 5 flowers, light bij light, zorgen ervoor dat het mogelijk is! hopelijk. 


