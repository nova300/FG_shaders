Shader "Custom/Ripple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        

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

            v2f vert (appdata v)
            {
                v2f o;
                float2 uvsCent = v.uv * 2 - 1;
                float radDist = length( uvsCent );
                v.vertex.y += cos ((radDist - _Time.y * 0.5) * 3.14 * 3) * 0.5;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                
                //o.vertex.x += sin(worldPos.x / 2+ _Time.w);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvsCent = i.uv * 2 - 1;
                float radDist = length( uvsCent );
                //return cos ((radDist - _Time.y * 1.0) * 3.14 * 5) * 0.5;
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= col.a;
                return col;
            }
            ENDCG
        }
    }
}
