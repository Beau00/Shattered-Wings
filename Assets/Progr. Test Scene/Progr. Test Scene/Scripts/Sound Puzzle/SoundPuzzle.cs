using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lowest, lower, low, middle, high, higher, highest;

    public GameObject smollDoorOne, smollDoorTwo, smollDoorThree, smollDoorFour;
    public bool smolldoorOpenOne, smolldoorOpenTwo, smolldoorOpenThree, smolldoorOpenFour;
    public float doorRotation;
    public GameObject trofeeSoundPuzzle;
    LinkedList<AudioSource> input = new LinkedList<AudioSource>(); 
    LinkedList<AudioSource> solution = new LinkedList<AudioSource>();

    // Start is called before the first frame update
    void Start()
    {
        solution.AddLast(lower); // volgorde van bepaalde sounds
        solution.AddLast(middle);
        solution.AddLast(high);
        solution.AddLast(lowest);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
