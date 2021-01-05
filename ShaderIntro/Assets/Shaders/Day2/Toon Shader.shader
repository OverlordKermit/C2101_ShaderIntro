Shader "Unlit/ToonShaderCode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	_Color ("A Color", Color) = (1,0,0,1)
	_Value ("A Value", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader_
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct VertexData
            {
                float4 vertex : POSITION;
		float3 normal : NORMAL;
                float2 uv     : TEXCOORD0;
            };

            struct VertexToFragment
            {
                float2 uv     : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            VertexToFragment vertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
                output.vertex = UnityObjectToClipPos(vertexData.vertex);
                output.uv = vertexData.uv;
                return output;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
