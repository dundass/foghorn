﻿using UnityEngine;
using System.Collections;

public class Animal : MonoBehaviour, IAgent {

    public enum reactions { fight, flight }

    public bool hostile { get; set; }
    // var idlebehaviour    // maybe put these in IAgent ?
    // var attackbehaviour
    // var reaction (= reactions.fight/reactions.flight)
    // var drops[] // how to implement chances ?

    // Use this for initialization
    void Start() {

    }

    // Update is called once per frame
    void Update() {

    }
}
