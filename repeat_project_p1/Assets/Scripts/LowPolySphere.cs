using UnityEngine;

public class LowPolySphere : MonoBehaviour
{
    public int resolution = 10;

    void Start()
    {
        MeshFilter meshFilter = gameObject.AddComponent<MeshFilter>();
        MeshRenderer renderer = gameObject.AddComponent<MeshRenderer>();
        renderer.material = new Material(Shader.Find("Standard"));

        meshFilter.mesh = CreateLowPolySphere(resolution);
    }

    Mesh CreateLowPolySphere(int resolution)
    {
        Mesh mesh = new Mesh();
        Vector3[] vertices = new Vector3[(resolution + 1) * (resolution + 1)];
        int[] triangles = new int[resolution * resolution * 6];
        Vector2[] uv = new Vector2[vertices.Length];

        float step = 2f / resolution;
        for (int y = 0, i = 0; y <= resolution; y++)
        {
            for (int x = 0; x <= resolution; x++, i++)
            {
                float u = x * step - 1;
                float v = y * step - 1;

                Vector3 point = new Vector3(u, v, 1).normalized;
                vertices[i] = point;
                uv[i] = new Vector2((float)x / resolution, (float)y / resolution);

                if (x < resolution && y < resolution)
                {
                    int index = i * 6;
                    triangles[index] = i;
                    triangles[index + 1] = i + resolution + 1;
                    triangles[index + 2] = i + resolution + 2;
                    triangles[index + 3] = i;
                    triangles[index + 4] = i + resolution + 2;
                    triangles[index + 5] = i + 1;
                }
            }
        }

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.uv = uv;
        mesh.RecalculateNormals();
        return mesh;
    }
}
