using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeSystem : MonoBehaviour
{
    public Material night, day, sunUp, sunDown;
    public GameObject flowerOne, flowerTwo, flowerThree, flowerFour, flowerFive; // dead ones
    public GameObject flowerOneNight, flowerTwoNight, flowerThreeNight, flowerFourNight, flowerFiveNight; // alive ones
    public GameObject blackOut;
    public Canvas timeScreen;
    public Animator animator;
    public bool forIfstatement;
   
   
    void Start()
    {
        // it only works when you've opened the menu once. Fix!
        RenderSettings.skybox = day;
        blackOut.SetActive(false);
        flowerOneNight.SetActive(false);
        flowerTwoNight.SetActive(false);
        flowerThreeNight.SetActive(false);
        flowerFourNight.SetActive(false);
        flowerFiveNight.SetActive(false);

    }

    void Update()
    {
        
    }

    public void Night()
    {


        //blackOut.SetActive(true);
        RenderSettings.skybox = night;
        //timeScreen.enabled = false;
        //flowerOneNight.SetActive(true);
        //flowerTwoNight.SetActive(true);
        //flowerThreeNight.SetActive(true);
        //flowerFourNight.SetActive(true);
        //flowerFiveNight.SetActive(true);
        //Destroy(flowerOne);
        //Destroy(flowerTwo);
        //Destroy(flowerThree);
        //Destroy(flowerFour);
        //Destroy(flowerFive);
        
        blackOut.SetActive(true);
        float saveTime = 0f;

        if (blackOut.activeSelf == true)
        {
            saveTime += Time.deltaTime;
        }
        if (saveTime >= 2)
        {
            gameObject.SetActive(false);
        }
        // wait for seconds       Invoke("SetActive", 5.0f);  Invoke("SetFalse", 5.0f);     where as 5 is the numbers of seconds for the wait of active and non active.
        //Invoke("SetActive", 2.0f);
        //blackOut.enabled = true;
        //Invoke("SetFalse", 2.0f);
        //StartCoroutine(NightButton());
        //RenderSettings.skybox = night;
        // blackOut.SetActive(false);
        // wait for seconds to delete

        //wake up animation and a new day started!
    }

        IEnumerator NightButton()
        {
        //if(/* button == pressed, remove the timescreen, */ forIfstatement)
        //animator.SetTrigger(sleeping);
        blackOut.SetActive(true);
        
        RenderSettings.skybox = night;
        // put animation on
        //enable black screen
        // change to night 
        // all flower changes etc.
        yield return new WaitForSeconds(3);
        RenderSettings.skybox = night;
        blackOut.SetActive(false);
        //animator.SetTrigger(wakeup);
        // remove the black screen
        // wake up animation
        }


    public void Day()
    {
      
        RenderSettings.skybox = day;
    }
    

    public void SunUp()
    {
        RenderSettings.skybox = sunUp;
        
    }

   
    public void SunDown()
    {
        
        RenderSettings.skybox = sunDown;

    }

 

}
