// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/MaskTexture_"
{
    Properties{
        _Color("Color Tint",Color)=(1,1,1,1)
        _MainTex("Main Tex",2D)="white"{}

        _BumpMap("Normal Map",2D)="bump"{}
        _BumpScale("Bump scale",Float)=1.0

        _SpecularMask("Specular Mask",2D)="white"{}
        _SpecularScale("Specular Scale",Float)=1.0

        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
        

    }


    SubShader{


        Pass{

            Tags{  "LightModel" = "ForwardBase"}


            CGPROGRAM


            #pragma vertex vert
            #pragma fragment frag


            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _BumpMap;

            float _BumpScale;

            sampler2D _SpecularMask;
            float _SpecularScale;

            fixed4 _Specular;
            float _Gloss;





            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
                float4 texcoord:TEXCOORD0; 
    
            };


            struct v2f{

                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float3 lightDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;


            };


            v2f vert(a2v v){

                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.wz;

                float3 binormal = cross(normalize(v.normal),normalize(v.tangent.xyz))*v.tangent.w;

                fixed3x3 rotation = fixed3x3(v.tangent.xyz,binormal,v.normal);
                o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;

                 

                return o;

            }


            


            fixed4 frag(v2f i):SV_Target{

                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);



                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap,i.uv));
                tangentNormal.xy *= _BumpScale;

                tangentNormal.z = sqrt(1.0f-dot(tangentNormal.xy,tangentNormal.xy));

                fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
                fixed ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;


                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(tangentLightDir,tangentNormal));

                fixed3 halfDir = normalize(tangentLightDir+tangentViewDir);

                fixed specularMask = tex2D(_SpecularMask,i.uv).r*_SpecularScale;

                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(halfDir,tangentNormal)),_Gloss)*specularMask;

                return fixed4(ambient + diffuse + specular ,1.0);

 
            } 

            ENDCG

        }


    }


    Fallback "Specular"

        
}
