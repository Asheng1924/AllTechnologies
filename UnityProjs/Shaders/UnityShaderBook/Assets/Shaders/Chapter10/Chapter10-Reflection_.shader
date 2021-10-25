// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 10/Reflection_" {

    Properties{

            _Color("Color",Color)=(1,1,1,1)
            _ReflectColor("ReflectColor",Color)=(1,1,1,1)
            _ReflectAmount("ReflectCount",Range(0,1))=1
            _CubeMap("Reflection CubeMap",Cube)="_Skybox"{} 
    }

    SubShader{

        Tags {"RenderType" = "Opaque"  "Queue" = "Geometry"}


        Pass {

        Tags {"LightMode"="ForwardBase"}
        
            CGPROGRAM


            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"


            struct a2v{

                fixed3 vertex:POSITION;
                fixed3 normal:NORMAL;

                 
            };
 

            struct v2f{

                fixed4 pos:SV_POSITION; 
                fixed3 worldPos:TEXCOORD0;
                fixed3 worldNormal:TEXCOORD1;
                fixed3 worldRefl:TEXCOORD2;
                fixed3 worldViewDir:TEXCOORD3;
                SHADOW_COORDS(4) 

            };

            fixed4 _Color;
            fixed4 _ReflectColor;
            fixed _ReflectAmount;
            samplerCUBE _CubeMap;

            v2f vert(a2v v){

                v2f o;

                 o.pos = UnityObjectToClipPos(v.vertex);

                 o.worldNormal = UnityObjectToWorldNormal(v.normal);

                 o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

                 o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);


                 o.worldRefl = reflect(-o.worldViewDir,o.worldNormal);
    

                TRANSFER_SHADOW(o); 

                return o;

            
            }



            fixed4 frag(v2f i):SV_Target{
                fixed3 worldNormal = normalize(i.worldNormal);

                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));


                fixed3 worldViewDir = normalize(i.worldViewDir);


                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;


                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(worldLightDir,worldNormal));


                fixed3 reflection = texCUBE(_CubeMap,i.worldRefl).rgb * _ReflectColor.rgb;

                UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

                fixed3 color = ambient + lerp(diffuse , reflection,_ReflectAmount);


                return fixed4(color,1.0);

        



            }







            ENDCG





        }

    }




     
}
