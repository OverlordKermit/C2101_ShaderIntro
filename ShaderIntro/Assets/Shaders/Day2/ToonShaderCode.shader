Shader "Unlit/ToonShaderCode"
{
    Properties //UI
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _Color ("A Color", Color) = (1,0,0,1)
	    _Value ("A Value", Float) = 1
	    _SunDirection ("SunDirection", Vector) = (0,1,0,0)
	    _LightThreshold ("LightThreshold", Float) = 0
	    _LightColor ("Light Color", Color) = (1,1,1,1)
	    _DarkColor ("Dark Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader_
            #pragma fragment FragmentShader

            #include "UnityCG.cginc"

            struct VertexData
            {
                float4 vertex : POSITION;
		        float3 normal : NORMAL;
                float2 uv     : TEXCOORD0;
            };

            struct VertexToFragment
            {
                float4 vertex : SV_POSITION;
		        float3 normal : NORMAL;
                float2 uv     : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
	        float3 _SunDirection;
	        float  _LightThreshold;
	        float3 _LightColor;
	        float3 _DarkColor;

            VertexToFragment vertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
                output.vertex = UnityObjectToClipPos(vertexData.vertex);
		        output.normal = vertexData.normal;
                output.uv = vertexData.uv;
                return output;
            }

            // GPU IS DOING THINGS WITH THE DATA
            
            float4 FragmentShader (VertexToFragment vertexToFragment) : SV_Target
            {
		        float3 normal = normalize(vertexToFragment.normal);
		        _SunDirection = normalize(_SunDirection);
		        float dotProduct = dot(normal, _SunDirection);
		
		        float3 lightColor;
		        if(dotProduct > _LightThreshold){
		            lightColor = _LightColor;
		        }
		        else {
		            lightColor = _DarkColor;
		        }
                float4 texCol = tex2D(_MainTex, vertexToFragment.uv);
                float3 col = texCol * lightColor;
                return float4(col, 1);
            }
            ENDCG
        }
    }
}
