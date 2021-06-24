using System.Collections;
using UnityEngine;

public class MainAltaar : MonoBehaviour
{
    public GameObject altaar1, altaar2, altaar3;
    public Transform altaar1pos, altaar2pos, altaar3pos;
    public bool axeAdd = false, bookAdd = false, skullAdd = false;
    public bool oneInPos = false, twoInPos = false, threeInPos = false;
    public GameObject biem;
    public AudioSource biemzoom;
    public GameObject mt;
    bool playSound = true;
 
    private void Start()
    {
        biem.SetActive(false);
        biemzoom.Stop();
    }

    void Update()
    {
        // same sysyem as altaar1 
        Collider[] colliders = Physics.OverlapSphere(new Vector3(gameObject.transform.position.x, gameObject.transform.position.y + 1f, gameObject.transform.position.z), 3f);
        foreach (Collider collider in colliders)
        {
            if (collider.transform.name.ToString() == "FullAxe" || axeAdd)
            {
                altaar1.tag = mt.tag;
                altaar1.transform.position = altaar1pos.position;
                altaar1.transform.rotation = altaar1pos.rotation;
                oneInPos = true;
            }

            if (collider.transform.name.ToString() == "Book" || bookAdd)
            {
                altaar2.tag = mt.tag;
                altaar2.transform.position = altaar2pos.position;
                altaar2.transform.rotation = altaar2pos.rotation;
                twoInPos = true;
            }

            if (collider.transform.name.ToString() == "Skull" || skullAdd)
            {
                altaar3.tag = mt.tag;
                altaar3.transform.position = altaar3pos.position;
                altaar3.transform.rotation = altaar3pos.rotation;
                threeInPos = true;
            }
        }

        bool axeAdded = altaar1.transform.position.Equals(altaar1pos.position);
        bool bookAdded = altaar2.transform.position.Equals(altaar2pos.position);
        bool skullAdded = altaar3.transform.position.Equals(altaar3pos.position);
        bool everythingAdded = axeAdded && bookAdded && skullAdded;

        if (axeAdded)
        {
            Debug.Log("AXE ADDED IN ");
        }
        if(oneInPos && twoInPos && threeInPos && playSound  /*everythingAdded*/)
        {
            playSound = false;
            Debug.Log("Main Altaar Finished");
            StartCoroutine(BiemActive());
            biemzoom.PlayDelayed(2);
        }
        else if((!oneInPos || !twoInPos || !threeInPos) && !playSound)
        {
            playSound = true;
        }
    }
    
    IEnumerator BiemActive()
    {
        yield return new WaitForSeconds(2f);
        biem.SetActive(true);
      
    }
}
