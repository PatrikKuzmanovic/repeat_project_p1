Shader "Custom/SimplePhong"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Specular("Specular Power", Range(1, 100)) = 50
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Specular;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float4 pos : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : TEXCOORD1;
                    float3 worldPos : TEXCOORD2;
                };

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.normal = UnityObjectToWorldNormal(v.normal);
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                    return o;
                }

                half4 frag(v2f i) : SV_Target
                {
                    // Normalize vectors
                    float3 normal = normalize(i.normal);
                    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                    float3 viewDir = normalize(-i.worldPos);

                    // Diffuse lighting
                    float diff = max(0.0, dot(normal, lightDir));

                    // Specular lighting using the Phong model
                    float3 reflectDir = reflect(-lightDir, normal);
                    float spec = pow(max(0.0, dot(viewDir, reflectDir)), _Specular);

                    // Fetch the main directional light color
                    float3 lightColor = _LightColor0.rgb;

                    // Combining the results
                    float4 texColor = tex2D(_MainTex, i.uv);
                    float3 finalColor = diff * lightColor * texColor.rgb + spec * lightColor;

                    return float4(finalColor, 1.0);
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}
