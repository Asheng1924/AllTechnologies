// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/SpecularVertextLevel_"
{

    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Glosss",Range(8.0,255))=20 
    }


    SubShader
    {
        Pass
        {

            Tags { "LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"


            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertext:POSITION;
                float3 normal:NORMAL;

            };



            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
    
        
            };



            v2f vert(a2v v)
            {

                v2f o;

                /*transform the vertext form object space to projection space*/ 
                o.pos = UnityObjectToClipPos(v.vertext);
                /*get ambient term*/ 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                /*transfom the normal from object space to world space*/
                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                //get the light direction in the world space
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                //Computer Diffuse
                fixed3 diffuse=_LightColor0.rgb*_Diffuse*max(0,dot(worldNormal,worldLightDir));

                //get Reflection direction in the worldSpace
                fixed3 reflectionDir =normalize(reflect(-worldLightDir,worldNormal));

                /*get the view direction in world space*/

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertext).xyz);

                /*Computer specular term*/
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(reflectionDir,viewDir)),_Gloss);

                o.color = diffuse+specular+ambient;
                return o;
            }



            fixed4 frag(v2f i):SV_TARGET{
                return fixed4(i.color,1.0);
            } 


            ENDCG 


        }


    }
        Fallback "Specular"


}
