/* SPDX-FileCopyrightText: 2019-2022 Blender Authors
 *
 * SPDX-License-Identifier: GPL-2.0-or-later */

#include "infos/overlay_extra_info.hh"

FRAGMENT_SHADER_CREATE_INFO(overlay_image_base)

#include "common_colormanagement_lib.glsl"
#include "select_lib.glsl"

void main()
{
  float2 uvs_clamped = clamp(uvs, 0.0f, 1.0f);
  float4 tex_color;
  tex_color = texture_read_as_linearrgb(imgTexture, imgPremultiplied, uvs_clamped);

  fragColor = tex_color * ucolor;

  if (!imgAlphaBlend) {
    /* Arbitrary discard anything below 5% opacity.
     * Note that this could be exposed to the User. */
    if (tex_color.a < 0.05f) {
      discard;
    }
    else {
      fragColor.a = 1.0f;
    }
  }

  /* Pre-multiplied blending. */
  fragColor.rgb *= fragColor.a;

  select_id_output(select_id);
}
