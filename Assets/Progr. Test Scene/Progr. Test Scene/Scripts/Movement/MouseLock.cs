using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseLock : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {
        //if pause screen is on, then      Cursor.lockState = CursorLockMode.None;    but not locked!
        // if u press ESC it already leaves lock mode to escape the "play" function in unity, so idk
    }
}
