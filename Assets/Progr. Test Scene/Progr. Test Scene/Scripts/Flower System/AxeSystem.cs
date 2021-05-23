using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AxeSystem : MonoBehaviour
{
    public static int count = 0;
    bool added = false;
    public GameObject axeHead1, axeHead2, axeHandle;
    public Transform axeHeadPositionOne, axeHeadPositionTwo, axeHandlePosition;


    public GameObject fullAxe;

    private void Start()
    {
        fullAxe.SetActive(false);
    }



    private void Update()
    {
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y + 1f, gameObject.transform.position.z), gameObject.transform.localScale.x / 2f);
        bool inThis = false;
        foreach (Collider collider in colliders)
        {
            if (gameObject.transform.name == "collision1")
            {
                Debug.Log("collsion one works.");
                if (collider.transform.name.ToString() == "AxeHeadOne")
                {
                    Debug.Log("axe head one on position");
                    inThis = true;
                    axeHead1.transform.position = axeHeadPositionOne.position;
                }
            }
            else if (gameObject.transform.name == "collision2")
            {
                Debug.Log("collsion two works.");
                if (collider.transform.name.ToString() == "AxeHeadTwo")
                {
                    Debug.Log("axe head two on position");
                    inThis = true;
                    axeHead2.transform.position = axeHeadPositionTwo.position;
                }
            }
            else if (gameObject.transform.name == "collision3")
            {
                Debug.Log("collsion three works.");
                if (collider.transform.name.ToString() == "AxeHandle")
                {
                    Debug.Log("axe handle on position");
                    inThis = true;
                    axeHandle.transform.position = axeHandlePosition.position;
                }
            }

        }

        if (axeHead1.transform.position == axeHeadPositionOne.position && axeHead2.transform.position == axeHeadPositionTwo.position && axeHandle.transform.position == axeHandlePosition.position)
        {

            axeHead1.SetActive(false);
            axeHead2.SetActive(false);
            axeHandle.SetActive(false);
            // effect explosion ofzo zodat het smoother eruit ziet en dat niemand het door heeft dat het gedelete word en instantiate hehe 
            fullAxe.SetActive(true);
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
