using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using Firebase.Firestore;
using Newtonsoft.Json;
//using Firebase.Extensions;
using System.Text;
using System.IO;
using System;




[Serializable]
public class DoodleInfo
{
  // public Dictionary<string, List<float[]>> vectors = new Dictionary<string, List<float[]>>();

  public List<Dictionary<string, object>> lines = new List<Dictionary<string, object>>();

}





public class ARDraw : MonoBehaviour
{


  Camera arCamera;


  Vector3 anchor = new Vector3(0, 0, 0.3f);



  bool anchorUpdate = false;
  //should anchor update or not
  //
  public GameObject linePrefab;
  //prefab which genrate the line for user

  LineRenderer lineRenderer;
  //LineRenderer which connects and generate

  public List<LineRenderer> lineList = new List<LineRenderer>();

  public string uniqueName = "newname";

  public DoodleInfo doodleinfo = new DoodleInfo();
  

  //List of lines drawn

  List<float[]> tem = new List<float[]>();
  public Transform linePool;

  int counter = 0;

  public bool use;
  //code is in use or not

  public bool isRedrawing = false;

  public bool startLine;
  private Touch touch;

  //already started line or not

  private Color startColor = Color.white;
  private Color endColor = Color.white;

  private float lineSize = 0.01f;


  public GameObject doodleTransform;

  void Start()
  {
    arCamera = GameObject.Find("AR Camera").GetComponent<Camera>();
  }

  void Update()
  {
    if(!isRedrawing) {
      if (use)
      {
        if (startLine)
        {
          Debug.Log("Update");
          UpdateAnchor();
          DrawLinewContinue();
        }
      }
    }
  }



  void UpdateAnchor()
  {
    if (anchorUpdate)
    {
      Vector3 temp = Input.mousePosition;
      Debug.Log("UpdateAnchor");
      temp.z = 0.3f;
      anchor = arCamera.ScreenToWorldPoint(temp);

      float[] tmp = { anchor.x, anchor.y, anchor.z };
      tem.Add(tmp);

      //tem.Clear();

    }


  }

  public void setAnchor(String anchorString) {
    String[] points = anchorString.Split(',');
    Vector3 newAnchor = Vector3.one;
    
    newAnchor.x = float.Parse(points[0].ToString());
    newAnchor.y = float.Parse(points[1].ToString());
    newAnchor.z = float.Parse(points[2].ToString());    

    anchor = newAnchor;
  }

  public void MakeLineRenderer()
  {
    if(isRedrawing) return;

    GameObject tempLine = Instantiate(linePrefab);
    
    tempLine.transform.SetParent(linePool);
    tempLine.transform.position = Vector3.zero;
    tempLine.transform.localScale = new Vector3(1, 1, 1);

    anchorUpdate = true;
    UpdateAnchor();

    lineRenderer = tempLine.GetComponent<LineRenderer>();
    lineRenderer.positionCount = 1;
    lineRenderer.SetPosition(0, anchor);

    lineRenderer.startColor = startColor;
    lineRenderer.endColor = endColor;

    lineRenderer.endWidth = lineSize;
    lineRenderer.startWidth = lineSize * 0.6f;


    startLine = true;
    lineList.Add(lineRenderer);
  }

  public void setDoodleTransform(String anchStr) {
    
    String[] points = anchStr.Split(',');
    Vector3 anch = Vector3.zero;

    anch.x = float.Parse(points[0].ToString());
    anch.y = float.Parse(points[1].ToString());
    anch.z = float.Parse(points[2].ToString());    

    Vector3 worldPoint = arCamera.ScreenToWorldPoint(anch);
    doodleTransform.transform.position = worldPoint;

    UnityMessageManager.Instance.SendMessageToFlutter(worldPoint.ToString());
  }

  public void setTransform(String anchStr) {
    
    String[] points = anchStr.Split(',');
    Vector3 anch = Vector3.zero;

    anch.x = float.Parse(points[0].ToString());
    anch.y = float.Parse(points[1].ToString());
    anch.z = float.Parse(points[2].ToString());    

    Vector3 worldPoint = arCamera.ScreenToWorldPoint(anch);
    linePool.position = worldPoint;
    // doodleTransform.transform.position = worldPoint;

    UnityMessageManager.Instance.SendMessageToFlutter(worldPoint.ToString());
  }
  

  public void ReMakeLineRenderer()
  {
    isRedrawing = true;
    
    GameObject tempLine = Instantiate(linePrefab);


    // GameObject transObj = Instantiate(doodleTransform);
    // Transform trans = transObj.transform;


    tempLine.transform.SetParent(linePool, false);
    tempLine.transform.position = Vector3.zero;
    tempLine.transform.localScale = new Vector3(1, 1, 1);

    
    // doodleTransform = worldPoint;




    lineRenderer = tempLine.GetComponent<LineRenderer>();

    lineRenderer.startColor = startColor;
    lineRenderer.endColor = endColor;

    lineRenderer.endWidth = lineSize;
    lineRenderer.startWidth = lineSize * 0.6f;


    startLine = true;
    lineList.Add(lineRenderer);
  }

  public void setStartColor(String color)
  {
    ColorUtility.TryParseHtmlString(color, out startColor);
  }
  public void setEndColor(String color)
  {
    ColorUtility.TryParseHtmlString(color, out endColor);
  }
  public void setLineSize(String size) 
  {
    float newSize = float.Parse(size);
    lineSize = newSize;
  }

  public void DrawLinewContinue()
  {
    lineRenderer.positionCount = lineRenderer.positionCount + 1;
    //Debug.Log("DrawLine");
    lineRenderer.SetPosition(lineRenderer.positionCount - 1, anchor);
  }

  public void StartDrawLine()
  {
    use = true;
    Debug.Log("StartDrawLine");

    if (!startLine)
    {
      MakeLineRenderer();
    }
  }

  public void StopDrawLine()
  {


    use = false;
    startLine = false;
    lineRenderer = null;
    anchorUpdate = false;

    
    // doodleinfo.vectors.Add(counter.ToString(), new List<float[]>(tem));
    // counter++;

    tem.Clear();
    Debug.Log("Counter " + counter.ToString());
    Debug.Log("List " + tem.Count);

  }

  public void reStop() {
    isRedrawing = false;
  }

  public void Undo()
  {
    if(isRedrawing) return;
    
    LineRenderer undo = lineList[lineList.Count - 1];
    Destroy(undo.gameObject);
    lineList.RemoveAt(lineList.Count - 1);
  }

  public void ClearScreen()
  {
    if(isRedrawing) return;

    foreach (LineRenderer item in lineList)
    {
      Destroy(item.gameObject);
    }
    lineList.Clear();
  }


  public void GetDoodleData() {
    DoodleInfo doodleData = new DoodleInfo();
    
    foreach (LineRenderer line in lineList)
    {
      Dictionary<string, object> lineData = new Dictionary<string, object>();

      Vector3[] linePoints = new Vector3[line.positionCount];
      line.GetPositions(linePoints);

      
      List<float[]> floatPoints = new List<float[]>();
      
      foreach(Vector3 point in linePoints) {
        float[] floatPoint = { point.x, point.y, point.z };
        floatPoints.Add(floatPoint);
      }

      
      lineData.Add("vectors", floatPoints);
      lineData.Add("startColor", ColorUtility.ToHtmlStringRGBA(line.startColor));
      lineData.Add("endColor", ColorUtility.ToHtmlStringRGBA(line.endColor));
      lineData.Add("width", line.endWidth);

      doodleData.lines.Add(lineData);
    }


    StringBuilder sb = new StringBuilder();
    StringWriter sw = new StringWriter(sb);
    using (JsonWriter writer = new JsonTextWriter(sw))
    {
      var serializer = new JsonSerializer();
      serializer.Serialize(writer, doodleData);
    }
    

    Debug.Log(sb.ToString());
    UnityMessageManager.Instance.SendMessageToFlutter(sb.ToString());
  }





  public void displayVal(String message)
  {
    Debug.Log("Message from flutter" + message);

  }

  public void sendVectorPoints()
  {

    StringBuilder sb = new StringBuilder();
    StringWriter sw = new StringWriter(sb);
    counter = 0;

    using (JsonWriter writer = new JsonTextWriter(sw))
    {
      var serializer = new JsonSerializer();
      serializer.Serialize(writer, doodleinfo);
    }


    UnityMessageManager.Instance.SendMessageToFlutter(sb.ToString());
  }



}

