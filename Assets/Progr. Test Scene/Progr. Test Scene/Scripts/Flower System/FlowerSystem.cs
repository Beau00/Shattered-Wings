using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlowerSystem : MonoBehaviour
{
   // public Animator animations;
    public GameObject flowerOne;
   // public GameObject flowerTwo;
   // public GameObject flowerThree;
    //public GameObject flowerFour;
    //public GameObject flowerFive;
    // public GameObject bunca;
    public GameObject tabletRuinOne;

    private void Start()
    {
        tabletRuinOne.SetActive(false);
    }
    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.name == flowerOne.transform.name)
        {
            Debug.Log("FlowerOne is Placed on Final destination");
            tabletRuinOne.SetActive(true);
        }
        if(collision.gameObject.name != flowerOne.transform.name)
        {
            tabletRuinOne.SetActive(false);
        }



    }
}


// 5 colliders, 5 flowers, light bij light, zorgen ervoor dat het mogelijk is! hopelijk. 


