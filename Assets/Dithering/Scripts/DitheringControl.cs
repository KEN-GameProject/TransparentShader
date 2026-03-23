using UnityEngine;

public class DitheringControl : MonoBehaviour
{
    [SerializeField]
    private MeshRenderer mesh;

    private Transform cameraTransform;

    private void Start()
    {
        cameraTransform = GameObject.FindGameObjectWithTag("MainCamera").transform;
    }

    private void Update()
    {
        // 1.25
        float distance = Vector3.Distance(transform.position, cameraTransform.position);
        mesh.material.SetFloat("_Distance", distance);

        float diff = Mathf.Clamp(distance, 1.25f, 2);
        float value = 1 - (diff - 1.25f) / (2 - 1.25f); // [0 - 1]の範囲へ
        Debug.Log($"distance : {diff} / value : {value} / lerp : {61 * value}");
    }
}
