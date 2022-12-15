Shader "Unlit/BasicLighting"
{
    Properties
    {
        _Color ("Base_Color", Color) = (1.000000,1.000000,1.000000,1.000000)
        _A_Color ("Albedo_Color", Color) = (0.000000,0.000000,0.000000,0.000000)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            uniform float4 _Color;
            uniform float4 _A_Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float light : TEXCOORD1;
                float4 colour : TEXCOORD2;
                UNITY_FOG_COORDS(3)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                float3 N = normalize(UnityObjectToWorldNormal(v.normal));
                float3 V = normalize(_WorldSpaceCameraPos - mul( unity_ObjectToWorld, v.vertex));
                o.light = dot(V, N) / 1 * (1 - 0.4) + 0.4;
                o.colour = _Color + _A_Color + UNITY_LIGHTMODEL_AMBIENT;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * i.colour;
                //col += _A_Color * _A_Color.a;
                //col += UNITY_LIGHTMODEL_AMBIENT * UNITY_LIGHTMODEL_AMBIENT.a;
                col *= i.light;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                
                return col;
            }
            ENDCG
        }
    }
}
