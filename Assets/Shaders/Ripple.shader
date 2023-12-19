Shader "Custom/Ripple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RippleSource ("Ripple Source UV", Vector) = (1.0,1.0,0,0) 
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

            float4 _RippleSource;

            v2f vert (appdata v)
            {
                v2f o;
                float2 uvsCent = v.uv - _RippleSource.xy;
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
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= col.a;
                return col;
            }
            ENDCG
        }
    }
}
