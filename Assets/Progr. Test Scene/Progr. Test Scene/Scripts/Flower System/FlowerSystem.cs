using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlowerSystem : MonoBehaviour
{
    public GameObject flowerOne;
    public GameObject flowerTwo;
    public GameObject flowerThree;
    public GameObject flowerFour;
    public GameObject flowerFive;
    public GameObject bunca;
   
    void Start()
    {
        
    }

   
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        /* if bunca has collision with one of the flowers
         * play pickup animation, delete flower, instantiate in mouth of bunca
         * 
         * if bunca wants to drop, press a key
         * play drop animation, instantiate from mouth to make it fall out. 
         * delete flower in mouth.
         */
    }
}
