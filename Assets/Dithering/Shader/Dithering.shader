Shader "Custom/Dithering"
{
    Properties
    {
        _DiscardScale("Discard Scale", Range(1, 10)) = 1 // ドットの大きさ
        _Discard("Discard", Range(0, 100)) = 50 // ディザリング ディスカード値
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                int _DiscardScale;
                int _Discard;
            CBUFFER_END

            // bayer配列
            static const int pattern[4][4] = 
            {
                { 0,  8,  2, 10 },
                { 12, 4, 14,  6 },
                { 3, 11,  1,  9 },
                { 15, 7, 13,  5 }
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // bayer配列から0~3のindex値を取り出す
                int x = (int)fmod(IN.positionHCS.x / _DiscardScale, 4);
                int y = (int)fmod(IN.positionHCS.y / _DiscardScale, 4);

                int dither = pattern[x][y] * 4;
                clip(dither - _Discard);

                half4 color = 1;
                return color;
            }
            ENDHLSL
        }
    }
}
