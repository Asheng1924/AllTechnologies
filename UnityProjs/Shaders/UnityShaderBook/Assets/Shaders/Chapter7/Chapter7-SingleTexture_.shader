// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/SingleTexture_"
{
    Properties{
        _Color("Color Tint",Color)=(1,1,1,1)
        _MainText("Main Tex",2D)="white"{}
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20

    }


    SubShader{

        Pass{
              /*定义该pass的光照模式*/
               Tags { "LightMode"="ForwardBase"}


            //由于包含CG代码
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"


            fixed4 _Color;
            sampler2D _MainText;
            /*用来声明纹理的属性 S:代表缩放 T：代表偏移量*/
            float4 _MainText_ST;
            fixed4 _Specular;
            float _Gloss;


            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                //Unity就会将模型的第一组纹理坐标存储到该变量中
                float4 texcoord:TEXCOORD0;
            };

        
            struct v2f{
                float4 pos:SV_POSITION;
                float3 wordNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                /*用于存储纹理坐标 以便在片元着色器中使用该坐标进行纹理采样*/
                float2 uv:TEXCOORD2;
            };



            v2f vert(a2v v){
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);

                o.wordNormal = UnityObjectToWorldNormal(v.normal);

                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;

                o.uv = v.texcoord.xy*_MainText_ST.xy+_MainText_ST.zw;

                return o; 
            }


            fixed4 frag(v2f i):SV_Target{
                fixed3 worldNormal = normalize(i.wordNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                //use the texture to sample the diffuse color  作为材质的反射率

                fixed3 albedo = tex2D(_MainText,i.uv).rgb*_Color.rgb;

                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;


                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));


                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(viewDir+ worldLightDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(halfDir,worldNormal)),_Gloss);

                return fixed4(diffuse+specular+ambient,1.0);
    
            }
            ENDCG
        }
    }
        Fallback "Specular"

}
