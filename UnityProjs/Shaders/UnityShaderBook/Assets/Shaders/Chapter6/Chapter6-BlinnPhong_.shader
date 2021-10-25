// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/BlinnPhong_"
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
              float3 worldNormal:TEXCOORD0;
              float3 worldPos:TEXCOORD1;
    
        
            };



            v2f vert(a2v v)
            {

                v2f o;

                /**Transform the vertex from modle space to  projection space*/
                o.pos =UnityObjectToClipPos(v.vertext);

                /*Transform the normal from object space to world space**/
                //o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);

                /**use the build-in function to compute the normal in world space*/
                o.worldNormal=UnityObjectToWorldNormal(v.normal);

                /**Transform the vertext from object space to worldspace*/
                o.worldPos=mul(unity_ObjectToWorld,v.vertext).xyz;

                return o;
            }



            fixed4 frag(v2f i):SV_TARGET{

                
                /**Get Ambient term**/
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);


                //fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                /*use the build-in funciton to compute the light direciton in world space
                 Remeber to normalize the result**/
                fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));

                //computer diffuse

                fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldLightDir,worldNormal));

                
                


                

                //get the view direction in the world space

                //fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);


                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
            
                /**get the half direction*/
                fixed3 halfDir = normalize(worldLightDir+viewDir);

                
                //computer specular

                fixed3 specular = _LightColor0.rgb*_Specular*pow(saturate(dot(halfDir,worldNormal)),_Gloss); 

                return fixed4(ambient+specular + diffuse,1.0);
                    






 
            } 


            ENDCG 


        }


    }
        Fallback "Specular"


}
