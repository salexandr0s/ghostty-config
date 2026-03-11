// CRT scanline effect
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 col = texture(iChannel0, uv);

    // Scanlines
    float scanline = sin(fragCoord.y * 3.14159 * 0.75) * 0.02;
    col.rgb -= scanline;

    // Subtle vignette
    float vignette = 1.0 - smoothstep(0.7, 2.0, length(uv - 0.5) * 1.5);
    col.rgb *= vignette;

    fragColor = vec4(col.rgb, texture(iChannel0, uv).a);
}
