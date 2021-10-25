Shader "Unity Shaders Book/Chapter 10/Mirror_"
{

    Properties{

        _MainTex("MainTex",2D)= "white"{}

    }


    SubShader {

        Tags {"RenderType" = "Opaque"   "Queue"="Geometry"}


        Pass { 

            CGPROGRAM
                
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct a2v {
                fixed4 vertex:POSITION;
                fixed4 texcoord:TEXCOORD0; 
            };


            struct v2f{
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;

            }; 


            v2f vert(a2v v){

                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.texcoord;
                o.uv.x = 1 - o.uv.x;

                return o;
            }

            fixed4 frag(v2f i):SV_Target{

                return tex2D(_MainTex,i.uv);

            } 

            ENDCG

        }

    }


        Fallback Off


}
