using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
  public GameObject someGameObject;
  public ARDraw arDraw;

  // Start is called before the first frame update
  // Start is called before the first frame update
  void Start()
  {
    gameObject.AddComponent<UnityMessageManager>();
  }

  // Update is called once per frame
  void Update()
  {

  }


  void Something()
  {
    UnityMessageManager.Instance.SendMessageToFlutter("party");
    Debug.Log("something....");
  }

  public void ClearScreen()
  {
    arDraw.ClearScreen();
  }


}