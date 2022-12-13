Shader "Custom/Billboard3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
          { 
              "Queue"="Transparent"  
              "RenderType"="Transparent" 
          }
        // No culling or depth
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata i)
            {
                v2f o;
                o.uv = i.uv;
                
                //copy them so we can change them (demonstration purpos only)
                float4x4 m = UNITY_MATRIX_M;
                float4x4 v = UNITY_MATRIX_V;
                float4x4 p = UNITY_MATRIX_P;
                
                //break out the axis
                float3 right = normalize(v._m00_m01_m02);
                float3 up = float3(0, 1, 0);
                float3 forward = normalize(v._m20_m21_m22);
                //get the rotation parts of the matrix
                float4x4 rotationMatrix = float4x4(right, 0,
                    up, 0,
                    forward, 0,
                    0, 0, 0, 1);
                
                //the inverse of a rotation matrix happens to always be the transpose
                float4x4 rotationMatrixInverse = transpose(rotationMatrix);
                
                //apply the rotationMatrixInverse, model, view and projection matrix
                float4 pos = i.vertex;
                pos = mul(rotationMatrixInverse, pos);
                pos = mul(m, pos);
                pos = mul(v, pos);
                pos = mul(p, pos);
                o.vertex = pos;
                
                return o;
                /*v2f o;
                float4x4 vmat = UNITY_MATRIX_V;
                vmat._m00_m01_m02 = float3(1, 0, 0);
                vmat._m10_m11_m12 = float3(0, 1, 0);
                vmat._m20_m21_m22 = float3(0, 0, 1);
                float3 vpos = mul((float3x3)unity_ObjectToWorld, v.vertex.xyz);
				float4 worldCoord = float4(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23, 1);
				float4 viewPos = mul(vmat, worldCoord) + float4(vpos, 0);
				float4 outPos = mul(UNITY_MATRIX_P, viewPos);
                o.vertex = outPos;
                o.uv = v.uv;
                return o; */
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                col.rgb *= col.a;
                return col;
            }
            ENDCG
        }
    }
}
