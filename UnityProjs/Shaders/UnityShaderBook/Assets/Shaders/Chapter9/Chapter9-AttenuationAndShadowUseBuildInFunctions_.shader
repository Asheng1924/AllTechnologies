Shader "Unity Shaders Book/Chapter 9/Attenuation And Shadow Use Build-in Functions_"
{
    
    Properties{

        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20


    }



    SubShader{


        Pass
        {

        Tags{ "LightMode"="ForwardBase"}


            CGPROGRAM

            #pragma multi_compile_fwdbase


            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2f{
                float4 vertex:POSITION;
                float3 normal:NORMAL;

            };


            struct v2f{

                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                //声明一个用于对阴影纹理采样的坐标
                SHADOW_COORDS(2)
        
            };


            v2f vert(a2f v){

                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);


                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

                //用于计算上一步中声明的阴影纹理坐标
                TRANSFER_SHADOW(o);

                return o; 
             

            }

            fixed4 frag(v2f i):SV_Target{



                fixed3 worldNormal = normalize(i.worldNormal);

                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);


                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0,dot(worldNormal,worldLightDir));



                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz -  i.worldPos.xyz);


                fixed3 halfDir = normalize(worldLightDir+viewDir);


                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal,halfDir)),_Gloss);


                //fixed atten = 1.0;

                //使用shadow coordinate to sample shadow map 
                //fixed shadow = SHADOW_ATTENUATION(i);

                 UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

               return fixed4(ambient + (diffuse + specular) * atten ,1.0); 

            }   

            ENDCG 
        }


        Pass
        {
            Tags { "LightMode" = "ForwardAdd"}

            Blend One One

            CGPROGRAM
            #pragma multi_compile_fwdadd_fullshadows


            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"



            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;

            };


            struct v2f{
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                //声明一个用于对阴影纹理采样的坐标
                SHADOW_COORDS(2)

            };


            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);


                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                TRANSFER_SHADOW(o);

                return o; 

            }

            fixed4 frag(v2f i):SV_Target{

                fixed3 worldNormal = normalize(i.worldNormal);

                #ifdef USING_DIRECTIONAL_LIGHT
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
                #endif


                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0,dot(worldNormal,worldLightDir));


                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir + viewDir);


                fixed3 specular = _LightColor0.rgb *  _Specular.rgb * pow(max(0,dot(halfDir,worldNormal)),_Gloss);

                //统一计算shadow 和衰减

                UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

                return fixed4((diffuse + specular) * atten, 1.0); 

            }
 

            ENDCG  
        }  

    }  

    FallBack "Specular"  
}

