meta:
  id: icns
  title: Apple icon image (ICNS)
  application:
    # Listing only official Apple software.
    # Various third-party software also supports reading and writing the format.
    - macOS
    - Preview (macOS)
    - icns Browser
    - Icon Composer
    - iconutil
  file-extension: icns
  xref:
    justsolve: ICNS
    mac-os-file-type: icns
    mac-os-resource-type: icns
    mime:
      - image/icns
      - image/x-icns
    pronom: fmt/1185
    uti: com.apple.icns
    wikidata: Q2858737
  license: MIT
  ks-version: "0.9"
  imports:
    - /common/bytes_with_io
  endian: be
doc: |
  Icon image format used by Mac OS 8.5 and later,
  including all versions of Mac OS X/macOS.
  This is the Mac equivalent of the Windows ICO format.

  An ICNS file stores an *icon family*:
  a collection of images with visually the same content,
  but at different resolutions and color depths.
  When the system renders an icon on screen,
  it chooses the most optimal format from the icon family to display to the user,
  depending on the icon's displayed size and the capabilities of the display hardware.

  An icon family in an ICNS file can also contain other nested icon families.
  This feature is sometimes used to represent different states or visual variants of the same icon,
  such as an opened, selected or dark mode version.

  Each icon in an icon family is identified by a four-byte type code,
  which also indicates the image data format and resolution.
  Supported formats include PNG and JPEG 2000 (for larger sizes and modern systems)
  and multiple raw bitmap formats with varying resolution, color depth, and transparency support
  (for smaller sizes and/or compatibility with older systems).

  ICNS data can be stored either as a standalone file,
  or as a resource with type code `'icns'` in a resource fork.
  The latter was especially common on Classic Mac OS and for Carbon applications,
  and is still used (as of macOS 10.14) by the Finder to store custom file and folder icons set by the user.
doc-ref:
  - '<OSServices/IconStorage.h>'
  - '<OSServices/IconStorage.r>'
  - '<HIServices/Icons.r>'
  - 'https://sourceforge.net/p/icns/ libicns SourceForge project'
  - 'https://github.com/python-pillow/Pillow/blob/master/src/PIL/IcnsImagePlugin.py Python Pillow ICNS plugin code'
  - "https://www.macdisk.com/maciconen.php#icns Information about 'icns' resources in resource forks"
seq:
  - id: root_element
    type: icon_family_element
    valid:
      expr: |
        _.header.type.as_enum == icon_family_element::header::type::main_family
    doc: |
      The element at the root of the file.
      This element must have type `"icns"`,
      should be as long as the entire stream,
      and contains the main icon family.
types:
  icon_family_element:
    doc: |
      A single element in an icon family.

      It is normally safe to ignore elements with an unrecognized type code or unparseable data when reading -
      they are most likely new icon types/resolutions, icon family variants, or metadata introduced in a newer system version.
      However, when modifying and writing an icon family,
      such elements should be stripped out,
      to avoid leaving outdated information in the icon family that could be used by newer systems.
    -webide-representation: '{header}'
    seq:
      - id: header
        type: header
        doc: The header storing the element's type code and length.
      - id: data_with_io
        type: bytes_with_io
        size: header.len_data
        doc: |
          Use `data` instead,
          unless you need access to this field's `_io`.
    instances:
      data:
        value: data_with_io.data
        doc: The raw data stored in the element.
      data_parsed:
        io: data_with_io._io
        pos: 0
        type:
          switch-on: header.type.as_enum
          cases:
            'header::type::main_family': icon_family_data
            'header::type::tile_variant_family': icon_family_data
            'header::type::rollover_variant_family': icon_family_data
            'header::type::drop_variant_family': icon_family_data
            'header::type::open_variant_family': icon_family_data
            'header::type::open_drop_variant_family': icon_family_data
            'header::type::sbpp_variant_family': icon_family_data
            'header::type::sidebar_variant_family': icon_family_data
            'header::type::selected_variant_family': icon_family_data
            'header::type::dark_mode_variant_family': icon_family_data
            'header::type::table_of_contents': table_of_contents_data
            'header::type::icon_composer_version': icon_composer_version_data
            'header::type::icon_16x12x1_with_mask': icon_x1_and_mask_data(16, 12)
            'header::type::icon_16x12x4': icon_x4_data(16, 12)
            'header::type::icon_16x12x8': icon_x8_data(16, 12)
            'header::type::icon_16x16x1_with_mask': icon_x1_and_mask_data(16, 16)
            'header::type::icon_16x16x4': icon_x4_data(16, 16)
            'header::type::icon_16x16x8': icon_x8_data(16, 16)
            'header::type::icon_16x16_rgb': icon_rgb_data(16, 16)
            'header::type::icon_16x16_rgb_mask': icon_rgb_mask_data(16, 16)
            'header::type::icon_32x32x1_with_mask': icon_x1_and_mask_data(32, 32)
            'header::type::icon_32x32x4': icon_x4_data(32, 32)
            'header::type::icon_32x32x8': icon_x8_data(32, 32)
            'header::type::icon_32x32_rgb': icon_rgb_data(32, 32)
            'header::type::icon_32x32_rgb_mask': icon_rgb_mask_data(32, 32)
            'header::type::icon_48x48x1_with_mask': icon_x1_and_mask_data(48, 48)
            'header::type::icon_48x48x4': icon_x4_data(48, 48)
            'header::type::icon_48x48x8': icon_x8_data(48, 48)
            'header::type::icon_48x48_rgb': icon_rgb_data(48, 48)
            'header::type::icon_48x48_rgb_mask': icon_rgb_mask_data(48, 48)
            'header::type::icon_128x128_rgb': icon_rgb_zero_prefixed_data(128, 128)
            'header::type::icon_128x128_rgb_mask': icon_rgb_mask_data(128, 128)
            'header::type::icon_16x16_argb': icon_argb_data(16, 16, 1)
            'header::type::icon_18x18_argb': icon_argb_data(18, 18, 1)
            'header::type::icon_32x32_argb': icon_argb_data(32, 32, 1)
            'header::type::icon_18x18_at_2x_argb': icon_argb_data(18, 18, 2)
            'header::type::icon_16x16_png_jp2': icon_png_jp2_data(16, 16, 1)
            'header::type::icon_32x32_png_jp2': icon_png_jp2_data(32, 32, 1)
            'header::type::icon_64x64_png_jp2': icon_png_jp2_data(64, 64, 1)
            'header::type::icon_128x128_png_jp2': icon_png_jp2_data(128, 128, 1)
            'header::type::icon_256x256_png_jp2': icon_png_jp2_data(256, 256, 1)
            'header::type::icon_512x512_png_jp2': icon_png_jp2_data(512, 512, 1)
            'header::type::icon_16x16_at_2x_png_jp2': icon_png_jp2_data(16, 16, 2)
            'header::type::icon_32x32_at_2x_png_jp2': icon_png_jp2_data(32, 32, 2)
            'header::type::icon_128x128_at_2x_png_jp2': icon_png_jp2_data(128, 128, 2)
            'header::type::icon_256x256_at_2x_png_jp2': icon_png_jp2_data(256, 256, 2)
            'header::type::icon_512x512_at_2x_png_jp2': icon_png_jp2_data(512, 512, 2)
            _: bytes_with_io # necessary to make the valid check below work if type is unknown
        valid:
          expr: _io.eof
        doc: |
          The data stored in the element,
          parsed based on the type code in the header.
    types:
      header:
        doc: |
          An icon family element's header,
          storing the type code and length.
        -webide-representation: '{type}: {len_element} bytes'
        seq:
          - id: type
            type: type_code
            size: 4
            doc: |
              The element's type code.
              This indicates the format of the icon or other data stored in the element.
          - id: len_element
            type: u4
            doc: |
              The length of the element,
              including the entire header (type and length).
        instances:
          len_data:
            value: len_element - sizeof<header>
            doc: |
              The length of the data stored in the element.
              This is the length of the entire element minus the length of the header.
        enums:
          type:
            # region Icon families
            0x69636e73: # 'icns'
              id: main_family
              -orig-id: kIconFamilyType
              doc: |
                The main icon family.
                This type should only be used by the root element,
                and should not appear inside another icon family.
            0x74696c65: # 'tile'
              id: tile_variant_family
              -orig-id: kTileIconVariant
              doc: |
                A "tile" variant of the icon family.
                This type is only rarely used.
            0x6f766572: # 'over'
              id: rollover_variant_family
              -orig-id: kRolloverIconVariant
              doc: |
                A "rollover" variant of the icon family.
                This type is only rarely used.
            0x64726f70: # 'drop'
              id: drop_variant_family
              -orig-id: kDropIconVariant
              doc: |
                A "drop" variant of the icon family.
                This type is only rarely used.
            0x6f70656e: # 'open'
              id: open_variant_family
              -orig-id: kOpenIconVariant
              doc: |
                An "open" variant of the icon family.
                This type is only rarely used.
            0x6f647270: # 'odrp'
              id: open_drop_variant_family
              -orig-id: kOpenDropIconVariant
              doc: |
                An "open drop" variant of the icon family.
                This type is only rarely used.
            0x73627070: # 'sbpp'
              id: sbpp_variant_family
              doc: |
                An icon family variant type used in Finder sidebar icons on Mac OS X 10.7
                (and possibly also later versions).
                It's not very clear what this variant is used for -
                it might be the unselected variant of the icon,
                with the main icon family being the selected variant.
            0x73627470: # 'sbtp'
              id: sidebar_variant_family
              doc: |
                A Finder sidebar variant of the icon family.
                This type is used in some device icons on macOS 10.14
                (and possibly also earlier and later versions).

                This icon family variant is generated by `iconutil` on macOS 10.14 (and possibly earlier)
                from files named `template_<resolution>.png` rather than the default `icon_<resolution>.png`.
            0x736c6374: # 'slct'
              id: selected_variant_family
              doc: |
                A selected variant of the icon family.
                This type is used in Finder sidebar icons on macOS 10.14
                (and possibly also earlier and later versions).

                This icon family variant is generated by `iconutil` on macOS 10.14 (and possibly earlier)
                from files that have `[selected]` prepended to their resolution,
                for example `icon_[selected]16x16.png` or `template_[selected]16x16.png`.
            0xfdd92fa8: # not ASCII
              id: dark_mode_variant_family
              doc: |
                A dark mode variant of the icon family.
                This type is used in system icons on macOS 10.14
                (and possibly also later versions).
            # endregion

            # region Metadata
            0x544f4320: # 'TOC '
              id: table_of_contents
              doc: |
                A table of contents,
                containing a copy of the headers of all other elements in the icon family.
                See table_of_contents_data for the exact structure of the data.
                This element is optional,
                and if present should be the first element in the icon family.

                The table of contents can be used to calculate the locations of all elements in the icon family without having to read or seek through the entire icon family.
                This allows more efficient random access to the icon family's elements.

                If an icon family with a table of contents contains other icon families,
                these nested icon families are listed in the table of contents,
                but the contents of the nested icon families are not.
                Instead, each nested icon family contains its own table of contents.

                Table of contents elements were introduced in Mac OS X 10.7 and are present in most system icons since this system version.
                As of macOS 10.14 (and possibly earlier) some new system icons no longer include tables of contents.
            0x69636e56: # 'icnV'
              id: icon_composer_version
              doc: |
                Stores the version of Icon Composer that created the ICNS.
                See icon_composer_version_data for the exact structure of the data.
                If present,
                it is usually the last element in the icon family.

                This element is generated by Icon Composer version 2.1.1 (127.2) and later
                (probably by all versions since 2.0).
            0x696e666f: # 'info'
              id: info
              doc: |
                A `NSDictionary` of information/metadata,
                serialized using `NSKeyedArchiver` into a binary property list (bplist).
                If present,
                it is usually the first or last element in the icon family.

                This element exists since macOS 10.14 (and possibly earlier)
                and is generated by the `iconutil` tool on that system version.

                As of macOS 10.14,
                the only known keys in the info dictionary are `"name"` and `"variantName"`,
                which are human-readable string identifiers that describe the icon family.
                These keys usually have the following values,
                based on the icon family's type code:

                | Type code        | `"name"`     | `"variantName"` |
                |------------------|--------------|-----------------|
                | default/`'icns'` | `"icon"`     | not present     |
                | `'sbtp'`         | `"template"` | not present     |
                | `'slct'`         | `"selected"` | not present     |
                | `0xfdd92fa8`     | `"dark"`     | `"dark"`        |

                Note: sometimes the main `'icns'` icon family has a different name than the default `"icon"`.
                This happens if `iconutil` is passed an iconset directory that contains no files for the main icon family (named `icon_<resolution>.png`),
                but does contain files for another icon family (e. g. `template_<resolution>.png` for the `'sbtp'` family).
                In this case,
                `iconutil` makes the other icon family (e. g. `'sbtp'`) the main icon family and changes its type code to `'icns'`,
                but still writes the original name (e. g. `"template"`) into the `'info'` dictionary.
            # endregion

            # region Classic bitmap icon images

            # region 16x12 ("mini")
            0x69636d23: # 'icm#'
              id: icon_16x12x1_with_mask
              -orig-id: kMini1BitMask
              doc: |
                A 16x12-pixel 1-bit monochrome bitmap icon with a 1-bit mask.
                See icon_x1_and_mask_data for the exact structure of the data.
            0x69636d34: # 'icm4'
              id: icon_16x12x4
              -orig-id: kMini4BitData
              doc: |
                A 16x12-pixel 4-bit color bitmap icon,
                in the Mac OS default 4-bit color palette.
                Uses the 1-bit mask from the 'icm#' (icon_16x12x1_with_mask) icon in the same family.
                See icon_x4_data for the exact structure of the data.
            0x69636d38: # 'icm8'
              id: icon_16x12x8
              -orig-id: kMini8BitData
              doc: |
                A 16x12-pixel 8-bit color bitmap icon,
                in the Mac OS default 8-bit color palette.
                Uses the 1-bit mask from the 'icm#' (icon_16x12x1_with_mask) icon in the same family.
                See icon_x8_data for the exact structure of the data.
            # The 16x12 size has no RGB icon ('im32') or RGB mask ('m8mk') variant.
            # endregion

            # region 16x16 ("small")
            0x69637323: # 'ics#'
              id: icon_16x16x1_with_mask
              -orig-id: kSmall1BitMask
              doc: |
                A 16x16-pixel 1-bit monochrome bitmap icon with a 1-bit mask.
                See icon_x1_and_mask_data for the exact structure of the data.
            0x69637334: # 'ics4'
              id: icon_16x16x4
              -orig-id: kSmall4BitData
              doc: |
                A 16x16-pixel 4-bit color bitmap icon,
                in the Mac OS default 4-bit color palette.
                Uses the 1-bit mask from the 'ics#' (icon_16x16x1_with_mask) icon in the same family.
                See icon_x4_data for the exact structure of the data.
            0x69637338: # 'ics8'
              id: icon_16x16x8
              -orig-id: kSmall8BitData
              doc: |
                A 16x16-pixel 8-bit color bitmap icon,
                in the Mac OS default 8-bit color palette.
                Uses the 1-bit mask from the 'ics#' (icon_16x16x1_with_mask) icon in the same family.
                See icon_x8_data for the exact structure of the data.
            0x69733332: # 'is32'
              id: icon_16x16_rgb
              -orig-id: kSmall32BitData
              doc: |
                A 16x16-pixel RGB color bitmap icon.
                The corresponding 8-bit mask is stored in a separate 's8mk' (icon_16x16_rgb_mask) element,
                so this bitmap is not actually 32-bit as the type code suggests.
                See icon_rgb_data for the exact structure of the data.
            0x73386d6b: # 's8mk'
              id: icon_16x16_rgb_mask
              -orig-id: kSmall8BitMask
              doc: |
                A 16x16-pixel 8-bit mask for the corresponding 'is32' (icon_16x16_rgb) bitmap.
                See icon_rgb_mask_data for the exact structure of the data.
            # endregion

            # region 32x32 ("large")
            0x49434e23: # 'ICN#'
              id: icon_32x32x1_with_mask
              -orig-id: kLarge1BitMask
              doc: |
                A 32x32-pixel 1-bit monochrome bitmap icon with a 1-bit mask.
                See icon_x1_and_mask_data for the exact structure of the data.
            0x69636c34: # 'icl4'
              id: icon_32x32x4
              -orig-id: kLarge4BitData
              doc: |
                A 32x32-pixel 4-bit color bitmap icon,
                in the Mac OS default 4-bit color palette.
                Uses the 1-bit mask from the 'ICN#' (icon_32x32x1_with_mask) icon in the same family.
                See icon_x4_data for the exact structure of the data.
            0x69636c38: # 'icl8'
              id: icon_32x32x8
              -orig-id: kLarge8BitData
              doc: |
                A 32x32-pixel 8-bit color bitmap icon,
                in the Mac OS default 8-bit color palette.
                Uses the 1-bit mask from the 'ICN#' (icon_32x32x1_with_mask) icon in the same family.
                See icon_x8_data for the exact structure of the data.
            0x696c3332: # 'il32'
              id: icon_32x32_rgb
              -orig-id: kLarge32BitData
              doc: |
                A 32x32-pixel RGB color bitmap icon.
                The corresponding 8-bit mask is stored in a separate 'l8mk' (icon_32x32_rgb_mask) element,
                so this bitmap is not actually 32-bit as the type code suggests.
                See icon_rgb_data for the exact structure of the data.
            0x6c386d6b: # 'l8mk'
              id: icon_32x32_rgb_mask
              -orig-id: kLarge8BitMask
              doc: |
                A 32x32-pixel 8-bit mask for the corresponding 'il32' (icon_32x32_rgb) bitmap.
                See icon_rgb_mask_data for the exact structure of the data.
            # endregion

            # region 48x48 ("huge")
            0x69636823: # 'ich#'
              id: icon_48x48x1_with_mask
              -orig-id: kHuge1BitMask
              doc: |
                A 48x48-pixel 1-bit monochrome bitmap icon with a 1-bit mask.
                See icon_x1_and_mask_data for the exact structure of the data.
            0x69636834: # 'ich4'
              id: icon_48x48x4
              -orig-id: kHuge4BitData
              doc: |
                A 48x48-pixel 4-bit color bitmap icon,
                in the Mac OS default 4-bit color palette.
                Uses the 1-bit mask from the 'ich#' (icon_48x48x1_with_mask) icon in the same family.
                See icon_x4_data for the exact structure of the data.
            0x69636838: # 'ich8'
              id: icon_48x48x8
              -orig-id: kHuge8BitData
              doc: |
                A 48x48-pixel 8-bit color bitmap icon,
                in the Mac OS default 8-bit color palette.
                Uses the 1-bit mask from the 'ich#' (icon_48x48x1_with_mask) icon in the same family.
                See icon_x8_data for the exact structure of the data.
            0x69683332: # 'ih32'
              id: icon_48x48_rgb
              -orig-id: kHuge32BitData
              doc: |
                A 48x48-pixel RGB color bitmap icon.
                The corresponding 8-bit mask is stored in a separate 'h8mk' (icon_48x48_rgb_mask) element,
                so this bitmap is not actually 32-bit as the type code suggests.
                See icon_rgb_data for the exact structure of the data.
            0x68386d6b: # 'h8mk'
              id: icon_48x48_rgb_mask
              -orig-id: kHuge8BitMask
              doc: |
                A 48x48-pixel 8-bit mask for the corresponding 'ih32' (icon_48x48_rgb) bitmap.
                See icon_rgb_mask_data for the exact structure of the data.
            # endregion

            # region 128x128 ("thumbnail")
            # The 128x128 size has no 1-bit icon/mask ('ict#'), 4-bit icon ('ict4'), or 8-bit icon ('ict8') variants.
            0x69743332: # 'it32'
              id: icon_128x128_rgb
              -orig-id: kThumbnail32BitData
              doc: |
                A 128x128-pixel RGB color bitmap icon.
                The corresponding 8-bit mask is stored in a separate 't8mk' (icon_128x128_rgb_mask) element,
                so this bitmap is not actually 32-bit as the type code suggests.
                See icon_rgb_zero_prefixed_data for the exact structure of the data.

                Supported since Mac OS X 10.0.
            0x74386d6b: # 't8mk'
              id: icon_128x128_rgb_mask
              -orig-id: kThumbnail8BitMask
              doc: |
                A 128x128-pixel 8-bit mask for the corresponding 'it32' (icon_128x128_rgb) bitmap.
                See icon_rgb_mask_data for the exact structure of the data.

                Supported since Mac OS X 10.0.
            # endregion

            # endregion

            # region ARGB bitmap icon images
            0x69633034: # 'ic04'
              id: icon_16x16_argb
              -orig-id: kIconServices16PixelDataARGB
              doc: |
                A 16x16-pixel ARGB bitmap icon.
                See icon_argb_data for the exact structure of the data.

                Supported since macOS 10.13 (possibly earlier).
            0x69637362: # 'icsb'
              id: icon_18x18_argb
              doc: |
                An 18x18-pixel ARGB bitmap icon.
                See icon_argb_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633035: # 'ic05'
              id: icon_32x32_argb
              -orig-id: kIconServices32PixelDataARGB
              doc: |
                A 32x32-pixel ARGB bitmap icon.
                See icon_argb_data for the exact structure of the data.

                Supported since macOS 10.13 (possibly earlier).
            0x69637342: # 'icsB'
              id: icon_18x18_at_2x_argb
              doc: |
                A 36x36-pixel ARGB bitmap icon,
                intended to be rendered at a size of 18x18 points on HiDPI screens.
                See icon_argb_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            # The type 'ic06' exists in <OSServices/IconStorage.h> as kIconServices48PixelDataARGB,
            # but (as of macOS 10.14) the system does not recognize it as an element type when stored in an actual icon family.
            # endregion

            # region PNG/JPEG 2000 icon images

            # region Regular scale
            0x69637034: # 'icp4'
              id: icon_16x16_png_jp2
              doc: |
                A 16x16-pixel icon in PNG or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69637035: # 'icp5'
              id: icon_32x32_png_jp2
              doc: |
                A 32x32-pixel icon in PNG or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69637036: # 'icp6'
              id: icon_64x64_png_jp2
              doc: |
                A 64x64-pixel icon in PNG or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633037: # 'ic07'
              id: icon_128x128_png_jp2
              doc: |
                A 128x128-pixel icon in PNG or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633038: # 'ic08'
              id: icon_256x256_png_jp2
              doc: |
                A 256x256-pixel icon in PNG (since Mac OS X 10.6) or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.5.
            0x69633039: # 'ic09'
              id: icon_512x512_png_jp2
              doc: |
                A 512x512-pixel icon in PNG (since Mac OS X 10.6) or JPEG 2000 format.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.5.
            # endregion

            # region HiDPI scale (@2x)
            0x69633131: # 'ic11'
              id: icon_16x16_at_2x_png_jp2
              doc: |
                A 32x32-pixel icon in PNG or JPEG 2000 format,
                intended to be rendered at a size of 16x16 points on HiDPI screens.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633132: # 'ic12'
              id: icon_32x32_at_2x_png_jp2
              doc: |
                A 64x64-pixel icon in PNG or JPEG 2000 format,
                intended to be rendered at a size of 32x32 points on HiDPI screens.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            # There is no 64x64@2x PNG/JPEG 2000 type.
            0x69633133: # 'ic13'
              id: icon_128x128_at_2x_png_jp2
              doc: |
                A 256x256-pixel icon in PNG or JPEG 2000 format,
                intended to be rendered at a size of 128x128 points on HiDPI screens.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633134: # 'ic14'
              id: icon_256x256_at_2x_png_jp2
              doc: |
                A 512x512-pixel icon in PNG or JPEG 2000 format,
                intended to be rendered at a size of 256x256 points on HiDPI screens.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.7.
            0x69633130: # 'ic10'
              id: icon_512x512_at_2x_png_jp2
              doc: |
                A 1024x1024-pixel icon in PNG (since Mac OS X 10.6) or JPEG 2000 format,
                intended to be rendered at a size of 512x512 points on HiDPI screens.
                Mac OS X 10.7 and older instead treat this as a non-HiDPI 1024x1024 icon,
                but this makes almost no difference in practice,
                because the image is 1024x1024 in both cases.
                See icon_png_jp2_data for the exact structure of the data.

                Supported since Mac OS X 10.6 (possibly since 10.5).
            # endregion

            # endregion
        types:
          type_code:
            doc: A four-character type code.
            -webide-representation: '{as_bytes:str}'
            seq:
              - id: as_bytes
                size-eos: true
                doc: The type code as a raw byte array.
            instances:
              as_enum:
                pos: 0
                type: u4
                enum: type
                doc: The type code as an integer-based enum.
      icon_family_data:
        doc: The element data for an icon family.
        seq:
          - id: elements
            type: icon_family_element
            repeat: eos
            doc: The elements contained in the icon family.
      table_of_contents_data:
        doc: The element data for a table of contents.
        seq:
          - id: element_headers
            type: header
            repeat: eos
            doc: |
              The header data for all other elements in the icon family that contains the table of contents elements.
              This information can be used to calculate the positions of all elements without having to read the entire data.
      icon_composer_version_data:
        doc: The element data for an Icon Composer version number.
        -webide-representation: '{version:dec}'
        seq:
          - id: version
            type: f4
            doc: |
              The version of Icon Composer that created this ICNS file.
              Some versions of Icon Composer set this to -1 instead of an actual version number.
      icns_style_packbits:
        doc: |
          A run-length encoding compression scheme similar to (but not the same as) PackBits.
          Used in the RGB and ARGB bitmap icon types.
        seq:
          - id: chunks
            type: chunk
            repeat: eos
            doc: The chunks that make up the compressed data.
        types:
          chunk:
            doc: |
              A single chunk of compressed data.
              Each chunk stores either a sequence of literal bytes,
              or a single byte that is repeated a certain number of times.
            seq:
              - id: tag
                type: u1
                doc: |
                  The chunk's tag byte,
                  indicating whether the chunk is a literal or repeat chunk,
                  as well as how many literal bytes follow or how often the byte should be repeated.
              - id: literal_data
                size: tag + 1
                if: not is_repeat
                doc: |
                  If this is a literal chunk,
                  the literal byte sequence stored in the chunk.
              - id: repeated_byte
                type: u1
                if: is_repeat
                doc: |
                  If this is a repeat chunk,
                  the byte to be repeated in the output.
            instances:
              is_repeat:
                value: tag >= 128
                doc: |
                  If true, this is a repeat chunk.
                  If false, this is a literal chunk.
              len_literal_data:
                value: tag + 1
                if: not is_repeat
                doc: |
                  If this is a literal chunk,
                  the number of literal bytes stored in the chunk.
              repeat_count:
                value: tag - 125
                if: is_repeat
                doc: |
                  If this is a repeat chunk,
                  the number of times the stored byte should be repeated in the output.
      icon_x1_and_mask_data:
        doc: The data for a 1-bit monochrome bitmap icon with a 1-bit mask.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: icon
            size: width * height / 8
            doc: |
              The icon bitmap data,
              as a packed sequence of 1-bit pixels,
              in MSB-first bit order
              (i. e. pixels that come earlier in the file go into the higher bits).
              0 is white and 1 is black.
          - id: mask
            size: width * height / 8
            doc: |
              The icon mask data,
              as a packed sequence of 1-bit pixels,
              in MSB-first bit order
              (i. e. pixels that come earlier in the file go into the higher bits).
              0 is transparent and 1 is solid.
      icon_x4_data:
        doc: |
          The data for a 4-bit color bitmap icon.
          These icons do not contain a mask,
          but use the mask from the 1-bit monochrome icon of the same size from the same family.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: icon
            size: width * height / 2
            doc: |
              The icon bitmap data,
              as a packed sequence of 4-bit pixels,
              in MSB-first bit order
              (i. e. pixels that come earlier in the file go into the higher bits).
              Color values come from the Mac OS default 4-bit color palette.
      icon_x8_data:
        doc: |
          The data for an 8-bit color bitmap icon.
          These icons do not contain a mask,
          but use the mask from the 1-bit monochrome icon of the same size from the same family.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: icon
            size: width * height
            doc: |
              The icon bitmap data,
              as a packed sequence of 8-bit pixels.
              Color values come from the Mac OS default 8-bit color palette.
      icon_rgb_data:
        doc: |
          The data for a 24-bit RGB bitmap icon.
          These icons do not contain a mask -
          the mask is stored as a separate element in the same icon family.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: data
            type:
              switch-on: _io.size == width * height * 3
              cases:
                false: icns_style_packbits
                # If true, the data is uncompressed and should be read as a raw byte array.
            size-eos: true
            doc: |
              The icon's red, green and blue color channels,
              each a sequence of 8-bit color values (one per pixel),
              optionally compressed using run-length encoding.

              When storing the data in compressed form,
              each color channel is compressed separately,
              and afterwards the compressed data for the three channels is concatenated and stored.
              (That is, a chunk in the compressed data cannot span multiple color channels.)

              When reading the compressed data,
              this detail is mostly irrelevant -
              the compressed length of each color channel is variable and not stored in the data,
              so there is no way to separate the three color channels without decompressing them.
      icon_rgb_zero_prefixed_data:
        doc: |
          A variant of icon_rgb_data that has four extra zero bytes preceding the compressed RGB data.
          This variant is only used by the 'it32' (icon_128x128_rgb) icon type.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: zero_prefix
            contents: [0, 0, 0, 0]
            doc: A prefix with no known meaning or purpose.
          - id: icon
            type: icon_rgb_data(width, height)
            doc: The actual icon data in the usual RGB format.
      icon_rgb_mask_data:
        doc: |
          The data for an 8-bit mask,
          to be used together with the 24-bit RGB icon of the same size in the same icon family.
        params:
          - id: width
            type: u4
            doc: The width of the icon in pixels.
          - id: height
            type: u4
            doc: The height of the icon in pixels.
        seq:
          - id: mask
            size: width * height
            doc: |
              The mask data,
              as a packed sequence of 8-bit opacity values (one per pixel).
              0 is fully transparent and 255 is fully opaque.
      icon_argb_data:
        doc: The data for a 32-bit ARGB bitmap icon.
        params:
          - id: point_width
            type: u4
            doc: The width of the icon in points.
          - id: point_height
            type: u4
            doc: The height of the icon in points.
          - id: scale
            type: u4
            doc: |
              The number of pixels per point (along each dimension) in the image.
              Icons with scale 1 are intended for screens with normal pixel density,
              and those with scale 2 are intended for HiDPI screens.
        seq:
          - id: signature
            contents: "ARGB"
            doc: Signature indicating that this is an ARGB bitmap.
          - id: compressed_data
            type: icns_style_packbits
            doc: |
              The icon's alpha channel and red, green and blue color channels,
              each a sequence of 8-bit opacity/color values (one per pixel),
              compressed using run-length encoding.
              (Unlike RGB icons,
              the data of ARGB icons *must* be compressed -
              the system does not read uncompressed ARGB data correctly.)

              When storing the data,
              each channel is compressed separately,
              and afterwards the compressed data for the four channels is concatenated and stored.
              (That is, a chunk in the compressed data cannot span multiple channels.)

              When reading the data,
              this detail is mostly irrelevant -
              the compressed length of each channel is variable and not stored in the data,
              so there is no way to separate the four color channels without decompressing them.
        instances:
          pixel_width:
            value: point_width * scale
            doc: |
              The width of the icon in pixels,
              calculated based on the width in points and the scale.
          pixel_height:
            value: point_height * scale
            doc: |
              The height of the icon in pixels,
              calculated based on the height in points and the scale.
      icon_png_jp2_data:
        doc: |
          The data for a PNG or JPEG 2000 icon.
          Mac OS X 10.5 only supports the JPEG 2000 format here;
          Mac OS X 10.6 and later support both PNG and JPEG 2000.

          As of Mac OS X 10.7,
          practically all system icons use PNG instead of JPEG 2000,
          and the developer tools (Icon Composer and `iconutil`) always output PNG data.
          The JPEG 2000 format is almost never used anymore here.
        params:
          - id: point_width
            type: u4
            doc: The width of the icon in points.
          - id: point_height
            type: u4
            doc: The height of the icon in points.
          - id: scale
            type: u4
            doc: |
              The number of pixels per point (along each dimension) in the image.
              Icons with scale 1 are intended for screens with normal pixel density,
              and those with scale 2 are intended for HiDPI screens.
        seq:
          - id: png_or_jp2_data
            size-eos: true
            doc: |
              The icon data in PNG or JPEG 2000 format.
              Both formats have unique signatures/magic numbers,
              which can be used to determine which of the two formats the icon data has.
        instances:
          pixel_width:
            value: point_width * scale
            doc: |
              The width of the icon in pixels,
              calculated based on the width in points and the scale.
          pixel_height:
            value: point_height * scale
            doc: |
              The height of the icon in pixels,
              calculated based on the height in points and the scale.
